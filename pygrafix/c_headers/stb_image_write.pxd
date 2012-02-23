cdef extern from "stb_image_write_include.h":
    ctypedef struct FILE # transparent struct

    int stbi_write_png(char *filename, int w, int h, int comp, void *data, int stride_in_bytes)
    int stbi_write_bmp(char *filename, int w, int h, int comp, void *data)
    int stbi_write_tga(char *filename, int w, int h, int comp, void *data)

    int stbi_write_png_file(FILE* f, int w, int h, int comp, void *data, int stride_in_bytes)
    int stbi_write_bmp_file(FILE* f, int w, int h, int comp, void *data)
    int stbi_write_tga_file(FILE* f, int w, int h, int comp, void *data)

    unsigned char* stbi_write_png_mem(int w, int h, int comp, void *data, int stride_in_bytes, int *len)
    unsigned char* stbi_write_bmp_mem(int w, int h, int comp, void *data, int *len)
    unsigned char* stbi_write_tga_mem(int w, int h, int comp, void *data, int *len)
