from pygrafix.c_headers cimport glfw

def get_glfw_version():
    cdef int major, minor, revision

    major, minor, revision = 0, 0, 0

    glfw.glfwGetVersion(&major, &minor, &revision)

    return "%d.%d.%d" % (major, minor, revision)
