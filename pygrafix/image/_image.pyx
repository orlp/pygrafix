from pygrafix.c_headers.glew cimport *

import math
import weakref

_gl_textures = []
_textures = []

# this has to be a from module import ***, because pygrafix.image is not defined yet
from pygrafix import resource
from pygrafix import window
from pygrafix.window._window import _context_init_funcs
from pygrafix.image import codecs

def get_next_pot(n):
    return 2 ** (n - 1).bit_length()

def _init_context():
    global _gl_textures, _textures

    # init glew
    ret = glewInit()
    if ret != GLEW_OK:
        raise Exception("Error while initializing GLEW")

    _gl_textures = [ref for ref in _gl_textures if ref()]
    _textures = [ref for ref in _textures if ref()]

    for gl_texture in _gl_textures:
        gl_texture()._upload_texture()

    for texture in _textures:
        texture()._update_info()

def _destroy_context():
    cdef InternalTexture gl_texture

    global _gl_textures, _textures

    _gl_textures = [ref for ref in _gl_textures if ref()]
    _textures = [ref for ref in _textures if ref()]

    for gl_texture in _gl_textures:
        glDeleteTextures(1, &gl_texture.id)
        gl_texture.id = 0

cdef class ImageData:
    def __init__(self, width, height, format, data):
        self.width = width
        self.height = height
        self.format = format
        self.data = data

    def copy(self):
        return ImageData(width, height, format, data[:])

cdef class InternalTexture:
    def __init__(self, imgdata):
        self.imgdata = imgdata
        self.width = imgdata.width
        self.height = imgdata.height

        old_current_window = window.get_active_window()

        for win in window.get_open_windows():
            win.switch_to()
            self._upload_texture()

        if old_current_window:
            old_current_window.switch_to()

        _gl_textures.append(weakref.ref(self))

    def copy(self):
        newtex = Texture(self.imgdata)

        # imgdata.width might have been changed from the original amount. load our own width/height
        newtex.width = self.width
        newtex.height = self.height

        return newtex

    def _upload_texture(self):
        if len(self.imgdata.format) == 4:
            oglformat = GL_RGBA
        elif len(self.imgdata.format) == 3:
            oglformat = GL_RGB
        elif len(self.imgdata.format) == 2:
            oglformat = GL_LUMINANCE_ALPHA
        elif len(self.imgdata.fornat) == 1:
            oglformat = GL_LUMINANCE
        else:
            raise Exception("Unknown data format")

        if GLEW_ARB_texture_non_power_of_two:
            self.target = GL_TEXTURE_2D
        else:
            self.target = GL_TEXTURE_2D

            # if our width is not a power of two we must convert it
            if self.imgdata.width != get_next_pot(self.imgdata.width):
                old_pitch = self.imgdata.width * len(self.imgdata.format)
                old_size = old_pitch * self.imgdata.height

                transparent_columns = (b"\0" * len(self.imgdata.format)) * (get_next_pot(self.imgdata.width) - self.imgdata.width)

                self.imgdata.data = b"".join(self.imgdata.data[i:i + old_pitch] + transparent_columns for i in range(0, old_size, old_pitch))
                self.imgdata.width = get_next_pot(self.imgdata.width)

            # same goes for our height
            if self.imgdata.height != get_next_pot(self.imgdata.height):
                transparent_row = (b"\0" * len(self.imgdata.format)) * self.imgdata.width

                self.imgdata.data += transparent_row * (get_next_pot(self.imgdata.height) - self.imgdata.height)
                self.imgdata.height = get_next_pot(self.imgdata.height)

        # generate texture id
        glGenTextures(1, &self.id)

        if not self.id:
            raise Exception("Error while creating texture")

        glBindTexture(self.target, self.id)
        glTexImage2D(self.target, 0, oglformat, self.imgdata.width, self.imgdata.height, 0, oglformat, GL_UNSIGNED_BYTE, <char *> self.imgdata.data)

    def __del__(self):
        glDeleteTextures(1, &self.id)
        self.imgdata = None

cdef class Texture:
    property region:
        def __get__(self):
            return self._region

        def __set__(self, region):
            self._region = region
            self._update_info()

    property width:
        def __get__(self):
            return self._region[2]

    property height:
        def __get__(self):
            return self._region[3]

    def __init__(self, internal_texture, region = None):
        if region == None:
            region = (0, 0, internal_texture.width, internal_texture.height)

        self.internal_texture = internal_texture
        self._region = region

        self._update_info()

        _textures.append(weakref.ref(self))

    def copy(self, lazycopy = True):
        if lazycopy:
            texture = self.internal_texture
        else:
            texture = self.internal_texture.copy()

        return Texture(self, texture, self.region)

    def get_region(self, x, y, width, height):
        region = (self.region[0] + x, self.region[1] + y, width, height)

        return Texture(self.internal_texture, region)

    def _update_info(self):
        cdef GLfloat x, y, width, height

        x, y, width, height = self.region

        # (0, 0), (0, 1), (1, 1), (1, 0)
        self.texcoords[0] = x / self.internal_texture.imgdata.width
        self.texcoords[1] = y / self.internal_texture.imgdata.height
        self.texcoords[2] = x / self.internal_texture.imgdata.width
        self.texcoords[3] = (y + height) / self.internal_texture.imgdata.height
        self.texcoords[4] = (x + width) / self.internal_texture.imgdata.width
        self.texcoords[5] = (y + height) / self.internal_texture.imgdata.height
        self.texcoords[6] = (x + width) / self.internal_texture.imgdata.width
        self.texcoords[7] = y / self.internal_texture.imgdata.height

def load(filename, file = None, decoder = None):
    """Loads an image from a file. If file is passed filename will be used as a hint for the filetype. Optionally you can specify a decoder argument which will be used for decoding the image."""

    if file == None:
        file = resource.get_file(filename, "rb")

    # if an explicit decoder was specified we will only try that one
    if decoder:
        return decoder.decode(file, filename)

    # otherwise decode it using all possible means
    error = codecs.ImageDecodeException("No codecs found")
    for decoder in codecs.get_decoders(filename):
        try:
            imgdata = decoder.decode(file, filename)
            return Texture(InternalTexture(imgdata))
        except codecs.ImageDecodeException as e:
            error = e
            file.seek(0)

    raise error

_context_init_funcs.append(_init_context)


__all__ = ["load", "ImageData", "Texture"]
