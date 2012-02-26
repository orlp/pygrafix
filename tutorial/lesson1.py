import pygrafix

window = pygrafix.window.Window()

while True:
    # read new events
    window.poll_events()

    # check if window is closed
    if not window.is_open():
        break

    # draw background with color (0.1, 0.1, 0.1)
    window.clear(0.1, 0.3, 0.1)

    # draw red-ish rectangle
    pygrafix.draw.rectangle_outline((100, 100), (70, 80), (1.0, 0.1, 0.1), width = 6)
    pygrafix.draw.rectangle_outline((100, 100), (70, 80), (0.0, 0.1, 1.0), width = 1)

    # flip the drawing buffer with the viewing buffer
    window.flip()
