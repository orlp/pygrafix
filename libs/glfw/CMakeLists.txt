project(GLFW C)

cmake_minimum_required(VERSION 2.4)
cmake_policy(VERSION 2.4)

set(GLFW_VERSION_MAJOR "3")
set(GLFW_VERSION_MINOR "0")
set(GLFW_VERSION_PATCH "0")
set(GLFW_VERSION_EXTRA "")
set(GLFW_VERSION "${GLFW_VERSION_MAJOR}.${GLFW_VERSION_MINOR}")
set(GLFW_VERSION_FULL "${GLFW_VERSION}.${GLFW_VERSION_PATCH}${GLFW_VERSION_EXTRA}")

find_package(OpenGL REQUIRED)

#--------------------------------------------------------------------
# Set up GLFW for Win32 and WGL on Windows
#--------------------------------------------------------------------
if (WIN32)
    message(STATUS "Building GLFW for WGL on a Win32 system") 

    # Define the platform identifier
    set(_GLFW_WIN32_WGL 1)

    # Set up library and include paths
    list(APPEND GLFW_INCLUDE_DIR ${OPENGL_INCLUDE_DIR})
    list(APPEND GLFW_LIBRARIES ${OPENGL_gl_LIBRARY})
endif (WIN32)

#--------------------------------------------------------------------
# Set up GLFW for Xlib and GLX on Unix-like systems with X Windows
#--------------------------------------------------------------------
if (UNIX AND NOT APPLE)
    message(STATUS "Building GLFW for X11 and GLX on a Unix-like system")

    # Define the platform identifier
    set(_GLFW_X11_GLX 1)

    # Set up library and include paths
    list(APPEND GLFW_INCLUDE_DIR ${X11_X11_INCLUDE_PATH} ${OPENGL_INCLUDE_DIR})
    list(APPEND GLFW_LIBRARIES ${X11_X11_LIB} ${OPENGL_gl_LIBRARY})

    find_library(MATH_LIBRARY m)
    if (MATH_LIBRARY)
        list(APPEND GLFW_LIBRARIES ${MATH_LIBRARY})
    endif(MATH_LIBRARY)

    find_library(RT_LIBRARY rt)
    if (RT_LIBRARY)
        list(APPEND GLFW_LIBRARIES ${RT_LIBRARY})
    endif(RT_LIBRARY)

    include(CheckFunctionExists)
    include(CheckSymbolExists)

    include(${GLFW_SOURCE_DIR}/CMake/CheckX11Extensions.cmake)
    set(CMAKE_REQUIRED_LIBRARIES ${GLFW_LIBRARIES})
    
    # Check for XRandR (modern resolution switching extension)
    check_x11_xrandr()
    if (X11_XRANDR_FOUND)
        set(_GLFW_HAS_XRANDR 1) 
        list(APPEND GLFW_INCLUDE_DIR ${X11_XRANDR_INCLUDE_DIR})
        list(APPEND GLFW_LIBRARIES ${X11_XRANDR_LIBRARIES})
    endif(X11_XRANDR_FOUND)

    # Check for Xf86VidMode (fallback legacy resolution switching extension)
    check_x11_xf86vidmode()
    if (X11_XF86VIDMODE_FOUND)
        set(_GLFW_HAS_XF86VIDMODE 1)
        list(APPEND GLFW_INCLUDE_DIR ${X11_XF86VIDMODE_INCLUDE_DIR})
        list(APPEND GLFW_LIBRARIES ${X11_XF86VIDMODE_LIBRARIES})
    endif(X11_XF86VIDMODE_FOUND) 

    # Check for Xkb (X keyboard extension)
    check_function_exists(XkbQueryExtension _GLFW_HAS_XKB)

    # Check for glXGetProcAddress
    check_function_exists(glXGetProcAddress _GLFW_HAS_GLXGETPROCADDRESS)

    if (NOT _GLFW_HAS_GLXGETPROCADDRESS)
        check_function_exists(glXGetProcAddressARB _GLFW_HAS_GLXGETPROCADDRESSARB)
    endif (NOT _GLFW_HAS_GLXGETPROCADDRESS)

    if (NOT _GLFW_HAS_GLXGETPROCADDRESS AND NOT _GLFW_HAS_GLXGETPROCADDRESSARB)
        check_function_exists(glXGetProcAddressEXT _GLFW_HAS_GLXGETPROCADDRESSEXT)
    endif (NOT _GLFW_HAS_GLXGETPROCADDRESS AND NOT _GLFW_HAS_GLXGETPROCADDRESSARB)

    if (NOT _GLFW_HAS_GLXGETPROCADDRESS AND
        NOT _GLFW_HAS_GLXGETPROCADDRESSARB AND
        NOT _GLFW_HAS_GLXGETPROCADDRESSEXT)
        message(WARNING "No glXGetProcAddressXXX variant found")
    endif (NOT _GLFW_HAS_GLXGETPROCADDRESS AND
           NOT _GLFW_HAS_GLXGETPROCADDRESSARB AND
           NOT _GLFW_HAS_GLXGETPROCADDRESSEXT)

    if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
        set(_GLFW_USE_LINUX_JOYSTICKS 1)
    endif (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
endif(UNIX AND NOT APPLE)

#--------------------------------------------------------------------
# Set up GLFW for Cocoa and NSOpenGL on Mac OS X
#--------------------------------------------------------------------
if (UNIX AND APPLE)
    message(STATUS "Building GLFW for Cocoa and NSOpenGL on Mac OS X")
        
    # Define the platform identifier
    set(_GLFW_COCOA_NSGL 1)

    option(GLFW_BUILD_UNIVERSAL "Build the GLFW library and examples as Universal Binaries" FALSE)

    # Universal build
    if (GLFW_BUILD_UNIVERSAL)
        message(STATUS "Building GLFW as Universal Binaries")
        set(CMAKE_OSX_ARCHITECTURES ppc;i386;ppc64;x86_64)
        set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk)
        set(CMAKE_C_FLAGS "-mmacosx-version-min=10.5") 
    else(GLFW_BUILD_UNIVERSAL)
        message(STATUS "Building GLFW only for the native architecture")
    endif(GLFW_BUILD_UNIVERSAL)
    
    # Set up library and include paths
    find_library(COCOA_FRAMEWORK Cocoa)
    find_library(IOKIT_FRAMEWORK IOKit)
    find_library(CORE_FOUNDATION_FRAMEWORK CoreFoundation)
    list(APPEND GLFW_LIBRARIES ${COCOA_FRAMEWORK})
    list(APPEND GLFW_LIBRARIES ${OPENGL_gl_LIBRARY})
    list(APPEND GLFW_LIBRARIES ${IOKIT_FRAMEWORK})
    list(APPEND GLFW_LIBRARIES ${CORE_FOUNDATION_FRAMEWORK})
