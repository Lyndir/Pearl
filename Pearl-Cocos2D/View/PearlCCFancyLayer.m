/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

//
//  PearlCCFancyLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 18/12/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCFancyLayer.h"
#import "PearlGLUtils.h"


@interface PearlCCFancyLayer ()

@property (nonatomic, readwrite, assign) CGSize                        contentSizeInPixels;
@property (readwrite, assign) ccColor4B                                backColor;

@property (readwrite, assign) GLuint                                   vertexBuffer;
@property (readwrite, assign) GLuint                                   colorBuffer;

@end


@implementation PearlCCFancyLayer

@synthesize contentSizeInPixels = _contentSizeInPixels;
@synthesize outerPadding = _outerPadding;
@synthesize padding = _padding;
@synthesize innerRatio = _innerRatio;
@synthesize backColor = _backColor, colorGradient = _colorGradient;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize colorBuffer = _colorBuffer;



- (id)init {
    
    if(!(self = [super init]))
        return self;
    
    self.outerPadding    = PearlMarginMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.padding         = PearlMarginMake(30.0f, 30.0f, 50.0f, 30.0f);
    self.backColor       = ccc4(0x00, 0x00, 0x00, 0xdd);
    self.colorGradient   = ccc4(0x00, 0x00, 0x00, 0xdd);
    self.innerRatio      = 1.0f / 50.0f;
    
    self.vertexBuffer    = 0;
    self.colorBuffer     = 0;
    
    [self update];
    
    return self;
}


-(void) onEnter {
    
    [super onEnter];
    
    [self update];
}


-(void) update {
    
    CGFloat barHeight       = 0;
    if(![[UIApplication sharedApplication] isStatusBarHidden])
        barHeight   = [[UIApplication sharedApplication] statusBarFrame].size.height;

    CGSize winSizeInPixels      = [[CCDirector sharedDirector] winSizeInPixels];
    self.contentSizeInPixels = CGSizeMake(winSizeInPixels.width, winSizeInPixels.height - barHeight);
    CGFloat inner           = self.contentSizeInPixels.height * self.innerRatio;
    
    /*
       pos.x + pad                                pos.x + width - pad - inner
       |                                             |
       v                                             v
           1+9---------------------------------------8         <- pos.y + pad
          /                                           \
         /                                             \
        /                                               \
       2                                                 7     <- pos.y + pad + inner
       |                                                 |
       |                        0                        |
       |                                                 |
       3                                                 6     <- pos.y + height - pad - inner
        \                                               /
         \                                             /
          \                                           /
           4-----------------------------------------5         <- pos.y + height - pad
           ^                                             ^
           |                                             |
           pos.x + pad + inner                           pos.x + width - pad
     */
    
    GLfloat *vertices = malloc(sizeof(GLfloat) * 10 * 2);
    vertices[0]     = self.contentSizeInPixels.width / 2;                            // 0
    vertices[1]     = self.contentSizeInPixels.height / 2;
    vertices[2]     = self.outerPadding.left + inner;                        // 1
    vertices[3]     = self.outerPadding.bottom;
    vertices[4]     = self.outerPadding.left;                                // 2
    vertices[5]     = self.outerPadding.bottom + inner;
    vertices[6]     = self.outerPadding.left;                                // 3
    vertices[7]     = self.contentSizeInPixels.height - self.outerPadding.top - inner;
    vertices[8]     = self.outerPadding.left + inner;                        // 4
    vertices[9]     = self.contentSizeInPixels.height - self.outerPadding.top;
    vertices[10]    = self.contentSizeInPixels.width - self.outerPadding.right - inner;   // 5
    vertices[11]    = self.contentSizeInPixels.height - self.outerPadding.top;
    vertices[12]    = self.contentSizeInPixels.width - self.outerPadding.right;           // 6
    vertices[13]    = self.contentSizeInPixels.height - self.outerPadding.top - inner;
    vertices[14]    = self.contentSizeInPixels.width - self.outerPadding.right;           // 7
    vertices[15]    = self.outerPadding.bottom + inner;
    vertices[16]    = self.contentSize.width - self.outerPadding.right - inner;   // 8
    vertices[17]    = self.outerPadding.bottom;
    vertices[18]    = self.outerPadding.left + inner;                        // 9
    vertices[19]    = self.outerPadding.bottom;

    ccColor4B *colors = malloc(sizeof(ccColor4B) * 10);
    colors[1] = colors[2] = colors[7] = colors[8] = colors[9] = self.backColor;
    colors[3] = colors[4] = colors[5] = colors[6] = self.colorGradient;
    colors[0] = self.backColor;
    
    // Push our window data into VBOs.
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorBuffer);
    glGenBuffers(1, &_vertexBuffer);
    glGenBuffers(1, &_colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat *) * 10 * 2, vertices, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, self.colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(ccColor4B) * 10, colors, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // Free the clientside window data.
    free(vertices);
    free(colors);
}


-(void) setOuterPadding:(PearlMargin)anOuterPadding {
    
    _outerPadding = anOuterPadding;
    [self update];
}


-(void) setPadding:(PearlMargin)aPadding {
    
    _padding = aPadding;
    [self update];
}


-(void) setInnerRatio:(float)anInnerRatio {
    
    _innerRatio = anInnerRatio;
    [self update];
}


- (ccColor3B)color {
    
    return ccc3(self.color.r, self.color.g, self.color.b);
}


- (GLubyte)opacity {
    
    return self.backColor.a;
}


- (void)setColor:(ccColor3B)newColor {
    
    self.backColor = ccc4(newColor.r, newColor.g, newColor.b, self.backColor.a);
    self.colorGradient = self.backColor;
    
    [self update];
}


- (void)setOpacity: (GLubyte)anOpacity {
    
    _backColor.a = anOpacity;
    
    [self update];
}


-(void) draw {
    
    [super draw];

    CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, @"PearlCCFancyLayer - draw");
   	CC_NODE_DRAW_SETUP();

//	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//	//glEnableClientState(GL_VERTEX_ARRAY);
//	//glEnableClientState(GL_COLOR_ARRAY);
//	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//	glDisable(GL_TEXTURE_2D);
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color);

    // Tell OpenGL about our data.
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, self.colorBuffer);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_FALSE, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);

    // Draw our background.
//#if (CC_BLEND_SRC != GL_SRC_ALPHA || CC_BLEND_DST != GL_ONE_MINUS_SRC_ALPHA)
    ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//#endif
    glDrawArrays(GL_TRIANGLE_FAN, 0, 10);
//#if (CC_BLEND_SRC != GL_SRC_ALPHA || CC_BLEND_DST != GL_ONE_MINUS_SRC_ALPHA)
//    ccGLBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
//#endif

//    // Reset data source.
//    //glDisableClientState(GL_VERTEX_ARRAY);
//    //glDisableClientState(GL_COLOR_ARRAY);
//    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//    glEnable(GL_TEXTURE_2D);

    CHECK_GL_ERROR_DEBUG();
    CC_INCREMENT_GL_DRAWS(1);
    CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"PearlCCFancyLayer - draw");
}


-(void) dealloc {

    [super dealloc];
}


@end
