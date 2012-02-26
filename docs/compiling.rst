Compiling
=========

Compiling pygrafix can be pretty hard for a novice, but these instructions should help you on your way.


Compiling on Linux
------------------
First you need to install the required software if you don't have it yet. If you
don't have CMake yet (though that's unlikely) get it::

    $ sudo apt-get install cmake

Now we need Cython. Cython can be downloaded from the repos but often is outdated.
So download it from http://www.cython.org/ and build it from source (very easy).

Now we need to compile pygrafix itself.

First you need to compile GLFW 3. GLFW 3 is currently an unstable branch of GLFW, so it's not
in the repos. This also means that you shouldn't install it. In order to compile GLFW3
you should go into the libs/glfw directory and make a new directory "build".
:command:`cd` into the directory and call :command:`cmake` on the above directory. After that
you want to call :command:`make` (BUT NOT :command:`make install`)::

    $ mkdir libs/glfw/build
    $ cd libs/glfw/build
    $ cmake ..
    $ make

After it's done go back to the top directory of pygrafix and invoke the build script::

    $ cd ../../..
    $ sudo python setup.py install

You're done!

Compiling on Windows
--------------------
Windows doesn't come with a C compiler, so I recommend installing GCC. This can be
done by installing MinGW through TDM-GCC (http://tdm-gcc.tdragon.net/). Make sure
to get the 32-bit version, just like Python.

You'll also need CMake, so get it from http://www.cmake.org/ (win32 installer).
The same goes for Cython, get it from http://www.cython.org/ (win32 installer).

First we need to compile GLFW::

    > mkdir libs\glfw\build
    > cd libs\glfw\build
    > cmake -G "MinGW Makefiles" ..
    > make

And then pygrafix itself::

    > cd ..\..\..
    > python setup.py build --compiler=mingw32
    > python setup.py install

It might be possible that you get an error about "-mno-cygwin". In order to fix this
you must go to your python install folder, find a file named "distutils.py" and
remove all occurences of "-mno-cygwin". There sadly is no other way.

Another thing, CMake might be giving you an error that it can not find a working GCC.
I fixed this problem by opening my MinGW install directory and copy bin\make.exe to
bin\mingw32-make.exe.
