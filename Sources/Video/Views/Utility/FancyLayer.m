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
//  FancyLayer.m
//  iLibs
//
//  Created by Maarten Billemont on 18/12/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "FancyLayer.h"


@interface FancyLayer ()

@property (nonatomic, readwrite, assign) CGSize                                   contentSize;
@property (readwrite, assign) ccColor4B                                backColor;

@property (readwrite, assign) GLuint                                   vertexBuffer;
@property (readwrite, assign) GLuint                                   colorBuffer;

@end


@implementation FancyLayer

@synthesize contentSize = _contentSize;
@synthesize outerPadding = _outerPadding;
@synthesize padding = _padding;
@synthesize innerRatio = _innerRatio;
@synthesize backColor = _backColor, colorGradient = _colorGradient;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize colorBuffer = _colorBuffer;



- (id)init {
    
    if(!(self = [super init]))
        return self;
    
    self.outerPadding    = margin(5.0f, 5.0f, 5.0f, 5.0f);
    self.padding         = margin(50.0f, 50.0f, 50.0f, 50.0f);
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
    
    int barHeight       = 0;
    if(![[UIApplication sharedApplication] isStatusBarHidden]) {
        if([Director sharedDirector].deviceOrientation == CCDeviceOrientationLandscapeLeft
           || [Director sharedDirector].deviceOrientation == CCDeviceOrientationLandscapeRight)
            barHeight   = [[UIApplication sharedApplication] statusBarFrame].size.width;
        else
            barHeight   = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    
    CGSize winSize      = [[Director sharedDirector] winSize];
    self.contentSize         = CGSizeMake(winSize.width, winSize.height - barHeight);
    int inner           = self.contentSize.height * self.innerRatio;
    
    /*
           pos.x + pad                                pos.x + width - pad - inner
           |                                             |
           v                                             v
           2+10--------------------------------------9         <- pos.y + pad
          /                                           \
         /                                             \
        /                                               \
       3                                                 8     <- pos.y + pad + inner
       |                                                 |
       |                        1                        |
       |                                                 |
       4                                                 7     <- pos.y + height - pad - inner
        \                                               /
         \                                             /
          \                                           /
           5-----------------------------------------6         <- pos.y + height - pad
           ^                                             ^
           |                                             |
           pos.x + pad + inner                           pos.x + width - pad
     */
    
    GLfloat *vertices = malloc(sizeof(GLfloat) * 10 * 2);
    vertices[0]     = self.contentSize.width / 2;                            // 1
    vertices[1]     = self.contentSize.height / 2;
    vertices[2]     = self.outerPadding.left + inner;                        // 2
    vertices[3]     = self.outerPadding.bottom;
    vertices[4]     = self.outerPadding.left;                                // 3
    vertices[5]     = self.outerPadding.bottom + inner;
    vertices[6]     = self.outerPadding.left;                                // 4
    vertices[7]     = self.contentSize.height - self.outerPadding.top - inner;
    vertices[8]     = self.outerPadding.left + inner;                        // 5
    vertices[9]     = self.contentSize.height - self.outerPadding.top;
    vertices[10]    = self.contentSize.width - self.outerPadding.right - inner;   // 6
    vertices[11]    = self.contentSize.height - self.outerPadding.top;
    vertices[12]    = self.contentSize.width - self.outerPadding.right;           // 7
    vertices[13]    = self.contentSize.height - self.outerPadding.top - inner;
    vertices[14]    = self.contentSize.width - self.outerPadding.right;           // 8
    vertices[15]    = self.outerPadding.bottom + inner;
    vertices[16]    = self.contentSize.width - self.outerPadding.right - inner;   // 9
    vertices[17]    = self.outerPadding.bottom;
    vertices[18]    = self.outerPadding.left + inner;                        // 10
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


-(void) setOuterPadding:(Margin)anOuterPadding {
    
    _outerPadding = anOuterPadding;
    [self update];
}


-(void) setPadding:(Margin)aPadding {
    
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
    
    // Tell OpenGL about our data.
	glEnableClientState(GL_VERTEX_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
	glVertexPointer(2, GL_FLOAT, 0, 0);

	glEnableClientState(GL_COLOR_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER, self.colorBuffer);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, 0);
	
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // Draw our background.
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 10);
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    
    // Reset data source.
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
}


-(void) dealloc {
    
    [super dealloc];
}


@end
