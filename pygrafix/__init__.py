import pygrafix.resource
import pygrafix.window
import pygrafix.window.key
import pygrafix.window.mouse
import pygrafix.image
import pygrafix.image.codecs
import pygrafix.sprite
import pygrafix.draw

_version = (0, 0, 0)

def get_version():
    """Returns the current pygrafix version in the format (major, minor, revision)."""

    return _version

__all__ = ["get_version"]
