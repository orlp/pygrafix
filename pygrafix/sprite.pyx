from libc.stdlib cimport malloc, free
from libc.string cimport memset, memcpy
from libc.math cimport sin, cos, M_PI
from pygrafix.c_headers.glew cimport *

from pygrafix import window

cdef GLuint shader_program
cdef char *vertex_shader_src, *fragment_shader_src


vertex_shader_src = """

uniform float sprite_rotation;
uniform float vec2 sprite_position;

void main() {
    glPosition = sprite_position
}

"""

fragment_shader_src = """

uniform float vec4 sprite_color

void main() {
	gl_FragColor = sprite_color;
}

"""


def _load_shader():
    cdef int shader_length
    cdef GLuint vertex_shader, fragment_shader

    vertex_shader = glCreateShader(GL_VERTEX_SHADER)
    fragment_shader = glCreateShader(GL_FRAGMENT_SHADER)

    shader_length = len(vertex_shader_src)
    glShaderSource(vertex_shader, 1, <GLchar **> &vertex_shader_src, &shader_length)

    shader_length = len(fragment_shader_src)
    glShaderSource(fragment_shader, 1, <GLchar **> &fragment_shader_src, &shader_length)

    glCompileShader(vertex_shader)
    glCompileShader(fragment_shader)

    shader_program = glCreateProgram()

    glAttachShader(shader_program, vertex_shader)
    glAttachShader(shader_program, fragment_shader)

    glLinkProgram(shader_program)
    glUseProgram(shader_program)

def _init_context():
    # init glew
    ret = glewInit()
    if ret != GLEW_OK:
        raise Exception("Error while initializing GLEW")

    # set up 2d opengl
    # disable depth testing and lighting, we won't use it
    glDisable(GL_DEPTH_TEST)
    glDepthMask(GL_FALSE)
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

    _load_shader()


cdef class Sprite:
    property scale:
        def __get__(self):
            return self.scale_x

        def __set__(self, scale):
            self.scale_x = scale
            self.scale_y = scale

    property position:
        def __get__(self):
            return (self.scale_x, self.scale_y)

        def __set__(self, position):
            self.scale_x, self.scale_y = position

    property width:
        def __get__(self):
            return self.texture.width

    property height:
        def __get__(self):
            return self.texture.height

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

        self.visible = True

    def draw(self, scale_smoothing = True):
        cdef GLfloat vertices[8]
        cdef GLfloat texcoords[8]
        cdef GLubyte colors[16]

        if not self.visible: return

        self._update_colors(colors)
        self._update_texcoords(texcoords)
        self._update_vertices(vertices)

        glEnable(self.texture.target)
        glBindTexture(self.texture.target, self.texture.id)

        if scale_smoothing :
            filter = GL_LINEAR
        else:
            filter = GL_NEAREST

        glTexParameteri(self.texture.target, GL_TEXTURE_MIN_FILTER, filter)
        glTexParameteri(self.texture.target, GL_TEXTURE_MAG_FILTER, filter)

        glEnableClientState(GL_COLOR_ARRAY)
        glEnableClientState(GL_VERTEX_ARRAY)
        glEnableClientState(GL_TEXTURE_COORD_ARRAY)

        glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors)
        glTexCoordPointer(2, GL_FLOAT, 0, texcoords)
        glVertexPointer(2, GL_FLOAT, 0, vertices)

        glDrawArrays(GL_QUADS, 0, 4)

        glEnableClientState(GL_COLOR_ARRAY)
        glDisableClientState(GL_VERTEX_ARRAY)
        glDisableClientState(GL_TEXTURE_COORD_ARRAY)

        glDisable(self.texture.target)

    cdef inline void _update_vertices(self, GLfloat *vertices):
        cdef float x1, y1, x2, y2, x, y

        if not self.visible:
            memset(vertices, 0, 8 * sizeof(GLfloat))
            return

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
            vertices[2] = x1 * cr - y2 * sr + x
            vertices[3] = x1 * sr + y2 * cr + y
            vertices[4] = x2 * cr - y2 * sr + x
            vertices[5] = x2 * sr + y2 * cr + y
            vertices[6] = x2 * cr - y1 * sr + x
            vertices[7] = x2 * sr + y1 * cr + y

        else:
            x1 = self.x - self.anchor_x * self.scale_x
            y1 = self.y - self.anchor_y * self.scale_y
            x2 = x1 + self.texture.width * self.scale_x
            y2 = y1 + self.texture.height * self.scale_y

            vertices[0] = x1
            vertices[1] = y1
            vertices[2] = x1
            vertices[3] = y2
            vertices[4] = x2
            vertices[5] = y2
            vertices[6] = x2
            vertices[7] = y1

    cdef inline void _update_texcoords(self, GLfloat *texcoords):
        if not self.visible:
            memset(texcoords, 0, 8 * sizeof(GLfloat))
            return

        memcpy(texcoords, self.texture.texcoords, 8 * sizeof(GLfloat))

    cdef inline void _update_colors(self, GLubyte *colors):
        cdef GLubyte r, g, b, a

        if not self.visible:
            memset(colors, 0, 16 * sizeof(GLubyte))
            return

        r = <GLubyte> (self.red * 255)
        g = <GLubyte> (self.green * 255)
        b = <GLubyte> (self.blue * 255)
        a = <GLubyte> (self.alpha * 255)

        # we have to do this 4 times (once for each vertex). Loop unrolled for max perf
        colors[0] = r
        colors[1] = g
        colors[2] = b
        colors[3] = a
        colors[4] = r
        colors[5] = g
        colors[6] = b
        colors[7] = a
        colors[8] = r
        colors[9] = g
        colors[10] = b
        colors[11] = a
        colors[12] = r
        colors[13] = g
        colors[14] = b
        colors[15] = a

