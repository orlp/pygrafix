cdef class ImageData:
    cdef public bytes data
    cdef public int width
    cdef public int height
    cdef public str format

cdef class Texture:
    cdef int _smoothing
    cdef int _id
    cdef ImageData imgdata
    cdef readonly int width
    cdef readonly int height
