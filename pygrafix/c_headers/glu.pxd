cdef extern from "glu_include.h":
    # glu definitions
    int GLU_FALSE
    int GLU_TRUE

    int GLU_VERSION_1_1
    int GLU_VERSION_1_2

    int GLU_VERSION
    int GLU_EXTENSIONS

    int GLU_INVALID_ENUM
    int GLU_INVALID_VALUE
    int GLU_OUT_OF_MEMORY
    int GLU_INVALID_OPERATION

    int GLU_OUTLINE_POLYGON
    int GLU_OUTLINE_PATCH

    int GLU_NURBS_ERROR1
    int GLU_NURBS_ERROR2
    int GLU_NURBS_ERROR3
    int GLU_NURBS_ERROR4
    int GLU_NURBS_ERROR5
    int GLU_NURBS_ERROR6
    int GLU_NURBS_ERROR7
    int GLU_NURBS_ERROR8
    int GLU_NURBS_ERROR9
    int GLU_NURBS_ERROR10
    int GLU_NURBS_ERROR11
    int GLU_NURBS_ERROR12
    int GLU_NURBS_ERROR13
    int GLU_NURBS_ERROR14
    int GLU_NURBS_ERROR15
    int GLU_NURBS_ERROR16
    int GLU_NURBS_ERROR17
    int GLU_NURBS_ERROR18
    int GLU_NURBS_ERROR19
    int GLU_NURBS_ERROR20
    int GLU_NURBS_ERROR21
    int GLU_NURBS_ERROR22
    int GLU_NURBS_ERROR23
    int GLU_NURBS_ERROR24
    int GLU_NURBS_ERROR25
    int GLU_NURBS_ERROR26
    int GLU_NURBS_ERROR27
    int GLU_NURBS_ERROR28
    int GLU_NURBS_ERROR29
    int GLU_NURBS_ERROR30
    int GLU_NURBS_ERROR31
    int GLU_NURBS_ERROR32
    int GLU_NURBS_ERROR33
    int GLU_NURBS_ERROR34
    int GLU_NURBS_ERROR35
    int GLU_NURBS_ERROR36
    int GLU_NURBS_ERROR37

    int GLU_AUTO_LOAD_MATRIX
    int GLU_CULLING
    int GLU_SAMPLING_TOLERANCE
    int GLU_DISPLAY_MODE
    int GLU_PARAMETRIC_TOLERANCE
    int GLU_SAMPLING_METHOD
    int GLU_U_STEP
    int GLU_V_STEP

    int GLU_PATH_LENGTH
    int GLU_PARAMETRIC_ERROR
    int GLU_DOMAIN_DISTANCE

    int GLU_MAP1_TRIM_2
    int GLU_MAP1_TRIM_3

    int GLU_POINT
    int GLU_LINE
    int GLU_FILL
    int GLU_SILHOUETTE

    int GLU_ERROR

    int GLU_SMOOTH
    int GLU_FLAT
    int GLU_NONE

    int GLU_OUTSIDE
    int GLU_INSIDE

    int GLU_TESS_BEGIN
    int GLU_BEGIN
    int GLU_TESS_VERTEX
    int GLU_VERTEX
    int GLU_TESS_END
    int GLU_END
    int GLU_TESS_ERROR
    int GLU_TESS_EDGE_FLAG
    int GLU_EDGE_FLAG
    int GLU_TESS_COMBINE
    int GLU_TESS_BEGIN_DATA
    int GLU_TESS_VERTEX_DATA
    int GLU_TESS_END_DATA
    int GLU_TESS_ERROR_DATA
    int GLU_TESS_EDGE_FLAG_DATA
    int GLU_TESS_COMBINE_DATA

    int GLU_CW
    int GLU_CCW
    int GLU_INTERIOR
    int GLU_EXTERIOR
    int GLU_UNKNOWN

    int GLU_TESS_WINDING_RULE
    int GLU_TESS_BOUNDARY_ONLY
    int GLU_TESS_TOLERANCE

    int GLU_TESS_ERROR1
    int GLU_TESS_ERROR2
    int GLU_TESS_ERROR3
    int GLU_TESS_ERROR4
    int GLU_TESS_ERROR5
    int GLU_TESS_ERROR6
    int GLU_TESS_ERROR7
    int GLU_TESS_ERROR8
    int GLU_TESS_MISSING_BEGIN_POLYGON
    int GLU_TESS_MISSING_BEGIN_CONTOUR
    int GLU_TESS_MISSING_END_POLYGON
    int GLU_TESS_MISSING_END_CONTOUR
    int GLU_TESS_COORD_TOO_LARGE
    int GLU_TESS_NEED_COMBINE_CALLBACK

    int GLU_TESS_WINDING_ODD
    int GLU_TESS_WINDING_NONZERO
    int GLU_TESS_WINDING_POSITIVE
    int GLU_TESS_WINDING_NEGATIVE
    int GLU_TESS_WINDING_ABS_GEQ_TWO

    int GLU_INCOMPATIBLE_GL_VERSION
    double GLU_TESS_MAX_COORD

    # glu typedefs
    ctypedef struct GLUnurbs:
        pass
    ctypedef struct GLUquadric:
        pass
    ctypedef struct GLUtesselator:
        pass

    ctypedef GLUnurbs GLUnurbsObj
    ctypedef GLUquadric GLUquadricObj
    ctypedef GLUtesselator GLUtesselatorObj
    ctypedef GLUtesselator GLUtriangulatorObj

    ctypedef void (*_GLUfuncptr)()

    # glu functions
    cdef void gluBeginCurve(GLUnurbs *nurb)
    cdef void gluBeginPolygon(GLUtesselator *tess)
    cdef void gluBeginSurface(GLUnurbs *nurb)
    cdef void gluBeginTrim(GLUnurbs *nurb)
    cdef GLint gluBuild1DMipmaps(GLenum target, GLint internalFormat, GLsizei width, GLenum format, GLenum type, void *data)
    cdef GLint gluBuild2DMipmaps(GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLenum format, GLenum type, void *data)
    cdef void gluCylinder(GLUquadric *quad, GLdouble base, GLdouble top, GLdouble height, GLint slices, GLint stacks)
    cdef void gluDeleteNurbsRenderer(GLUnurbs *nurb)
    cdef void gluDeleteQuadric(GLUquadric *quad)
    cdef void gluDeleteTess(GLUtesselator *tess)
    cdef void gluDisk(GLUquadric *quad, GLdouble inner, GLdouble outer, GLint slices, GLint loops)
    cdef void gluEndCurve(GLUnurbs *nurb)
    cdef void gluEndPolygon(GLUtesselator *tess)
    cdef void gluEndSurface(GLUnurbs *nurb)
    cdef void gluEndTrim(GLUnurbs *nurb)
    cdef GLubyte* gluErrorString(GLenum error)
    cdef wchar_t* gluErrorUnicodeStringEXT(GLenum error)
    cdef void gluGetNurbsProperty(GLUnurbs *nurb, GLenum property, GLfloat *data)
    cdef GLubyte* gluGetString(GLenum name)
    cdef void gluGetTessProperty(GLUtesselator *tess, GLenum which, GLdouble *data)
    cdef void gluLoadSamplingMatrices(GLUnurbs *nurb, GLfloat *model, GLfloat *perspective, GLint *view)
    cdef void gluLookAt(GLdouble eyeX, GLdouble eyeY, GLdouble eyeZ, GLdouble centerX, GLdouble centerY, GLdouble centerZ, GLdouble upX, GLdouble upY, GLdouble upZ)
    cdef GLUnurbs* gluNewNurbsRenderer()
    cdef GLUquadric* gluNewQuadric()
    cdef GLUtesselator* gluNewTess()
    cdef void gluNextContour(GLUtesselator *tess, GLenum type)
    cdef void gluNurbsCallback(GLUnurbs *nurb, GLenum which, _GLUfuncptr CallBackFunc)
    cdef void gluNurbsCurve(GLUnurbs *nurb, GLint knotCount, GLfloat *knots, GLint stride, GLfloat *control, GLint order, GLenum type)
    cdef void gluNurbsProperty(GLUnurbs *nurb, GLenum property, GLfloat value)
    cdef void gluNurbsSurface(GLUnurbs *nurb, GLint sKnotCount, GLfloat *sKnots, GLint tKnotCount, GLfloat *tKnots, GLint sStride, GLint tStride, GLfloat *control, GLint sOrder, GLint tOrder, GLenum type)
    cdef void gluOrtho2D(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top)
    cdef void gluPartialDisk(GLUquadric *quad, GLdouble inner, GLdouble outer, GLint slices, GLint loops, GLdouble start, GLdouble sweep)
    cdef void gluPerspective(GLdouble fovy, GLdouble aspect, GLdouble zNear, GLdouble zFar)
    cdef void gluPickMatrix(GLdouble x, GLdouble y, GLdouble delX, GLdouble delY, GLint *viewport)
    cdef GLint gluProject(GLdouble objX, GLdouble objY, GLdouble objZ, GLdouble *model, GLdouble *proj, GLint *view, GLdouble *winX, GLdouble *winY, GLdouble *winZ)
    cdef void gluPwlCurve(GLUnurbs *nurb, GLint count, GLfloat *data, GLint stride, GLenum type)
    cdef void gluQuadricCallback(GLUquadric *quad, GLenum which, _GLUfuncptr CallBackFunc)
    cdef void gluQuadricDrawStyle(GLUquadric *quad, GLenum draw)
    cdef void gluQuadricNormals(GLUquadric *quad, GLenum normal)
    cdef void gluQuadricOrientation(GLUquadric *quad, GLenum orientation)
    cdef void gluQuadricTexture(GLUquadric *quad, GLboolean texture)
    cdef GLint gluScaleImage(GLenum format, GLsizei wIn, GLsizei hIn, GLenum typeIn, void *dataIn, GLsizei wOut, GLsizei hOut, GLenum typeOut, GLvoid *dataOut)
    cdef void gluSphere(GLUquadric *quad, GLdouble radius, GLint slices, GLint stacks)
    cdef void gluTessBeginContour(GLUtesselator *tess)
    cdef void gluTessBeginPolygon(GLUtesselator *tess, GLvoid *data)
    cdef void gluTessCallback(GLUtesselator *tess, GLenum which, _GLUfuncptr CallBackFunc)
    cdef void gluTessEndContour(GLUtesselator *tess)
    cdef void gluTessEndPolygon(GLUtesselator *tess)
    cdef void gluTessNormal(GLUtesselator *tess, GLdouble valueX, GLdouble valueY, GLdouble valueZ)
    cdef void gluTessProperty(GLUtesselator *tess, GLenum which, GLdouble data)
    cdef void gluTessVertex(GLUtesselator *tess, GLdouble *location, GLvoid *data)
    cdef GLint gluUnProject(GLdouble winX, GLdouble winY, GLdouble winZ, GLdouble *model, GLdouble *proj, GLint *view, GLdouble *objX, GLdouble *objY, GLdouble *objZ)
    cdef GLint gluUnProject4(GLdouble winX, GLdouble winY, GLdouble winZ, GLdouble clipW, GLdouble *model, GLdouble *proj, GLint *view, GLdouble nearVal, GLdouble farVal, GLdouble *objX, GLdouble *objY, GLdouble *objZ, GLdouble *objW)
