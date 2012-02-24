from libc.stdlib cimport malloc, free
from pygrafix.c_headers.glew cimport *

def line(start_point, end_point, color = (1.0, 1.0, 1.0, 1.0), int width = 1, edge_smoothing = False, blending = "mix"):
    """This function draws a line between start_point and end_point. color must have the form *red, green, blue, alpha) with all components 0 <= c <= 1. blending can be any of "add", "multiply", "mix" or None. The defaults are an opaque white line, 1 pixel wide, with no smoothing and mix blending."""

    cdef int i
    cdef GLfloat color_arr[8]
    cdef GLfloat vertices_arr[4]

    if len(color) == 3:
        color = color + (1.0,)

    for i in range(4):
        color_arr[i] = color[i]
        color_arr[i+4] = color[i]

    vertices_arr[0] = start_point[0]
    vertices_arr[1] = start_point[1]
    vertices_arr[2] = end_point[0]
    vertices_arr[3] = end_point[1]

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
    """This function draws a polygon with the given vertices. vertices should be a list of (x, y) tuples. At least 3 vertices must be given. color must have the form (red, green, blue[, alpha]) with all components 0 <= c <= 1. blending can be any of "add", "multiply", "mix" or None. The defaults are an opaque white polygon, with no smoothing and mix blending."""

    cdef int i, j
    cdef float color_value
    cdef GLfloat *color_arr
    cdef GLfloat *vertices_arr

    if len(vertices) < 3:
        raise Exception("polygon needs at least 3 vertices")

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
    """This function draws the outline of a polygon with the given vertices. vertices should be a list of (x, y) tuples. At least 3 vertices must be given. color must have the form (red, green, blue[, alpha]) with all components 0 <= c <= 1. blending can be any of "add", "multiply", "mix" or None. The defaults are an opaque white 1 pixel outline, with no smoothing and mix blending."""

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

def rectangle(position, size, color = (1.0, 1.0, 1.0, 1.0), edge_smoothing = False, blending = "mix"):
    topleft = (position[0], position[1])
    topright = (position[0] + size[0], position[1])
    bottomright = (position[0] + size[0], position[1] + size[1])
    bottomleft = (position[0], position[1] + size[1])

    polygon((topleft, topright, bottomright, bottomleft), color, edge_smoothing, blending)

def rectangle_outline(position, size, color = (1.0, 1.0, 1.0, 1.0), width = 1, edge_smoothing = False, blending = "mix"):

    size = (size[0] + width, size[1] + width)
    position = (position[0] - width / 2.0, position[1] - width / 2.0)

    topleft = (position[0], position[1])
    topright = (position[0] + size[0], position[1])
    bottomright = (position[0] + size[0], position[1] + size[1])
    bottomleft = (position[0], position[1] + size[1])

    polygon_outline((topleft, topright, bottomright, bottomleft), color, width, edge_smoothing, blending)


__all__ = ["line", "polygon", "polygon_outline", "rectangle", "rectangle_outline"]
