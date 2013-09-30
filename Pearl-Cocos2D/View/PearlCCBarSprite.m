/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  PearlCCBarSprite.m
//  Pearl
//
//  Created by Maarten Billemont on 27/06/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#define SmoothingTime 0.1f
#import "PearlCCBarSprite.h"


@interface PearlCCBarSprite ()

- (void)updateBodyFrame:(ccTime)dt;

@property (readwrite, retain) CCTexture2D          *head;
@property (readwrite, assign) CCTexture2D __strong **body;
@property (readwrite, retain) CCTexture2D          *tail;

@property (readwrite, assign) CGFloat    age;
@property (readwrite, assign) NSUInteger bodyFrame;
@property (readwrite, assign) NSUInteger bodyFrames;

@property (readwrite, assign) BOOL   animatedTargetting;
@property (readwrite, assign) ccTime smoothTimeElapsed;

@property (readwrite, assign) CGPoint current;
@property (readwrite, assign) float currentLength;

@end


@implementation PearlCCBarSprite

@synthesize head = _head, body = _body, tail = _tail;
@synthesize age = _age;
@synthesize bodyFrame = _bodyFrame, bodyFrames = _bodyFrames;
@synthesize animatedTargetting = _animatedTargetting;
@synthesize smoothTimeElapsed = _smoothTimeElapsed;
@synthesize current = _current;
@synthesize currentLength = _currentLength;
@synthesize textureSize = _textureSize, uniformColor = _uniformColor;


- (id)initWithHead:(NSString *)bundleHeadReference body:(NSString *)bundleBodyReference withFrames:(NSUInteger)bodyFrameCount
              tail:(NSString *)bundleTailReference animatedTargetting:(BOOL)anAnimatedTargetting {

    if (!(self = [super init]))
        return self;

    self.anchorPoint        = CGPointZero;
    self.visible            = NO;
    self.animatedTargetting = anAnimatedTargetting;
    self.shaderProgram      = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTexture_uColor];
    self.uniformColor       = glGetUniformLocation(_shaderProgram->_program, "u_color");

    if (bundleHeadReference)
        self.head = [[CCTextureCache sharedTextureCache] addImage:bundleHeadReference];
    if (bundleBodyReference) {
        self.bodyFrames = bodyFrameCount;
        self.body = (__strong CCTexture2D **)calloc(sizeof(CCTexture2D *), self.bodyFrames);
        if (self.bodyFrames > 1) {
            for (NSUInteger f = 0; f < self.bodyFrames; ++f)
                self.body[f] = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:bundleBodyReference, f]];
        } else
            self.body[0] = [[CCTextureCache sharedTextureCache] addImage:bundleBodyReference];

        self.bodyFrame   = 0;
        self.textureSize = CGSizeMake(self.body[self.bodyFrame].contentSize.width, self.body[self.bodyFrame].contentSize.height);
    }
    if (bundleTailReference)
        self.tail = [[CCTextureCache sharedTextureCache] addImage:bundleTailReference];

    [self schedule:@selector(updateBodyFrame:) interval:0.02f];
    if (self.animatedTargetting)
        [self schedule:@selector(update:)];

    return self;
}


- (void)updateBodyFrame:(ccTime)dt {

    self.age += dt;
    self.bodyFrame = ((NSUInteger)(self.age * 50 * self.body[0].contentSize.width / self.textureSize.width)) % self.bodyFrames;
}


- (void)update:(ccTime)dt {

    self.smoothTimeElapsed = MIN(SmoothingTime, self.smoothTimeElapsed + dt);

    CGFloat completion = self.smoothTimeElapsed / SmoothingTime;
    self.current = ccpAdd(self.current, ccpMult(ccpSub(self.target, self.current), completion));

    CGPoint bar = ccpSub(self.current, self.position);
    self.currentLength = ccpLength(bar);

    self.rotation = CC_RADIANS_TO_DEGREES(ccpToAngle(ccp(bar.x, -bar.y)));
}


- (void)setTarget:(CGPoint)t {

    if (self.animatedTargetting && self.visible) {
        _target = t;
        self.smoothTimeElapsed = 0;
    } else {
        _target = self.current = t;
        self.smoothTimeElapsed = SmoothingTime;
        [self update:0];
    }

    self.visible = !CGPointEqualToPoint(t, CGPointZero);
}

- (CGPoint)target {

    return _target;
}


- (void)draw {

    [super draw];

    CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, @"PearlCCBarSprite - draw");
    CC_NODE_DRAW_SETUP();

