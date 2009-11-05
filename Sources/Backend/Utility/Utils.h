//
//  Utils.h
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//


/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the right side. */
NSString* RPad(const NSString* string, NSUInteger l);
/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the left side. */
NSString* LPad(const NSString* string, NSUInteger l);
/** Generate a string where the ordinal suffix of the given number is appended to the given prefix. */
NSString* AppendOrdinalPrefix(const NSInteger number, const NSString* prefix);

/** YES when invoked on an iPod touch device. */
BOOL IsIPod();
/** YES when invoked on an iPhone device. */
BOOL IsIPhone();
/** YES when invoked on the iPhone simulator. */
BOOL IsSimulator();
