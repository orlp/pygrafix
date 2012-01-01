CC=gcc
CYTHON=python C:\Python27\Scripts\cython.py

CFLAGS=-O3 -Wall -Wno-unused-but-set-variable -Wno-strict-aliasing -IC:\Python27\include -Ipygrafix/c_headers
LIBS=-s -LC:\Python27\libs -lpython27

.PHONY: all

all: pygrafix/sprite.pyd pygrafix/window/_window.pyd pygrafix/image/codecs/stb_image.pyd pygrafix/image/_image.pyd

pygrafix/window/_window.pyd: pygrafix/window/_window.pyx pygrafix/c_headers/glfw.pxd pygrafix/c_headers/glfw_include.h
	${CYTHON} -o pygrafix/window/_window.cy.c pygrafix/window/_window.pyx
	${CC} ${CFLAGS} -c -o pygrafix/window/_window.cy.o pygrafix/window/_window.cy.c
	${CC} ${CFLAGS} -shared -o pygrafix/window/_window.pyd pygrafix/window/_window.cy.o ${LIBS} -lglfw -lopengl32

pygrafix/image/_image.pyd: pygrafix/image/_image.pyx pygrafix/c_headers/stb_image.pxd pygrafix/c_headers/stb_image_include.h
	${CYTHON} -o pygrafix/image/_image.cy.c pygrafix/image/_image.pyx
	${CC} ${CFLAGS} -c -o pygrafix/image/_image.cy.o pygrafix/image/_image.cy.c
	${CC} ${CFLAGS} -shared -o pygrafix/image/_image.pyd pygrafix/image/_image.cy.o ${LIBS} -lopengl32

pygrafix/image/codecs/stb_image.pyd: pygrafix/image/codecs/stb_image.pyx pygrafix/c_headers/stb_image.pxd pygrafix/c_headers/stb_image_include.h
	${CC} ${CFLAGS} -c -o libs/stb_image/stb_image.o libs/stb_image/stb_image.c
	${CYTHON} -o pygrafix/image/codecs/stb_image.cy.c pygrafix/image/codecs/stb_image.pyx
	${CC} ${CFLAGS} -c -o pygrafix/image/codecs/stb_image.cy.o pygrafix/image/codecs/stb_image.cy.c
	${CC} ${CFLAGS} -shared -o pygrafix/image/codecs/stb_image.pyd pygrafix/image/codecs/stb_image.cy.o libs/stb_image/stb_image.o ${LIBS}

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

	copy glfw.pyd dist > nul
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
