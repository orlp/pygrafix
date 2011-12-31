cdef extern from "stb_image_include.h":
    int STBI_default
    int STBI_grey
    int STBI_grey_alpha
    int STBI_rgb
    int STBI_rgb_alpha

    # we only use a few functions from stb_image, include only a few
    char* stbi_load_from_memory(unsigned char *buffer, int len, int *x, int *y, int *comp, int req_comp)
    char *stbi_failure_reason()
    void stbi_image_free(void *retval_from_stbi_load)
