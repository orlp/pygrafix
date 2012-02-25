import Image as PILImage

from pygrafix.image import ImageData
from pygrafix.image.codecs import ImageDecodeException

class PilImageDecoder:
    def get_extensions(self):
        return (".bmp", ".cur", ".gif", ".ico", ".jpg" , ".jpeg", ".pcx", ".png", ".tga", ".tif", ".tiff", ".xbm", ".xpm")

    def decode(self, file, filename):
        try:
            image = PILImage.open(file)
        except Exception, e:
            raise ImageDecodeException("PIL cannot read %r: %s" % (filename or file, e))

        # image = image.transpose(PILImage.FLIP_TOP_BOTTOM)

        # Convert bitmap and palette images to component
        if image.mode in ("1", "P"):
            image = image.convert()

        if image.mode.lower() not in ("l", "la", "rgb", "rgba"):
            raise ImageDecodeException("Unsupported mode \"%s\"" % image.mode.lower())

        width, height = image.size

        return ImageData(width, height, image.mode.lower(), bytes(image.tostring()))
