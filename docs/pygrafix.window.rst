:mod:`pygrafix.window` --- Managing windows
===========================================

.. module:: pygrafix.window

This module allows you to open and manage your windows to be used for pygrafix.

.. class:: Window([width[, height[, title[, fullscreen[, resizable[, refresh_rate[, vsync[, bit_depth]]]]]]]])

    Creates a new window. *width* and *height* give the size of the new window, *title* is a string for the window caption, *fullscreen* is a boolean indicating whether the new window is fullscreen or not. *resizable* is a boolean indicating whether the new window is resizable by the user. *refresh_rate* is the refresh rate in Hz (only used in fullscreen). *vsync* is a boolean indicating whether vsync should be enabled. *bit_depth* is a tuple in the form *(red, green, blue, alpha)* indicating how much bits should be used for each channel.

    If *width* is zero (the default), it will be calculated as ``width = (4/3) * height``, if *height* is not zero. If *height* is zero (the default), it will be calculated as ``height = (3/4) * width``, if *width* is not zero. If both *width* and *height* are zero, *width* will be set to 640 and *height* to 480.

    If no title is given the default title "pygrafix window" is chosen. The default value for *resizable* is False. If *refresh_rate* is zero (the default) the system's refresh rate will be used. The default value for *vsync* is True. If *bit_depth* is not given pygrafix will choose the best values.

    pygrafix only supports double-buffered windows. This means that all drawing gets done on the back buffer and the user only ever sees the front-buffer. This is done to prevent half-done frames from showing up to the user. You swap the front and the back buffer by calling :meth:`flip`.

    All attributes are read-write unless said otherwise.

    .. attribute:: width

        The width of the screen in pixels.

    .. attribute:: height

        The height of the screen in pixels.

    .. attribute:: size

        The size of the window in the form *(width, height)*.

    .. attribute:: position

        The position of the window in the form *(x, y)*. *x* and *y* are measured in pixels relative to the topleft of the screen.

    .. attribute:: resizable

        A boolean indicating if the window is resizable by the user (you can always resize the window from the code). Read-only.

    .. attribute:: refresh_rate

        The refresh rate of the window. Only applicable in full-screen. Read-only.

    .. attribute:: vsync

        A boolean indicating whether vsync is enabled or not.

    .. attribute:: mouse_cursor

        Defines the cursor mode. Legal modes are *"normal"*, *"hidden"* and *"captured"*. In normal mode the regular hardware cursor is used and all mouse position functions work normally. In hidden mode everything is the same, except the cursor is not shown. Captured mode is radically different, the cursor is hidden and is not blocked by window boundaries. This last mode is commonly used for first-person-shooters.

    .. attribute:: key_repeat

        A boolean indicating whether key repeating is enabled or not.

    .. attribute:: title

        The title of this window.

    .. attribute:: fullscreen

        A boolean indicating whether the window is fullscreen or not.

    .. method:: close()

        Closes the window.

    .. method:: is_open()

        Returns whether the window is open or not.

    .. method:: poll_events()

        Calling this will pump through new window events like keypresses. Call this at least once per frame.

    .. method:: wait_events()

        Does the same as the :meth:`poll_events` but sleeps the process until an event is triggered.

    .. method:: minimize()

        Minimizes the window.

    .. method:: restore()

        Restores the window.

    .. method:: has_focus()

        Returns a boolean indicating whether this window has focus.

    .. method:: is_minimized()

        Returns a boolean indicating if the window is minimized.

    .. method:: switch_to()

        Makes this window the active window (the window that is drawn on).

    .. method:: flip()

        This flips the front and the back and makes everything that has been drawn visible to the user. Call this once per frame.

    .. method:: get_mouse_position()

        Returns the position of the mouse relative to the topleft of the screen in the form *(x, y)*.

    .. method set_mouse_position(x, y)

        Sets the position of the mouse to *(x, y)* relative to the topleft of the screen.

    .. method:: is_key_pressed(key)

        Returns True if *key* is pressed, else False. *key* can be a key constant from :mod:`pygrafix.window.key` or an alphanumeric string of length one (for example *"A"*).

    .. method:: is_mouse_button_pressed(button)

        Returns True if *button* is pressed, else False. *button* can be a mouse button constant from :mod:`pygrafix.window.mouse`.

    .. method:: clear([red[, green[, blue]]])

        Clears the whole screen to the given color.

    .. method:: get_screen_data([position[, size[, buffer]]])

        Returns an :class:`~pygrafix.image.ImageData` object containing the current contents of the screen. You can select a sub-part of the screen with *position* and *size*. Position must have the form *(x, y)* and size *(width, height)*. The optional argument *buffer* may be *"front"* or *"back"* and defaults to *"front"*. The front buffer is what the user currently sees, the back buffer is the buffer you do your drawing on.

    .. method:: save_screenshot(filename[, file])

        Saves a screenshot of this window into a file. If *file* is given *filename* will be used as a hint for the filetype.

    .. method:: get_fps()

        Returns the frames per second. This value is calculated from how often :meth:`flip` gets called with an algorithm that slightly smoothes out FPS changes.




.. function:: get_active_window()

    Returns the active window. The active window is the window any draw calls will target.

.. function:: get_open_windows()

    Returns a list of all opened windows.

.. function:: get_video_modes()

    Returns a list of all legal video modes in the form *(width, height, (redbits, greenbits, bluebits))*.

.. function:: get_desktop_video_mode()

    Returns the desktop video mode in the form *(width, height, (redbits, greenbits, bluebits))*.
