from pygrafix.c_headers.gl cimport *
from pygrafix.c_headers.soil cimport *

from pygrafix import window
from pygrafix import image

# flags (SOIL image data -> texture)
FLAG_POWER_OF_TWO = SOIL_FLAG_POWER_OF_TWO
FLAG_MIPMAPS = SOIL_FLAG_MIPMAPS
FLAG_TEXTURE_REPEATS = SOIL_FLAG_TEXTURE_REPEATS
FLAG_MULTIPLY_ALPHA = SOIL_FLAG_MULTIPLY_ALPHA
FLAG_INVERT_Y = SOIL_FLAG_INVERT_Y
FLAG_COMPRESS_TO_DXT = SOIL_FLAG_COMPRESS_TO_DXT
FLAG_DDS_LOAD_DIRECT = SOIL_FLAG_DDS_LOAD_DIRECT
FLAG_NTSC_SAFE_RGB = SOIL_FLAG_NTSC_SAFE_RGB
FLAG_COCG_Y = SOIL_FLAG_CoCg_Y
FLAG_TEXTURE_RECTANGLE = SOIL_FLAG_TEXTURE_RECTANGLE

cdef class Texture:
    cdef object _image
    cdef readonly int width
    cdef readonly int height
    cdef unsigned int _texture_flags
    cdef GLuint _texture_id

    property flags:
        def __get__(self):
            return self._texture_flags

        def __set__(self, newflags):
            if newflags != self._texture_flags:
                self._texture_flags = newflags

                cur_window = window.get_current_window()

                # we already have an opengl texture active that we must recreate using the new flags
                if cur_window and self._texture_id in cur_window._opengl_textures:
                    self._create_texture()

    property id:
        def __get__(self):
            cur_window = window.get_current_window()

            if not cur_window:
                raise Exception("Error while getting texture id: no active OpenGL context")

            # we don't have an active, valid opengl texture
            if not self._texture_id in cur_window._opengl_textures:
                # so generate a new one
                self._create_texture(True)

            return self._texture_id

    def __init__(self, image, flags = FLAG_POWER_OF_TWO | FLAG_MULTIPLY_ALPHA | FLAG_COMPRESS_TO_DXT):
        self._texture_flags = flags

        self._image = image
        self.width = image.width
        self.height = image.height

        self._create_texture(True)

    def __del__(self):
        cur_window = window.get_current_window()

        if cur_window and self.texture_id in cur_window._opengl_textures:
            glDeleteTextures(1, &self._texture_id)
            cur_window._opengl_textures.discard(self._texture_id)

    cdef _create_texture(self, new = False):
        cur_window = window.get_current_window()

        if not cur_window:
            raise Exception("Error while creating texture: no active OpenGL context")

        if new:
            self._texture_id = 0

        texture_id = SOIL_create_OGL_texture(self._image.data,
                                             self._image.width,
                                             self._image.height,
                                             self._image.channels,
                                             self._texture_id,
                                             self._texture_flags)

        if texture_id == 0:
            self._texture_id = 0
            raise Exception("Error while creating texture: " + str(SOIL_last_result()))

        cur_window._opengl_textures.add(texture_id)
        self._texture_id = texture_id
