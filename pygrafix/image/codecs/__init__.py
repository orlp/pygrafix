# exceptions
class ImageDecodeException(Exception):
    pass

class ImageEncodeException(Exception):
    pass

_decoders = []
_encoders = []

def add_decoder(decoder):
    _decoders.append(decoder)

def add_encoder(encoder):
    _encoders.append(encoder)

def get_decoders(filename = None):
    if not filename:
        return _decoders

    available_decoders = []

    for decoder in _decoders:
        if any(filename.endswith(extension) for extension in decoder.get_extensions()):
            available_decoders.append(decoder)

    return available_decoders

def get_encoders(filename = None):
    if not filename:
        return _encoders

    available_encoders = []

    for encoder in _encoders:
        if any(filename.endswith(extension) for extension in decoder.get_extensions()):
            available_encoders.append(encoder)

    return available_encoders

def _add_default_codecs():
    try:
        from pygrafix.image.codecs import stb_image
        add_decoder(stb_image.StbImageDecoder())
        add_encoder(stb_image.StbImageEncoder())
    except ImportError:
        pass

    try:
        from pygrafix.image.codecs import pil
        add_decoder(pil.PilImageDecoder())
    except ImportError:
        pass
