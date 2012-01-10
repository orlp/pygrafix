from __future__ import division

import time
import random

import pygrafix
from pygrafix.window import key

# open window and set up
windows = [pygrafix.window.Window(800, 600, title = "Snowflakes x3", fullscreen = False, vsync = False) for i in range(3)]

# load resources
for window in windows:
    window.switch_to()
    snowflaketex = pygrafix.image.load("snowflake.png")

# create sprite group
spritegroup = {}
for window in windows:
    spritegroup[id(window)] = pygrafix.sprite.SpriteGroup()

# snowflake object
class Snowflake(object):
    def __init__(self, window):
        self.window = window
        self.sprite = pygrafix.sprite.Sprite(snowflaketex)

        # sprite init
        self.sprite.x = random.uniform(0, self.window.width)
        self.sprite.y = random.uniform(0, self.window.height)
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
        spritegroup[id(window)].add_sprite(self.sprite)

    def animate(self, dt):
        self.sprite.x += self.dx * dt
        self.sprite.y += self.dy * dt
        self.sprite.rotation += self.drotation * dt

        win_width, win_height = self.window.size

        if (self.sprite.x < 0 and self.dx < 0) or (self.sprite.x > win_width and self.dx > 0):
            self.dx = -self.dx

        if self.sprite.y > win_height + self.sprite.height:
            self.sprite.y = -self.sprite.height

        if (self.sprite.scale > 2 and self.dscale > 0) or (self.sprite.scale < 0.5 and self.dscale < 0):
            self.dscale = -self.dscale

# create snowflakes
snowflakes = {}
for window in windows:
    snowflakes[id(window)] = [Snowflake(window) for _ in range(100)]

def main():
    # time tracking and FPS
    now = time.clock()
    accum = 0.0

    while True:
        # time and fps
        dt = time.clock() - now
        now += dt
        accum += dt

        # print fps for window 1
        if accum >= 1:
            print(windows[0].get_fps())
            accum -= 1

        # check if all windows are closed
        remaining = 0
        for window in windows:
            if window.is_open():
                remaining = True
                break
        
        if remaining == 0:
            break
        
        for window in windows:
            if not window.is_open():
                continue
            
            window.switch_to()
            
            # read new events
            window.poll_events()
            
            # close window
            if window.is_key_pressed(key.ESCAPE):
                window.close()

            # fullscreen?
            if window.is_key_pressed(key.F11):
                window.toggle_fullscreen()

            for snowflake in snowflakes[id(window)]:
                snowflake.animate(dt)

            window.clear()
            spritegroup[id(window)].draw()
            window.flip()

        time.sleep(0.000001)


import cProfile
cProfile.run("main()", sort = "time")
