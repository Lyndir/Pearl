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
//  Utility.h
//  iLibs
//
//  Created by Maarten Billemont on 26/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//


// Helpers
static inline ccColor4B
ccc(const long c)
{
    GLubyte *components = (GLubyte *)&c;
	ccColor4B cc = { components[3], components[2], components[1], components[0] };
    
	return cc;
}

static inline ccColor4F
cccf(const float r, const float g, const float b, const float a)
{
    ccColor4F c;
    c.r = r;
    c.g = g;
    c.b = b;
    c.a = a;

	return c;
}


/**
 * GL types
 */
typedef struct Vertex {
	CGPoint p;
    ccColor4B c;
} Vertex;

static inline Vertex
ivc(const CGPoint p, const long c)
{
    Vertex v;
    v.p = p; //cpvtoiv(p);
    v.c = ccc(c);
	return v;
}

static inline Vertex
ivcf(const CGFloat x, const CGFloat y, const long c)
{
    Vertex v;
    v.p = ccp(x, y);
    v.c = ccc(c);
	return v;
}

typedef struct _glPoint {
    CGPoint p;
    GLfloat s;
    ccColor4B c;
} glPoint;


NSString* RPad(const NSString* string, NSUInteger l);
NSString* LPad(const NSString* string, NSUInteger l);
NSString* AppendOrdinalPrefix(const NSInteger number, const NSString* prefix);

BOOL IsIPod();
BOOL IsIPhone();
BOOL IsSimulator();

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
