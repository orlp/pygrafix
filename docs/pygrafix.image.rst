:mod:`pygrafix.image` --- Working with image files
==================================================

.. module:: pygrafix.image

This module is used for loading images into a format pygrafix can understand.

.. function:: load(filename[, file[, decoder]])

    Loads an image from a file. If *file* is passed *filename* will be used as a hint for the filetype. Optionally you can specify a *decoder* argument which will be used for decoding the image, for more information about decoders read :mod:`pygrafix.image.codecs`. Returns a :class:`Texture` object.

.. class:: Texture(internal_texture[, region])

    Creates a :class:`Texture` object from an :class:`InternalTexture` object. Normally you shouldn't have to create :class:`Texture` objects yourself, use :func:`load` instead. The optional region argument is the region to use, this defaults to *(0, 0, internal_texture.width, internal_texture.height)*.

    .. attribute:: width

        The width of the texture. Note that when the *region* attribute is set that this will return the width of the region. To get the actual texture width use *internal_texture.width*. Read-only.

    .. attribute:: height

        The height of the texture. Note that when the *region* attribute is set that this will return the height of the region. To get the actual texture width use *internal_texture.height*. Read-only.

    .. attribute:: region

        A tuple in the form *(x, y, width, height)* that describes a region of the internal texture that gets represented by this texture. Read-write.

    .. attribute:: internal_texture

        The internal texture used for this texture. Read-only.

    .. method:: copy([lazycopy])

        Returns a copy of this texture. If *lazycopy* is True this function equals ``texture.get_region(0, 0, texture.width, texture.height)``. *lazycopy* is False by default.

    .. method:: get_region([x[, y[, width[, height]]]])

        Returns a :class:`Texture` object that represents a region of this texture, starting *(x, y)* pixels from the topleft of this texture, spanning *(width, height)* pixels. Any changes to the original texture will be represented in this region too, use ``texture.copy().get_region(...)`` if that's undesired behaviour.

.. class:: InternalTexture(imgdata)

    Creates a :class:`InternalTexture` object from an :class:`ImageData` object. Normally you shouldn't have to create :class:`InternalTexture` objects yourself, use :func:`load` instead.

    .. attribute:: width

        The width of the texture. Read-only.

    .. attribute:: height

        The height of the texture. Read-only.

.. class:: Imagedata(width, height, format, data)

    The format used to represent raw image data. *format* can be any of *"RGBA", "RGB", "LA", "A"*. Data must be :class:`bytes` data given in the format described. Only 8-bit channels are supported.
