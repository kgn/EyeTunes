/* ETAppleEventObject.h -- Proxy Object For AppleEvent iTunes Objects 
					       forwards parameter/element requests through 
						   AppleEvent transparently */

/*
 
 EyeTunes.framework - Cocoa iTunes Interface
 http://www.liquidx.net/eyetunes/
 
 Copyright (c) 2005-2007, Alastair Tse <alastair@liquidx.net>
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 Neither the Alastair Tse nor the names of its contributors may
 be used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
*/

// Important URLs: 
// http://developer.apple.com/documentation/mac/IAC/IAC-230.html

#import "EyeTunesEventCodes.h"

#define ET_APPLE_EVENT_OBJECT_DEFAULT_APPL 'hook'

@interface ETAppleEventObject : NSObject {
	AEDesc *refDescriptor;
	OSType targetApplCode;
}

- (id) initWithDescriptor:(AEDesc *)aDesc applCode:(OSType)applCode;
- (AEDesc *)descriptor;


+ (AliasHandle)newAliasHandleWithPath:(NSString *)path;

// AEGizmo String Generation
- (NSString *) stringForOSType: (DescType) descType;
- (NSString *)	eventParameterStringForCountElementsOfClass:(DescType)classType;
- (NSString *)	eventParameterStringForElementOfClass:(DescType)classType atIndex:(int)index;
- (NSString *)	eventParameterStringForProperty:(DescType)descType;
- (NSString *)	eventParameterStringForSettingProperty:(DescType)descType;
- (NSString *)	eventParameterStringForSettingProperty:(DescType)propertyType OfElementOfClass:(DescType)classType atIndex:(int)index;
- (NSString *)	eventParameterStringForTestObject:(DescType)objectType 
									  forProperty:(DescType)propertyType 
									  forIntValue:(int)value;
- (NSString *)	eventParameterStringForTestObject:(DescType)objectType 
									  forProperty:(DescType)propertyType 
									  forStringValue:(NSString *)value;
- (NSString *)	eventParameterStringForTestObject:(DescType)objectType 
									  forProperty:(DescType)propertyType;

- (NSString *)	eventParameterStringForSearchingType:(DescType)objectType withTest:(NSString *)testString;

// Get/Set Object "Properties"
- (AppleEvent *) getPropertyOfType:(DescType)descType forObject:(AEDesc *)targetObject;
- (AppleEvent *) getPropertyOfType:(DescType)descType;
- (BOOL) setPropertyWithValue:(AEDesc *)valueDesc ofType:(DescType)descType forObject:(AEDesc *)targetObject;
- (BOOL) setPropertyWithValue:(AEDesc *)valueDesc ofType:(DescType)descType;

// Count/Get/Set Object "Elements"
- (int)				getCountOfElementsOfClass:(DescType)descType;
- (AppleEvent *)	getElementOfClass:(DescType)classType atIndex:(int)index;
- (AppleEvent *)	deleteAllElementsOfClass:(DescType)descType;
- (AppleEvent *)	getElementOfClass:(DescType)classType 
								byKey:(DescType)key 
						 withIntValue:(int)value;
- (AppleEvent *)	getElementOfClass:(DescType)classType 
								byKey:(DescType)key 
					 withLongIntValue:(long long int)value;
- (AppleEvent *)	getElementOfClass:(DescType)classType 
								byKey:(DescType)key 
					  withStringValue:(NSString *)value;

// not working yet
//- (AppleEvent *) deleteElement:(int)index OfClass:(DescType)descType;
- (BOOL) setElementOfClass:(DescType)classType atIndex:(int)index withValue:(AEDesc *)value;
- (BOOL) setProperty:(DescType)propertyType OfElementOfClass:(DescType)classType atIndex:(int)index withValue:(AEDesc *)value;

// Get/Set Properties directly
- (DescType)    getPropertyAsEnumForDesc:(DescType)descType;
- (int)			getPropertyAsIntegerForDesc:(DescType)descType;
- (long long int)	getPropertyAsLongIntegerForDesc:(DescType)descType;
- (NSString *)	getPropertyAsStringForDesc:(DescType)descType;
- (NSDate *)	getPropertyAsDateForDesc:(DescType)descType;
- (NSString *)  getPropertyAsPathForDesc:(DescType)descType;
- (NSString *)  getPropertyAsPathURLForDesc:(DescType)descType;
- (NSString *)	getPropertyAsVersionForDesc:(DescType)descType;

- (BOOL)		setPropertyWithInteger:(int)value forDesc:(DescType)descType;
- (BOOL)		setPropertyWithLongInteger:(long long int)value forDesc:(DescType)descType;
- (BOOL)		setPropertyWithString:(NSString *)value forDesc:(DescType)descType;
- (BOOL)		setPropertyWithDate:(NSDate *)value forDesc:(DescType)descType;
// Debug functions
#ifdef ET_DEBUG
+ (void) printDescriptor:(AEDesc *)desc;
+ (NSString *) debugHexDump:(void *)ptr ofLength:(int)len;
- (NSArray *)	getPropertyAsIntegerWithDumpForDesc:(DescType)descType;
- (NSArray *)	getPropertyAsStringWithDumpForDesc:(DescType)descType;
- (NSArray *)	getPropertyAsDateWithDumpForDesc:(DescType)descType;
- (NSArray *)  getPropertyAsPathURLWithDumpForDesc:(DescType)descType;
#endif


@end
