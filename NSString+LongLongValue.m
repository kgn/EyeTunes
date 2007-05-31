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
	long long int v = strtoull([self cString], NULL, 16);
	return v;
}
@end
