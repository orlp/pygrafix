from pygrafix.c_headers.glew cimport *
from pygrafix.c_headers.glfw cimport *

from libc.stdlib cimport malloc, free

import time
import sys
import weakref
import os

# every function in this list gets called when the context gets created/destroyed (internal use only)
_context_init_funcs = []
_context_destroy_funcs = []

if sys.platform == "win32":
    timefunc = time.clock
else:
    timefunc = time.time

# glfw init func, call this before anything
# FIXME glfw has a bug changing the CWD. save 'n restore

_backup_cwd = os.path.abspath(os.getcwd())

if not glfwInit():
    raise Exception("Couldn't initialize GLFW")

os.chdir(_backup_cwd)

# we keep track of our opened windows in this list (weakrefs)
_opened_windows = []

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
    cdef GLFWwindow _window
    cdef bint _key_repeat
    cdef bint _vsync
    cdef bint _fullscreen
    cdef str _title
    cdef double _frametime
    cdef double _last_flip

    # these have to be public because non-member functions use them
    cdef public bint _closed
    cdef public int _mousewheel_pos

    cdef public object _close_callback
    cdef public object _resize_callback
    cdef public object _refresh_callback
    cdef public object _mouse_scroll_callback
    cdef public object _mouse_move_callback
    cdef public object _key_press_callback
    cdef public object _key_release_callback
    cdef public object _text_callback

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
        glfwOpenWindowHint(GLFW_FSAA_SAMPLES, 4)
        glfwOpenWindowHint(GLFW_REFRESH_RATE, refresh_rate)
        glfwOpenWindowHint(GLFW_WINDOW_RESIZABLE, resizable)

        self._window = glfwOpenWindow(width, height, mode, title, NULL)

        # check if the window really is open
        if not glfwIsWindow(self._window):
            raise Exception("Failed to create window")

        self._closed = False

        # make link from GLFW window to Python Window
        glfwSetWindowUserPointer(self._window, <void*> self)

        # set as current active
        self.switch_to()

        # center window if we're not fullscreen
        if not fullscreen:
            glfwGetDesktopMode(&display)
            self.position = (display.width / 2 - self.width / 2, display.height / 2 - self.height / 2)

        # set extra settings and initial values
        self.mouse_cursor = "normal"
        self.key_repeat = True
        self.vsync = vsync
        self.title = title
        self._fullscreen = fullscreen
        self._closed = False
        self._mousewheel_pos = 0
        self._frametime = 0.05
        self._last_flip = timefunc()

        # we start of without any callback handlers
        self._close_callback = None
        self._resize_callback = None
        self._refresh_callback = None
        self._mouse_scroll_callback = None
        self._mouse_move_callback = None
        self._key_press_callback = None
        self._key_release_callback = None
        self._text_callback = None

        # set up event handlers
        glfwSetWindowCloseCallback(&_close_callback_handler)
        glfwSetWindowSizeCallback(&_resize_callback_handler)
        glfwSetWindowRefreshCallback(&_refresh_callback_handler)
        glfwSetMousePosCallback(&_mouse_move_callback_handler)
        glfwSetScrollCallback(&_mouse_scroll_callback_handler)
        glfwSetKeyCallback(&_key_callback_handler)
        glfwSetCharCallback(&_char_callback_handler)

        # remove dead references and add ourselves to the window list
        _opened_windows = [win for win in _opened_windows if win()]
        _opened_windows.append(weakref.ref(self))

        # initialize context
        self.init_opengl()
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

    def clear(self, red = 0.0, green = 0.0, blue = 0.0):
        glClearColor(red, green, blue, 1.0)
        glClear(GL_COLOR_BUFFER_BIT)

    def get_screen_data(self, position = (0, 0), size = None, buffer = "front"):
        from pygrafix.image import ImageData

        cdef unsigned char *c_pixel_data
        cdef bytes pixel_data

        old_window = get_active_window()
        self.switch_to()

        if buffer == "front":
            glReadBuffer(GL_FRONT)
        elif buffer == "back":
            glReadBuffer(GL_BACK)
        else:
            raise Exception("Unknown buffer value: %s" % repr(buffer))

        if size is None:
            size = (self.width - position[0], self.height - position[1])

        if position[0] < 0 or position[1] < 0 or size[0] < 0 or size[1] < 0:
            raise ValueError("Position and size may only have positive members")

        if (position[0] + size[0]) > self.width or (position[1] + size[1]) > self.height:
            raise ValueError("Area doesn't fit in the screen")

        # get data from OpenGL
        c_pixel_data = <unsigned char*> malloc(size[0] * size[1] * 3 * sizeof(unsigned char))
        glReadPixels(position[0], position[1], size[0], size[1], GL_RGB, GL_UNSIGNED_BYTE, c_pixel_data)
        pixel_data = c_pixel_data[:size[0] * size[1] * 3]
        free(c_pixel_data)

        # invert image
        rows = [pixel_data[start_index:start_index + size[0] * 3] for start_index in range(0, size[0] * size[1] * 3, size[0] * 3)]
        pixel_data = "".join(rows[::-1])

        return ImageData(size[0], size[1], "RGB", pixel_data)

    def save_screenshot(self, filename, file = None):
        from pygrafix.image import write
        write(self.get_screen_data(buffer = "front"), filename, file)


    def get_fps(self):
        if self._frametime == 0:
            return 0.0

        return 1 / self._frametime

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

    # built-in methods
    def __enter__(self):
        self.switch_to()

    # special properties
    property width:
        def __get__(self):
            return self.size[0]

        def __set__(self, int width):
            self.size = (width, self.height)

    property height:
        def __get__(self):
            return self.size[1]

        def __set__(self, int height):
            self.size = (self.width, height)

    property size:
        def __get__(self):
            cdef int w, h

            w, h = -1, -1
            glfwGetWindowSize(self._window, &w, &h)

            if h == -1 or w == -1:
                raise Exception("Error while retrieving size.")

            return w, h

        def __set__(self, tup):
            width, height = tup
            glfwSetWindowSize(self._window, width, height)

    property position:
        def __get__(self):
            cdef int x, y
            glfwGetWindowPos(self._window, &x, &y)

            return x, y

        def __set__(self, tup):
            cdef int x, y
            x, y = tup
            glfwSetWindowPos(self._window, x, y)

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
            glfwSwapInterval(vsync)
            self._vsync = vsync

    property mouse_cursor:
        def __get__(self):
            mouse_cursor = glfwGetInputMode(self._window, GLFW_CURSOR_MODE)

            if mouse_cursor == GLFW_CURSOR_NORMAL:
                return "normal"
            elif mouse_cursor == GLFW_CURSOR_HIDDEN:
                return "hidden"
            elif mouse_cursor == GLFW_CURSOR_CAPTURED:
                return "captured"

        def __set__(self, mouse_cursor):
            if mouse_cursor == "normal":
                mode = GLFW_CURSOR_NORMAL
            elif mouse_cursor == "hidden":
                mode = GLFW_CURSOR_HIDDEN
            elif mouse_cursor == "captured":
                mode = GLFW_CURSOR_CAPTURED
            else:
                raise Exception("Unknown mouse_cursor value, possibilities are \"normal\", \"hidden\" and \"captured\".")

            glfwSetInputMode(self._window, GLFW_CURSOR_MODE, mode)

    property key_repeat:
        def __get__(self):
            return self._key_repeat

        def __set__(self, bint key_repeat):
            glfwSetInputMode(self._window, GLFW_KEY_REPEAT, key_repeat)

            self._key_repeat = key_repeat

    property title:
        def __get__(self):
            return self._title

        def __set__(self, title):
            self._title = title
            glfwSetWindowTitle(self._window, title)

    property fullscreen:
        def __get__(self):
            return self._fullscreen

        def __set__(self, fullscreen):
            if fullscreen != self._fullscreen:
                # save settings
                width = self.width
                height = self.height
                refresh_rate = self.refresh_rate
                title = self.title
                vsync = self.vsync
                resizable = self.resizable
                key_repeat = self.key_repeat
                mouse_cursor = self.mouse_cursor

                rbits = glfwGetWindowParam(self._window, GLFW_RED_BITS)
                gbits = glfwGetWindowParam(self._window, GLFW_GREEN_BITS)
                bbits = glfwGetWindowParam(self._window, GLFW_BLUE_BITS)
                abits = glfwGetWindowParam(self._window, GLFW_ALPHA_BITS)
                bit_depth = (rbits, gbits, bbits, abits)

                # save callbacks
                close_callback = self._close_callback
                resize_callback = self._resize_callback
                refresh_callback = self._refresh_callback
                mouse_scroll_callback = self._mouse_scroll_callback
                mouse_move_callback = self._mouse_move_callback
                key_press_callback = self._key_press_callback
                key_release_callback = self._key_release_callback
                text_callback = self._text_callback

                # clean up and close
                self.close()

                # re-open window
                self.__init__(width, height, title, fullscreen, resizable, refresh_rate, vsync, bit_depth)
                self.mouse_cursor = mouse_cursor
                self.key_repeat = key_repeat

                # re-register callbacks
                self.set_close_callback(close_callback)
                self.set_resize_callback(resize_callback)
                self.set_refresh_callback(refresh_callback)
                self.set_mouse_scroll_callback(mouse_scroll_callback)
                self.set_mouse_move_callback(mouse_move_callback)
                self.set_key_press_callback(key_press_callback)
                self.set_key_release_callback(key_release_callback)
                self.set_text_callback(text_callback)

    cdef init_opengl(self):
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

        glEnable(GL_MULTISAMPLE)

        #glHint(GL_LINE_SMOOTH_HINT, GL_NICEST)
        #glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST)

        # make sure glColor is used
        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)

        # set up the correct viewport
        width, height = self.size
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


# and some free functions
def get_active_window():
    """get_active_window()

    Returns the current active window."""

    cdef GLFWwindow current_context

    current_context = glfwGetCurrentContext()

    if current_context == NULL:
        return None

    return <Window> glfwGetWindowUserPointer(current_context)

def get_open_windows():
    """get_open_windows()

    Returns a list of all opened windows."""

    return [win() for win in _opened_windows if win()]

def get_video_modes():
    """get_video_modes()

    Returns a list of all legal video modes in the form (width, height, (redbits, greenbits, bluebits))."""

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
    """get_desktop_video_mode()

    Returns the desktop video mode in the form (width, height, (redbits, greenbits, bluebits))."""

    cdef GLFWvidmode video_mode

    glfwGetDesktopMode(&video_mode)

    return (video_mode.width, video_mode.height, (video_mode.redBits, video_mode.greenBits, video_mode.blueBits))

__all__ = ["Window", "get_active_window", "get_open_windows", "get_video_modes", "get_desktop_video_mode"]
