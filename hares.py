from __future__ import division

import time
import random

import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Hares", fullscreen = False)

# load resources
maptex = pygrafix.image.load("zazaka.png")

# create sprite groups
hares = pygrafix.sprite.SpriteGroup()

# create hares
for _ in range(300):
    hare = pygrafix.sprite.Sprite(maptex)

    hare.x = random.uniform(0, window.width)
    hare.y = random.uniform(0, window.height)
    hare.scale_x = random.uniform(0.5, 2)
    hare.scale_y = hare.scale_x
    hare.rotation = random.uniform(0, 360)

    hare.red = random.random()
    hare.green = random.random()
    hare.blue = random.random()

    hare.anchor_x = hare.texture.width/2
    hare.anchor_y = hare.texture.height/2

    hares.add_sprite(hare)

# time tracking and FPS
now = time.clock()
accum = 0.0
frames = 0

def animate(dt):
    for hare in hares:
        hare.rotation += 10 * dt
        hare.x += 10 * dt

    #for hare in hares:
    #    hare.x += hare.dx * dt
    #    hare.y += hare.dy * dt
    #
    #    if hare.x > window.width or hare.x < 0:
    #        hare.dx = -hare.dx
    #
    #    if hare.y > window.height or hare.y < 0:
    #        hare.dy = -hare.dy
    #
    #    hare.scale_x += hare.dscale * dt
    #    hare.scale_y += hare.dscale * dt
    #    if hare.scale_x > 2 or hare.scale_x < 0.5:
    #        hare.dscale = -hare.dscale
    #
    #    hare.rotation += hare.drotation * dt

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

        animate(dt)

        window.clear(0.0, 0.4, 0.0, 1.0)
        hares.draw()
        window.flip()

        time.sleep(0.00001)


import cProfile
main()#cProfile.run("main()", sort = "time")
