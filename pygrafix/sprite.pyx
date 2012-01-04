
from libc.stdlib cimport malloc, free
from libc.math cimport sin, cos, M_PI

from pygrafix.c_headers.glew cimport *
cimport pygrafix.image._image as image

from pygrafix import window

def _init_context():
    # init glew
    ret = glewInit()
    if ret != GLEW_OK:
        raise Exception("Error while initializing GLEW")

    # set up 2d opengl
    # disable depth testing and lighting, we won't use it
    glDisable(GL_DEPTH_TEST)
    glDisable(GL_LIGHTING)

    # enable blending
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

    # make sure glColor is used
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)

    # set up the correct viewport
    width, height = window.get_current_window().size
    glViewport(0, 0, width, height)

    glMatrixMode(GL_PROJECTION)
    glPushMatrix()
    glLoadIdentity()

    glOrtho(0.0, width, height, 0.0, 0.0, 1.0)

    glMatrixMode(GL_MODELVIEW)
    glPushMatrix()
    glLoadIdentity()

    # displacement trick for exact pixelization
    glTranslatef(0.375, 0.375, 0.0)

window.register_window_init_func(_init_context)

cdef class Sprite:
    cdef public image.Texture texture
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

    def __init__(self, texture):
        self.texture = texture

        self.x = 0.0
        self.y = 0.0

        self.anchor_x = 0.0
        self.anchor_y = 0.0

        self.rotation = 0.0

        self.scale_x = 1.0
        self.scale_y = 1.0

        self.red = 1.0
        self.green = 1.0
        self.blue = 1.0
        self.alpha = 1.0

    def draw(self, scale_smoothing = True):
        cdef GLfloat vertices[8]
        cdef GLfloat texcoords[8]

        if self.texture.target == GL_TEXTURE_RECTANGLE_ARB:
            # (0, 0), (0, tex_height), (tex_width, tex_height), (tex_width, 0)
            texcoords[0] = 0
            texcoords[1] = 0
            texcoords[2] = 0
            texcoords[3] = self.texture.height
            texcoords[4] = self.texture.width
            texcoords[5] = self.texture.height
            texcoords[6] = self.texture.width
            texcoords[7] = 0
        else:
            # (0, 0), (0, 1), (1, 1), (1, 0)
            texcoords[0] = 0
            texcoords[1] = 0
            texcoords[2] = 0
            texcoords[3] = 1
            texcoords[4] = 1
            texcoords[5] = 1
            texcoords[6] = 1
            texcoords[7] = 0

        self._update_vertices(vertices)

        glEnable(self.texture.target)
        glBindTexture(self.texture.target, self.texture.id)

        if scale_smoothing :
            filter = GL_LINEAR
        else:
            filter = GL_NEAREST

        glTexParameteri(self.texture.target, GL_TEXTURE_MIN_FILTER, filter)
        glTexParameteri(self.texture.target, GL_TEXTURE_MAG_FILTER, filter)

        glEnableClientState(GL_VERTEX_ARRAY)
        glEnableClientState(GL_TEXTURE_COORD_ARRAY)

        glTexCoordPointer(2, GL_FLOAT, 0, texcoords)
        glVertexPointer(2, GL_FLOAT, 0, vertices)

        glColor4f(self.red, self.green, self.blue, self.alpha)

        glDrawArrays(GL_QUADS, 0, 4)

        glDisableClientState(GL_VERTEX_ARRAY)
        glDisableClientState(GL_TEXTURE_COORD_ARRAY)

        glDisable(self.texture.target)

    cdef _update_vertices(self, GLfloat *vertices):
        cdef float x1, y1, x2, y2, x, y

        if self.rotation != 0.0:
            x1 = -self.anchor_x * self.scale_x
            y1 = -self.anchor_y * self.scale_y
            x2 = x1 + self.texture.width * self.scale_x
            y2 = y1 + self.texture.height * self.scale_y
            x = self.x
            y = self.y

            r = self.rotation * M_PI / 180.0
            cr = cos(r)
            sr = sin(r)

            vertices[0] = x1 * cr - y1 * sr + x
            vertices[1] = x1 * sr + y1 * cr + y
            vertices[2] = x2 * cr - y1 * sr + x
            vertices[3] = x2 * sr + y1 * cr + y
            vertices[4] = x2 * cr - y2 * sr + x
            vertices[5] = x2 * sr + y2 * cr + y
            vertices[6] = x1 * cr - y2 * sr + x
            vertices[7] = x1 * sr + y2 * cr + y

        else:
            x1 = self.x - self.anchor_x * self.scale_x
            y1 = self.y - self.anchor_y * self.scale_y
            x2 = x1 + self.texture.width * self.scale_x
            y2 = y1 + self.texture.height * self.scale_y

            vertices[0] = int(x1)
            vertices[1] = int(y1)
            vertices[2] = int(x2)
            vertices[3] = int(y1)
            vertices[4] = int(x2)
            vertices[5] = int(y2)
            vertices[6] = int(x1)
            vertices[7] = int(y2)

cdef class SpriteGroup:
    cdef public list sprites
    cdef readonly double level
    cdef readonly bint scale_smoothing

    def __init__(self, level = 0.0, scale_smoothing = True, batch = None):
        self.level = level
        self.scale_smoothing = scale_smoothing
        self.sprites = []

        if batch:
            batch.add_group(self)

    def add_sprite(self, Sprite sprite):
        index = 0

        while index < len(self.sprites) and sprite.texture != self.sprites[index].texture:
            index += 1

        self.sprites.insert(index, sprite)

    def draw(self):
        _drawlist(self.sprites, self.scale_smoothing)

    def __iter__(self):
        return iter(self.sprites)

