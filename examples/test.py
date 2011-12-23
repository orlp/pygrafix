import time

import pygrafix
from pygrafix.window import key

# callbacks
def on_resize(window, width, height):
    draw_frame(window)

    window.flip()

def on_scroll(window, delta, pos):
    global rotate
    global scale

    if window.is_key_pressed(key.LCTRL):
        if delta > 0:
            scale /= 1.1
        else:
            scale *= 1.1
    else:
        rotate -= 25 * delta

def on_key_press(window, symbol):
    print(key.symbol_string(symbol))

def draw_frame(window):
    window.clear()

    mouse_x, mouse_y = window.get_mouse_position()
    sprite.x = mouse_x
    sprite.y = mouse_y
    sprite.rotation = rotate
    sprite.scale_x = scale
    sprite.scale_y = scale

    sprite.draw()

# open window and set up
window = pygrafix.window.Window(800, 600, title = "Test window", resizable = True)

pygrafix.sprite.enable()

window.set_resize_callback(on_resize)
window.set_mouse_scroll_callback(on_scroll)
window.set_key_press_callback(on_key_press)

# load resources
img = pygrafix.image.load("sprite.tga")
sprite = pygrafix.sprite.Sprite(img)
sprite.anchor_x = sprite.texture.width / 2
sprite.anchor_y = sprite.texture.height / 2

scale = 1
rotate = 0
frametime = 0.0

while window.is_open():
    start = time.clock()

    window.wait_events()

    if window.is_key_pressed(pygrafix.window.key.ESCAPE):
        window.close()
        break

    if window.is_key_pressed(pygrafix.window.key.F):
        print(1/frametime)

    draw_frame(window)

    window.flip()

    frametime = frametime * 0.99 + (time.clock() - start) * 0.01
