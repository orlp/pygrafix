# exceptions
class FormatNotSupportedError(Exception):
    pass

class ChannelsNotSupportedError(Exception):
    pass

_decoders = []

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

    for decoder in _decoders:
        try:
            return decoder.decode(file, format, request_channels)

        except pygrafix.image.codecs.ChannelsNotSupportedError as e:
            error = e
        except pygrafix.image.codecs.FormatNotSupportedError as e:
            # ChannelsNotSupportedError has precedence over FormatNotSupportedError
            if not isinstance(error, pygrafix.image.codecs.ChannelsNotSupportedError):
                error = e

    raise error

# add default codecs
try:
    from pygrafix.image.codecs import soil
    _decoders.append(soil.SoilImageDecoder())
except ImportError:
    pass
