from distutils.core import setup
from distutils.extension import Extension
from cython_dist import build_ext

import sys, os, fnmatch

if sys.platform == "win32":
    opengl_lib = "opengl32"
    glew_lib = "glew32"
else:
    opengl_lib = "GL"
    glew_lib = "GLEW"

setup(
    name = "pygrafix",
    description = "pygrafix is a Python/Cython hardware-accelerated 2D graphics library.",
    version = "0.0",
    author = "Orson Peters",
    author_email = "nightcracker@nclabs.org",
    url = "https://github.com/nightcracker/pygrafix",
    cmdclass = {"build_ext": build_ext},
    packages = [
        "pygrafix",
        "pygrafix.window",
        "pygrafix.image",
        "pygrafix.image.codecs",
    ],
    ext_modules = [
        Extension(
            "pygrafix.sprite", ["pygrafix/sprite.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = [glew_lib, opengl_lib],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-Wno-strict-aliasing", "-O2"],
            extra_link_args = ["-s"],
            depends = ["pygrafix/c_headers/glew.pxd", "pygrafix/sprite.pxd", "pygrafix/image/_image.pxd"]
        ),

        Extension(
            "pygrafix.draw", ["pygrafix/draw.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = [glew_lib, opengl_lib],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-Wno-strict-aliasing", "-O2"],
            extra_link_args = ["-s"],
            depends = ["pygrafix/c_headers/glew.pxd"]
        ),

        Extension("pygrafix.window._window", ["pygrafix/window/_window.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = [glew_lib, opengl_lib],
            extra_objects = ["libs/glfw/build/src/libglfw.a"],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-Wno-strict-aliasing", "-O2"],
            extra_link_args = ["-s"],
            depends = ["pygrafix/c_headers/glew.pxd", "pygrafix/c_headers/glfw.pxd"]
        ),

        Extension("pygrafix.image._image", ["pygrafix/image/_image.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = [glew_lib, opengl_lib],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-Wno-strict-aliasing", "-O2"],
            extra_link_args = ["-s"],
            depends = ["pygrafix/c_headers/glew.pxd", "pygrafix/image/_image.pxd"]
        ),

        Extension("pygrafix.image.codecs.stb_image", ["libs/stb_image/stb_image.c", "libs/stb_image/stb_image_write.c", "pygrafix/image/codecs/stb_image.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = [glew_lib, opengl_lib],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-Wno-strict-aliasing", "-O2"],
            extra_link_args = ["-s"],
            depends = ["pygrafix/c_headers/stb_image.pxd"]
        )
    ]
)

# if we are cleaning, clean the .cy.c scripts too
if "clean" in sys.argv:
    matches = []
    for root, dirnames, filenames in os.walk("."):
        for filename in fnmatch.filter(filenames, "*.cy.c") + fnmatch.filter(filenames, "*.pyc"):
            matches.append(os.path.join(root, filename))

    for filename in matches:
        print("removing '%s'" % filename)
        os.remove(filename)
