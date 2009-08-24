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


@implementation BarSprite

@synthesize target, textureSize;

- (id) initWithHead:(NSString *)bundleHeadReference body:(NSString *)bundleBodyReference withFrames:(NSUInteger)bodyFrameCount tail:(NSString *)bundleTailReference animatedTargetting:(BOOL)anAnimatedTargetting {
    
    if (!(self = [super init]))
        return self;
    
    self.anchorPoint        = CGPointZero;
    self.visible            = NO;
    animatedTargetting      = anAnimatedTargetting;

    if (bundleHeadReference)
        head = [[[TextureMgr sharedTextureMgr] addImage:bundleHeadReference] retain];
    if (bundleBodyReference) {
        bodyFrames = bodyFrameCount;
        body = malloc(sizeof(Texture2D *) * bodyFrames);
        if (bodyFrames > 1) {
            for (NSUInteger f = 0; f < bodyFrames; ++f)
                body[f] = [[[TextureMgr sharedTextureMgr] addImage:[NSString stringWithFormat:bundleBodyReference, f]] retain];
        } else
            body[0] = [[[TextureMgr sharedTextureMgr] addImage:bundleBodyReference] retain];
        
        bodyFrame = 0;
        textureSize = CGSizeMake(body[bodyFrame].pixelsWide, body[bodyFrame].pixelsHigh);
    }
    if (bundleTailReference)
        tail = [[[TextureMgr sharedTextureMgr] addImage:bundleTailReference] retain];
    
    [self schedule:@selector(updateBodyFrame:) interval:0.02f];
    if (animatedTargetting)
        [self schedule:@selector(update:)];
    
    return self;
}


- (void)updateBodyFrame:(ccTime)dt {
    
    age                 += dt;
    bodyFrame           = ((NSUInteger) (age * 50 * body[0].pixelsWide / textureSize.width)) % bodyFrames;
}


- (void)update:(ccTime)dt {
    
    smoothTimeElapsed   = fminf(kSmoothingTime, smoothTimeElapsed + dt);

    CGFloat completion  = smoothTimeElapsed / kSmoothingTime;
    current             = ccpAdd(current, ccpMult(ccpSub(target, current), completion));
    
    CGPoint bar         = ccpSub(current, self.position);
    currentLength       = ccpLength(bar);
    
    self.rotation       = CC_RADIANS_TO_DEGREES(ccpToAngle(ccp(bar.x, -bar.y)));
}


- (void)setTarget:(CGPoint)t {
    
    if (animatedTargetting && self.visible) {
        target                  = t;
        smoothTimeElapsed       = 0;
    } else {
        target = current        = t;
        smoothTimeElapsed       = kSmoothingTime;
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

    GLfloat s = (currentLength * 2 - tail.pixelsWide / 2 - head.pixelsWide / 2) / textureSize.width;
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
            -textureSize.width / 2.0f + currentLength,  -textureSize.height / 2.0f, 0.0f,
             textureSize.width / 2.0f + currentLength,  -textureSize.height / 2.0f, 0.0f,
            -textureSize.width / 2.0f + currentLength,   textureSize.height / 2.0f, 0.0f,
             textureSize.width / 2.0f + currentLength,   textureSize.height / 2.0f, 0.0f,
        /* body */ }, {
             textureSize.width / 2.0f,                  -textureSize.height / 2.0f, 0.0f,
            -textureSize.width / 2.0f + currentLength,  -textureSize.height / 2.0f, 0.0f,
             textureSize.width / 2.0f,                   textureSize.height / 2.0f, 0.0f,
            -textureSize.width / 2.0f + currentLength,   textureSize.height / 2.0f, 0.0f
        /* tail */ }, {
            -textureSize.width / 2.0f,                  -textureSize.height / 2.0f, 0.0f,
             textureSize.width / 2.0f,                  -textureSize.height / 2.0f, 0.0f,
            -textureSize.width / 2.0f,                   textureSize.height / 2.0f, 0.0f,
             textureSize.width / 2.0f,                   textureSize.height / 2.0f, 0.0f,
        }
    };

    /* head */
    glBindTexture(GL_TEXTURE_2D, head.name);
    glVertexPointer(3, GL_FLOAT, 0, vertices[0]);
    glTexCoordPointer(2, GL_FLOAT, 0, coordinates[0]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    /* body */
    glBindTexture(GL_TEXTURE_2D, body[bodyFrame].name);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
    
    glVertexPointer(3, GL_FLOAT, 0, vertices[1]);
    glTexCoordPointer(2, GL_FLOAT, 0, coordinates[1]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    /* tail */
    glBindTexture(GL_TEXTURE_2D, tail.name);
    glVertexPointer(3, GL_FLOAT, 0, vertices[2]);
    glTexCoordPointer(2, GL_FLOAT, 0, coordinates[2]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    /*CGFloat x, step = body[bodyFrame].pixelsWide / 2 + 2;
    for (x = -halfLength + tail.pixelsWide / 2; x < halfLength - head.pixelsWide / 2; x += step)
        [body[bodyFrame] drawAtPoint:CGPointMake(x, 0)];
    [body[bodyFrame] drawInRect:CGRectMake(x, body[bodyFrame].pixelsHigh / -2, halfLength - head.pixelsWide / 2, body[bodyFrame].pixelsHigh / 2)];*/
    //[head drawAtPoint:CGPointMake(halfLength - head.pixelsWide / 2, head.pixelsWide / -2)];
    //[tail drawAtPoint:CGPointMake(-halfLength - tail.pixelsWide / 2,  tail.pixelsWide / -2)];
    
    glDisable(GL_TEXTURE_2D);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}


- (void)dealloc {

    [head release];
    head = nil;
    
    [tail release];
    tail = nil;
    
    for (NSUInteger f = 0; f < bodyFrames; ++f) {
        [body[f] release];
        body[f] = nil;
    }
    free(body);
    body = nil;
    
    [super dealloc];
}


@end
