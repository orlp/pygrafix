import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Test window", fullscreen = False, vsync = False)

# load resources
maptex = pygrafix.image.load("map.png")
maptex.set_scale_smoothing(0) # pixel art, we don't want any smoothing to be done when we scale

map = pygrafix.sprite.Sprite(maptex)
map.scale = 6
map.y = -400

while True:
    # read new events
    window.poll_events()

    # check if we need to quit
    if not window.is_open() or window.is_key_pressed(key.ESCAPE):
        break

    # fullscreen?
    if window.is_key_pressed(key.F11):
        window.toggle_fullscreen()

    window.clear(0.0, 0.0, 0.0, 1.0)
    map.draw()

    window.flip()
