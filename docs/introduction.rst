Introduction
============

This is a short introduction to pygrafix.

Why this project?
-----------------
There are two major game/graphics libraries for Python out there, Pygame
and Pyglet. Pygame is built ontop of the SDL library and is very mature.
It however lacks a clean interface and has serious performance issues
if you aren't very careful about using it (and even then some things are plain impossible).
It also has some great parts, mostly the non-graphics modules are quite good.
Then there is pyglet, a pure-python approach to graphics. It is very promising
and has a much cleaner API but uses an awkward bottom-left coordinate system.
It is also written in pure Python code with ctypes, which means potential performance
issues can lie below the surface due to the amount of wrapping going on. This project
tries to combine the great parts of both (and other) libraries while removing
the awkwardness.

Why Cython?
-----------
Cython allows the rapid development of Python to be combined with the speed of C.
It is also very easy to wrap C libraries with, resulting in great performance too.
Since I already decided parts of the library will be in C Cython has no portability
drawbacks of some kind. It will run on any system capable of running Python, and
produce portable C code. If necesarry you could even ship the C code produced by Cython;
this means your code base is completely portable, even for people that can't/don't want
to install Cython. This way they will only need Python and a C compiler (you will most
likely be shipping binaries to your end users removing the need of the C
compiler too).

On what external libraries does pygrafix rely?
----------------------------------------------
pygrafix currently relies on GLFW for windowing, OpenGL for graphics rendering,
GLEW for more OpenGL functionality and stb_image for image writing/reading. GLFW
and stb_image are shipped with the source of pygrafix, GLEW and OpenGL are not.
To compile you need the developer 32-bit version of Python, a C compiler, CMake
and Cython installed.

What are the core design goals?
-------------------------------
 - Opening and using windows and recieving input
 - Loading common image formats into textures
 - Loading and using fonts
 - A fast 2D sprite system supporting many transformations.
 - Providing clear, fast and object-oriented interfaces to all features
 - Loading and playing back sound

What other features might get added?
------------------------------------
 - Particle systems
 - Offscreen rendering targets
 - (2D) game specific high-performance modules (fast collision, vector, etc)

What features will not get added?
---------------------------------
 - Networking
 - Game-engine specific stuff
 - 3D functionality
