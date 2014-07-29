//
//  UIColor+ColorWithHex.m
//  ColorWithHex
//
//  Created by Angelo Villegas on 3/24/11.
//  Copyright (c) 2011 Angelo Villegas. All rights reserved.
//	http://www.studiovillegas.com/
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "UIColor+ColorWithHex.h"


@implementation UIColor (ColorWithHex)

#pragma mark - Category Methods
// Direct Conversion to hexadecimal (Automatic)
+ (UIColor *)colorWithHex:(UInt32)hexadecimal
{
	CGFloat red, green, blue;
	
	// bitwise AND operation
	// hexadecimal's first 2 values
	red = ( hexadecimal >> 16 ) & 0xFF;
	// hexadecimal's 2 middle values
	green = ( hexadecimal >> 8 ) & 0xFF;
	// hexadecimal's last 2 values
	blue = hexadecimal & 0xFF;
	
	UIColor *color = [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: 1.0f];
	return color;
}

+ (UIColor *)colorWithAlphaHex:(UInt32)hexadecimal
{
	CGFloat red, green, blue, alpha;
	
	// bitwise AND operation
	// hexadecimal's first 2 values
	alpha = ( hexadecimal >> 24 ) & 0xFF;
	// hexadecimal's third and fourth values
	red = ( hexadecimal >> 16 ) & 0xFF;
	// hexadecimal's fifth and sixth values
	green = ( hexadecimal >> 8 ) & 0xFF;
	// hexadecimal's seventh and eighth
	blue = hexadecimal & 0xFF;
	
	UIColor *color = [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: alpha / 255.0f];
    return color;
}


+ (NSString *)hexStringFromColor:(UIColor *)color
{
	NSString *string = [self hexStringFromColor: color hash: YES];
	return string;
}

+ (NSString *)hexStringFromColor:(UIColor *)color hash:(BOOL)withHash
{
	// get the color components of the color
	const NSUInteger totalComponents = CGColorGetNumberOfComponents( [color CGColor] );
	const CGFloat *components = CGColorGetComponents( [color CGColor] );
	NSString *hexadecimal = nil;
	
	// some cases, totalComponents will only have 2 components
	// such as black, white, gray, etc..
	// multiply it by 255 and display the result using an uppercase
	// hexadecimal specifier (%X) with a character length of 2
	switch ( totalComponents )
	{
		case 4 :
			hexadecimal = [NSString stringWithFormat: @"#%02X%02X%02X" , (int)(255 * components[0]) , (int)(255 * components[1]) , (int)(255 * components[2])];
			break;
			
		case 2 :
			hexadecimal = [NSString stringWithFormat: @"#%02X%02X%02X" , (int)(255 * components[0]) , (int)(255 * components[0]) , (int)(255 * components[0])];
			break;
			
		default:
			break;
	}
	
	return hexadecimal;
}

+ (NSString *)hexStringWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
	UIColor *color = [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f];
	NSString *string = [self hexStringFromColor: color];
	return string;
}

+ (UIColor *)randomColor
{
	static BOOL generated = NO;
	
	// ff the randomColor hasn't been generated yet,
	// reset the time to generate another sequence
	if ( !generated )
	{
		generated = YES;
		srandom( (int)time( NULL ) );
	}
	
	// generate a random number and divide it using the
	// maximum possible number random() can be generated
	CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
	
	UIColor *color = [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f];
	return color;
}


@end
