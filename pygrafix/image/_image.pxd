from pygrafix.c_headers.glew cimport GLuint, GLenum, GLfloat

cdef class ImageData:
    cdef public bytes data
    cdef public int width
    cdef public int height
    cdef public str format

cdef class AbstractTexture:
    # we want our texture to be weakref'able
    cdef object __weakref__

    cdef GLuint id
    cdef GLenum target

    cdef GLfloat[8] texcoords

    cdef int tex_width
    cdef int tex_height

cdef class Texture(AbstractTexture):
    cdef ImageData imgdata

cdef class TextureRegion(AbstractTexture):
    cdef tuple region
    cdef readonly Texture texture