endif(UNIX AND APPLE)

#--------------------------------------------------------------------
# Add subdirectories
#--------------------------------------------------------------------
add_subdirectory(src)

#--------------------------------------------------------------------
# Create shared configuration header
#--------------------------------------------------------------------
configure_file(${GLFW_SOURCE_DIR}/src/config.h.in 
               ${GLFW_BINARY_DIR}/src/config.h @ONLY)

#--------------------------------------------------------------------
# Install standard files 
#--------------------------------------------------------------------

install(DIRECTORY include/GL DESTINATION include 
        FILES_MATCHING PATTERN glfw3.h)

install(FILES COPYING.txt readme.html 
        DESTINATION share/doc/glfw-${GLFW_VERSION_FULL}/)

# The respective port's CMakeLists.txt file installs the library

#--------------------------------------------------------------------
# -- Documentation generation 
#--------------------------------------------------------------------
configure_file("${GLFW_SOURCE_DIR}/docs/Doxyfile.in"
               "${GLFW_BINARY_DIR}/docs/Doxyfile"
               @ONLY)

#--------------------------------------------------------------------
# Uninstall operation
# Don't generate this target if a higher-level project already has
#--------------------------------------------------------------------
if(NOT TARGET uninstall)
    configure_file(${GLFW_SOURCE_DIR}/cmake_uninstall.cmake.in
                   ${GLFW_BINARY_DIR}/cmake_uninstall.cmake IMMEDIATE @ONLY)

    add_custom_target(uninstall
                      ${CMAKE_COMMAND} -P
                      ${GLFW_BINARY_DIR}/cmake_uninstall.cmake)
endif()

