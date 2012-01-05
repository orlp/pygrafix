from __future__ import division

import time
import random

import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Hares", fullscreen = False)

# load resources
haretex = pygrafix.image.load("hare.png")

# create sprite group
spritegroup = pygrafix.sprite.SpriteGroup()

# hare object
class Hare(object):
    def __init__(self):
        self.sprite = pygrafix.sprite.Sprite(haretex)

        # sprite init
        self.sprite.x = random.uniform(0, window.width)
        self.sprite.y = random.uniform(0, window.height)
        self.sprite.scale = random.uniform(0.5, 2)
        self.sprite.rotation = random.uniform(0, 360)

        self.sprite.red = random.random()
        self.sprite.green = random.random()
        self.sprite.blue = random.random()
        self.sprite.alpha = random.random()

        self.sprite.anchor_x = self.sprite.texture.width/2
        self.sprite.anchor_y = self.sprite.texture.height/2

        # animation config
        self.dx = random.uniform(-200, 200)
        self.dy = random.uniform(-200, 200)
        self.drotation = random.uniform(0, 80)
        self.dscale = random.uniform(-1.0, 1.0)

        # register sprite in spritegroup
        spritegroup.add_sprite(self.sprite)

    def animate(self, dt):
        self.sprite.x += self.dx * dt
        self.sprite.y += self.dy * dt
        self.sprite.rotation += self.drotation * dt
        self.sprite.scale += self.dscale * dt

        win_width, win_height = 800, 600

        if (self.sprite.x < 0 and self.dx < 0) or (self.sprite.x > win_width and self.dx > 0):
            self.dx = -self.dx

        if (self.sprite.y < 0 and self.dy < 0) or (self.sprite.y > win_height and self.dy > 0):
            self.dy = -self.dy

        if (self.sprite.scale > 2 and self.dscale > 0) or (self.sprite.scale < 0.5 and self.dscale < 0):
            self.dscale = -self.dscale

# create hares
hares = [Hare() for _ in range(1000)]

# time tracking and FPS
now = time.clock()
accum = 0.0

def main():
    global now, accum, frames

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

        if accum >= 1:
            print(window.get_fps())
            accum -= 1

        for hare in hares:
            hare.animate(dt)

        window.clear()
        spritegroup.draw()
        window.flip()

        time.sleep(0.00001)


import cProfile
cProfile.run("main()", sort = "time")
