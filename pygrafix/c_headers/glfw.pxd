cdef extern from "glfw_include.h":
    # glfw defines
    int GLFW_VERSION_MAJOR
    int GLFW_VERSION_MINOR
    int GLFW_VERSION_REVISION

    int GLFW_RELEASE
    int GLFW_PRESS

    int GLFW_KEY_UNKNOWN
    int GLFW_KEY_SPACE
    int GLFW_KEY_SPECIAL
    int GLFW_KEY_ESC
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
    int GLFW_KEY_UP
    int GLFW_KEY_DOWN
    int GLFW_KEY_LEFT
    int GLFW_KEY_RIGHT
    int GLFW_KEY_LSHIFT
    int GLFW_KEY_RSHIFT
    int GLFW_KEY_LCTRL
    int GLFW_KEY_RCTRL
    int GLFW_KEY_LALT
    int GLFW_KEY_RALT
    int GLFW_KEY_TAB
    int GLFW_KEY_ENTER
    int GLFW_KEY_BACKSPACE
    int GLFW_KEY_INSERT
    int GLFW_KEY_DEL
    int GLFW_KEY_PAGEUP
    int GLFW_KEY_PAGEDOWN
    int GLFW_KEY_HOME
    int GLFW_KEY_END
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
    int GLFW_KEY_KP_DIVIDE
    int GLFW_KEY_KP_MULTIPLY
    int GLFW_KEY_KP_SUBTRACT
    int GLFW_KEY_KP_ADD
    int GLFW_KEY_KP_DECIMAL
    int GLFW_KEY_KP_EQUAL
    int GLFW_KEY_KP_ENTER
    int GLFW_KEY_KP_NUM_LOCK
    int GLFW_KEY_CAPS_LOCK
    int GLFW_KEY_SCROLL_LOCK
    int GLFW_KEY_PAUSE
    int GLFW_KEY_LSUPER
    int GLFW_KEY_RSUPER
    int GLFW_KEY_MENU
    int GLFW_KEY_LAST

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

    int GLFW_WINDOW
    int GLFW_FULLSCREEN

    int GLFW_OPENED
    int GLFW_ACTIVE
    int GLFW_ICONIFIED
    int GLFW_ACCELERATED
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
    int GLFW_WINDOW_NO_RESIZE
    int GLFW_FSAA_SAMPLES
    int GLFW_OPENGL_VERSION_MAJOR
    int GLFW_OPENGL_VERSION_MINOR
    int GLFW_OPENGL_FORWARD_COMPAT
    int GLFW_OPENGL_DEBUG_CONTEXT
    int GLFW_OPENGL_PROFILE

    int GLFW_OPENGL_CORE_PROFILE
    int GLFW_OPENGL_COMPAT_PROFILE

    int GLFW_MOUSE_CURSOR
    int GLFW_STICKY_KEYS
    int GLFW_STICKY_MOUSE_BUTTONS
    int GLFW_SYSTEM_KEYS
    int GLFW_KEY_REPEAT
    int GLFW_AUTO_POLL_EVENTS

    int GLFW_WAIT
    int GLFW_NOWAIT

    int GLFW_PRESENT
    int GLFW_AXES
    int GLFW_BUTTONS

    int GLFW_NO_RESCALE_BIT
    int GLFW_ORIGIN_UL_BIT
    int GLFW_BUILD_MIPMAPS_BIT
    int GLFW_ALPHA_MAP_BIT

    double GLFW_INFINITY

    # glfw typedefs
    ctypedef struct GLFWvidmode:
        int Width, Height
        int RedBits, BlueBits, GreenBits

    ctypedef struct GLFWimage:
        int Width, Height
        int Format
        int BytesPerPixel
        unsigned char *Data

    ctypedef int GLFWthread
    ctypedef void *GLFWmutex
    ctypedef void *GLFWcond

    ctypedef void (*GLFWwindowsizefun)(int, int)
    ctypedef int (*GLFWwindowclosefun)()
    ctypedef void (*GLFWwindowrefreshfun)()
    ctypedef void (*GLFWmousebuttonfun)(int, int)
    ctypedef void (*GLFWmouseposfun)(int, int)
    ctypedef void (*GLFWmousewheelfun)(int)
    ctypedef void (*GLFWkeyfun)(int, int)
    ctypedef void (*GLFWcharfun)(int, int)
    ctypedef void (*GLFWthreadfun)(void*)

    # glfw functions
    cdef int glfwInit()
    cdef void glfwTerminate()
    cdef void glfwGetVersion(int *major, int *minor, int *rev)

    cdef int glfwOpenWindow(int width, int height, int redbits, int greenbits, int bluebits, int alphabits, int depthbits, int stencilbits, int mode)
    cdef void glfwOpenWindowHint(int target, int hint)
    cdef void glfwCloseWindow()
    cdef void glfwSetWindowTitle(char *title)
    cdef void glfwGetWindowSize(int *width, int *height)
    cdef void glfwSetWindowSize(int width, int height)
    cdef void glfwSetWindowPos(int x, int y)
    cdef void glfwIconifyWindow()
    cdef void glfwRestoreWindow()
    cdef void glfwSwapBuffers()
    cdef void glfwSwapInterval(int interval)
    cdef int glfwGetWindowParam(int param)
    cdef void glfwSetWindowSizeCallback(GLFWwindowsizefun cbfun)
    cdef void glfwSetWindowCloseCallback(GLFWwindowclosefun cbfun)
    cdef void glfwSetWindowRefreshCallback(GLFWwindowrefreshfun cbfun)

    cdef int glfwGetVideoModes(GLFWvidmode *list, int maxcount)
    cdef void glfwGetDesktopMode(GLFWvidmode *mode)

    cdef void glfwPollEvents()
    cdef void glfwWaitEvents()
    cdef int glfwGetKey(int key)
    cdef int glfwGetMouseButton(int button)
    cdef void glfwGetMousePos(int *xpos, int *ypos)
    cdef void glfwSetMousePos(int xpos, int ypos)
    cdef int glfwGetMouseWheel()
    cdef void glfwSetMouseWheel(int pos)
    cdef void glfwSetKeyCallback(GLFWkeyfun cbfun)
    cdef void glfwSetCharCallback(GLFWcharfun cbfun)
    cdef void glfwSetMouseButtonCallback(GLFWmousebuttonfun cbfun)
    cdef void glfwSetMousePosCallback(GLFWmouseposfun cbfun)
    cdef void glfwSetMouseWheelCallback(GLFWmousewheelfun cbfun)

    cdef int glfwGetJoystickParam(int joy, int param)
    cdef int glfwGetJoystickPos(int joy, float *pos, int numaxes)
    cdef int glfwGetJoystickButtons(int joy, unsigned char *buttons, int numbuttons)

    cdef double glfwGetTime()
    cdef void glfwSetTime(double time)
    cdef void glfwSleep(double time)

    cdef int glfwExtensionSupported(char *extension)
    cdef void* glfwGetProcAddress(char *procname)
    cdef void glfwGetGLVersion(int *major, int *minor, int *rev)

    cdef GLFWthread glfwCreateThread(GLFWthreadfun fun, void *arg)
    cdef void glfwDestroyThread(GLFWthread ID)
    cdef int glfwWaitThread(GLFWthread ID, int waitmode)
    cdef GLFWthread glfwGetThreadID()
    cdef GLFWmutex glfwCreateMutex()
    cdef void glfwDestroyMutex(GLFWmutex mutex)
    cdef void glfwLockMutex(GLFWmutex mutex)
    cdef void glfwUnlockMutex(GLFWmutex mutex)
    cdef GLFWcond glfwCreateCond()
    cdef void glfwDestroyCond(GLFWcond cond)
    cdef void glfwWaitCond(GLFWcond cond, GLFWmutex mutex, double timeout)
    cdef void glfwSignalCond(GLFWcond cond)
    cdef void glfwBroadcastCond(GLFWcond cond)
    cdef int glfwGetNumberOfProcessors()

    cdef void glfwEnable(int token)
    cdef void glfwDisable(int token)

    cdef int glfwReadImage(char *name, GLFWimage *img, int flags)
    cdef int glfwReadMemoryImage(void *data, long size, GLFWimage *img, int flags)
    cdef void glfwFreeImage(GLFWimage *img)
    cdef int glfwLoadTexture2D(char *name, int flags)
    cdef int glfwLoadMemoryTexture2D(void *data, long size, int flags)
    cdef int glfwLoadTextureImage2D(GLFWimage *img, int flags)
