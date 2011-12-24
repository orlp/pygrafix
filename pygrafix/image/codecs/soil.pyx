from pygrafix.c_headers.soil cimport *

from pygrafix.image import Image
from pygrafix.image.codecs import ImageDecodeException

class SoilImageDecoder:
    formats = ["bmp", "tga", "dds", "png", "jpg"]

    _channel_constants = {
        None: SOIL_LOAD_AUTO,
        1: SOIL_LOAD_L,
        2: SOIL_LOAD_LA,
        3: SOIL_LOAD_RGB,
        4: SOIL_LOAD_RGBA,
    }

    def decode(self, file, format, request_channels):
        if not format in self.formats:
            raise ImageDecodeException

        cdef int img_width, img_height, orig_channels
        cdef char *c_img_data
        cdef bytes img_data

        file_data = file.read()

        c_img_data = <char*> SOIL_load_image_from_memory(file_data, len(file_data), &img_width, &img_height, &orig_channels, self._channel_constants[request_channels])

        if c_img_data == NULL:
            raise ImageDecodeException("Error while loading image data: " + str(SOIL_last_result()))

        if request_channels == None:
            request_channels = orig_channels

        img_data = c_img_data[:img_width * img_height * request_channels]

        result = Image(img_width, img_height, request_channels, img_data)

        return result
