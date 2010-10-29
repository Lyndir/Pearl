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
//  BarSprite.m
//  iLibs
//
//  Created by Maarten Billemont on 27/06/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "BarSprite.h"

#define kSmoothingTime 0.1f


@interface BarSprite ()

- (void)updateBodyFrame:(ccTime)dt;

@property (readwrite, retain) CCTexture2D            *head;
@property (readwrite, assign) CCTexture2D            **body;
@property (readwrite, retain) CCTexture2D            *tail;

@property (readwrite, assign) CGFloat              age;
@property (readwrite, assign) NSUInteger           bodyFrame;
@property (readwrite, assign) NSUInteger           bodyFrames;

@property (readwrite, assign) BOOL                 animatedTargetting;
@property (readwrite, assign) ccTime               smoothTimeElapsed;

@property (readwrite, assign) CGPoint              current;
@property (readwrite, assign) CGFloat              currentLength;

@end


@implementation BarSprite

@synthesize head = _head, body = _body, tail = _tail;
@synthesize age = _age;
@synthesize bodyFrame = _bodyFrame, bodyFrames = _bodyFrames;
@synthesize animatedTargetting = _animatedTargetting;
@synthesize smoothTimeElapsed = _smoothTimeElapsed;
@synthesize target = _target;
@synthesize current = _current;
@synthesize currentLength = _currentLength;
@synthesize textureSize = _textureSize;


- (id) initWithHead:(NSString *)bundleHeadReference body:(NSString *)bundleBodyReference withFrames:(NSUInteger)bodyFrameCount tail:(NSString *)bundleTailReference animatedTargetting:(BOOL)anAnimatedTargetting {
    
    if (!(self = [super init]))
        return self;
    
    self.anchorPoint        = CGPointZero;
    self.visible            = NO;
    self.animatedTargetting      = anAnimatedTargetting;

    if (bundleHeadReference)
        self.head = [[CCTextureCache sharedTextureCache] addImage:bundleHeadReference];
    if (bundleBodyReference) {
        self.bodyFrames = bodyFrameCount;
        self.body = malloc(sizeof(CCTexture2D *) * self.bodyFrames);
        if (self.bodyFrames > 1) {
            for (NSUInteger f = 0; f < self.bodyFrames; ++f)
                self.body[f] = [[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:bundleBodyReference, f]] retain];
        } else
            self.body[0] = [[[CCTextureCache sharedTextureCache] addImage:bundleBodyReference] retain];
        
        self.bodyFrame = 0;
        self.textureSize = CGSizeMake(self.body[self.bodyFrame].pixelsWide, self.body[self.bodyFrame].pixelsHigh);
    }
    if (bundleTailReference)
        self.tail = [[CCTextureCache sharedTextureCache] addImage:bundleTailReference];
    
    [self schedule:@selector(updateBodyFrame:) interval:0.02f];
    if (self.animatedTargetting)
        [self schedule:@selector(update:)];
    
    return self;
}


- (void)updateBodyFrame:(ccTime)dt {
    
    self.age                 += dt;
    self.bodyFrame           = ((NSUInteger) (self.age * 50 * self.body[0].pixelsWide / self.textureSize.width)) % self.bodyFrames;
}


- (void)update:(ccTime)dt {
    
    self.smoothTimeElapsed   = fminf(kSmoothingTime, self.smoothTimeElapsed + dt);

    CGFloat completion  = self.smoothTimeElapsed / kSmoothingTime;
    self.current             = ccpAdd(self.current, ccpMult(ccpSub(self.target, self.current), completion));
    
    CGPoint bar         = ccpSub(self.current, self.position);
    self.currentLength       = ccpLength(bar);
    
    self.rotation       = CC_RADIANS_TO_DEGREES(ccpToAngle(ccp(bar.x, -bar.y)));
}


- (void)setTarget:(CGPoint)t {
    
    if (self.animatedTargetting && self.visible) {
        _target                     = t;
        self.smoothTimeElapsed      = 0;
    } else {
        _target = self.current      = t;
        self.smoothTimeElapsed      = kSmoothingTime;
        [self update:0];
    }
    
    self.visible = !CGPointEqualToPoint(t, CGPointZero);
}


