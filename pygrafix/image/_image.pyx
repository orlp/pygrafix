from pygrafix.c_headers.glew cimport *

import math
import weakref

_textures = []
_texture_regions = []

# this has to be a from module import ***, because pygrafix.image is not defined yet
from pygrafix import window
from pygrafix.image import codecs

def _init_context():
    global _textures, _texture_regions

    # init glew
    ret = glewInit()
    if ret != GLEW_OK:
        raise Exception("Error while initializing GLEW")


    _textures = [ref for ref in _textures if ref()]
    _texture_regions = [ref for ref in _texture_regions if ref()]

    for texture in _textures:
        texture()._upload_texture()

    for texture_region in _texture_regions:
        texture_region()._update_info()

def _destroy_context():
    cdef Texture texture

    global _textures, _texture_regions

    _textures = [ref for ref in _textures if ref()]
    _texture_regions = [ref for ref in _texture_regions if ref()]

    for texture in _textures:
        glDeleteTextures(1, &texture.id)
        texture.id = 0

    for texture_region in _texture_regions:
        texture_region().target = 0
        texture_region().id = 0


def get_next_pot(n):
    return 2 ** (n - 1).bit_length()

cdef class ImageData:
    def __init__(self, width, height, format, data):
        self.width = width
        self.height = height
        self.format = format
        self.data = data

cdef class Texture(AbstractTexture):
    property width:
        def __get__(self):
            return self.tex_width

    property height:
        def __get__(self):
            return self.tex_height

    def __init__(self, imgdata):
        self.imgdata = imgdata
        self.tex_width = imgdata.width
        self.tex_height = imgdata.height

        if window.get_current_window():
            self._upload_texture()

        _textures.append(weakref.ref(self))

    def copy(self):
        newtex = Texture(self.imgdata)

        # imgdata.width might have been changed from the original amount. load our own width/height
        newtex.tex_width = self.tex_width
        newtex.tex_height = self.tex_height

        return newtex

    def get_region(self, x = 0, y = 0, width = None, height = None):
        if width == None:
            width = self.tex_width

        if height == None:
            height = self.tex_height

        return TextureRegion(self, x, y, width, height)

    def _upload_texture(self):
        cur_window = window.get_current_window()

        if not cur_window:
            raise Exception("No opened window")

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
        elif GLEW_ARB_texture_rectangle:
            # do we have rectangle support?
            self.target = GL_TEXTURE_RECTANGLE_ARB
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

        # generate texcoords
        if self.target == GL_TEXTURE_RECTANGLE_ARB:
            # (0, 0), (0, tex_height), (tex_width, tex_height), (tex_width, 0)
            self.texcoords[0] = 0
            self.texcoords[1] = 0
            self.texcoords[2] = 0
            self.texcoords[3] = self.imgdata.height
            self.texcoords[4] = self.imgdata.width
            self.texcoords[5] = self.imgdata.height
            self.texcoords[6] = self.imgdata.width
            self.texcoords[7] = 0
        else:
            # (0, 0), (0, 1), (1, 1), (1, 0)
            self.texcoords[0] = 0
            self.texcoords[1] = 0
            self.texcoords[2] = 0
            self.texcoords[3] = 1
            self.texcoords[4] = 1
            self.texcoords[5] = 1
            self.texcoords[6] = 1
            self.texcoords[7] = 0

    def __del__(self):
        glDeleteTextures(1, &self.id)
        self.imgdata = None

cdef class TextureRegion(AbstractTexture):
    property width:
        def __get__(self):
            return self.tex_width

    property height:
        def __get__(self):
            return self.tex_height

    def __init__(self, texture, x, y, width, height):
        self.texture = texture
        self.tex_width = width
        self.tex_height = height

        self.region = (x, y, width, height)

        if window.get_current_window():
            self._update_info()

        _texture_regions.append(weakref.ref(self))

    def _update_info(self):
        cdef GLfloat x, y, width, height

        self.id = self.texture.id
        self.target = self.texture.target

        x, y, width, height = self.region

        if self.target == GL_TEXTURE_RECTANGLE_ARB:
            # (x, y), (x, y + tex_height), (x + tex_width, y + tex_height), (x + tex_width, y)
            self.texcoords[0] = x
            self.texcoords[1] = y
            self.texcoords[2] = x
            self.texcoords[3] = y + height
            self.texcoords[4] = x + width
            self.texcoords[5] = y + height
            self.texcoords[6] = x + width
            self.texcoords[7] = y
        else:
            # (0, 0), (0, 1), (1, 1), (1, 0)
            self.texcoords[0] = x / self.texture.imgdata.width
            self.texcoords[1] = y / self.texture.imgdata.height
            self.texcoords[2] = x / self.texture.imgdata.width
            self.texcoords[3] = (y + height) / self.texture.imgdata.height
            self.texcoords[4] = (x + width) / self.texture.imgdata.width
            self.texcoords[5] = (y + height) / self.texture.imgdata.height
            self.texcoords[6] = (x + width) / self.texture.imgdata.width
            self.texcoords[7] = y / self.texture.imgdata.height

def load(filename, file = None, decoder = None, ):
    if file == None:
        file = open(filename, "rb")

    # if an explicit decoder was specified we will only try that one
    if decoder:
        return decoder.decode(file, filename)

    # otherwise decode it using all possible means
    error = codecs.ImageDecodeException("No codecs found")
    for decoder in codecs.get_decoders(filename):
        try:
            imgdata = decoder.decode(file, filename)
            return Texture(imgdata)
        except codecs.ImageDecodeException as e:
            error = e
            file.seek(0)

    raise error


window.register_context_init_func(_init_context)
