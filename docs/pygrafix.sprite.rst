:mod:`pygrafix.sprite` --- Fast sprites
=======================================

.. module:: pygrafix.sprite
    :synopsis: Fast sprite implementation.

This module gives you fast sprites that can be moved, rotated, scaled and colored.

.. class:: Sprite(texture)

    Creates a new sprite with the texture *texture*. This is the core rendering functionality of pygrafix. A sprite can be moved, rotated (around a point within the sprite), scaled (with different scales for x and y), flipped and colored. All of this only affects the sprite, not the texture that it uses. Multiple sprites can be created off of one texture.

    .. attribute:: x

        The horizontal position of the sprite.

    .. attribute:: y

        The vertical position of the sprite.

    .. attribute:: position

        A property which can be used for reading/modifying *x* and *y* at the same time. For example::

            >>> print(sprite.x, sprite.y, sprite.position)
            5, 10, (5, 10)
            >>> sprite.position = (60, 7)
            >>> print(sprite.x, sprite.y, sprite.position)
            60, 7, (60, 7)

    .. attribute:: anchor_x

        The horizontal position of the sprites' anchor.

    .. attribute:: anchor_y

        The vertical position of the sprites' anchor.

    .. attribute:: anchor

        A shorthand for assigning to *anchor_x* and *anchor_y* at the same time.

        The anchor of a sprite is used to determine how to place a sprite, even when scaled and rotated. The anchor of a sprite also rotates and scales with the sprite. Finally when a sprite is rendered pygrafix makes sure that the anchor point of the sprite always lies on the sprites' *position*.

    .. attribute:: width

        Shorthand for ``sprite.texture.width``. Read-only.

    .. attribute:: height

        Shorthand for ``sprite.texture.height``. Read-only.

    .. attribute:: size

        Shorthand for ``(sprite.width, sprite.height).`` Read-only.

    .. function:: draw([scale_smoothing[, edge_smoothing[, blending]]])

        Draws the sprite as defined by it's properties. *scale_smoothing* is a boolean indicating whether the sprite should be drawn nicely smoothed when scaled or pixelated. *blending* can be any of "add", "multiply" and "mix", or None to disable blending.

.. function:: draw_batch(sprites[, preserve_order[, scale_smoothing[, edge_smoothing[, blending]]]])

    Draws a list of sprites in one go. This is the main rendering function of pygrafix, and depending on the application this function will do the most work. This function draws each sprite in *sprite* with the attributes *scale_smoothing*, *edge_smoothing* and *blending* as describute in :meth:`Sprite.draw`.

    This function is the most efficient when a lot of sprites use the same :class:`~pygrafix.image.InternalTexture` and sprites with the same texture are grouped together. By default no particular order of drawing is guaranteed by this function, for speed purposes sprites are sorted on texture. If you absolutely need a specific order of drawing, pass True to *preserve_order* (by default it's False) or consider slicing up your drawing in smaller batches.
