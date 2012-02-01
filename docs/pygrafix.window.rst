:mod:`pygrafix.window` --- Managing windows
===========================================

This module allows you to open and manage your windows to be used for pygrafix.

.. class:: Window([width[, height[, title[, fullscreen[, resizable[, refresh_rate[, vsync[, bit_depth]]]]]]]])

    Creates a new window. *width* and *height* give the size of the new window, *title* is a string for the window caption, *fullscreen* is a boolean indicating whether the new window is fullscreen or not. *resizable* is a boolean indicating whether the new window is resizable by the user. *refresh_rate* is the refresh rate in Hz (only used in fullscreen). *vsync* is a boolean indicating whether vsync should be enabled. *bit_depth* is a tuple in the form *(red, green, blue, alpha)* indicating how much bits should be used for each channel.

    If *width* is zero (the default), it will be calculated as ``width = (4/3) * height``, if *height* is not zero. If *height* is zero (the default), it will be calculated as ``height = (3/4) * width``, if *width* is not zero. If both *width* and *height* are zero, *width* will be set to 640 and *height* to 480.

    If no title is given the default title "pygrafix window" is chosen. The default value for *resizable* is False. If *refresh_rate* is zero (the default) the system's refresh rate will be used. The default value for *vsync* is True. If *bit_depth* is not given pygrafix will choose the best values.

    .. attribute:: width

        The width of the screen in pixels. Read-write.

    .. attribute:: height

        The height of the screen in pixels. Read-write.

    .. attribute:: size

        The size of the window in the form *(width, height)*. Read-write.

    .. attribute:: resizable

        A boolean indicating if the window is resizable by the user (you can always resize the window from the code). Read-only.

    .. attribute:: refresh_rate

        The refresh rate of the window. Only applicable in full-screen. Read-only.

    .. attribute:: vsync

        A boolean indicating whether vsync is enabled or not. Read-write.

    .. attribute:: mouse_cursor

        A boolean indicating whether the mouse is enabled or disabled. Read-write.

    .. attribute:: title

        The title of this window. Read-write.

    .. attribute:: fullscreen

        A boolean indicating whether the window is fullscreen or not. Read-only.

    .. method:: close()

        Closes the window.

    .. method:: is_open()

        Returns whether the window is open or not.

    .. method:: poll_events()

        Calling this will pump through new window events like keypresses. Call this at least once per frame.

    .. method:: wait_events()

        Does the same as the :meth:`poll_events` but sleeps the process until an event is triggered.

    .. method:: set_position(x, y)

        Moves the window such that the topleft of the window is *(x, y)* pixels away from the topleft of the screen.

    .. method:: set_size(width, height)

        Sets the new window size in pixels.

    .. method:: get_size()

        Returns the size of the window in the form *(width, height)*.

    .. method:: set_title(title)

        Sets the title of the window

    .. method:: toggle_fullscreen()

        Switches to fullscreen if in windowed mode and vice versa.

    .. method:: minimize()

        Minimizes the window.

    .. method:: restore()

        Restores the window.

    .. method:: has_focus()

        Returns a boolean indicating whether this window has focus.

    .. method:: is_minimized()

        Returns a boolean indicating if the window is minimized.

    .. method:: flip()

        This flips the window buffers and makes everything that has been drawn visible to the user. Call this once per frame.

    .. method:: switch_to()

        Makes this window the active window (the window that is drawn on).

    .. method:: set_mouse_cursor(mouse_cursor)

        If *mouse_cursor* is True this will enable the hardware mouse cursor, else it will turn it off.

    .. method:: set_key_repeat(key_repeat)

        If *key_repeat* is True this will turn key repeating on, else off.

    .. method:: set_vsync(vsync)

        If *vsync* is True this will turn vsync on, else off.

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

    .. method:: get_fps()

        Returns the frames per second as calculated from how often :meth:`flip` gets called.




.. function:: get_active_window()

    Returns the active window. The active window is the window any draw calls will target.

.. function:: get_open_windows()

    Returns a list of all opened windows.

.. function:: get_video_modes()

    Returns a list of all legal video modes in the form *(width, height, (redbits, greenbits, bluebits))*.

.. function:: get_desktop_video_mode()

    Returns the desktop video mode in the form *(width, height, (redbits, greenbits, bluebits))*.
