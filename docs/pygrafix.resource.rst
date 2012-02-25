:mod:`pygrafix.resource` --- Managing resource locations
========================================================

.. module:: pygrafix.resource
    :synopsis: Functions for finding resources.

This module is used for managing resource locations from which pygrafix can load resources.

.. function:: add_location(location)

    Adds a resource location to pygrafix. These resource locations are used in the functions :func:`get_path`, :func:`get_file`, :func:`get_location` and :func:`exists` as well as other resource loading functions throughout pygrafix (for example :func:`pygrafix.image.load`).

    The *location* variable can be a string containing a path, a string containing the path to a zipfile as well as a custom object.

    If a custom object is passed it must support at least the following methods::

        class CustomLocation:
            # tries to open filename in this location with the correct mode
            # if for any reason this fails or the resource is not found raise IOError
            def open(self, filename, mode = "rb"):
                pass

            # return True if filename exists in this location, otherwise False
            def isfile(self, filename):
                pass

            # return an absolute path to filename in this location, whether it exists or not
            # if absolute paths are not applicable return anything you find appropriate, but don't raise an exception
            def getpath(self, filename):
                pass

.. function:: get_path(resource)

    *resource* is a string containing the filename of a resource. This function will look through all resource locations and return an absolute path to the resource. :exc:`IOError` is raised if the resource was not found.

    Note: an absolute path is not always available/appropriate, for example a path into a zipfile. Use this function for printing purposes only, or with care.

.. function:: get_file(resource)

    *resource* is a string containing the filename of a resource. This function will look through all resource locations for the file and return a file object opened in binary reading mode. :exc:`IOError` is raised if the resource was not found.

.. function:: get_location(resource)

    *resource* is a string containing the filename of a resource. This function will look through all resource locations for the resource, and if it's found the function will return the containing location.

.. function:: exists(resource)

    *resource* is a string containing the filename of a resource. This function will look through all resource locations and return True if the resource exists, otherwise False.

.. function:: get_script_home()

    Returns a string containing the directory of the program entry module.

    For ordinary Python scripts, this is the directory containing the __main__ module. For executables created with py2exe the result is the directory containing the running executable file. For OS X bundles created using Py2App the result is the Resources directory within the running bundle.

    If none of the above cases apply and the file for ``__main__`` cannot be determined the working directory is returned.

.. function:: get_settings_path(name)

    Returns a string containing a directory to save user preferences.

    Different platforms have different conventions for where to save user preferences, saved games, and settings. This function implements those conventions. Note that the returned path may not exist: applications should use :func:`os.makedirs` to construct it if desired.

    On Linux, a hidden directory :file:`{name}` in the user's home directory is returned.

    On Windows (including under Cygwin) the :file:`{name}` directory in the user's :file:`Application Settings` directory is returned.

    On Mac OS X the :file:`{name}` directory under :file:`~/Library/Application Support` is returned.
