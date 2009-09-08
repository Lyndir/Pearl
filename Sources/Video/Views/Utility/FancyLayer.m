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


@implementation FancyLayer

@synthesize contentSize, outerPadding, padding, innerRatio;


- (id)init {
    
    if(!(self = [super init]))
        return self;
    
    outerPadding    = 5.0f;
    padding         = 50.0f;
    color           = ccc4(0x00, 0x00, 0x00, 0xdd);
    innerRatio      = 1.0f / padding;
    
    vertexBuffer    = 0;
    colorBuffer     = 0;
    
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
    contentSize         = CGSizeMake(winSize.width, winSize.height - barHeight);
    int inner           = contentSize.height * innerRatio;
    
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
    vertices[0]     = contentSize.width / 2;                        // 1
    vertices[1]     = contentSize.height / 2;
    vertices[2]     = outerPadding + inner;                         // 2
    vertices[3]     = outerPadding;
    vertices[4]     = outerPadding;                                 // 3
    vertices[5]     = outerPadding + inner;
    vertices[6]     = outerPadding;                                 // 4
    vertices[7]     = contentSize.height - outerPadding - inner;
    vertices[8]     = outerPadding + inner;                         // 5
    vertices[9]     = contentSize.height - outerPadding;
    vertices[10]    = contentSize.width - outerPadding - inner;     // 6
    vertices[11]    = contentSize.height - outerPadding;
    vertices[12]    = contentSize.width - outerPadding;             // 7
    vertices[13]    = contentSize.height - outerPadding - inner;
    vertices[14]    = contentSize.width - outerPadding;             // 8
    vertices[15]    = outerPadding + inner;
    vertices[16]    = contentSize.width - outerPadding - inner;     // 9
    vertices[17]    = outerPadding;
    vertices[18]    = outerPadding + inner;                         // 10
    vertices[19]    = outerPadding;

    ccColor4B *colors = malloc(sizeof(ccColor4B) * 10);
    for(int i = 0; i < 10; ++i)
        colors[i] = color;
    
    // Push our window data into VBOs.
    glDeleteBuffers(1, &vertexBuffer);
    glDeleteBuffers(1, &colorBuffer);
    glGenBuffers(1, &vertexBuffer);
    glGenBuffers(1, &colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat *) * 10 * 2, vertices, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(ccColor4B) * 10, colors, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // Free the clientside window data.
    free(vertices);
    free(colors);
}


-(void) setOuterPadding:(float)_outerPadding {
    
    outerPadding = _outerPadding;
    [self update];
}


-(void) setPadding:(float)_padding {
    
    padding = _padding;
    [self update];
}


-(void) setInnerRatio:(float)_innerRatio {
    
    innerRatio = _innerRatio;
    [self update];
}


- (ccColor3B)color {
    
    return ccc3(color.r, color.g, color.b);
}


- (GLubyte)opacity {
    
    return color.a;
}


- (void)setColor:(ccColor3B)newColor {
    
    color.r = newColor.r;
    color.g = newColor.g;
    color.b = newColor.b;
    
    [self update];
}


- (void)setOpacity: (GLubyte)anOpacity {
    
    color.a = anOpacity;
    
    [self update];
}


-(void) draw {
    
    // Tell OpenGL about our data.
	glEnableClientState(GL_VERTEX_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
	glVertexPointer(2, GL_FLOAT, 0, 0);

	glEnableClientState(GL_COLOR_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, 0);
	
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // Draw our background.
	glDrawArrays(GL_TRIANGLE_FAN, 0, 10);
    
    // Reset data source.
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
}


-(void) dealloc {
    
    [super dealloc];
}


@end
