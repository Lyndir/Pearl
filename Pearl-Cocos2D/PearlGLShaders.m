/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */
//
//  Created by lhunath on 09/04/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


const GLchar *PearlGLShaderPointSize_vert =

const GLchar *PearlGLShaderPointSize_frag =

//
const GLchar *PearlGLShaderPointSprite_vert =

const GLchar *PearlGLShaderPointSprite_frag =

@implementation PearlGLShaders {

}

+ (CCGLProgram *)pointSizeShader {

    static CCGLProgram *program = nil;
    if (!program) {
        program = [[CCGLProgram alloc] initWithVertexShaderByteArray:PearlGLShaderPointSize_vert
                                             fragmentShaderByteArray:PearlGLShaderPointSize_frag];

        [program addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [program addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [program addAttribute:kPearlGLAttributeNameSize index:kPearlGLVertexAttrib_Size];

        [program link];
        [program updateUniforms];
        CHECK_GL_ERROR_DEBUG();
    }

    return program;
}

+ (CCGLProgram *)pointSpriteShader {

    static CCGLProgram *program = nil;
    if (!program) {
        program = [[CCGLProgram alloc] initWithVertexShaderByteArray:PearlGLShaderPointSprite_vert
                                             fragmentShaderByteArray:PearlGLShaderPointSprite_frag];

        [program addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [program addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [program addAttribute:kPearlGLAttributeNameSize index:kPearlGLVertexAttrib_Size];

        [program link];
        [program updateUniforms];
        CHECK_GL_ERROR_DEBUG();
    }

    return program;
}


@end
