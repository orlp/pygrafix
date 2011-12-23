# almost directly taken from pyglet

class Config:
    _attribute_names = [
        "aux_buffers",
        "samples",
        "buffer_size",
        "depth_size",
        "stencil_size",
        "accum_size",
        "stereo",
    ]

    _defaults = {
        "aux_buffers": 0,
        "samples": 0,
        "buffer_size": (8, 8, 8, 8),
        "depth_size": 24,
        "stencil_size": 0,
        "accum_size": (0, 0, 0, 0),
        "stereo": False,
    }

    def __init__(self, **kwargs):
        # we have to set this directly in the dict because __setattr__ reads _readonly
        # which would lead to an AttributeError (because _readonly isn't set yet)
        self.__dict__["_readonly"] = False

        for name in self._attribute_names:
            if name in kwargs:
                setattr(self, name, kwargs[name])
            else:
                setattr(self, name, self._defaults[name])

    def __setattr__(self, name, value):
        if self._readonly:
            raise AttributeError("This OpenGL config is read only.")

        if (name == "buffer_size" or name == "accum_size") and isinstance(value, int):
            if value == 16: value = (5, 6, 5, 0)
            elif value == 24: value = (8, 8, 8, 0)
            elif value == 32: value = (8, 8, 8, 8)
            elif value == 64: value = (16, 16, 16, 16)

        self.__dict__[name] = value

    def __repr__(self):
        s = "pygrafix.gl.gl.Config(\n"

        for name in self._attribute_names:
            s += "    %s = %s,\n" % (name, repr(getattr(self, name)))

        s += ")"
        return s

    def _make_readonly(self):
        self._readonly = True
