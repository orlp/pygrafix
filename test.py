from __future__ import division

import time

import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Test window", fullscreen = False, vsync = False)

# load resources
map = pygrafix.sprite.Sprite(pygrafix.image.load("map.png"))
map.scale = 6
map.y = -400

map_x, map_y = 0.0, 0.0

def draw_frame(window):
    window.clear()

    map.x = map_x
    map.y = map_y
    map.draw()

    window.flip()

def main():
    global map_x, map_y

    old = time.clock()
    accum = 0.0
    frames = 0

    while True:
        # read new events
        window.poll_events()

        # check if we need to quit
        if not window.is_open() or window.is_key_pressed(key.ESCAPE):
            break

        if window.is_key_pressed(key.F11):
            window.toggle_fullscreen()

        # time management
        new = time.clock()
        dt = new - old

        accum += dt
        frames += 1

        if accum > 1:
            print(frames // accum)
            accum = 0.0
            frames = 0

        old = new

        # animation
        scrollspeed_x = 1200.0 * (window.get_mouse_position()[0] - window.width/2) / window.width
        scrollspeed_y = 1200.0 * (window.get_mouse_position()[1] - window.height/2) / window.height

        map_x += dt * -scrollspeed_x
        map_y += dt * -scrollspeed_y

        draw_frame(window)


import cProfile

cProfile.run("main()", sort="time")
