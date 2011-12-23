cdef extern from "soil_include.h":
    int SOIL_LOAD_AUTO
    int SOIL_LOAD_L
    int SOIL_LOAD_LA
    int SOIL_LOAD_RGB
    int SOIL_LOAD_RGBA

    int SOIL_CREATE_NEW_ID

    int SOIL_FLAG_POWER_OF_TWO
    int SOIL_FLAG_MIPMAPS
    int SOIL_FLAG_TEXTURE_REPEATS
    int SOIL_FLAG_MULTIPLY_ALPHA
    int SOIL_FLAG_INVERT_Y
    int SOIL_FLAG_COMPRESS_TO_DXT
    int SOIL_FLAG_DDS_LOAD_DIRECT
    int SOIL_FLAG_NTSC_SAFE_RGB
    int SOIL_FLAG_CoCg_Y
    int SOIL_FLAG_TEXTURE_RECTANGLE

    int SOIL_SAVE_TYPE_TGA
    int SOIL_SAVE_TYPE_BMP
    int SOIL_SAVE_TYPE_DDS

    char *SOIL_DDS_CUBEMAP_FACE_ORDER

    int SOIL_HDR_RGBE
    int SOIL_HDR_RGBdivA
    int SOIL_HDR_RGBdivA2

    cdef unsigned int SOIL_load_OGL_texture(char *filename, int force_channels, unsigned int reuse_texture_ID, unsigned int flags)
    cdef unsigned int SOIL_load_OGL_cubemap(char *x_pos_file, char *x_neg_file, char *y_pos_file, char *y_neg_file, char *z_pos_file, char *z_neg_file, int force_channels, unsigned int reuse_texture_ID, unsigned int flags)
    cdef unsigned int SOIL_load_OGL_single_cubemap(char *filename, char face_order[6], int force_channels, unsigned int reuse_texture_ID, unsigned int flags)
    cdef unsigned int SOIL_load_OGL_HDR_texture(char *filename, int fake_HDR_format, int rescale_to_max, unsigned int reuse_texture_ID, unsigned int flags)
    cdef unsigned int SOIL_load_OGL_texture_from_memory(unsigned char *buffer, int buffer_length, int force_channels, unsigned int reuse_texture_ID, unsigned int flags)
    cdef unsigned int SOIL_load_OGL_cubemap_from_memory(unsigned char *x_pos_buffer, int x_pos_buffer_length, unsigned char *x_neg_buffer, int x_neg_buffer_length, unsigned char *y_pos_buffer, int y_pos_buffer_length, unsigned char *y_neg_buffer, int y_neg_buffer_length, unsigned char *z_pos_buffer, int z_pos_buffer_length, unsigned char *z_neg_buffer, int z_neg_buffer_length, int force_channels, unsigned int reuse_texture_ID, unsigned int flags)
    cdef unsigned int SOIL_load_OGL_single_cubemap_from_memory(unsigned char *buffer, int buffer_length, char face_order[6], int force_channels, unsigned int reuse_texture_ID, unsigned int flags)
    cdef unsigned int SOIL_create_OGL_texture(unsigned char *data, int width, int height, int channels, unsigned int reuse_texture_ID, unsigned int flags)
    cdef unsigned int SOIL_create_OGL_single_cubemap(unsigned char *data, int width, int height, int channels, char face_order[6], unsigned int reuse_texture_ID, unsigned int flags)
    cdef int SOIL_save_screenshot(char *filename, int image_type, int x, int y, int width, int height)
    cdef unsigned char* SOIL_load_image(char *filename, int *width, int *height, int *channels, int force_channels)
    cdef unsigned char* SOIL_load_image_from_memory(unsigned char *buffer, int buffer_length, int *width, int *height, int *channels, int force_channels)
    cdef int SOIL_save_image(char *filename, int image_type, int width, int height, int channels, unsigned char *data)
    cdef void SOIL_free_image_data(unsigned char *img_data)
    cdef char* SOIL_last_result()
