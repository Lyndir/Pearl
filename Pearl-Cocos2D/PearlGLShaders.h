//
//  Created by lhunath on 09/04/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define kPearlGLAttributeNameSize @"a_size"

enum {
    kPearlGLVertexAttrib_Size = kCCVertexAttrib_MAX,

	kPearlGLVertexAttrib_MAX,
};

@interface PearlGLShaders : NSObject

+ (CCGLProgram *)pointSizeShader;
+ (CCGLProgram *)pointSpriteShader;

@end
