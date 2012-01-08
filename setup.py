from distutils.core import setup
from distutils.extension import Extension
from cython_dist import build_ext

setup(
    cmdclass = {"build_ext": build_ext},
    ext_modules = [
        Extension(
            "pygrafix.sprite", ["pygrafix/sprite.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = ["glew32", "opengl32"],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-s"],
            depends = ["pygrafix/c_headers/glew.pxd", "pygrafix/sprite.pxd", "pygrafix/image/_image.pxd"]
        ),

        Extension("pygrafix.window._window", ["pygrafix/window/_window.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = ["glfw", "opengl32"],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-s"],
            depends = ["pygrafix/c_headers/glew.pxd", "pygrafix/c_headers/glfw.pxd"]
        ),

        Extension("pygrafix.image._image", ["pygrafix/image/_image.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = ["glew32", "opengl32"],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-s"],
            depends = ["pygrafix/c_headers/glew.pxd", "pygrafix/image/_image.pxd"]
        ),

        Extension("pygrafix.image.codecs.stb_image", ["libs/stb_image/stb_image.c", "pygrafix/image/codecs/stb_image.pyx"],
            include_dirs = ["pygrafix/c_headers"],
            libraries = ["glew32", "opengl32"],
            extra_compile_args = ["-Wno-unused-but-set-variable", "-s"],
            depends = ["pygrafix/c_headers/stb_image.pxd"]
        )
    ]
)
