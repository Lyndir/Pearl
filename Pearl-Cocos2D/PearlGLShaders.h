/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */


#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define kPearlGLAttributeNameSize @"a_size"

enum {
    kPearlGLVertexAttrib_Size = kCCVertexAttrib_MAX,

    kPearlGLVertexAttrib_MAX
};

@interface PearlGLShaders : NSObject

+ (CCGLProgram *)pointSizeShader;
+ (CCGLProgram *)pointSpriteShader;

@end
