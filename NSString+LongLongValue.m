//
//  NSString+LongLongValue.m
//  EyeTunes
//
//  Created by Alastair on 30/05/2007.
//  Copyright 2007 liquidx.net. All rights reserved.
//

#import "NSString+LongLongValue.h"


@implementation NSString (LongLongValue)
- (long long int)longlongValue
{
	long long int v=0;
	NSScanner* scanner = [NSScanner scannerWithString:self];
	[scanner scanLongLong:&v];
	return v;
}
@end
