from pygrafix.c_headers.glew cimport *
from pygrafix.c_headers.glfw cimport *

from libc.stdlib cimport malloc, free

import time
import sys
import weakref

if sys.platform == "win32":
    timefunc = time.clock
else:
    timefunc = time.time

# glfw init func, call this before anything
if not glfwInit():
    raise Exception("Couldn't initialize GLFW")

# every function in this list gets called when the context gets created/destroyed
cdef list _context_init_funcs = []
cdef list _context_destroy_funcs = []

# we keep track of our opened windows (weakrefs)
cdef list _opened_windows = []

def _register_context_init_func(func):
    _context_init_funcs.append(func)

def _register_context_destroy_func(func):
    _context_destroy_funcs.append(func)

# callback handlers, these can't be part of Window thanks to issues with "self"
# the close callback handler - default behaviour is to close the application
# this ONLY gets called when the user closes the application NOT when window.close() gets called
cdef int _close_callback_handler(GLFWwindow window) with gil:
    self = <Window> glfwGetWindowUserPointer(window)

    cdef bint keep_open
    if self._close_callback:
        keep_open = bool(self._close_callback(self))

        self._closed = not keep_open

        return GL_TRUE if self._closed else GL_FALSE
    else:
        self._closed = True

        return GL_TRUE

# this gets called when the window needs to be redrawn due to effects from the outside
# (for example when a previously hidden part of the window has become visible)
cdef void _refresh_callback_handler(GLFWwindow window) with gil:
    try:
        self = <Window> glfwGetWindowUserPointer(window)
        self._refresh_callback(self)
    except:
        pass

# this gets called when the user resizes the window
# (NOT when window.set_size() is called)
cdef void _resize_callback_handler(GLFWwindow window, int width, int height) with gil:
    try:
        self = <Window> glfwGetWindowUserPointer(window)
        self._resize_callback(self, width, height)
    except:
        pass

# this gets called when the user scrolls
cdef void _mouse_scroll_callback_handler(GLFWwindow window, int posx, int posy) with gil:
    try:
        self = <Window> glfwGetWindowUserPointer(window)

        delta = posy - self._mousewheel_pos
        self._mousewheel_pos = posy

        self._mouse_scroll_callback(self, delta, posy)
    except:
        pass

# this gets called when the user moves his mouse
cdef void _mouse_move_callback_handler(GLFWwindow window, int x, int y) with gil:
    try:
        self = <Window> glfwGetWindowUserPointer(window)
        self._mouse_move_callback(self, x, y)
    except:
        pass

# this gets called when the user presses or releases a key
cdef void _key_callback_handler(GLFWwindow window, int key, int action) with gil:
    try:
        self = <Window> glfwGetWindowUserPointer(window)

        if action == GLFW_PRESS:
            self._key_press_callback(self, key)
        elif action == GLFW_RELEASE:
            self._key_release_callback(self, key)
    except:
        pass

# this gets called when the user inputs a printable character
cdef void _char_callback_handler(GLFWwindow window, int char) with gil:
    try:
        self = <Window> glfwGetWindowUserPointer(window)

        self._text_callback(self, chr(char))
    except:
        pass

