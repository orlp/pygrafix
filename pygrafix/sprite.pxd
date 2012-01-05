from pygrafix.c_headers.glew cimport GLfloat, GLubyte, GLshort
cimport pygrafix.image._image as image

cdef class Sprite:
    cdef public image.AbstractTexture texture
    cdef public float x
    cdef public float y
    cdef public float anchor_x
    cdef public float anchor_y
    cdef public float scale_x
    cdef public float scale_y
    cdef public float rotation
    cdef public float red
    cdef public float green
    cdef public float blue
    cdef public float alpha
    cdef public bint visible

    cdef inline void _update_vertices(self, GLfloat *vertices)
    cdef inline void _update_texcoords(self, GLfloat *texcoords)
    cdef inline void _update_colors(self, GLubyte *colors)
