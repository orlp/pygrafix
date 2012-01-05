from __future__ import division

import time
import random

import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Hares", fullscreen = False)

# load resources
haretex = pygrafix.image.load("hare.png")

# create sprite groups
hares = pygrafix.sprite.SpriteGroup()

# create hares
for _ in range(500):
    hare = pygrafix.sprite.Sprite(haretex)

    hare.x = random.uniform(0, window.width)
    hare.y = random.uniform(0, window.height)
    hare.scale = random.uniform(0.5, 2)
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

hareanims = [[random.uniform(-200, 200), random.uniform(-200, 200), random.uniform(0, 80), random.uniform(-1.0, 1.0)] for _ in range(1000)]

def animate(dt):
    win_width, win_height = window.size

    index = 0
    for hare in hares:
        hareanim = hareanims[index]

        hare.x += hareanim[0] * dt
        hare.y += hareanim[1] * dt
        hare.rotation += hareanim[2] * dt
        hare.scale += hareanim[3] * dt

        if (hare.x < 0 and hareanim[0] < 0) or (hare.x > win_width and hareanim[0] > 0):
            hareanim[0] = -hareanim[0]

        if (hare.y < 0 and hareanim[1] < 0) or (hare.y > win_height and hareanim[1] > 0):
            hareanim[1] = -hareanim[1]

        if (hare.scale > 2 and hareanim[3] > 0) or (hare.scale < 0.5 and hareanim[3] < 0):
            hareanim[3] = -hareanim[3]

        index += 1

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
