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
//  GLUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 26/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//


/**
 * GL types
 */
typedef struct Vertex {
	CGPoint p;
    ccColor4B c;
} Vertex;

//! helper macro that converts a ccColor4B into a ccColor3B by dropping the alpha value.
static inline ccColor3B
ccc4to3(const ccColor4B color)
{
	ccColor3B c = { color.r, color.g, color.b };
	return c;
}

//! helper macro that creates an ccColor4B type from a long
static inline ccColor4B
ccc4l(const long color)
{
    GLubyte *components = (GLubyte *)&color;
	ccColor4B c = { components[3], components[2], components[1], components[0] };
	return c;
}

//! helper macro that creates an ccColor3B type from a long
static inline ccColor3B
ccc3l(const long color)
{
    GLubyte *components = (GLubyte *)&color;
	ccColor3B c = { components[3], components[2], components[1] };
	return c;
}

//! helper macro that creates an ccColor4F type
static inline ccColor4F
ccc4f(const float r, const float g, const float b, const float a)
{
	ccColor4F c = { r, g, b, a };
	return c;
}

//! Comparisons
static inline int
max(const int a, const int b)
{
    if (a > b)
        return a;
    return b;
}
static inline int
min(const int a, const int b)
{
    if (a < b)
        return a;
    return b;
}

CGPoint CGPointFromSize(const CGSize size);
CGSize CGSizeFromPoint(const CGPoint point);
CGRect CGRectFromPointAndSize(const CGPoint point, const CGSize size);

void IndicateInSpaceOf(CGPoint point, CocosNode *node);
void DrawIndicators();

void DrawPointsAt(const CGPoint* points, const NSUInteger count, const ccColor4B color);
void DrawPoints(const CGPoint* points, const ccColor4B* colors, const NSUInteger n);

void DrawLinesTo(const CGPoint from, const CGPoint* to, const NSUInteger count, const ccColor4B color, const CGFloat width);
void DrawLines(const CGPoint* points, const ccColor4B* colors, const NSUInteger n, const CGFloat width);

void DrawBoxFrom(const CGPoint from, const CGPoint to, const ccColor4B fromColor, const ccColor4B toColor);

void DrawBorderFrom(const CGPoint from, const CGPoint to, const ccColor4B color, const CGFloat width);

/** Apply glScissor for the given coordinates in the given node's space. */
void Scissor(const CocosNode *inNode, const CGPoint from, const CGPoint to);
