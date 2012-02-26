import pygrafix

window = pygrafix.window.Window()

while True:
    # read new events
    window.poll_events()
    
    # check if window is closed
    if not window.is_open():
        break
