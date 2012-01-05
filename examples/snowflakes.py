from __future__ import division

import time
import random

import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Hares", fullscreen = False, vsync = False)

# load resources
snowflaketex = pygrafix.image.load("snowflake.png")

# create sprite group
spritegroup = pygrafix.sprite.SpriteGroup()

# snowflake object
class Snowflake(object):
    def __init__(self):
        self.sprite = pygrafix.sprite.Sprite(snowflaketex)

        # sprite init
        self.sprite.x = random.uniform(0, window.width)
        self.sprite.y = random.uniform(0, window.height)
        self.sprite.scale = random.uniform(0.5, 2)
        self.sprite.rotation = random.uniform(0, 360)

        self.sprite.alpha = random.uniform(0.0, 1.0)

        self.sprite.anchor_x = self.sprite.texture.width/2
        self.sprite.anchor_y = self.sprite.texture.height/2

        # animation config
        self.dx = random.uniform(-200, 200)
        self.dy = random.uniform(0, 200)
        self.drotation = random.uniform(0, 80)

        # register sprite in spritegroup
        spritegroup.add_sprite(self.sprite)

    def animate(self, dt):
        self.sprite.x += self.dx * dt
        self.sprite.y += self.dy * dt
        self.sprite.rotation += self.drotation * dt

        win_width, win_height = window.size

        if (self.sprite.x < 0 and self.dx < 0) or (self.sprite.x > win_width and self.dx > 0):
            self.dx = -self.dx

        if self.sprite.y > win_height + self.sprite.height:
            self.sprite.y = -self.sprite.height

        if (self.sprite.scale > 2 and self.dscale > 0) or (self.sprite.scale < 0.5 and self.dscale < 0):
            self.dscale = -self.dscale

# create snowflakes
snowflakes = [Snowflake() for _ in range(300)]

def main():
    # time tracking and FPS
    now = time.clock()
    accum = 0.0

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

        for snowflake in snowflakes:
            snowflake.animate(dt)

        window.clear()
        spritegroup.draw()
        window.flip()

        time.sleep(0.000001)


import cProfile
cProfile.run("main()", sort = "time")
