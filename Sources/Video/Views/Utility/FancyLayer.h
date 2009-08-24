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
//  FancyLayer.h
//  iLibs
//
//  Created by Maarten Billemont on 18/12/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//



@interface FancyLayer : Layer <CocosNodeRGBA> {

    CGSize  contentSize;
    float   outerPadding;
    float   padding;
    float   innerRatio;
    ccColor4B color;
    
    GLuint vertexBuffer;
    GLuint colorBuffer;
}

-(void) update;

@property (nonatomic, readonly) CGSize     contentSize;
@property (nonatomic, readwrite) float     outerPadding;
@property (nonatomic, readwrite) float     padding;
@property (nonatomic, readwrite) float     innerRatio;

@end
