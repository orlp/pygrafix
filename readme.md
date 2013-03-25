###This project is abandoned, my suggestion is to use the Allegro game library instead - it's very high quality.

pygrafix is a Python/Cython hardware-accelerated 2D graphics library.

Why this project?
-----------------
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
-----------
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
----------------------------------------------
pygrafix currently relies only on GLFW, a lightweight C library that get
wrapped with Cython. pygrafix also uses stb_image for image loading. Both
are shipped with the source of pygrafix. To compile you need the developer
32-bit version of Python, a C compiler, CMake and Cython installed.

What are the core design goals?
-------------------------------
 - Opening and using a window and recieving input
 - Loading common image formats into textures
 - Loading and using fonts
 - A fast 2D sprite system supporting many transformations.
 - Providing clear, fast and object-oriented interfaces to all features

What other features might get added?
 - Loading and playing back sound
 - (2D) game specific high-performance modules (collision, vector, quaternion, etc)

Downloads
---------

The latest version, compiled for windows can be found here: https://github.com/nightcracker/pygrafix/downloads

Compiling on Linux
------------------
First you need to install the required software if you don't have it yet. If you
don't have CMake yet (though that's unlikely) get it:

    $ sudo apt-get install cmake

Now we need Cython. Cython can be downloaded from the repos but often is outdated.
So download it from http://www.cython.org/ and build it from source (very easy).

Now we need to compile pygrafix itself.

First you need to compile GLFW 3. You do this by going into the libs/glfw directory
and make a new directory "build". cd into the directory and call cmake on the above
directory. After that you want to call make (BUT NOT make install).

    $ mkdir libs/glfw/build
    $ cd libs/glfw/build
    $ cmake ..
    $ make

After it's done go back to the top directory of pygrafix and invoke the build script:

    $ cd ../../..
    $ sudo python setup.py install

You're done!

Compiling on Windows
--------------------
Windows doesn't come with a C compiler, so I recommend installing GCC. This can be
done by installing MinGW through TDM-GCC (http://tdm-gcc.tdragon.net/). Make sure
to get the 32-bit version, just like Python.

You'll also need CMake, so get it from http://www.cmake.org/ (win32 installer).
The same goes for Cython, get it from http://www.cython.org/ (win32 installer)

First we need to compile GLFW:

    > mkdir libs\glfw\build
    > cd libs\glfw\build
    > cmake -G "MinGW Makefiles" ..
    > make

And then pygrafix itself:

    > cd ..\..\..
    > python setup.py build --compiler=mingw32
    > python setup.py install

It might be possible that you get an error about "-mno-cygwin". In order to fix this
you must go to your python install folder, find a file named "distutils.py" and
remove all occurences of "-mno-cygwin". There sadly is no other way.

Another thing, CMake might be giving you an error that it can not find a working GCC.
I fixed this problem by opening my MinGW install directory and copy bin\make.exe to
bin\mingw32-make.exe.

Disclaimer
----------
Large amounts of code and ideas have been... lent from other projects. Keeping
all copyright notices in the code would be unpractical, thus I have created
a directoy called "licenses". All copyright owners will get a place in this
folder, either by their own or their project's name. Also pygrafix's license can
be found there.