- (void) draw
{
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glEnable(GL_TEXTURE_2D);
    
    //GLfloat width = (GLfloat)body[bodyFrame].pixelsWide * body[bodyFrame].maxS;
    //GLfloat height = (GLfloat)body[bodyFrame].pixelsHigh * body[bodyFrame].maxT;

    GLfloat s = (self.currentLength * 2 - self.tail.pixelsWide / 2 - self.head.pixelsWide / 2) / self.textureSize.width;
    GLfloat coordinates[3][8] = {
        /* head */ {
            0.0f,   1.0f,
            1.0f,   1.0f,
            0.0f,   0.0f,
            1.0f,   0.0f,
        /* body */ }, {
            0.0f,   1.0f,
            s,      1.0f,
            0.0f,   0.0f,
            s,      0.0f
        /* tail */ }, {
            0.0f,   1.0f,
            1.0f,   1.0f,
            0.0f,   0.0f,
            1.0f,   0.0f,
        }
    };
    
    GLfloat vertices[3][12] = {
        /* head */ {
            -self.textureSize.width / 2.0f + self.currentLength,  -self.textureSize.height / 2.0f, 0.0f,
             self.textureSize.width / 2.0f + self.currentLength,  -self.textureSize.height / 2.0f, 0.0f,
            -self.textureSize.width / 2.0f + self.currentLength,   self.textureSize.height / 2.0f, 0.0f,
             self.textureSize.width / 2.0f + self.currentLength,   self.textureSize.height / 2.0f, 0.0f,
        /* body */ }, {
             self.textureSize.width / 2.0f,                  -self.textureSize.height / 2.0f, 0.0f,
            -self.textureSize.width / 2.0f + self.currentLength,  -self.textureSize.height / 2.0f, 0.0f,
             self.textureSize.width / 2.0f,                   self.textureSize.height / 2.0f, 0.0f,
            -self.textureSize.width / 2.0f + self.currentLength,   self.textureSize.height / 2.0f, 0.0f
        /* tail */ }, {
            -self.textureSize.width / 2.0f,                  -self.textureSize.height / 2.0f, 0.0f,
             self.textureSize.width / 2.0f,                  -self.textureSize.height / 2.0f, 0.0f,
            -self.textureSize.width / 2.0f,                   self.textureSize.height / 2.0f, 0.0f,
             self.textureSize.width / 2.0f,                   self.textureSize.height / 2.0f, 0.0f,
        }
    };

    /* head */
    glBindTexture(GL_TEXTURE_2D, self.head.name);
    glVertexPointer(3, GL_FLOAT, 0, vertices[0]);
    glTexCoordPointer(2, GL_FLOAT, 0, coordinates[0]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    /* body */
    glBindTexture(GL_TEXTURE_2D, self.body[self.bodyFrame].name);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
    
    glVertexPointer(3, GL_FLOAT, 0, vertices[1]);
    glTexCoordPointer(2, GL_FLOAT, 0, coordinates[1]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    /* tail */
    glBindTexture(GL_TEXTURE_2D, self.tail.name);
    glVertexPointer(3, GL_FLOAT, 0, vertices[2]);
    glTexCoordPointer(2, GL_FLOAT, 0, coordinates[2]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    /*CGFloat x, step = self.body[self.bodyFrame].pixelsWide / 2 + 2;
    for (x = -halfLength + self.tail.pixelsWide / 2; x < halfLength - self.head.pixelsWide / 2; x += step)
        [self.body[self.bodyFrame] drawAtPoint:CGPointMake(x, 0)];
    [self.body[self.bodyFrame] drawInRect:CGRectMake(x, self.body[self.bodyFrame].pixelsHigh / -2, halfLength - self.head.pixelsWide / 2, self.body[self.bodyFrame].pixelsHigh / 2)];*/
    //[head drawAtPoint:CGPointMake(halfLength - head.pixelsWide / 2, head.pixelsWide / -2)];
    //[tail drawAtPoint:CGPointMake(-halfLength - tail.pixelsWide / 2,  tail.pixelsWide / -2)];
    
    glDisable(GL_TEXTURE_2D);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}


- (void)dealloc {

    self.head = nil;
    self.tail = nil;
    
    for (NSUInteger f = 0; f < self.bodyFrames; ++f) {
        [self.body[f] release];
        self.body[f] = nil;
    }
    free(self.body);
    self.body = nil;
    
    [super dealloc];
}


@end