# the window class
cdef class Window:
    # we want our window to be weakref'able
    cdef object __weakref__

    # internal, private variables
    cdef bint _mouse_cursor
    cdef bint _key_repeat
    cdef bint _vsync
    cdef str _title
    cdef double _frametime
    cdef double _last_flip
    cdef GLFWwindow _window

    # these have to be public because non-member functions use them
    cdef public _closed
    cdef public int _mousewheel_pos

    cdef public object _close_callback
    cdef public object _resize_callback
    cdef public object _refresh_callback
    cdef public object _mouse_scroll_callback
    cdef public object _mouse_move_callback
    cdef public object _key_press_callback
    cdef public object _key_release_callback
    cdef public object _text_callback

    # read-only properties
    # they are read-only because changing them is either impossible or very expensive
    cdef readonly bint fullscreen

    # special properties
    property width:
        def __get__(self):
            return self.get_size()[0]

        def __set__(self, int width):
            self.set_size(width, self.height)

    property height:
        def __get__(self):
            return self.get_size()[1]

        def __set__(self, int height):
            self.set_size(self.width, height)

    property size:
        def __get__(self):
            return self.get_size()

        def __set__(self, tup):
            width, height = tup
            self.set_size(width, height)

    property resizable:
        def __get__(self):
            return glfwGetWindowParam(self._window, GLFW_WINDOW_RESIZABLE)

    property refresh_rate:
        def __get__(self):
            return glfwGetWindowParam(self._window, GLFW_REFRESH_RATE)

    property vsync:
        def __get__(self):
            return self._vsync

        def __set__(self, bint vsync):
            self.set_vsync(vsync)

    property mouse_cursor:
        def __get__(self):
            return self._mouse_cursor

        def __set__(self, bint mouse_cursor):
            self.set_mouse_cursor(mouse_cursor)

    property key_repeat:
        def __get__(self):
            return self._key_repeat

        def __set__(self, bint key_repeat):
            self.set_key_repeat(key_repeat)

    property title:
        def __get__(self):
            return self._title

        def __set__(self, title):
            self.set_title(title)

    def __cinit__(self):
        self._closed = False
        self._close_callback = None
        self._resize_callback = None
        self._refresh_callback = None
        self._mouse_scroll_callback = None
        self._mouse_move_callback = None

        self._title = ""
        self._mousewheel_pos = 0
        self._frametime = 0.05
        self._last_flip = timefunc()

    def __init__(self, int width = 0, int height = 0, title = "pygrafix window", bint fullscreen = False, bint resizable = False, int refresh_rate = 0, bint vsync = True, bit_depth = (8, 8, 8, 0)):
        cdef GLFWvidmode display

        global _opened_windows

        if fullscreen:
            mode = GLFW_FULLSCREEN
        else:
            mode = GLFW_WINDOWED

        glfwOpenWindowHint(GLFW_ACCUM_RED_BITS, 0)
        glfwOpenWindowHint(GLFW_ACCUM_GREEN_BITS, 0)
        glfwOpenWindowHint(GLFW_ACCUM_BLUE_BITS, 0)
        glfwOpenWindowHint(GLFW_ACCUM_ALPHA_BITS, 0)
        glfwOpenWindowHint(GLFW_AUX_BUFFERS, 0)
        glfwOpenWindowHint(GLFW_FSAA_SAMPLES, 0)
        glfwOpenWindowHint(GLFW_REFRESH_RATE, refresh_rate)
        glfwOpenWindowHint(GLFW_WINDOW_RESIZABLE, resizable)

        self._window = glfwOpenWindow(width, height, mode, title, NULL)

        # check if the window really is open
        if not glfwIsWindow(self._window):
            raise Exception("Failed to create window")

        # make link from GLFW window to Python Window
        glfwSetWindowUserPointer(self._window, <void*> self)

        # set as current active
        self.switch_to()

        self._closed = False

        # center window if we're not fullscreen
        if not fullscreen:
            glfwGetDesktopMode(&display)
            self.set_position(display.width / 2 - width / 2, display.height / 2 - height / 2)

        # set extra settings
        self.set_mouse_cursor(True)
        self.set_key_repeat(True)
        self.set_vsync(vsync)
        self.set_title(title)

        # set up event handlers
        glfwSetWindowCloseCallback(&_close_callback_handler)
        glfwSetWindowSizeCallback(&_resize_callback_handler)
        glfwSetWindowRefreshCallback(&_refresh_callback_handler)
        glfwSetMousePosCallback(&_mouse_move_callback_handler)
        glfwSetScrollCallback(&_mouse_scroll_callback_handler)
        glfwSetKeyCallback(&_key_callback_handler)
        glfwSetCharCallback(&_char_callback_handler)

        # set read-only properties
        self.fullscreen = fullscreen

        # remove dead references and add ourselves to the window list
        _opened_windows = [win for win in _opened_windows if win()]
        _opened_windows.append(weakref.ref(self))

        for func in _context_init_funcs:
            func()

    def __del__(self):
        self.close()

    def close(self):
        if not self._closed:
            for func in _context_destroy_funcs:
                func()

            glfwCloseWindow(self._window)
            self._closed = True

    def is_open(self):
        return not self._closed

    def poll_events(self):
        glfwPollEvents()

    def wait_events(self):
        glfwWaitEvents()

    def set_position(self, int x, int y):
        glfwSetWindowPos(self._window, x, y)

    def set_size(self, int w, int h):
        glfwSetWindowSize(self._window, w, h)

    def get_size(self):
        cdef int w, h

        w, h = -1, -1
        glfwGetWindowSize(self._window, &w, &h)

        if h == -1 or w == -1:
            raise Exception("Error while retrieving size.")

        return w, h

    def set_title(self, title):
        self._title = title
        glfwSetWindowTitle(self._window, title)

    def toggle_fullscreen(self):
        # first read out information
        fullscreen = not self.fullscreen
        width = self.width
        height = self.height
        refresh_rate = self.refresh_rate
        title = self.title
        vsync = self.vsync
        resizable = self.resizable
        mouse_cursor = self.mouse_cursor
        key_repeat = self.key_repeat

        rbits = glfwGetWindowParam(self._window, GLFW_RED_BITS)
        gbits = glfwGetWindowParam(self._window, GLFW_GREEN_BITS)
        bbits = glfwGetWindowParam(self._window, GLFW_BLUE_BITS)
        abits = glfwGetWindowParam(self._window, GLFW_ALPHA_BITS)
        bit_depth = (rbits, gbits, bbits, abits)

        # clean up and close
        self.close()

        # re-open window

        self.__init__(width, height, title, fullscreen, resizable, refresh_rate, vsync, bit_depth)
        self.width = width
        self.height = height
        self.set_mouse_cursor(mouse_cursor)
        self.set_key_repeat(key_repeat)

    def minimize(self):
        glfwIconifyWindow(self._window)

    def restore(self):
        glfwRestoreWindow(self._window)

    def has_focus(self):
        return glfwGetWindowParam(self._window, GLFW_ACTIVE)

    def is_minimized(self):
        return glfwGetWindowParam(self._window, GLFW_ICONIFIED)

    def switch_to(self):
        glfwMakeContextCurrent(self._window)

    def flip(self):
        now = timefunc()
        dt = now - self._last_flip

        self._frametime = self._frametime * 0.95 + 0.05 * dt
        self._last_flip = now

        glfwSwapBuffers()

    def set_mouse_cursor(self, bint mouse_cursor):
        if mouse_cursor:
            glfwSetCursorMode(self._window, GLFW_CURSOR_NORMAL)
        else:
            glfwDisable(self._window, GLFW_CURSOR_CAPTURED)

        self._mouse_cursor = mouse_cursor

    def set_key_repeat(self, bint key_repeat):
        if key_repeat:
            glfwEnable(self._window, GLFW_KEY_REPEAT)
        else:
            glfwDisable(self._window, GLFW_KEY_REPEAT)

        self._key_repeat = key_repeat

    def set_vsync(self, bint vsync):
        glfwSwapInterval(vsync)
        self._vsync = vsync

    def get_mouse_position(self):
        cdef int x, y
        x, y = 0, 0

        glfwGetMousePos(self._window, &x, &y)

        return x, y

    def set_mouse_position(self, int x, int y):
        glfwSetMousePos(self._window, x, y)

    def is_key_pressed(self, key):
        if isinstance(key, str):
            return glfwGetKey(self._window, str[0].upper().encode("latin_1")) == GLFW_PRESS
        else:
            return glfwGetKey(self._window, key) == GLFW_PRESS

    def is_mouse_button_pressed(self, int button):
        return glfwGetMouseButton(self._window, button) == GLFW_PRESS

    # callbacks
    def set_close_callback(self, func):
        self._close_callback = func

    def set_resize_callback(self, func):
        self._resize_callback = func

    def set_refresh_callback(self, func):
        self._refresh_callback = func

    def set_mouse_scroll_callback(self, func):
        self._mousewheel_pos = 0
        self._mouse_scroll_callback = func

    def set_mouse_move_callback(self, func):
        self._mouse_move_callback = func

    def set_key_press_callback(self, func):
        self._key_press_callback = func

    def set_key_release_callback(self, func):
        self._key_release_callback = func

    def set_text_callback(self, func):
        self._text_callback = func

    def clear(self, red = 0.0, green = 0.0, blue = 0.0):
        glClearColor(red, green, blue, 1.0)
        glClear(GL_COLOR_BUFFER_BIT)

    def get_fps(self):
        if self._frametime == 0:
            return 0.0

        return 1 / self._frametime

    def __enter__(self):
        self.switch_to()


# and some free functions
def get_current_window():
    cdef GLFWwindow current_context

    current_context = glfwGetCurrentContext()

    if current_context == NULL:
        return None

    return <Window> glfwGetWindowUserPointer(current_context)

def get_open_windows():
    return [win() for win in _opened_windows if win()]

def get_video_modes():
    cdef GLFWvidmode* glfw_video_modes = <GLFWvidmode*> malloc(128 * sizeof(GLFWvidmode))
    cdef GLFWvidmode video_mode

    num_modes = glfwGetVideoModes(glfw_video_modes, 128)
    video_modes = []

    for i in range(num_modes):
        video_mode = glfw_video_modes[i]
        video_modes.append(
            (video_mode.width, video_mode.height, (video_mode.redBits, video_mode.greenBits, video_mode.blueBits))
        )

    free(glfw_video_modes)

    return video_modes

def get_desktop_video_mode():
    cdef GLFWvidmode video_mode

    glfwGetDesktopMode(&video_mode)

    return (video_mode.width, video_mode.height, (video_mode.redBits, video_mode.greenBits, video_mode.blueBits))

__all__ = ["Window", "get_current_window", "get_open_windows", "get_video_modes", "get_desktop_video_mode"]
