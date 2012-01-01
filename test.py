from __future__ import division

import time
import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Test window", fullscreen = False, vsync = False)

# load resources
maptex = pygrafix.image.load("map.png")
maptex.set_scale_smoothing(0) # pixel art, we don't want any smoothing to be done when we scale

map = pygrafix.sprite.Sprite(maptex)
map.scale = 6

map_x = 0
map_y = 400

# time tracking and FPS
now = time.clock()
accum = 0.0
frames = 0

while True:
    # read new events
    window.poll_events()

    # check if we need to quit
    if not window.is_open() or window.is_key_pressed(key.ESCAPE):
        break

    # fullscreen?
    if window.is_key_pressed(key.F11):
        window.toggle_fullscreen()

    # time and fps
    dt = time.clock() - now
    now += dt
    accum += dt
    frames += 1

    if accum >= 1:
        print(frames)
        accum -= 1
        frames = 0

    # animation
    mouse_x, mouse_y = window.get_mouse_position()
    map_x += 1000 * dt * (mouse_x - window.width / 2) / window.width
    map_y += 1000 * dt * (mouse_y - window.height / 2) / window.height

    map.x = -map_x
    map.y = -map_y

    window.clear(0.0, 0.0, 0.0, 1.0)
    map.draw()

    window.flip()
