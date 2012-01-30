:mod:`pygrafix.draw` --- Functions for drawing shapes
=====================================================

.. module:: pygrafix.draw
    :synopsis: Functions for efficiently drawing simple shapes.

This module allows you to draw simple shapes like lines and polygons.


.. function:: line(start_point, end_point[, color[, width[, edge_smoothing[, blending]]]])

    This function draws a line between *start_point* and *end_point*. Both points must have the form *(x, y)*. *color* must have the form *(red, green, blue[, alpha])* with all components *0 <= c <= 1*. *blending* can be any of *"add"*, *"multiply"*, *"mix"* or *None*.

    The defaults are an opaque white line, 1 pixel wide, with no smoothing and mix blending.


.. function:: polygon(vertices[, color[, edge_smoothing[, blending]]])

    This function draws a polygon with the given vertices. *vertices* must be a list of *(x, y)* tuples. At least 3 vertices must be given. *color* must have the form *(red, green, blue[, alpha])* with all components *0 <= c <= 1*. *blending* can be any of *"add"*, *"multiply"*, *"mix"* or *None*.

    The defaults are an opaque white polygon, with no smoothing and mix blending.


.. function:: polygon_outline(vertices[, color[, width[, edge_smoothing[, blending]]]])

    This function draws the outline of a polygon with the given vertices. *vertices* should be a list of *(x, y)* tuples. At least 3 vertices must be given. *color* must have the form *(red, green, blue[, alpha])* with all components *0 <= c <= 1*. *blending* can be any of *"add"*, *"multiply"*, *"mix"* or *None*.

    The defaults are an opaque white 1 pixel outline, with no smoothing and mix blending.
