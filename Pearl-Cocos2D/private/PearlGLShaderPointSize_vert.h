/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */
"                                                                           \n\
attribute vec4 a_position;                                                  \n\
attribute float a_size;                                                     \n\
attribute vec4 a_color;                                                     \n\
                                                                            \n\
#ifdef GL_ES                                                                \n\
varying lowp vec4 v_fragmentColor;                                          \n\
#else                                                                       \n\
varying vec4 v_fragmentColor;                                               \n\
#endif                                                                      \n\
                                                                            \n\
void main()                                                                 \n\
{                                                                           \n\
    gl_Position = CC_MVPMatrix * a_position;                                \n\
    gl_PointSize = a_size;                                                  \n\
    v_fragmentColor = a_color;                                              \n\
}                                                                           \n\
";
