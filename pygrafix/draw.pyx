from libc.stdlib cimport malloc, free
from pygrafix.c_headers.glew cimport *

def line(point1, point2, color = (1.0, 1.0, 1.0, 1.0), int width = 1, edge_smoothing = False, blending = "mix"):
    cdef int i
    cdef GLfloat color_arr[8]
    cdef GLfloat vertices_arr[4]

    if len(color) == 3:
        color = color + (1.0,)

    for i in range(4):
        color_arr[i] = color[i]
        color_arr[i+4] = color[i]

    vertices_arr[0] = point1[0]
    vertices_arr[1] = point1[1]
    vertices_arr[2] = point2[0]
    vertices_arr[3] = point2[1]

    glEnableClientState(GL_COLOR_ARRAY)
    glEnableClientState(GL_VERTEX_ARRAY)

    glColorPointer(4, GL_FLOAT, 0, color_arr)
    glVertexPointer(2, GL_FLOAT, 0, vertices_arr)

    #if edge_smoothing:
    #    glEnable(GL_LINE_SMOOTH)
    #else:
    #    glDisable(GL_LINE_SMOOTH)

    if blending == "add":
        glEnable(GL_BLEND)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE)
    elif blending == "multiply":
        glEnable(GL_BLEND)
        glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
    elif blending == "mix":
        glEnable(GL_BLEND)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    else:
        glDisable(GL_BLEND)

    glLineWidth(width)
    glDrawArrays(GL_LINES, 0, 2)

    glDisableClientState(GL_COLOR_ARRAY)
    glDisableClientState(GL_VERTEX_ARRAY)

def polygon(vertices, color = (1.0, 1.0, 1.0, 1.0), edge_smoothing = False, blending = "mix"):
    cdef int i, j
    cdef float color_value
    cdef GLfloat *color_arr
    cdef GLfloat *vertices_arr

    color_arr = <GLfloat*> malloc(len(vertices) * 4 * sizeof(GLfloat))
    vertices_arr = <GLfloat*> malloc(len(vertices) * 2 * sizeof(GLfloat))

    if len(color) == 3:
        color = color + (1.0,)

    for i in range(4):
        color_value = color[i]

        for j in range(len(vertices)):
            color_arr[4*j + i] = color_value

    for i, vertex in enumerate(vertices):
        vertices_arr[2*i] = vertex[0]
        vertices_arr[2*i + 1] = vertex[1]

    glEnableClientState(GL_COLOR_ARRAY)
    glEnableClientState(GL_VERTEX_ARRAY)

    glColorPointer(4, GL_FLOAT, 0, color_arr)
    glVertexPointer(2, GL_FLOAT, 0, vertices_arr)

    #if edge_smoothing:
    #    glEnable(GL_POLYGON_SMOOTH)
    #else:
    #    glDisable(GL_POLYGON_SMOOTH)

    if blending == "add":
        glEnable(GL_BLEND)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE)
    elif blending == "multiply":
        glEnable(GL_BLEND)
        glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
    elif blending == "mix":
        glEnable(GL_BLEND)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    else:
        glDisable(GL_BLEND)

    glDrawArrays(GL_POLYGON, 0, len(vertices))

    glDisableClientState(GL_COLOR_ARRAY)
    glDisableClientState(GL_VERTEX_ARRAY)

    free(color_arr)
    free(vertices_arr)

def polygon_outline(vertices, color = (1.0, 1.0, 1.0, 1.0), width = 1, edge_smoothing = False, blending = "mix"):
    cdef int i, j
    cdef float color_value
    cdef GLfloat *color_arr
    cdef GLfloat *vertices_arr

    color_arr = <GLfloat*> malloc(len(vertices) * 4 * sizeof(GLfloat))
    vertices_arr = <GLfloat*> malloc(len(vertices) * 2 * sizeof(GLfloat))

    if len(color) == 3:
        color = color + (1.0,)

    for i in range(4):
        color_value = color[i]

        for j in range(len(vertices)):
            color_arr[4*j + i] = color_value

    for i, vertex in enumerate(vertices):
        vertices_arr[2*i] = vertex[0]
        vertices_arr[2*i + 1] = vertex[1]

    glEnableClientState(GL_COLOR_ARRAY)
    glEnableClientState(GL_VERTEX_ARRAY)

    glColorPointer(4, GL_FLOAT, 0, color_arr)
    glVertexPointer(2, GL_FLOAT, 0, vertices_arr)

    #if edge_smoothing:
    #    glEnable(GL_LINE_SMOOTH)
    #else:
    #    glDisable(GL_LINE_SMOOTH)

    if blending == "add":
        glEnable(GL_BLEND)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE)
    elif blending == "multiply":
        glEnable(GL_BLEND)
        glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
    elif blending == "mix":
        glEnable(GL_BLEND)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    else:
        glDisable(GL_BLEND)

    glLineWidth(width)
    glDrawArrays(GL_LINE_LOOP, 0, len(vertices))

    glDisableClientState(GL_COLOR_ARRAY)
    glDisableClientState(GL_VERTEX_ARRAY)

    free(color_arr)
    free(vertices_arr)
