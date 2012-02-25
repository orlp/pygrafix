:mod:`pygrafix.image.codecs` --- Managing codecs
================================================

.. module:: pygrafix.image.codecs
    :synopsis: Functions for registering and using codecs.

This module is used for managing codecs to be used by pygrafix. pygrafix supports a few formats out of the box, but by adding image codecs it's possible to add more codecs for any format.

.. exception:: ImageDecodeException

    The error raised when decoding an image fails.

.. exception:: ImageEncodeException

    The error raised when encoding an image fails.

.. function:: get_decoders([filename])

    Return all decoders that could possibly decode the format described by the extension of *filename*. If *filename* is not given it returns all decoders.

.. function:: get_encoders([filename])

    Return all encoders that can encode the format described by the extension of *filename*. If *filename* is not given it returns all encoders.

.. function:: add_decoder(decoder)

    Adds *decoder* to pygrafix. A decoder must support two methods: ``get_extensions()`` and ``decode(file, filename)``.

    ``get_extensions()`` must return an iterable of extensions the decoder can decode, for example:

    .. code-block:: python

        def get_extensions(self):
            return (".bmp", ".png")

    ``decode(file, filename)`` must attempt to decode the file object *file*. *filename* is a hint regarding the containing file type (which can be a full filename or just the extension). If, for any reason, the decoder is not able to decode *file* it must raise :exc:`ImageDecodeException`. If it succeeds it must return an :class:`~pygrafix.image.ImageData` object containing the decoded data.

.. function:: add_encoder(encoder)

    Adds *encoder* to pygrafix. An encoder must support two methods: ``get_extensions()`` and ``encode(imgdata, file, filename)``.

    ``get_extensions()`` must return an iterable of extensions the encoder can encode, for example:

        def get_extensions(self):
            return (".bmp", ".png")

    ``encode(imgdata, file, filename)`` must encode the data found in *imgdata* into the file object *file*. *filename* is a hint into which file type the data must be encoded (which can be a string containing the full filename or just the extension). *imgdata* is passed as an :class:`~pygrafix.image.ImageData` object.
