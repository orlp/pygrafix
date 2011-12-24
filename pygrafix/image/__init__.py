# this has to be a from module import ***, because pygrafix.image is not defined yet
from pygrafix.image import codecs

class Image:
    def __init__(self, width, height, channels, data):
        self.data = data
        self.width = width
        self.height = height
        self.channels = channels

def load(filename, file = None, decoder = None, request_channels = None):
    if file == None:
        file = open(filename, "rb")

    format = filename.rsplit(".", 1)[-1].lower()

    error = None

    for decoder in codecs.get_codecs(format):
        try:
            return decoder.decode(file, format, request_channels)

        except codecs.ImageDecodeException as e:
            error = e

    raise error

# after defining all classes and methods, load default codecs
codecs.load_default_codecs()
