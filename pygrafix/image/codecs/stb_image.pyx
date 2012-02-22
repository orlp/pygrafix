from pygrafix.c_headers.stb_image cimport *

from pygrafix.image import ImageData
from pygrafix.image.codecs import ImageDecodeException

class StbImageDecoder:
    def get_extensions(self):
        return ["bmp", "tga", "psd", "png", "jpg", "gif"]

    def decode(self, file, filename):
        cdef int img_width, img_height, orig_channels
        cdef unsigned char *c_img_data
        cdef bytes img_data

        file_data = file.read()

        c_img_data = stbi_load_from_memory(<unsigned char*> file_data, len(file_data), &img_width, &img_height, &orig_channels, STBI_default)

        if c_img_data == NULL:
            raise ImageDecodeException("Error while loading image data: " + str(stbi_failure_reason()))

        img_data = c_img_data[:img_width * img_height * orig_channels] # trick for cython to turn char* into bytes even with null

        stbi_image_free(c_img_data)

        if orig_channels == STBI_grey:
            format = "l"
        elif orig_channels == STBI_grey_alpha:
            format = "la"
        elif orig_channels == STBI_rgb:
            format = "rgb"
        elif orig_channels == STBI_rgb_alpha:
            format = "rgba"
        else:
            raise ImageDecodeException("Unknown channel count: " + str(orig_channels))

        return ImageData(img_width, img_height, format, img_data)

class StbImageEncoder:
    def get_extensions(self):
        return ["bmp", "tga"]

    def encode(self, filename):
        pass
