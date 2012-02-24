from __future__ import division

import time
import pygrafix
import math
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Test window", fullscreen = False)
window.mouse_cursor = "hidden"

# load resources
maptex = pygrafix.image.load("map.png")

map = pygrafix.sprite.Sprite(maptex)
map.scale = 6
map.x = 0
map.y = -400

# time tracking and FPS
now = time.clock()
accum = 0.0
frames = 0

def main():
    global now, accum, frames, map_x, map_y

    while True:
        # read new events
        window.poll_events()

        # check if we need to quit
        if not window.is_open() or window.is_key_pressed(key.ESCAPE):
            break

        # fullscreen?
        if window.is_key_pressed(key.F11):
            window.fullscreen = not window.fullscreen

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
        mspeed_x, mspeed_y = float(mouse_x) / window.width - 0.5, float(mouse_y) / window.height - 0.5
        
        map.x -= math.copysign(2000.0, mspeed_x) * dt * (math.exp(abs(mspeed_x)) - 1)
        map.y -= math.copysign(2000.0, mspeed_y) * dt * (math.exp(abs(mspeed_y)) - 1)

        window.clear()
        map.draw(scale_smoothing = False)

        window.flip()

import cProfile
cProfile.run("main()", sort="time")
