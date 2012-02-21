import os
import sys
import zipfile

_resource_locations = []

# location types

class FolderLocation:
    def __init__(self, path):
        self.path = os.path.abspath(path)

    def open(self, filename, mode = "rb"):
        return open(self.getpath(filename), mode)

    def isfile(self, filename):
        return os.path.isfile(self.getpath(filename))

    def getpath(self, filename):
        return os.path.join(self.path, filename)


class ZipLocation:
    def __init__(self, path):
        self.path = os.path.abspath(path)

    # on a zip location we don't support modes, ignore
    def open(self, filename, mode = "rb"):
        try:
            zip = zipfile.ZipFile(self.path, "r")

            return zip.open(filename)
        except IndexError:
            raise IOError("File not found in zip.")

    def isfile(self, filename):
        zip = zipfile.ZipFile(self.path, "r")

        try:
            zip.getinfo(filename)
            return True
        except KeyError:
            return False

    # file path on zip files is a bit silly, but ok
    def getpath(self, filename):
        return os.join(self.path, filename)

def get_script_home():
    frozen = getattr(sys, "frozen", None)

    if frozen in ("windows_exe", "console_exe"):
        return os.path.dirname(sys.executable)
    elif frozen == "macosx_app":
        return os.environ["RESOURCEPATH"]
    else:
        main = sys.modules["__main__"]
        if hasattr(main, "__file__"):
            return os.path.dirname(main.__file__)

    # probably interactive
    return ""


def get_settings_path(name):
    if sys.platform in ("cygwin", "win32"):
        if "APPDATA" in os.environ:
            return os.path.join(os.environ["APPDATA"], name)
        else:
            return os.path.expanduser("~/%s" % name)
    elif sys.platform == "darwin":
        return os.path.expanduser("~/Library/Application Support/%s" % name)
    else:
        return os.path.expanduser("~/.%s" % name)


def add_location(location):
    # zipfile?
    if os.path.isfile(location) and zipfile.is_zipfile(location):
        _resource_locations.append(ZipLocation(location))
    # folder?
    elif os.path.isdir(location):
        _resource_locations.append(FolderLocation(location))
    # ???
    else:
        raise Exception("Unknown location %s" % str(location))

def add_custom_location(location):
    _resource_locations.append(location)

def get_path(resource):
    # we look for resources FIRST in the added resource paths, then in the working directory
    for location in _resource_locations + [FolderLocation(".")]:
        if location.isfile(resource):
            return location.getpath(resource)

    raise IOError("Resource %s is not found." % resource)

def get_file(resource, mode = "rb"):
    # we look for resources FIRST in the added resource paths, then in the zipfiles and finally in the working directory
    for location in _resource_locations + [FolderLocation(".")]:
        if location.isfile(resource):
            return location.open(resource, mode)

    raise IOError("Resource %s is not found." % resource)

def get_location(resource):
    for location in _resource_locations + [FolderLocation(".")]:
        if location.isfile(resource):
            return location


def exists(resource):
    for location in _resource_locations + [FolderLocation(".")]:
        if location.isfile(resource):
            return True

    return False
