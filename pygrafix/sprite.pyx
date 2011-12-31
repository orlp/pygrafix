from pygrafix.c_headers.gl cimport *

import pygrafix

_viewport_width = None
_viewport_height = None

cdef class Sprite:
    cdef public object texture
    cdef public int x
    cdef public int y
    cdef public int anchor_x
    cdef public int anchor_y
    cdef public float scale_x
    cdef public float scale_y
    cdef public float rotation
    cdef public float opacity

    property scale:
        def __set__(self, scale):
            self.scale_x = scale
            self.scale_y = scale

        def __get__(self):
            return self.scale_x

    def __init__(self, texture):
        self.texture = texture

        self.x = 0
        self.y = 0

        self.anchor_x = 0
        self.anchor_y = 0

        self.rotation = 0.0
        self.opacity = 1.0

        self.scale_x = 1.0
        self.scale_y = 1.0

    def draw(self):
        glEnable(self.texture.target)
        glBindTexture(self.texture.target, self.texture.id)

        glPushMatrix()

        glTranslatef(self.x, self.y, 0.0)
        glRotatef(self.rotation, 0.0, 0.0, 1.0)
        glScalef(self.scale_x, self.scale_y, 1.0)
        glTranslatef(-self.anchor_x, -self.anchor_y, 0)
        glColor4f(1.0, 1.0, 1.0, self.opacity)

        if self.texture.target == GL_TEXTURE_2D:
            glBegin(GL_QUADS)
            glTexCoord2i(0, 0)
            glVertex2i(0, 0)
            glTexCoord2i(0, 1)
            glVertex2i(0, self.texture.height)
            glTexCoord2i(1, 1)
            glVertex2i(self.texture.width, self.texture.height)
            glTexCoord2i(1, 0)
            glVertex2i(self.texture.width, 0)
            glEnd()
        else:
            glBegin(GL_QUADS)
            glTexCoord2i(0, 0)
            glVertex2i(0, 0)
            glTexCoord2i(0, self.texture.height)
            glVertex2i(0, self.texture.height)
            glTexCoord2i(self.texture.width, self.texture.height)
            glVertex2i(self.texture.width, self.texture.height)
            glTexCoord2i(self.texture.width, 0)
            glVertex2i(self.texture.width, 0)
            glEnd()

        glPopMatrix()
        glDisable(self.texture.target)
