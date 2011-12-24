# exceptions
class ImageDecodeException(Exception):
    pass

_codecs = []

def add_codec(codec):
    _codecs.append(codec)

def get_codecs(format):
    available_codecs = []

    for codec in _codecs:
        if format in codec.formats:
            available_codecs.append(codec)

    return available_codecs
