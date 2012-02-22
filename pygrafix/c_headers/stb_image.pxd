cdef extern from "stb_image_include.h":
    ctypedef struct FILE # transparent struct
    
    int STBI_default
    int STBI_grey
    int STBI_grey_alpha
    int STBI_rgb
    int STBI_rgb_alpha
    
    ctypedef unsigned char stbi_uc
    ctypedef void (*stbi_idct_8x8)(stbi_uc *out, int out_stride, short *data, unsigned short *dequantize)
    ctypedef void (*stbi_YCbCr_to_RGB_run)(stbi_uc *output, stbi_uc *y, stbi_uc *cb, stbi_uc *cr, int count, int step)

    stbi_uc *stbi_load_from_memory(stbi_uc *buffer, int len, int *x, int *y, int *comp, int req_comp)
    stbi_uc *stbi_load(char *filename, int *x, int *y, int *comp, int req_comp)
    stbi_uc *stbi_load_from_file(FILE *f, int *x, int *y, int *comp, int req_comp)

    ctypedef struct stbi_io_callbacks:
        int (*read)(void *user, char *data, int size)
        void (*skip) (void *user, unsigned n)
        int (*eof) (void *user)

    stbi_uc *stbi_load_from_callbacks(stbi_io_callbacks *clbk, void *user, int *x, int *y, int *comp, int req_comp)
    float *stbi_loadf_from_memory(stbi_uc *buffer, int len, int *x, int *y, int *comp, int req_comp)
    float *stbi_loadf(char *filename, int *x, int *y, int *comp, int req_comp)
    float *stbi_loadf_from_file(FILE *f, int *x, int *y, int *comp, int req_comp)
    float *stbi_loadf_from_callbacks(stbi_io_callbacks *clbk, void *user, int *x, int *y, int *comp, int req_comp)
    void stbi_hdr_to_ldr_gamma(float gamma)
    void stbi_hdr_to_ldr_scale(float scale)
    void stbi_ldr_to_hdr_gamma(float gamma)
    void stbi_ldr_to_hdr_scale(float scale)
    int stbi_is_hdr_from_callbacks(stbi_io_callbacks *clbk, void *user)
    int stbi_is_hdr_from_memory(stbi_uc *buffer, int len)
    int stbi_is_hdr(char *filename)
    int stbi_is_hdr_from_file(FILE *f)
    char *stbi_failure_reason() 
    void stbi_image_free(void *retval_from_stbi_load)
    int stbi_info_from_memory(stbi_uc *buffer, int len, int *x, int *y, int *comp)
    int stbi_info_from_callbacks(stbi_io_callbacks *clbk, void *user, int *x, int *y, int *comp)
    int stbi_info(char *filename, int *x, int *y, int *comp)
    int stbi_info_from_file (FILE *f, int *x, int *y, int *comp)
    void stbi_set_unpremultiply_on_load(int flag_true_if_should_unpremultiply)
    void stbi_convert_iphone_png_to_rgb(int flag_true_if_should_convert)
    char *stbi_zlib_decode_malloc_guesssize( char *buffer, int len, int initial_size, int *outlen)
    char *stbi_zlib_decode_malloc( char *buffer, int len, int *outlen)
    int stbi_zlib_decode_buffer(char *obuffer, int olen, char *ibuffer, int ilen)
    char *stbi_zlib_decode_noheader_malloc( char *buffer, int len, int *outlen)
    int stbi_zlib_decode_noheader_buffer(char *obuffer, int olen, char *ibuffer, int ilen)
    void stbi_install_idct(stbi_idct_8x8 func)
    void stbi_install_YCbCr_to_RGB(stbi_YCbCr_to_RGB_run func)