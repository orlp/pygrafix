from __future__ import division

import time
import random

import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, fullscreen = False, vsync = False)
window.set_mouse_cursor(False)

# load resources
particle = pygrafix.image.load("particles.png").get_region(0, 0, 32, 32)

# create sprite group
spritegroup = pygrafix.sprite.SpriteGroup(blending = "add")

class Flameparticle(object):
    def __init__(self):
        self.sprite = pygrafix.sprite.Sprite(particle)

        # sprite init
        self.sprite.x, self.sprite.y = window.get_mouse_position()

        self.sprite.red = random.uniform(0.7, 0.9)
        self.sprite.blue = random.uniform(0.0, 0.1)
        self.sprite.green = random.uniform(0.0, 0.2)
        self.sprite.alpha = random.uniform(0.0, 1.0)

        self.sprite.anchor_x = self.sprite.texture.width/2
        self.sprite.anchor_y = self.sprite.texture.height/2

        self.sprite.scale = random.uniform(0.2, 1.9)

        self.life_time = random.random()

        # animation config
        self.dx = random.uniform(-2, 2)
        self.dy = random.uniform(-90, 0)
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
            self.dx = random.uniform(-15, 15)
            self.dy = random.uniform(-220, 0)
            self.sprite.alpha = random.uniform(0.0, 1.0)
            self.dalpha = -self.sprite.alpha / self.life_time
            self.sprite.x, self.sprite.y = window.get_mouse_position()


# create steampuffs
flames = [Flameparticle() for _ in range(150)]

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

        for flame in flames:
            flame.animate(dt)

        window.clear()
        pygrafix.draw.polygon([(0, 0), (30, 50), (50, 0)], (1.0, 0.5, 0.0))
        pygrafix.draw.polygon_outline([(60+0, 0), (60+30, 50), (60+50, 0)], (1.0, 0.5, 0.0), width = 8)
        pygrafix.draw.line((50, 50), (100, 100), color = (1.0, 0.0, 0.0))
        spritegroup.draw()
        window.flip()

        time.sleep(0.000001)


import cProfile
cProfile.run("main()", sort = "time")
