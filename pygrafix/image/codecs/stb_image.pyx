from pygrafix.c_headers.stb_image cimport *
from pygrafix.c_headers.stb_image_write cimport *

from pygrafix.image import ImageData
from pygrafix.image.codecs import ImageDecodeException, ImageEncodeException

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
        return (".bmp", ".tga", ".png")

    def encode(self, imgdata, file, filename):
        cdef bytes output_data, input_data
        cdef int output_len
        cdef unsigned char* c_output_data
        cdef unsigned char* c_input_data

        input_data = imgdata.data
        c_input_data = input_data

        if len(imgdata.data) != imgdata.width * imgdata.height * len(imgdata.format):
            raise ImageEncodeException("ImageData has invalid size")

        if filename.endswith("bmp"):
            if len(imgdata.format) > 3:
                raise ImageEncodeException("BMP encoder doesn't support alpha-channel")

            c_output_data = stbi_write_bmp_mem(imgdata.width, imgdata.height, len(imgdata.format), <void *> c_input_data, &output_len)

        elif filename.endswith("tga"):
            c_output_data = stbi_write_tga_mem(imgdata.width, imgdata.height, len(imgdata.format), <void *> c_input_data, &output_len)

        elif filename.endswith("png"):
            c_output_data = stbi_write_png_mem(imgdata.width, imgdata.height, len(imgdata.format), <void *> c_input_data, 0, &output_len)

        else:
            raise ImageEncodeException("Unknown file type")

        if c_output_data == NULL:
            raise ImageEncodeException("stb_image_write error")

        output_data = c_output_data[:output_len]
        file.write(output_data)
