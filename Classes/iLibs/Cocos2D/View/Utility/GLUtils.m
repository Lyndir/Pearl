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
//  iLibs
//
//  Created by Maarten Billemont on 26/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "GLUtils.h"
#import "Logger.h"

int GLCheck(char *file, int line) {
    
    file = basename(file);
    GLenum glErr;
    int    retCode = 0;
    
    while ((glErr=glGetError()) != GL_NO_ERROR) {
        switch(glErr) {
            case GL_INVALID_ENUM:
                [[Logger get] err:@"%30s:%-5d\t    -> GL_INVALID_ENUM",         file, line];
                break;
            case GL_INVALID_VALUE:
                [[Logger get] err:@"%30s:%-5d\t    -> GL_INVALID_VALUE",        file, line];
                break;
            case GL_INVALID_OPERATION:
                [[Logger get] err:@"%30s:%-5d\t    -> GL_INVALID_OPERATION",    file, line];
                break;
            case GL_STACK_OVERFLOW:
                [[Logger get] err:@"%30s:%-5d\t    -> GL_STACK_OVERFLOW",       file, line];
                break;
            case GL_STACK_UNDERFLOW:
                [[Logger get] err:@"%30s:%-5d\t    -> GL_STACK_UNDERFLOW",      file, line];
                break;
            case GL_OUT_OF_MEMORY:
                [[Logger get] err:@"%30s:%-5d\t    -> GL_OUT_OF_MEMORY",        file, line];
                break;
            default:
                [[Logger get] err:@"%30s:%-5d\t    -> UNKNOWN",                 file, line];
        }
    }
    
    return retCode;
}

CGPoint CGPointFromSize(const CGSize size) {
    
    return CGPointMake(size.width, size.height);
}


CGSize CGSizeFromPoint(const CGPoint point) {
    
    return CGSizeMake(point.x, point.y);
}


CGRect CGRectFromPointAndSize(const CGPoint point, const CGSize size) {
    
    return CGRectMake(point.x, point.y, size.width, size.height);
}


#define INDICATORS 300
static CGPoint *indicatorPoints     = nil;
static ccColor4B *indicatorColors   = nil;
static CCNode* *indicatorSpaces  = nil;
static NSUInteger indicatorPosition = INDICATORS;

void IndicateInSpaceOf(const CGPoint point, const CCNode *node) {
    
    if (indicatorPoints == nil) {
        indicatorPoints = calloc(INDICATORS, sizeof(CGPoint));
        indicatorColors = calloc(INDICATORS, sizeof(ccColor4B));
        indicatorSpaces = calloc(INDICATORS, sizeof(CCNode*));
    }
    
    ++indicatorPosition;
    indicatorPoints[indicatorPosition % INDICATORS] = point;
    [indicatorSpaces[indicatorPosition % INDICATORS] release];
    indicatorSpaces[indicatorPosition % INDICATORS] = [node retain];
    for (NSUInteger i = 0; i <= indicatorPosition; ++i)
        if (i < indicatorPosition - INDICATORS)
            indicatorColors[i % INDICATORS] = ccc4(0x00, 0x00, 0x00, 0xff);
        else {
            NSUInteger shade = 0xff - (0xff * (indicatorPosition - i) / INDICATORS);
            indicatorColors[i % INDICATORS].r = shade;
            indicatorColors[i % INDICATORS].g = shade;
            indicatorColors[i % INDICATORS].b = shade;
            indicatorColors[i % INDICATORS].a = 0xff;
        }
}


void DrawIndicators() {
    
    if (!indicatorPoints)
        return;
    
    CGPoint *points = malloc(sizeof(CGPoint) * INDICATORS);
    for (NSUInteger i = 0; i < INDICATORS; ++i)
        points[i] = [indicatorSpaces[i] convertToWorldSpace:indicatorPoints[i]];
    
    DrawPoints(points, indicatorColors, INDICATORS);
}


void DrawPointsAt(const CGPoint* points, const NSUInteger n, const ccColor4B color) {
    
    ccColor4B *colors = malloc(sizeof(ccColor4B) * n);
    for (NSUInteger i = 0; i < n; ++i)
        colors[i] = color;

    DrawPoints(points, colors, n);
}


