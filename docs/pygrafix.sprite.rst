:mod:`pygrafix.sprite` --- Fast sprites
=======================================

.. module:: pygrafix.sprite
    :synopsis: Fast sprite implementation.

This module gives you fast sprites that can be moved, rotated, scaled and colored.

.. class:: Sprite(texture)

    Creates a new sprite with the texture *texture*. This is the core rendering functionality of pygrafix. A sprite can be moved, rotated (around a point within the sprite), scaled (with different scales for x and y), flipped and colored. All of this only affects the sprite, not the texture that it uses. Multiple sprites can be created off of one texture.

    .. attribute: x
    .. attribute: y

        The horizontal and vertical position of the sprite.

    .. attribute: position

        A property which can be used for reading/modifying *x* and *y* at the same time. For example:

            >>> print(sprite.x, sprite.y, sprite.position)
            5, 10, (5, 10)
            >>> sprite.position = (60, 7)
            >>> print(sprite.x, sprite.y, sprite.position)
            60, 7, (60, 7)

    .. attribute:: anchor_x

        The anchor of a sprite is used to determine how to place a sprite, even when scaled and rotated. The anchor of a sprite also rotates and scales with the sprite. Finally when a sprite is rendered pygrafix makes sure that the anchor point of the sprite always lies on the sprites' *position*.

        This might be hard to understand at first, but for example this means that