cdef _drawlist(list spritelist, bint scale_smoothing):
    cdef GLfloat *data
    cdef Sprite sprite
    cdef int index

    if not spritelist:
        return

    texture = spritelist[0].texture

    glEnable(texture.target)
    glBindTexture(texture.target, texture.id)

    if scale_smoothing:
        filter = GL_LINEAR
    else:
        filter = GL_NEAREST

    glTexParameteri(texture.target, GL_TEXTURE_MIN_FILTER, filter)
    glTexParameteri(texture.target, GL_TEXTURE_MAG_FILTER, filter)

    if GLEW_ARB_vertex_buffer_object:
        data = <GLfloat*> malloc(len(spritelist) * sizeof(GLfloat) * 8 + len(spritelist) * sizeof(GLfloat) * 8)

        index = 0

        for sprite in spritelist:
            sprite._update_vertices(data + index)
            index += 8

        if sprite.texture.target == GL_TEXTURE_RECTANGLE_ARB:
            for sprite in spritelist:
                # (0, 0), (0, tex_height), (tex_width, tex_height), (tex_width, 0)
                data[index + 0] = 0
                data[index + 1] = 0
                data[index + 2] = 0
                data[index + 3] = texture.height
                data[index + 4] = texture.width
                data[index + 5] = texture.height
                data[index + 6] = texture.width
                data[index + 7] = 0
                index += 8
        else:
            for sprite in spritelist:
                # (0, 0), (0, 1), (1, 1), (1, 0)
                data[index + 0] = 0
                data[index + 1] = 0
                data[index + 2] = 0
                data[index + 3] = 1
                data[index + 4] = 1
                data[index + 5] = 1
                data[index + 6] = 1
                data[index + 7] = 0
                index += 8


        glEnableClientState(GL_TEXTURE_COORD_ARRAY)
        glEnableClientState(GL_VERTEX_ARRAY)

        glTexCoordPointer(2, GL_FLOAT, 0, data + (len(spritelist) * 8))
        glVertexPointer(2, GL_FLOAT, 0, data)

        glDrawArrays(GL_QUADS, 0, 4 * len(spritelist))

        glDisableClientState(GL_TEXTURE_COORD_ARRAY)
        glDisableClientState(GL_VERTEX_ARRAY)

        free(data)

    glDisable(texture.target)







#
#def draw_list(li):
#    cdef GLuint buf
#
#    glGenBuffersARB(1, &buf)
#
#
#    tex = None
#    texgroups = []
#    cdef int texcoords[8]
#    cdef int vertices[8]
#
#    cdef Sprite sprite
#    cdef image.Texture texture
#
#    for sprite in li:
#        if sprite.texture != tex:
#            tex = sprite.texture
#            texgroups.append((tex, []))
#
#        texgroups[-1][1].append(sprite)
#
#    for texture, sprites in texgroups:
#        # set up tex coords
#        if self.texture.target == GL_TEXTURE_RECTANGLE_ARB:
#            # (0, 0), (0, tex_height), (tex_width, tex_height), (tex_width, 0)
#            texcoords[0] = 0
#            texcoords[1] = 0
#            texcoords[2] = 0
#            texcoords[3] = self.texture.height
#            texcoords[4] = self.texture.width
#            texcoords[5] = self.texture.height
#            texcoords[6] = self.texture.width
#            texcoords[7] = 0
#        else:
#            # (0, 0), (0, 1), (1, 1), (1, 0)
#            texcoords[0] = 0
#            texcoords[1] = 0
#            texcoords[2] = 0
#            texcoords[3] = 1
#            texcoords[4] = 1
#            texcoords[5] = 1
#            texcoords[6] = 1
#            texcoords[7] = 0
#
#        # (0, 0), (0, tex_height), (tex_width, tex_height), (tex_width, 0)
#        vertices[0] = 0
#        vertices[1] = 0
#        vertices[2] = 0
#        vertices[3] = texture.height
#        vertices[4] = texture.width
#        vertices[5] = texture.height
#        vertices[6] = texture.width
#        vertices[7] = 0
#
#        glEnable(texture.target)
#        glBindTexture(texture.target, texture.id)
#
#        glEnableClientState(GL_VERTEX_ARRAY)
#        glEnableClientState(GL_TEXTURE_COORD_ARRAY)
#
#        glTexCoordPointer(2, GL_INT, 0, texcoords)
#        glVertexPointer(2, GL_INT, 0, vertices)
#
#        for sprite in sprites:
#            glPushMatrix()
#
#            glColor4f(sprite.red, sprite.green, sprite.blue, sprite.alpha)
#
#            if sprite.x != 0 or sprite.y != 0:
#                glTranslatef(int(sprite.x), int(sprite.y), 0.0)
#
#            if sprite.rotation != 0:
#                glRotatef(sprite.rotation, 0.0, 0.0, 1.0)
#
#            if sprite.scale_x != 0 or sprite.scale_y != 0:
#                glScalef(sprite.scale_x, sprite.scale_y, 1.0)
#
#            if sprite.anchor_x != 0 or sprite.anchor_y != 0:
#                glTranslatef(-int(sprite.anchor_x), -int(sprite.anchor_y), 0.0)
#
#            glDrawArrays(GL_QUADS, 0, 4)
#
#            glPopMatrix()
#
#        glDisableClientState(GL_VERTEX_ARRAY)
#        glDisableClientState(GL_TEXTURE_COORD_ARRAY)
#
#        glDisable(texture.target)
