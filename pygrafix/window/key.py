# these constant VALUES are taken from GL/glfw.h, and names for the most part too

def symbol_string(symbol):
    return _key_names.get(symbol, str(symbol))

UNKNOWN = -1

TAB = 293
ENTER = 294
RETURN = ENTER
BACKSPACE = 295
INSERT = 296
DELETE = 297
PAGEUP = 298
PAGEDOWN = 299
HOME = 300
END = 301
SPACE = 32
ESCAPE = 257

F1 = 258
F2 = 259
F3 = 260
F4 = 261
F5 = 262
F6 = 263
F7 = 264
F8 = 265
F9 = 266
F10 = 267
F11 = 268
F12 = 269
F13 = 270
F14 = 271
F15 = 272
F16 = 273
F17 = 274
F18 = 275
F19 = 276
F20 = 277
F21 = 278
F22 = 279
F23 = 280
F24 = 281
F25 = 282

UP = 283
DOWN = 284
LEFT = 285
RIGHT = 286

LSHIFT = 287
RSHIFT = 288
LCTRL = 289
RCTRL = 290
LALT = 291
RALT = 292
LSUPER = 323
RSUPER = 324

NUMLOCK = 319
CAPS_LOCK = 320
SCROLL_LOCK = 321

KP_0 = 302
KP_1 = 303
KP_2 = 304
KP_3 = 305
KP_4 = 306
KP_5 = 307
KP_6 = 308
KP_7 = 309
KP_8 = 310
KP_9 = 311
KP_DIVIDE = 312
KP_MULTIPLY = 313
KP_SUBTRACT = 314
KP_ADD = 315
KP_DECIMAL = 316
KP_EQUAL = 317
KP_ENTER = 318

PAUSE = 322
MENU = 325

A = 65
B = 66
C = 67
D = 68
E = 69
F = 70
G = 71
H = 72
I = 73
J = 74
K = 75
L = 76
M = 77
N = 78
O = 79
P = 80
Q = 81
R = 82
S = 83
T = 84
U = 85
V = 86
W = 87
X = 88
Y = 89
Z = 90

_0 = 48
_1 = 49
_2 = 50
_3 = 51
_4 = 52
_5 = 53
_6 = 54
_7 = 55
_8 = 56
_9 = 57

_key_names = {}
for _name, _value in locals().items():
    if _name.upper() == _name:
        _key_names[_value] = _name
