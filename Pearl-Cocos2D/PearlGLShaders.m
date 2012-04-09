//
//  Created by lhunath on 09/04/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PearlGLShaders.h"

const GLchar * PearlGLShaderPointSize_vert =
#import "PearlGLShaderPointSize_vert.h"
const GLchar * PearlGLShaderPointSize_frag =
#import "PearlGLShaderPointSize_frag.h"

//
const GLchar * PearlGLShaderPointSprite_vert =
#import "PearlGLShaderPointSprite_vert.h"
const GLchar * PearlGLShaderPointSprite_frag =
#import "PearlGLShaderPointSprite_frag.h"

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
