from pygrafix.c_headers.glew cimport GLuint, GLenum

cdef class ImageData:
    cdef public bytes data
    cdef public int width
    cdef public int height
    cdef public str format

cdef class Texture:
    # we want our texture to be weakref'able
    cdef object __weakref__
    
    cdef GLuint id
    cdef GLenum target
    cdef ImageData imgdata
    cdef readonly int width
    cdef readonly int height
