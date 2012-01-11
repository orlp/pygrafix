cdef extern from "glfw_include.h":
    enum:
        GLFW_VERSION_MAJOR
        GLFW_VERSION_MINOR
        GLFW_VERSION_REVISION

        GLFW_RELEASE
        GLFW_PRESS

        GLFW_KEY_SPACE
        GLFW_KEY_APOSTROPHE
        GLFW_KEY_COMMA
        GLFW_KEY_MINUS
        GLFW_KEY_PERIOD
        GLFW_KEY_SLASH
        GLFW_KEY_0
        GLFW_KEY_1
        GLFW_KEY_2
        GLFW_KEY_3
        GLFW_KEY_4
        GLFW_KEY_5
        GLFW_KEY_6
        GLFW_KEY_7
        GLFW_KEY_8
        GLFW_KEY_9
        GLFW_KEY_SEMICOLON
        GLFW_KEY_EQUAL
        GLFW_KEY_A
        GLFW_KEY_B
        GLFW_KEY_C
        GLFW_KEY_D
        GLFW_KEY_E
        GLFW_KEY_F
        GLFW_KEY_G
        GLFW_KEY_H
        GLFW_KEY_I
        GLFW_KEY_J
        GLFW_KEY_K
        GLFW_KEY_L
        GLFW_KEY_M
        GLFW_KEY_N
        GLFW_KEY_O
        GLFW_KEY_P
        GLFW_KEY_Q
        GLFW_KEY_R
        GLFW_KEY_S
        GLFW_KEY_T
        GLFW_KEY_U
        GLFW_KEY_V
        GLFW_KEY_W
        GLFW_KEY_X
        GLFW_KEY_Y
        GLFW_KEY_Z
        GLFW_KEY_LEFT_BRACKET
        GLFW_KEY_BACKSLASH
        GLFW_KEY_RIGHT_BRACKET
        GLFW_KEY_GRAVE_ACCENT
        GLFW_KEY_WORLD_1
        GLFW_KEY_WORLD_2

        GLFW_KEY_ESCAPE
        GLFW_KEY_ENTER
        GLFW_KEY_TAB
        GLFW_KEY_BACKSPACE
        GLFW_KEY_INSERT
        GLFW_KEY_DELETE
        GLFW_KEY_RIGHT
        GLFW_KEY_LEFT
        GLFW_KEY_DOWN
        GLFW_KEY_UP
        GLFW_KEY_PAGE_UP
        GLFW_KEY_PAGE_DOWN
        GLFW_KEY_HOME
        GLFW_KEY_END
        GLFW_KEY_CAPS_LOCK
        GLFW_KEY_SCROLL_LOCK
        GLFW_KEY_NUM_LOCK
        GLFW_KEY_PRINT_SCREEN
        GLFW_KEY_PAUSE
        GLFW_KEY_F1
        GLFW_KEY_F2
        GLFW_KEY_F3
        GLFW_KEY_F4
        GLFW_KEY_F5
        GLFW_KEY_F6
        GLFW_KEY_F7
        GLFW_KEY_F8
        GLFW_KEY_F9
        GLFW_KEY_F10
        GLFW_KEY_F11
        GLFW_KEY_F12
        GLFW_KEY_F13
        GLFW_KEY_F14
        GLFW_KEY_F15
        GLFW_KEY_F16
        GLFW_KEY_F17
        GLFW_KEY_F18
        GLFW_KEY_F19
        GLFW_KEY_F20
        GLFW_KEY_F21
        GLFW_KEY_F22
        GLFW_KEY_F23
        GLFW_KEY_F24
        GLFW_KEY_F25
        GLFW_KEY_KP_0
        GLFW_KEY_KP_1
        GLFW_KEY_KP_2
        GLFW_KEY_KP_3
        GLFW_KEY_KP_4
        GLFW_KEY_KP_5
        GLFW_KEY_KP_6
        GLFW_KEY_KP_7
        GLFW_KEY_KP_8
        GLFW_KEY_KP_9
        GLFW_KEY_KP_DECIMAL
        GLFW_KEY_KP_DIVIDE
        GLFW_KEY_KP_MULTIPLY
        GLFW_KEY_KP_SUBTRACT
        GLFW_KEY_KP_ADD
        GLFW_KEY_KP_ENTER
        GLFW_KEY_KP_EQUAL
        GLFW_KEY_LEFT_SHIFT
        GLFW_KEY_LEFT_CONTROL
        GLFW_KEY_LEFT_ALT
        GLFW_KEY_LEFT_SUPER
        GLFW_KEY_RIGHT_SHIFT
        GLFW_KEY_RIGHT_CONTROL
        GLFW_KEY_RIGHT_ALT
        GLFW_KEY_RIGHT_SUPER
        GLFW_KEY_MENU
        GLFW_KEY_LAST

        GLFW_KEY_ESC
        GLFW_KEY_DEL
        GLFW_KEY_PAGEUP
        GLFW_KEY_PAGEDOWN
        GLFW_KEY_KP_NUM_LOCK
        GLFW_KEY_LCTRL
        GLFW_KEY_LSHIFT
        GLFW_KEY_LALT
        GLFW_KEY_LSUPER
        GLFW_KEY_RCTRL
        GLFW_KEY_RSHIFT
        GLFW_KEY_RALT
        GLFW_KEY_RSUPER

        GLFW_MOUSE_BUTTON_1
        GLFW_MOUSE_BUTTON_2
        GLFW_MOUSE_BUTTON_3
        GLFW_MOUSE_BUTTON_4
        GLFW_MOUSE_BUTTON_5
        GLFW_MOUSE_BUTTON_6
        GLFW_MOUSE_BUTTON_7
        GLFW_MOUSE_BUTTON_8
        GLFW_MOUSE_BUTTON_LAST

        GLFW_MOUSE_BUTTON_LEFT
        GLFW_MOUSE_BUTTON_RIGHT
        GLFW_MOUSE_BUTTON_MIDDLE

        GLFW_JOYSTICK_1
        GLFW_JOYSTICK_2
        GLFW_JOYSTICK_3
        GLFW_JOYSTICK_4
        GLFW_JOYSTICK_5
        GLFW_JOYSTICK_6
        GLFW_JOYSTICK_7
        GLFW_JOYSTICK_8
        GLFW_JOYSTICK_9
        GLFW_JOYSTICK_10
        GLFW_JOYSTICK_11
        GLFW_JOYSTICK_12
        GLFW_JOYSTICK_13
        GLFW_JOYSTICK_14
        GLFW_JOYSTICK_15
        GLFW_JOYSTICK_16
        GLFW_JOYSTICK_LAST

        GLFW_WINDOWED
        GLFW_FULLSCREEN

        GLFW_ACTIVE
        GLFW_ICONIFIED
        GLFW_ACCELERATED
        GLFW_OPENGL_REVISION

        GLFW_RED_BITS
        GLFW_GREEN_BITS
        GLFW_BLUE_BITS
        GLFW_ALPHA_BITS
        GLFW_DEPTH_BITS
        GLFW_STENCIL_BITS
        GLFW_REFRESH_RATE
        GLFW_ACCUM_RED_BITS
        GLFW_ACCUM_GREEN_BITS
        GLFW_ACCUM_BLUE_BITS
        GLFW_ACCUM_ALPHA_BITS
        GLFW_AUX_BUFFERS
        GLFW_STEREO
        GLFW_WINDOW_RESIZABLE
        GLFW_FSAA_SAMPLES
        GLFW_OPENGL_VERSION_MAJOR
        GLFW_OPENGL_VERSION_MINOR
        GLFW_OPENGL_FORWARD_COMPAT
        GLFW_OPENGL_DEBUG_CONTEXT
        GLFW_OPENGL_PROFILE
        GLFW_OPENGL_ROBUSTNESS

        GLFW_OPENGL_NO_ROBUSTNESS
        GLFW_OPENGL_NO_RESET_NOTIFICATION
        GLFW_OPENGL_LOSE_CONTEXT_ON_RESET

        GLFW_OPENGL_NO_PROFILE
        GLFW_OPENGL_CORE_PROFILE
        GLFW_OPENGL_COMPAT_PROFILE
        GLFW_OPENGL_ES2_PROFILE

        GLFW_STICKY_KEYS
        GLFW_STICKY_MOUSE_BUTTONS
        GLFW_SYSTEM_KEYS
        GLFW_KEY_REPEAT

        GLFW_CURSOR_NORMAL
        GLFW_CURSOR_HIDDEN
        GLFW_CURSOR_CAPTURED

        GLFW_PRESENT
        GLFW_AXES
        GLFW_BUTTONS

        GLFW_NO_ERROR
        GLFW_NOT_INITIALIZED
        GLFW_NO_CURRENT_WINDOW
        GLFW_INVALID_ENUM
        GLFW_INVALID_VALUE
        GLFW_OUT_OF_MEMORY
        GLFW_OPENGL_UNAVAILABLE
        GLFW_VERSION_UNAVAILABLE
        GLFW_PLATFORM_ERROR
        GLFW_WINDOW_NOT_ACTIVE

        GLFW_GAMMA_RAMP_SIZE

    ctypedef void* GLFWwindow

    ctypedef void (*GLFWerrorfun)(int, char*)
    ctypedef void (*GLFWwindowsizefun)(GLFWwindow, int, int)
    ctypedef int (*GLFWwindowclosefun)(GLFWwindow)
    ctypedef void (*GLFWwindowrefreshfun)(GLFWwindow)
    ctypedef void (*GLFWwindowfocusfun)(GLFWwindow, int)
    ctypedef void (*GLFWwindowiconifyfun)(GLFWwindow, int)
    ctypedef void (*GLFWmousebuttonfun)(GLFWwindow, int, int)
    ctypedef void (*GLFWmouseposfun)(GLFWwindow, int, int)
    ctypedef void (*GLFWscrollfun)(GLFWwindow, int, int)
    ctypedef void (*GLFWkeyfun)(GLFWwindow, int, int)
    ctypedef void (*GLFWcharfun)(GLFWwindow, int)
    ctypedef void* (*GLFWmallocfun)(size_t)
    ctypedef void (*GLFWfreefun)(void*)

    ctypedef struct GLFWvidmode:
        int width
        int height
        int redBits
        int blueBits
        int greenBits

    ctypedef struct GLFWgammaramp:
        unsigned short *red
        unsigned short *green
        unsigned short *blue

    ctypedef struct GLFWallocator:
        GLFWmallocfun malloc
        GLFWfreefun free

    ctypedef struct GLFWthreadmodel:
        int dummy

    cdef int glfwInit()
    cdef int glfwInitWithModels(GLFWthreadmodel *threading, GLFWallocator *allocator)
    cdef void glfwTerminate()
    cdef void glfwGetVersion(int *major, int *minor, int *rev)
    cdef char* glfwGetVersionString()

    cdef int glfwGetError()
    cdef char* glfwErrorString(int error)
    cdef void glfwSetErrorCallback(GLFWerrorfun cbfun)

    cdef int glfwGetVideoModes(GLFWvidmode *list, int maxcount)
    cdef void glfwGetDesktopMode(GLFWvidmode *mode)

    cdef void glfwSetGamma(float gamma)
    cdef void glfwGetGammaRamp(GLFWgammaramp *ramp)
    cdef void glfwSetGammaRamp(GLFWgammaramp *ramp)

    cdef GLFWwindow glfwOpenWindow(int width, int height, int mode, char *title, GLFWwindow share)
    cdef void glfwOpenWindowHint(int target, int hint)
    cdef int glfwIsWindow(GLFWwindow window)
    cdef void glfwCloseWindow(GLFWwindow window)
    cdef void glfwSetWindowTitle(GLFWwindow, char *title)
    cdef void glfwGetWindowSize(GLFWwindow, int *width, int *height)
    cdef void glfwSetWindowSize(GLFWwindow, int width, int height)
    cdef void glfwGetWindowPos(GLFWwindow, int *xpos, int *ypos)
    cdef void glfwSetWindowPos(GLFWwindow, int xpos, int ypos)
    cdef void glfwIconifyWindow(GLFWwindow window)
    cdef void glfwRestoreWindow(GLFWwindow window)
    cdef int glfwGetWindowParam(GLFWwindow window, int param)
    cdef void glfwSetWindowUserPointer(GLFWwindow window, void *pointer)
    cdef void* glfwGetWindowUserPointer(GLFWwindow window)
    cdef void glfwSetWindowSizeCallback(GLFWwindowsizefun cbfun)
    cdef void glfwSetWindowCloseCallback(GLFWwindowclosefun cbfun)
    cdef void glfwSetWindowRefreshCallback(GLFWwindowrefreshfun cbfun)
    cdef void glfwSetWindowFocusCallback(GLFWwindowfocusfun cbfun)
    cdef void glfwSetWindowIconifyCallback(GLFWwindowiconifyfun cbfun)

    cdef void glfwPollEvents()
    cdef void glfwWaitEvents()

    cdef int glfwGetKey(GLFWwindow window, int key)
    cdef int glfwGetMouseButton(GLFWwindow window, int button)
    cdef void glfwGetMousePos(GLFWwindow window, int *xpos, int *ypos)
    cdef void glfwSetMousePos(GLFWwindow window, int xpos, int ypos)
    cdef void glfwSetCursorMode(GLFWwindow window, int mode)
    cdef void glfwGetScrollOffset(GLFWwindow window, int *xoffset, int *yoffset)
    cdef void glfwSetKeyCallback(GLFWkeyfun cbfun)
    cdef void glfwSetCharCallback(GLFWcharfun cbfun)
    cdef void glfwSetMouseButtonCallback(GLFWmousebuttonfun cbfun)
    cdef void glfwSetMousePosCallback(GLFWmouseposfun cbfun)
    cdef void glfwSetScrollCallback(GLFWscrollfun cbfun)

    cdef int glfwGetJoystickParam(int joy, int param)
    cdef int glfwGetJoystickPos(int joy, float *pos, int numaxes)
    cdef int glfwGetJoystickButtons(int joy, unsigned char *buttons, int numbuttons)

    cdef double glfwGetTime()
    cdef void glfwSetTime(double time)

    cdef void glfwMakeContextCurrent(GLFWwindow window)
    cdef GLFWwindow glfwGetCurrentContext()
    cdef void glfwSwapBuffers()
    cdef void glfwSwapInterval(int interval)
    cdef int glfwExtensionSupported(char *extension)
    cdef void* glfwGetProcAddress(char *procname)
    cdef void glfwCopyContext(GLFWwindow src, GLFWwindow dst, unsigned long mask)

    cdef void glfwEnable(GLFWwindow window, int token)
    cdef void glfwDisable(GLFWwindow window, int token)
