pygrafix is a Python/Cython hardware-accelerated 2D graphics library.

Why this project?
There are two major game/graphics libraries for Python out there, Pygame
and Pyglet. Pygame is built ontop of the SDL library and is very mature.
It however lacks (IMO) a clean interface and has serious performance issues
if you aren't very careful about using it. It also has some great parts,
mostly the non-graphics modules are quite good. Then there is pyglet, a
pure-python approach to graphics. It is very promising and has a much cleaner
API but uses an awkward bottom-left coordinate system. It is also written
in pure Python code with ctypes, which means potential performance issues
can lie below the surface due to the amount of wrapping going on. This project
tries to combine the great parts of both (and other) libraries while removing
the awkwardness.

Why Cython?
Cython allows the rapid development of Python (C modules ugh) to be combined
with the speed of C. It is also very easy to wrap C libraries with, resulting
in great performance too. Since I already decided parts of the library will
be in C Cython has no portability drawbacks of some kind. It will run on
any system capable of running Python, and produce portable C code. If necesarry
you could even ship the C code produced by Cython; this means your code base
is completely portable, even for people that can't/don't want to install
Cython. This way they will only need Python and a C compiler (you will most
likely be shipping binaries to your end users removing the need of the C
compiler too).

On what external libraries does pygrafix rely?
pygrafix currently relies only on GLFW, a lightweight C library that get
wrapped with Cython. pygrafix also uses stb_image for image loading, but
stb_image is shipped with pygrafix as source.

What are the core design goals?
 - Opening and using a window and recieving input
 - Loading common image formats into textures
 - Loading and using fonts
 - A fast 2D sprite system supporting many transformations.
 - Providing clear, fast and object-oriented interfaces to all features

What other features might get added?
 - Loading and playing back sound
 - (2D) game specific high-performance modules (collision, vector, quaternion, etc)
 
Disclaimer:
Large amounts of code and ideas have been... lent from other projects. Keeping
all copyright notices in the code would be unpractical, thus I have created
a directoy called "licenses". All copyright owners will get a place in this
folder, either by their own or their project's name. Also pygrafix's license can
be found there.