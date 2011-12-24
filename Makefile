CC=gcc
CYTHON=python C:\Python27\Scripts\cython.py

CFLAGS=-O3 -Wall -Wno-unused-but-set-variable -Wno-strict-aliasing -IC:\Python27\include -Ipygrafix/c_headers -DGLFW_DLL
LIBS=-s -LC:\Python27\libs -lpython27

.PHONY: all

all: pygrafix/_pygrafix.pyd pygrafix/sprite.pyd pygrafix/window/_window.pyd pygrafix/gl/texture.pyd pygrafix/image/codecs/soil.pyd

pygrafix/_pygrafix.pyd: pygrafix/_pygrafix.pyx pygrafix/c_headers/glfw.pxd pygrafix/c_headers/glfw_include.h
	${CYTHON} -o pygrafix/_pygrafix.cy.c pygrafix/_pygrafix.pyx
	${CC} ${CFLAGS} -c -o pygrafix/_pygrafix.cy.o pygrafix/_pygrafix.cy.c
	${CC} ${CFLAGS} -shared -o pygrafix/_pygrafix.pyd pygrafix/_pygrafix.cy.o ${LIBS} -lglfwdll

pygrafix/window/_window.pyd: pygrafix/window/_window.pyx pygrafix/c_headers/glfw.pxd pygrafix/c_headers/glfw_include.h
	${CYTHON} -o pygrafix/window/_window.cy.c pygrafix/window/_window.pyx
	${CC} ${CFLAGS} -c -o pygrafix/window/_window.cy.o pygrafix/window/_window.cy.c
	${CC} ${CFLAGS} -shared -o pygrafix/window/_window.pyd pygrafix/window/_window.cy.o ${LIBS} -lglfwdll -lopengl32

pygrafix/gl/texture.pyd: pygrafix/gl/texture.pyx pygrafix/c_headers/gl.pxd pygrafix/c_headers/gl_include.h
	${CYTHON} -o pygrafix/gl/texture.cy.c pygrafix/gl/texture.pyx
	${CC} ${CFLAGS} -c -o pygrafix/gl/texture.cy.o pygrafix/gl/texture.cy.c
	${CC} ${CFLAGS} -shared -o pygrafix/gl/texture.pyd pygrafix/gl/texture.cy.o ${LIBS} -lsoil -lopengl32

pygrafix/image/codecs/soil.pyd: pygrafix/image/codecs/soil.pyx pygrafix/c_headers/soil.pxd pygrafix/c_headers/soil_include.h
	${CYTHON} -o pygrafix/image/codecs/soil.cy.c pygrafix/image/codecs/soil.pyx
	${CC} ${CFLAGS} -c -o pygrafix/image/codecs/soil.cy.o pygrafix/image/codecs/soil.cy.c
	${CC} ${CFLAGS} -shared -o pygrafix/image/codecs/soil.pyd pygrafix/image/codecs/soil.cy.o ${LIBS} -lsoil -lopengl32

pygrafix/sprite.pyd: pygrafix/sprite.pyx pygrafix/c_headers/gl.pxd pygrafix/c_headers/gl_include.h
	${CYTHON} -o pygrafix/sprite.cy.c pygrafix/sprite.pyx
	${CC} ${CFLAGS} -c -o pygrafix/sprite.cy.o pygrafix/sprite.cy.c
	${CC} ${CFLAGS} -shared -o pygrafix/sprite.pyd pygrafix/sprite.cy.o ${LIBS} -lopengl32


dist: all
	if EXIST dist (rmdir /S /Q dist > nul)
	mkdir dist > nul
	mkdir dist\pygrafix > nul
	mkdir dist\pygrafix\window > nul
	mkdir dist\pygrafix\gl > nul

	copy glfw.dll dist > nul
	copy pygrafix\__init__.py dist\pygrafix > nul
	copy pygrafix\window\__init__.py dist\pygrafix\window > nul
	copy pygrafix\gl\__init__.py dist\pygrafix\gl > nul

	copy pygrafix\window\key.py dist\pygrafix\window > nul
	copy pygrafix\window\mouse.py dist\pygrafix\window > nul
	copy pygrafix\window\window.pyd dist\pygrafix\window > nul

	copy pygrafix\gl\gl.pyd dist\pygrafix\gl
	copy pygrafix\gl\texture.pyd dist\pygrafix\gl

test:
	python test.py

clean:
	del /S /Q *.o > nul
	del /S /Q *.cy.c > nul
	del /S /Q *.pyc > nul
	del /S /Q *.pyo > nul

purge: clean
	del /S /Q *.pyd > nul
	rmdir /S /Q dist > nul
