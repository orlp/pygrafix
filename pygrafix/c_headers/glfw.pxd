cdef extern from "glfw_include.h":
    # glfw defines
    int GLFW_VERSION_MAJOR
    int GLFW_VERSION_MINOR
    int GLFW_VERSION_REVISION

    int GLFW_RELEASE
    int GLFW_PRESS

    int GLFW_KEY_SPACE
    int GLFW_KEY_APOSTROPHE
    int GLFW_KEY_COMMA
    int GLFW_KEY_MINUS
    int GLFW_KEY_PERIOD
    int GLFW_KEY_SLASH
    int GLFW_KEY_0
    int GLFW_KEY_1
    int GLFW_KEY_2
    int GLFW_KEY_3
    int GLFW_KEY_4
    int GLFW_KEY_5
    int GLFW_KEY_6
    int GLFW_KEY_7
    int GLFW_KEY_8
    int GLFW_KEY_9
    int GLFW_KEY_SEMICOLON
    int GLFW_KEY_EQUAL
    int GLFW_KEY_A
    int GLFW_KEY_B
    int GLFW_KEY_C
    int GLFW_KEY_D
    int GLFW_KEY_E
    int GLFW_KEY_F
    int GLFW_KEY_G
    int GLFW_KEY_H
    int GLFW_KEY_I
    int GLFW_KEY_J
    int GLFW_KEY_K
    int GLFW_KEY_L
    int GLFW_KEY_M
    int GLFW_KEY_N
    int GLFW_KEY_O
    int GLFW_KEY_P
    int GLFW_KEY_Q
    int GLFW_KEY_R
    int GLFW_KEY_S
    int GLFW_KEY_T
    int GLFW_KEY_U
    int GLFW_KEY_V
    int GLFW_KEY_W
    int GLFW_KEY_X
    int GLFW_KEY_Y
    int GLFW_KEY_Z
    int GLFW_KEY_LEFT_BRACKET
    int GLFW_KEY_BACKSLASH
    int GLFW_KEY_RIGHT_BRACKET
    int GLFW_KEY_GRAVE_ACCENT
    int GLFW_KEY_WORLD_1
    int GLFW_KEY_WORLD_2

    int GLFW_KEY_ESCAPE
    int GLFW_KEY_ENTER
    int GLFW_KEY_TAB
    int GLFW_KEY_BACKSPACE
    int GLFW_KEY_INSERT
    int GLFW_KEY_DELETE
    int GLFW_KEY_RIGHT
    int GLFW_KEY_LEFT
    int GLFW_KEY_DOWN
    int GLFW_KEY_UP
    int GLFW_KEY_PAGE_UP
    int GLFW_KEY_PAGE_DOWN
    int GLFW_KEY_HOME
    int GLFW_KEY_END
    int GLFW_KEY_CAPS_LOCK
    int GLFW_KEY_SCROLL_LOCK
    int GLFW_KEY_NUM_LOCK
    int GLFW_KEY_PRINT_SCREEN
    int GLFW_KEY_PAUSE
    int GLFW_KEY_F1
    int GLFW_KEY_F2
    int GLFW_KEY_F3
    int GLFW_KEY_F4
    int GLFW_KEY_F5
    int GLFW_KEY_F6
    int GLFW_KEY_F7
    int GLFW_KEY_F8
    int GLFW_KEY_F9
    int GLFW_KEY_F10
    int GLFW_KEY_F11
    int GLFW_KEY_F12
    int GLFW_KEY_F13
    int GLFW_KEY_F14
    int GLFW_KEY_F15
    int GLFW_KEY_F16
    int GLFW_KEY_F17
    int GLFW_KEY_F18
    int GLFW_KEY_F19
    int GLFW_KEY_F20
    int GLFW_KEY_F21
    int GLFW_KEY_F22
    int GLFW_KEY_F23
    int GLFW_KEY_F24
    int GLFW_KEY_F25
    int GLFW_KEY_KP_0
    int GLFW_KEY_KP_1
    int GLFW_KEY_KP_2
    int GLFW_KEY_KP_3
    int GLFW_KEY_KP_4
    int GLFW_KEY_KP_5
    int GLFW_KEY_KP_6
    int GLFW_KEY_KP_7
    int GLFW_KEY_KP_8
    int GLFW_KEY_KP_9
    int GLFW_KEY_KP_DECIMAL
    int GLFW_KEY_KP_DIVIDE
    int GLFW_KEY_KP_MULTIPLY
    int GLFW_KEY_KP_SUBTRACT
    int GLFW_KEY_KP_ADD
    int GLFW_KEY_KP_ENTER
    int GLFW_KEY_KP_EQUAL
    int GLFW_KEY_LEFT_SHIFT
    int GLFW_KEY_LEFT_CONTROL
    int GLFW_KEY_LEFT_ALT
    int GLFW_KEY_LEFT_SUPER
    int GLFW_KEY_RIGHT_SHIFT
    int GLFW_KEY_RIGHT_CONTROL
    int GLFW_KEY_RIGHT_ALT
    int GLFW_KEY_RIGHT_SUPER
    int GLFW_KEY_MENU
    int GLFW_KEY_LAST

    #depreciated
    int GLFW_KEY_ESC            #now GLFW_KEY_ESCAPE
    int GLFW_KEY_DEL            #now GLFW_KEY_DELETE
    int GLFW_KEY_PAGEUP         #now GLFW_KEY_PAGE_UP
    int GLFW_KEY_PAGEDOWN       #now GLFW_KEY_PAGE_DOWN
    int GLFW_KEY_KP_NUM_LOCK    #now GLFW_KEY_NUM_LOCK
    int GLFW_KEY_LCTRL          #now GLFW_KEY_LEFT_CONTROL
    int GLFW_KEY_LSHIFT         #now GLFW_KEY_LEFT_SHIFT
    int GLFW_KEY_LALT           #now GLFW_KEY_LEFT_ALT
    int GLFW_KEY_LSUPER         #now GLFW_KEY_LEFT_SUPER
    int GLFW_KEY_RCTRL          #now GLFW_KEY_RIGHT_CONTROL
    int GLFW_KEY_RSHIFT         #now GLFW_KEY_RIGHT_SHIFT
    int GLFW_KEY_RALT           #now GLFW_KEY_RIGHT_ALT
    int GLFW_KEY_RSUPER         #now GLFW_KEY_RIGHT_SUPER

    int GLFW_MOUSE_BUTTON_1
    int GLFW_MOUSE_BUTTON_2
    int GLFW_MOUSE_BUTTON_3
    int GLFW_MOUSE_BUTTON_4
    int GLFW_MOUSE_BUTTON_5
    int GLFW_MOUSE_BUTTON_6
    int GLFW_MOUSE_BUTTON_7
    int GLFW_MOUSE_BUTTON_8
    int GLFW_MOUSE_BUTTON_LAST

    int GLFW_MOUSE_BUTTON_LEFT
    int GLFW_MOUSE_BUTTON_RIGHT
    int GLFW_MOUSE_BUTTON_MIDDLE

    int GLFW_JOYSTICK_1
    int GLFW_JOYSTICK_2
    int GLFW_JOYSTICK_3
    int GLFW_JOYSTICK_4
    int GLFW_JOYSTICK_5
    int GLFW_JOYSTICK_6
    int GLFW_JOYSTICK_7
    int GLFW_JOYSTICK_8
    int GLFW_JOYSTICK_9
    int GLFW_JOYSTICK_10
    int GLFW_JOYSTICK_11
    int GLFW_JOYSTICK_12
    int GLFW_JOYSTICK_13
    int GLFW_JOYSTICK_14
    int GLFW_JOYSTICK_15
    int GLFW_JOYSTICK_16
    int GLFW_JOYSTICK_LAST

    int GLFW_WINDOWED
    int GLFW_FULLSCREEN

    int GLFW_ACTIVE
    int GLFW_ICONIFIED
    int GLFW_ACCELERATED
    int GLFW_OPENGL_REVISION

    int GLFW_RED_BITS
    int GLFW_GREEN_BITS
    int GLFW_BLUE_BITS
    int GLFW_ALPHA_BITS
    int GLFW_DEPTH_BITS
    int GLFW_STENCIL_BITS
    int GLFW_REFRESH_RATE
    int GLFW_ACCUM_RED_BITS
    int GLFW_ACCUM_GREEN_BITS
    int GLFW_ACCUM_BLUE_BITS
    int GLFW_ACCUM_ALPHA_BITS
    int GLFW_AUX_BUFFERS
    int GLFW_STEREO
    int GLFW_WINDOW_RESIZABLE
    int GLFW_FSAA_SAMPLES
    int GLFW_OPENGL_VERSION_MAJOR
    int GLFW_OPENGL_VERSION_MINOR
    int GLFW_OPENGL_FORWARD_COMPAT
    int GLFW_OPENGL_DEBUG_CONTEXT
    int GLFW_OPENGL_PROFILE
    int GLFW_OPENGL_ROBUSTNESS

    int GLFW_OPENGL_NO_ROBUSTNESS
    int GLFW_OPENGL_NO_RESET_NOTIFICATION
    int GLFW_OPENGL_LOSE_CONTEXT_ON_RESET

    int GLFW_OPENGL_NO_PROFILE
    int GLFW_OPENGL_CORE_PROFILE
    int GLFW_OPENGL_COMPAT_PROFILE
    int GLFW_OPENGL_ES2_PROFILE

    int GLFW_STICKY_KEYS
    int GLFW_STICKY_MOUSE_BUTTONS
    int GLFW_SYSTEM_KEYS
    int GLFW_KEY_REPEAT

    int GLFW_CURSOR_NORMAL
    int GLFW_CURSOR_HIDDEN
    int GLFW_CURSOR_CAPTURED

    int GLFW_PRESENT
    int GLFW_AXES
    int GLFW_BUTTONS

    int GLFW_NO_ERROR
    int GLFW_NOT_INITIALIZED
    int GLFW_NO_CURRENT_WINDOW
    int GLFW_INVALID_ENUM
    int GLFW_INVALID_VALUE
    int GLFW_OUT_OF_MEMORY
    int GLFW_OPENGL_UNAVAILABLE
    int GLFW_VERSION_UNAVAILABLE
    int GLFW_PLATFORM_ERROR
    int GLFW_WINDOW_NOT_ACTIVE

    int GLFW_GAMMA_RAMP_SIZE

    # glfw ctypedefs
    ctypedef void* GLFWwindow

    ctypedef void (* GLFWerrorfun)(int, char*)
    ctypedef void (* GLFWwindowsizefun)(GLFWwindow,int,int)
    ctypedef int  (* GLFWwindowclosefun)(GLFWwindow)
    ctypedef void (* GLFWwindowrefreshfun)(GLFWwindow)
    ctypedef void (* GLFWwindowfocusfun)(GLFWwindow,int)
    ctypedef void (* GLFWwindowiconifyfun)(GLFWwindow,int)
    ctypedef void (* GLFWmousebuttonfun)(GLFWwindow,int,int)
    ctypedef void (* GLFWmouseposfun)(GLFWwindow,int,int)
    ctypedef void (* GLFWscrollfun)(GLFWwindow,int,int)
    ctypedef void (* GLFWkeyfun)(GLFWwindow,int,int)
    ctypedef void (* GLFWcharfun)(GLFWwindow,int)
    ctypedef void* (* GLFWmallocfun)(size_t)
    ctypedef void (* GLFWfreefun)(void*)

    ctypedef struct GLFWvidmode:
        int width
        int height
        int redBits
        int blueBits
        int greenBits

    ctypedef struct GLFWgammaramp:
        unsigned short red
        unsigned short green
        unsigned short blue

    ctypedef struct GLFWallocator:
        GLFWmallocfun malloc
        GLFWfreefun free

    ctypedef struct GLFWthreadmodel:
        int dummy

    #glfw functions
    cdef int  glfwInit()
    cdef int  glfwInitWithModels(GLFWthreadmodel* threading, GLFWallocator* allocator)
    cdef void glfwTerminate()
    cdef void glfwGetVersion(int* major, int* minor, int* rev)
    cdef  char* glfwGetVersionString()

    cdef int glfwGetError()
    cdef  char* glfwErrorString(int error)
    cdef void glfwSetErrorCallback(GLFWerrorfun cbfun)

    cdef int  glfwGetVideoModes(GLFWvidmode* list, int maxcount)
    cdef void glfwGetDesktopMode(GLFWvidmode* mode)

    cdef void glfwSetGamma(float gamma)
    cdef void glfwGetGammaRamp(GLFWgammaramp* ramp)
    cdef void glfwSetGammaRamp( GLFWgammaramp* ramp)

    cdef GLFWwindow glfwOpenWindow(int width, int height, int mode,  char* title, GLFWwindow share)
    cdef void glfwOpenWindowHint(int target, int hint)
    cdef int  glfwIsWindow(GLFWwindow window)
    cdef void glfwCloseWindow(GLFWwindow window)
    cdef void glfwSetWindowTitle(GLFWwindow,  char* title)
    cdef void glfwGetWindowSize(GLFWwindow, int* width, int* height)
    cdef void glfwSetWindowSize(GLFWwindow, int width, int height)
    cdef void glfwGetWindowPos(GLFWwindow, int* xpos, int* ypos)
    cdef void glfwSetWindowPos(GLFWwindow, int xpos, int ypos)
    cdef void glfwIconifyWindow(GLFWwindow window)
    cdef void glfwRestoreWindow(GLFWwindow window)
    cdef int  glfwGetWindowParam(GLFWwindow window, int param)
    cdef void glfwSetWindowUserPointer(GLFWwindow window, void* pointer)
    cdef void* glfwGetWindowUserPointer(GLFWwindow window)
    cdef void glfwSetWindowSizeCallback(GLFWwindowsizefun cbfun)
    cdef void glfwSetWindowCloseCallback(GLFWwindowclosefun cbfun)
    cdef void glfwSetWindowRefreshCallback(GLFWwindowrefreshfun cbfun)
    cdef void glfwSetWindowFocusCallback(GLFWwindowfocusfun cbfun)
    cdef void glfwSetWindowIconifyCallback(GLFWwindowiconifyfun cbfun)

    cdef void glfwPollEvents()
    cdef void glfwWaitEvents()

    cdef int  glfwGetKey(GLFWwindow window, int key)
    cdef int  glfwGetMouseButton(GLFWwindow window, int button)
    cdef void glfwGetMousePos(GLFWwindow window, int* xpos, int* ypos)
    cdef void glfwSetMousePos(GLFWwindow window, int xpos, int ypos)
    cdef void glfwSetCursorMode(GLFWwindow window, int mode)
    cdef void glfwGetScrollOffset(GLFWwindow window, int* xoffset, int* yoffset)
    cdef void glfwSetKeyCallback(GLFWkeyfun cbfun)
    cdef void glfwSetCharCallback(GLFWcharfun cbfun)
    cdef void glfwSetMouseButtonCallback(GLFWmousebuttonfun cbfun)
    cdef void glfwSetMousePosCallback(GLFWmouseposfun cbfun)
    cdef void glfwSetScrollCallback(GLFWscrollfun cbfun)

    cdef int glfwGetJoystickParam(int joy, int param)
    cdef int glfwGetJoystickPos(int joy, float* pos, int numaxes)
    cdef int glfwGetJoystickButtons(int joy, unsigned char* buttons, int numbuttons)

    cdef double glfwGetTime()
    cdef void   glfwSetTime(double time)

    cdef void glfwMakeContextCurrent(GLFWwindow window)
    cdef GLFWwindow glfwGetCurrentContext()
    cdef void  glfwSwapBuffers()
    cdef void  glfwSwapInterval(int interval)
    cdef int   glfwExtensionSupported( char* extension)
    cdef void* glfwGetProcAddress( char* procname)
    cdef void  glfwCopyContext(GLFWwindow src, GLFWwindow dst, unsigned long mask)

    cdef void glfwEnable(GLFWwindow window, int token)
    cdef void glfwDisable(GLFWwindow window, int token)