void DrawPoints(const CGPoint* points, const ccColor4B* colors, const NSUInteger n) {
    
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, GL_COLOR_ARRAY
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	//BOOL vWasEnabled = glIsEnabled(GL_VERTEX_ARRAY);
    //if(!vWasEnabled)
    //    glEnableClientState(GL_VERTEX_ARRAY);
    //BOOL cWasEnabled = glIsEnabled(GL_COLOR_ARRAY);
    //if(!cWasEnabled && colors)
    //    glEnableClientState(GL_COLOR_ARRAY);
    
    // Define vertices and pass to GL.
    glVertexPointer(2, GL_FLOAT, 0, points);
    
    // Define colors and pass to GL.
    if(colors != nil)
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    
    // Draw.
    glPointSize(4);
    glDrawArrays(GL_POINTS, 0, n);
    
    // Reset data source.
    //if(!vWasEnabled)
    //    glDisableClientState(GL_VERTEX_ARRAY);
    //if(!cWasEnabled && colors)
    //    glDisableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}


void DrawLinesTo(const CGPoint from, const CGPoint* to, const NSUInteger n, const ccColor4B color, const CGFloat width) {
    
    CGPoint *points = malloc(sizeof(CGPoint) * (n + 1));
    points[0] = from;
    for(NSUInteger i = 0; i < n; ++i)
        points[i + 1] = to[i];

    glColor4ub(color.r, color.g, color.b, color.a);
    
    DrawLines(points, nil, n + 1, width);
    free(points);
}
    

void DrawLines(const CGPoint* points, const ccColor4B* longColors, const NSUInteger n, const CGFloat width) {
    
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, GL_COLOR_ARRAY
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	//BOOL vWasEnabled = glIsEnabled(GL_VERTEX_ARRAY);
    //if(!vWasEnabled)
    //    glEnableClientState(GL_VERTEX_ARRAY);
    //BOOL cWasEnabled = glIsEnabled(GL_COLOR_ARRAY);
    //if(!cWasEnabled && longColors)
    //    glEnableClientState(GL_COLOR_ARRAY);
    
    // Define vertices and pass to GL.
	glVertexPointer(2, GL_FLOAT, 0, points);
    
    // Define colors and pass to GL.
    if(longColors != nil)
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, longColors);
    
    // Draw.
    if(width && width != 1)
        glLineWidth(width);
	glDrawArrays(GL_LINE_STRIP, 0, n);
    if(width && width != 1)
        glLineWidth(1.0f);
    
    // Reset data source.
    //if(!vWasEnabled)
    //    glDisableClientState(GL_VERTEX_ARRAY);
    //if(!cWasEnabled && longColors)
    //    glDisableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}


void DrawBoxFrom(const CGPoint from, const CGPoint to, const ccColor4B fromColor, const ccColor4B toColor) {
    
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, GL_COLOR_ARRAY
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	//BOOL vWasEnabled = glIsEnabled(GL_VERTEX_ARRAY);
    //if(!vWasEnabled)
    //    glEnableClientState(GL_VERTEX_ARRAY);
    //BOOL cWasEnabled = glIsEnabled(GL_COLOR_ARRAY);
    //if(!cWasEnabled)
    //    glEnableClientState(GL_COLOR_ARRAY);
    
    // Define vertices and pass to GL.
    const GLfloat vertices[4 * 2] = {
        from.x, from.y,
        to.x,   from.y,
        from.x, to.y,
        to.x,   to.y,
    };
    glVertexPointer(2, GL_FLOAT, 0, vertices);

    // Define colors and pass to GL.
    const ccColor4B colors[4] = {
        fromColor, fromColor,
        toColor, toColor,
    };
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    
    // Draw.
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // Untoggle state.
    //if(!vWasEnabled)
    //    glDisableClientState(GL_VERTEX_ARRAY);
    //if(!cWasEnabled)
    //    glDisableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}


void DrawBorderFrom(const CGPoint from, const CGPoint to, const ccColor4B color, const CGFloat width) {
    
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, GL_COLOR_ARRAY
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	//BOOL vWasEnabled = glIsEnabled(GL_VERTEX_ARRAY);
    //if(!vWasEnabled)
    //    glEnableClientState(GL_VERTEX_ARRAY);
    //BOOL cWasEnabled = glIsEnabled(GL_COLOR_ARRAY);
    //if(!cWasEnabled)
    //    glEnableClientState(GL_COLOR_ARRAY);
    
    // Define vertices and pass to GL.
    const GLfloat vertices[4 * 2] = {
        from.x, from.y,
        to.x,   from.y,
        to.x,   to.y,
        from.x, to.y,
    };
	glVertexPointer(2, GL_FLOAT, 0, vertices);
    
    // Define colors and pass to GL.
    const ccColor4B colors[4] = { color, color, color, color };
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    
	// Draw.
    if(width && width != 1)
        glLineWidth(width);
	glDrawArrays(GL_LINE_LOOP, 0, 4);
    if(width && width != 1)
        glLineWidth(1.0f);
    
    // Untoggle state.
    //if(!vWasEnabled)
    //    glDisableClientState(GL_VERTEX_ARRAY);
    //if(!cWasEnabled)
    //    glDisableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

void Scissor(const CCNode *inNode, const CGPoint from, const CGPoint to) {
    
    CGPoint scissorFrom = [inNode convertToWorldSpace:from];
    CGPoint scissorTo = [inNode convertToWorldSpace:to];
    
    glScissor(MIN(scissorFrom.x, scissorTo.x), MIN(scissorFrom.y, scissorTo.y),
              ABS(scissorTo.x - scissorFrom.x), ABS(scissorTo.y - scissorFrom.y));
}
