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
//  GLUtils.c
//  Pearl
//
//  Created by Maarten Billemont on 26/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlGLUtils.h"
#import "PearlLogger.h"

int PearlGLCheck(char *file, int line) {
    
    file = basename(file);
    GLenum glErr;
    int    retCode = 0;
    
    while ((glErr=glGetError()) != GL_NO_ERROR) {
        switch(glErr) {
            case GL_INVALID_ENUM:
                [[PearlLogger get] err:@"%30s:%-5d\t    -> GL_INVALID_ENUM",         file, line];
                break;
            case GL_INVALID_VALUE:
                [[PearlLogger get] err:@"%30s:%-5d\t    -> GL_INVALID_VALUE",        file, line];
                break;
            case GL_INVALID_OPERATION:
                [[PearlLogger get] err:@"%30s:%-5d\t    -> GL_INVALID_OPERATION",    file, line];
                break;
            case GL_OUT_OF_MEMORY:
                [[PearlLogger get] err:@"%30s:%-5d\t    -> GL_OUT_OF_MEMORY",        file, line];
                break;
            default:
                [[PearlLogger get] err:@"%30s:%-5d\t    -> UNKNOWN",                 file, line];
        }
    }
    
    return retCode;
}


#define IndicatorCount 300
static CGPoint *PearlGLIndicatorPoints      = nil;
static CCNode **PearlGLIndicatorSpaces      = nil;
static NSUInteger PearlGLndicatorPosition   = IndicatorCount;

void PearlGLIndicateInSpaceOf(const CGPoint point, const CCNode *node) {
    
    if (PearlGLIndicatorPoints == nil) {
        PearlGLIndicatorPoints = calloc(IndicatorCount, sizeof(CGPoint));
        PearlGLIndicatorSpaces = calloc(IndicatorCount, sizeof(CCNode*));
    }
    
    ++PearlGLndicatorPosition;
    PearlGLIndicatorPoints[PearlGLndicatorPosition % IndicatorCount] = point;
    [PearlGLIndicatorSpaces[PearlGLndicatorPosition % IndicatorCount] release];
    PearlGLIndicatorSpaces[PearlGLndicatorPosition % IndicatorCount] = (CCNode *) [node retain];
}


void PearlGLDrawIndicators() {
    
    if (!PearlGLIndicatorPoints)
        return;
    
    CGPoint *points = malloc(sizeof(CGPoint) * IndicatorCount);
    for (NSUInteger i = 0; i < IndicatorCount; ++i)
        points[i] = [PearlGLIndicatorSpaces[i] convertToWorldSpace:PearlGLIndicatorPoints[i]];

    ccDrawColor4F(0xcc, 0xcc, 0x00, 0xcc);
    ccDrawPoints(points, IndicatorCount);
}

void PearlGLDrawBoxFrom(const CGPoint from, const CGPoint to, const ccColor4B color) {
    
    // Define vertices and pass to GL.
    const CGPoint vertices[4] = {
            ccp(to.x,   from.y),
            ccp(from.x, from.y),
            ccp(from.x, to.y),
            ccp(to.x,   to.y),
    };
    ccDrawFilledPoly(vertices, 4, ccc4FFromccc4B(color));
}


void PearlGLDrawBorderFrom(const CGPoint from, const CGPoint to, const ccColor4B color) {

    // Define vertices and pass to GL.
    const CGPoint vertices[4] = {
            ccp(to.x,   from.y),
            ccp(from.x, from.y),
            ccp(from.x, to.y),
            ccp(to.x,   to.y),
    };
    ccDrawColor4B(color.r, color.g, color.b, color.a);
    ccDrawPoly(vertices, 4, YES);
}

void PearlGLDraw(GLenum mode, const Vertex *vertices, const GLsizei amount) {

    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color);

    // Must be cast to void* so compiler stops treating it as a struct; otherwise we can't increment the pointer as a numeric value.
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)vertices + offsetof(Vertex, p));
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(Vertex), (void *)vertices + offsetof(Vertex, c));
    glDrawArrays(mode, 0, amount);
}

void PearlGLScissorOn(const CCNode *inNode, const CGPoint from, const CGPoint to) {
    
    CGPoint scissorFrom = [inNode convertToWorldSpace:from];
    CGPoint scissorTo = [inNode convertToWorldSpace:to];
    
    glEnable(GL_SCISSOR_TEST);
    glScissor((GLubyte)MIN(scissorFrom.x, scissorTo.x), (GLubyte)MIN(scissorFrom.y, scissorTo.y),
            (GLubyte)ABS(scissorTo.x - scissorFrom.x), (GLubyte)ABS(scissorTo.y - scissorFrom.y));
}

void PearlGLScissorOff() {

    glDisable(GL_SCISSOR_TEST);
}
