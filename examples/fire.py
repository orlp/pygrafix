from __future__ import division

import time
import random

import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, fullscreen = False, vsync = False)
window.mouse_cursor = "hidden"

# load resources
particles = pygrafix.image.load("particles.png")
fireparticle = particles.get_region(0, 0, 32, 32)
steamparticle = particles.get_region(0, 96, 32, 32)

# create list of sprites for batching
spritebatch1 = []
spritebatch2 = []

# keep track of alive particles
particles = []

class Flameparticle(object):
    def __init__(self):
        self.sprite = pygrafix.sprite.Sprite(fireparticle)

        # sprite init
        self.sprite.x, self.sprite.y = window.get_mouse_position()

        self.sprite.red = random.uniform(0.7, 0.9)
        self.sprite.blue = random.uniform(0.0, 0.1)
        self.sprite.green = random.uniform(0.0, 0.2)
        self.sprite.alpha = random.uniform(0.0, 1.0)

        self.sprite.anchor_x = self.sprite.texture.width/2
        self.sprite.anchor_y = self.sprite.texture.height/2

        self.sprite.scale = random.uniform(0.2, 1.9)

        self.life_time = random.random() * 3

        # animation config
        self.dx = random.uniform(-15, 15)
        self.dy = random.uniform(-220, 0)
        self.dalpha = -self.sprite.alpha / self.life_time

        # register ourselves
        spritebatch1.append(self.sprite)
        particles.append(self)

    def animate(self, dt):
        self.sprite.x += self.dx * dt
        self.sprite.y += self.dy * dt
        self.sprite.alpha += self.dalpha * dt

        win_width, win_height = window.size

        self.life_time -= dt

        if self.life_time < 0:
            spritebatch1.remove(self.sprite)
            particles.remove(self)

# a steampuff object
class Steampuff(object):
    def __init__(self):
        self.sprite = pygrafix.sprite.Sprite(steamparticle)

        # sprite init
        self.sprite.x, self.sprite.y = window.get_mouse_position()
        self.sprite.y -= 50
        self.sprite.scale = random.uniform(1.0, 1.2)
        self.sprite.rotation = random.uniform(0, 360)

        self.sprite.red = random.uniform(0.5, 0.7)
        self.sprite.blue = self.sprite.red
        self.sprite.green = self.sprite.red
        self.sprite.alpha = random.uniform(0.0, 1.0)

        self.sprite.anchor_x = self.sprite.texture.width/2
        self.sprite.anchor_y = self.sprite.texture.height/2

        self.life_time = random.random() * 3

        # animation config
        self.dx = random.uniform(-30, 30)
        self.dy = random.uniform(-220, 0)
        self.dalpha = -self.sprite.alpha / self.life_time
        
        self.sprite.x += self.dx * 1
        self.sprite.y += self.dy * 1


        # register sprite in spritegroup
        spritebatch2.append(self.sprite)
        particles.append(self)

    def animate(self, dt):
        self.sprite.x += self.dx * dt
        self.sprite.y += self.dy * dt
        self.sprite.alpha += self.dalpha * dt

        win_width, win_height = window.size

        self.life_time -= dt

        if self.life_time < 0:
            spritebatch2.remove(self.sprite)
            particles.remove(self)
            
            
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
            
        # update particles
        for particle in particles:
            particle.animate(dt)
        
        # spawn new particles
        if len(particles) < 400:
            for _ in range(min(100, 400 - len(particles))):
                Steampuff()
                Flameparticle()
                Flameparticle()
                Flameparticle()

        window.clear()

        pygrafix.sprite.draw_batch(spritebatch2, blending = "mix")
        pygrafix.sprite.draw_batch(spritebatch1, blending = "add")
        window.flip()

        time.sleep(0.000001)


import cProfile
cProfile.run("main()", sort = "time")
