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
#ifdef GL_ES                                                                \n\
precision lowp float;                                                       \n\
#endif                                                                      \n\
                                                                            \n\
varying vec4 v_fragmentColor;                                               \n\
                                                                            \n\
void main()                                                                 \n\
{                                                                           \n\
    gl_FragColor = v_fragmentColor;                                         \n\
}                                                                           \n\
";