cdef class SpriteGroup:
    cdef public list sprites
    cdef readonly bint scale_smoothing

    def __init__(self, scale_smoothing = True, batch = None):
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
        cdef Sprite sprite
        cdef int i

        if not self.sprites:
            return

        index = 0
        while index < len(self.sprites):
            start_index = index
            texture = self.sprites[index].texture

            while index < len(self.sprites) and self.sprites[index].texture == texture:
                index += 1

            _drawlist(self.sprites[start_index:index], texture, self.scale_smoothing)

    def __iter__(self):
        return iter(self.sprites)

cdef _drawlist(list spritelist, image.AbstractTexture texture, bint scale_smoothing):
    cdef GLfloat vertices[8]
    cdef GLfloat *texcoords
    cdef GLubyte *colors
    cdef Sprite sprite

    cdef int index
    cdef size_t num_sprites = len(spritelist)

    glEnable(texture.target)
    glBindTexture(texture.target, texture.id)

    if scale_smoothing:
        filter = GL_LINEAR
    else:
        filter = GL_NEAREST

    glTexParameteri(texture.target, GL_TEXTURE_MIN_FILTER, filter)
    glTexParameteri(texture.target, GL_TEXTURE_MAG_FILTER, filter)

    glEnableClientState(GL_VERTEX_ARRAY)
    glVertexPointer(2, GL_FLOAT, 0, vertices)

    for index in range(num_sprites):
        sprite = spritelist[index]

        vertices[0]

        glUniform1f(glGetUniformLocation(shader_program, "sprite_rotation"), sprite.rotation)
        glUniform2f(glGetUniformLocation(shader_program, "sprite_position"), sprite.x, sprite.y)
        glUniform4f(glGetUniformLocation(shader_program, "sprite_color"), sprite.red, sprite.green, sprite.blue, sprite.alpha)

        glDrawArrays(GL_QUADS, 0, 4)

    glDisableClientState(GL_VERTEX_ARRAY)
    glDisable(texture.target)


window.register_context_init_func(_init_context)