//    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//    //glEnableClientState(GL_VERTEX_ARRAY);
//    glDisableClientState(GL_COLOR_ARRAY);
//    //glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//    //glEnable(GL_TEXTURE_2D);
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position | kCCVertexAttribFlag_TexCoords);

    //GLfloat width = (GLfloat)body[bodyFrame]..contentSize.width * body[bodyFrame].maxS;
    //GLfloat height = (GLfloat)body[bodyFrame]..contentSize.height * body[bodyFrame].maxT;

    float lengthPx            = self.currentLength; // * CC_CONTENT_SCALE_FACTOR();
    GLfloat s                 = (lengthPx * 2 - (float)self.tail.contentSize.width / 2 - (float)self.head.contentSize.width / 2) /
                                (float)self.textureSize.width;
    GLfloat coordinates[3][8] = {
     /* head */ {
      0.0f, 1.0f,
      1.0f, 1.0f,
      0.0f, 0.0f,
      1.0f, 0.0f,
      /* body */ }, {
      0.0f, 1.0f,
      s, 1.0f,
      0.0f, 0.0f,
      s, 0.0f
      /* tail */ }, {
      0.0f, 1.0f,
      1.0f, 1.0f,
      0.0f, 0.0f,
      1.0f, 0.0f,
     }
    };

    GLfloat vertices[3][12] = {
     /* head */ {
      -(float)self.textureSize.width / 2.0f + lengthPx, -(float)self.textureSize.height / 2.0f, 0.0f,
      (float)self.textureSize.width / 2.0f + lengthPx, -(float)self.textureSize.height / 2.0f, 0.0f,
      -(float)self.textureSize.width / 2.0f + lengthPx, (float)self.textureSize.height / 2.0f, 0.0f,
      (float)self.textureSize.width / 2.0f + lengthPx, (float)self.textureSize.height / 2.0f, 0.0f,
      /* body */ }, {
      (float)self.textureSize.width / 2.0f, -(float)self.textureSize.height / 2.0f, 0.0f,
      -(float)self.textureSize.width / 2.0f + lengthPx, -(float)self.textureSize.height / 2.0f, 0.0f,
      (float)self.textureSize.width / 2.0f, (float)self.textureSize.height / 2.0f, 0.0f,
      -(float)self.textureSize.width / 2.0f + lengthPx, (float)self.textureSize.height / 2.0f, 0.0f
      /* tail */ }, {
      -(float)self.textureSize.width / 2.0f, -(float)self.textureSize.height / 2.0f, 0.0f,
      (float)self.textureSize.width / 2.0f, -(float)self.textureSize.height / 2.0f, 0.0f,
      -(float)self.textureSize.width / 2.0f, (float)self.textureSize.height / 2.0f, 0.0f,
      (float)self.textureSize.width / 2.0f, (float)self.textureSize.height / 2.0f, 0.0f,
     }
    };

    GLfloat colors[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    [self.shaderProgram setUniformLocation:self.uniformColor with4fv:colors count:1];

    /* head */
    ccGLBindTexture2D(self.head.name);
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, vertices[0]);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, coordinates[0]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    /* body */
    ccGLBindTexture2D(self.body[self.bodyFrame].name);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, vertices[1]);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, coordinates[1]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    /* tail */
    ccGLBindTexture2D(self.tail.name);
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, vertices[2]);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, coordinates[2]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    /*CGFloat x, step = self.body[self.bodyFrame].contentSize.width / 2 + 2;
    for (x = -halfLength + self.tail.contentSize.width / 2; x < halfLength - self.head.contentSize.width / 2; x += step)
        [self.body[self.bodyFrame] drawAtPoint:CGPointMake(x, 0)];
    [self.body[self.bodyFrame] drawInRect:CGRectMake(x, self.body[self.bodyFrame].contentSize.height / -2, halfLength - self.head.contentSize.width / 2, self.body[self.bodyFrame].contentSize.height / 2)];*/
    //[head drawAtPoint:CGPointMake(halfLength - head.contentSize.width / 2, head.contentSize.width / -2)];
    //[tail drawAtPoint:CGPointMake(-halfLength - tail.contentSize.width / 2,  tail.contentSize.width / -2)];

//    //glDisableClientState(GL_VERTEX_ARRAY);
//    glEnableClientState(GL_COLOR_ARRAY);
//    //glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    //glDisable(GL_TEXTURE_2D);

    CHECK_GL_ERROR_DEBUG();
    CC_INCREMENT_GL_DRAWS(1);
    CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"PearlCCBarSprite - draw");
}


- (void)dealloc {
    
    for (NSUInteger f = 0; f < self.bodyFrames; ++f)
        self.body[f] = nil;
    free(self.body);
}


@end
