import pygrafix
from pygrafix.window import key

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Test window", fullscreen = False, vsync = False)

# load resources
map = pygrafix.sprite.Sprite(pygrafix.image.load("map.png")) # large texture
map.scale = 6
map.y = -400

def main():
    while True:
        # read new events
        window.poll_events()

        # check if we need to quit
        if not window.is_open() or window.is_key_pressed(key.ESCAPE):
            break

        # fullscreen?
        if window.is_key_pressed(key.F11):
            window.toggle_fullscreen()

        window.clear(0.0, 0.0, 0.0, 1.0)
        map.draw() # lots of redundant drawing to take time

        window.flip() # but this one just eats up all time


import cProfile

cProfile.run("main()", sort="time")
