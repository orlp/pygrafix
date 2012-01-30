from pygrafix.c_headers.glew cimport GLuint, GLenum, GLfloat

cdef class ImageData:
    cdef public bytes data
    cdef public int width
    cdef public int height
    cdef public str format

cdef class InternalTexture:
    # we want our texture to be weakref'able
    cdef object __weakref__
    cdef ImageData imgdata

    cdef readonly width
    cdef readonly height

    cdef GLuint id
    cdef GLenum target

cdef class Texture:
    # we want our texture to be weakref'able
    cdef object __weakref__

    cdef readonly InternalTexture internal_texture
    cdef tuple _region
    cdef GLfloat[8] texcoords
