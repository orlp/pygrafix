from pygrafix.c_headers.gl cimport *

import pygrafix

def enable():
    window = pygrafix.window.get_current_window()
    width, height = window.size

    if width < 1: width = 1
    if height < 1: height = 1

    glViewport(0, 0, width, height)

    glEnable(GL_TEXTURE_2D)
    glEnable(GL_BLEND)

    glDisable(GL_DEPTH_TEST)

    glMatrixMode(GL_PROJECTION)
    glPushMatrix()
    glLoadIdentity()

    glOrtho(0.0, width, height, 0.0, 0.0, 1.0)

    glMatrixMode(GL_MODELVIEW)
    glPushMatrix()

    glLoadIdentity()

    # displacement trick for exact pixelization
    glTranslatef(0.375, 0.375, 0.0)

def disable():
    glMatrixMode(GL_PROJECTION)
    glPopMatrix()
    glMatrixMode(GL_MODELVIEW)
    glPopMatrix()

    glDisable(GL_TEXTURE_2D)
    glEnable(GL_DEPTH_TEST)

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

    def __init__(self, image):
        self.texture = pygrafix.gl.texture.Texture(image)

        self.x = 0
        self.y = 0

        self.anchor_x = 0
        self.anchor_y = 0

        self.rotation = 0.0
        self.opacity = 1.0

        self.scale_x = 1.0
        self.scale_y = 1.0

    def draw(self):
        glBindTexture(GL_TEXTURE_2D, self.texture.id)

        glPushMatrix()

        glTranslatef(self.x, self.y, 0.0)
        glRotatef(self.rotation, 0.0, 0.0, 1.0)
        glScalef(self.scale_x, self.scale_y, 1.0)
        glTranslatef(-self.anchor_x, -self.anchor_y, 0)
        glColor4f(1.0, 1.0, 1.0, self.opacity)

        glBegin(GL_QUADS)
        glTexCoord2f(0.0, 0.0)
        glVertex2f(0.0, 0.0)
        glTexCoord2f(0.0, 1.0)
        glVertex2f(0.0, self.texture.height)
        glTexCoord2f(1.0, 1.0)
        glVertex2f(self.texture.width, self.texture.height)
        glTexCoord2f(1.0, 0.0)
        glVertex2f(self.texture.width, 0.0)
        glEnd()

        glPopMatrix()
