import time
import pygrafix

# timer tracking when we must update the FPS again
next_fps_update = time.time()

window = pygrafix.window.Window(500, 500, resizable = True)
window.position = (10, 10)

while True:
    # read new events
    window.poll_events()
    
    # check if window is closed
    if not window.is_open():
        break
    
    # set window title to show our FPS, but only update every half second
    if time.time() > next_fps_update:
        window.title = "%d frames per second" % window.get_fps()
        next_fps_update = time.time() + 0.5

    # draw background with color (0.1, 0.1, 0.1)
    window.clear(0.0, 0.0, 0.0)
    
    # flip the drawing buffer with the viewing buffer
    window.flip()