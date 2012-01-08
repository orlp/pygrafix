from __future__ import division

import time
import random

import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, fullscreen = False, vsync = False)
window.set_mouse_cursor(False)

# load resources
particles = pygrafix.image.load("particles.png")
steamparticle = particles.get_region(0, 96, 32, 32)

# create sprite group
spritegroup = pygrafix.sprite.SpriteGroup()

# a steampuff object
class Steampuff(object):
    def __init__(self):
        self.sprite = pygrafix.sprite.Sprite(steamparticle)

        # sprite init
        self.sprite.x, self.sprite.y = window.get_mouse_position()
        self.sprite.scale = random.uniform(1.0, 1.2)
        self.sprite.rotation = random.uniform(0, 360)

        self.sprite.red = random.uniform(0.5, 0.7)
        self.sprite.blue = self.sprite.red
        self.sprite.green = self.sprite.red
        self.sprite.alpha = random.uniform(0.0, 1.0)

        self.sprite.anchor_x = self.sprite.texture.width/2
        self.sprite.anchor_y = self.sprite.texture.height/2

        self.life_time = random.random()

        # animation config
        self.dx = random.uniform(-90, 90)
        self.dy = random.uniform(-90, 90)
        self.dalpha = -self.sprite.alpha / self.life_time


        # register sprite in spritegroup
        spritegroup.add_sprite(self.sprite)

    def animate(self, dt):
        self.sprite.x += self.dx * dt
        self.sprite.y += self.dy * dt
        self.sprite.alpha += self.dalpha * dt

        win_width, win_height = window.size

        self.life_time -= dt

        if self.life_time < 0:
            self.life_time += 1
            self.dx = random.uniform(-50, 50)
            self.dy = random.uniform(-50, 50)
            self.sprite.alpha = random.uniform(0.0, 1.0)
            self.dalpha = -self.sprite.alpha / self.life_time
            self.sprite.x, self.sprite.y = window.get_mouse_position()


# create steampuffs
steampuffs = [Steampuff() for _ in range(300)]

def main():
    # time tracking and FPS
    now = time.clock()
    accum = 0.0

    while True:
        # read new events
        window.poll_events()

        # check if we need to quit
        if not window.is_open() or window.is_key_pressed(key.ESCAPE):
            window.close()
            break

        # fullscreen?
        if window.is_key_pressed(key.F11):
            window.toggle_fullscreen()

        # time and fps
        dt = time.clock() - now
        now += dt
        accum += dt

        if accum >= 1:
            window.title = "Steam: %d frames per second @ %d x %d" % (int(window.get_fps()), window.width, window.height)
            accum -= 1

        for steampuff in steampuffs:
            steampuff.animate(dt)

        window.clear()
        spritegroup.draw()
        window.flip()

        time.sleep(0.000001)


import cProfile
cProfile.run("main()", sort = "time")
