/*
 
 EyeTunes.framework - Cocoa iTunes Interface
 http://www.liquidx.net/eyetunes/
 
 Copyright (c) 2005, Alastair Tse <alastair@liquidx.net>
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

/* Notes about generating AEGizmo Strings
 - If you can, use AEMonitor (free for 10 days)
 - If not, use the TN2056's gdb trick, but beware of a few gotchas:
   exmn($$) -> exmn()
   form: always expects a character code, eg: form:enum('indx') or form:'indx' or form:indx. These are equiv.
   never care about the &cxxx ones, they are not needed.

*/

#import "ETAppleEventObject.h"


@implementation ETAppleEventObject

#pragma mark -
#pragma mark Init/Dealloc
#pragma mark -

- (id) init
{
	self = [super init];
	if (self) {
		refDescriptor = malloc(sizeof(AEDesc));
		refDescriptor->descriptorType = typeNull;
		refDescriptor->dataHandle = nil;
		targetApplCode = ET_APPLE_EVENT_OBJECT_DEFAULT_APPL;
	}
	return self;
}

- (id) initWithDescriptor:(AEDesc *)aDesc applCode:(OSType)applCode
{
	if (self) {
		refDescriptor = malloc(sizeof(AEDesc));
		memcpy(refDescriptor, aDesc, sizeof(AEDesc));
		targetApplCode = applCode;
	}
	return self;
}

- (void) dealloc
{
	AEDisposeDesc(refDescriptor);
	free(refDescriptor);
	[super dealloc];
}

- (AEDesc *)descriptor
{
	return refDescriptor;
}

+ (void) printDescriptor:(AEDesc *)desc
{
	OSErr err;
	Handle debug;
	err = AEPrintDescToHandle(desc, &debug);
	if (err != noErr) {
		ETLog(@"Error printing desc: %d", err);
		return;
	}
	ETLog(@"Apple Event Descriptor Dump:");
	ETLog(@"%s", debug[0]);
	DisposeHandle(debug);
}

+ (AliasHandle)newAliasHandleWithPath:(NSString *)path
{
	AliasHandle alias;
	FSRef fsRef;
	NSURL *url = [NSURL fileURLWithPath:path];

	if (!CFURLGetFSRef((CFURLRef)url, &fsRef)) {
		return nil;
	}
	
	if (!FSNewAliasMinimal(&fsRef, &alias)) {
		return alias;
	}
	return nil;
}
		

#pragma mark -
#pragma mark AEGizmo Strings
#pragma mark -

- (NSString *)eventParameterStringForCountElementsOfClass:(DescType)classType
{
	NSString *parameterString = [NSString stringWithFormat:@"kocl:type(%@) , '----':@", NSFileTypeForHFSTypeCode(classType)];
	return parameterString;
}

- (NSString *)eventParameterStringForDeleteElementsOfClass:(DescType)classType
{
	NSString *parameterString = [NSString stringWithFormat:@"'----':obj { form:indx, want:type(%@), seld:abso('all '), from:@ }", 
															NSFileTypeForHFSTypeCode(classType)];
	return parameterString;
}

- (NSString *)eventParameterStringForElementOfClass:(DescType)classType atIndex:(int)index
{
	NSString *parameterString = [NSString stringWithFormat:@"'----':obj { form:indx, want:type(%@), seld:%d, from:@ }", NSFileTypeForHFSTypeCode(classType), index];
	return parameterString;	
}

- (NSString *)eventParameterStringForProperty:(DescType)descType
{
	NSString *parameterString = [NSString stringWithFormat:@"'----':obj { form:prop, want:type(prop), seld:type(%@), from:@ }", NSFileTypeForHFSTypeCode(descType)];
	return parameterString;
}

- (NSString *)eventParameterStringForSettingProperty:(DescType)descType
{
	NSString *parameterString = [NSString stringWithFormat:@"data:@, '----':obj { form:prop, want:type(prop), seld:type(%@), from:@ }", NSFileTypeForHFSTypeCode(descType)];
	return parameterString;
}

- (NSString *)eventParameterStringForSettingElementOfClass:(DescType)classType atIndex:(int)index
{
	NSString *parameterString = [NSString stringWithFormat:@"data:@, '----':obj { form:indx, want:type(%@), seld:%d, from:@ }", NSFileTypeForHFSTypeCode(classType), index];
	return parameterString;	
}

- (NSString *)eventParameterStringForSettingProperty:(DescType)propertyType OfElementOfClass:(DescType)classType atIndex:(int)index
{
	NSString *parameterString = [NSString stringWithFormat:@"data:@, '----':obj { form:prop, want:type(prop), seld:type(%@), from:obj { form:indx, want:type(%@), seld:%d, from:@ }}", 
		NSFileTypeForHFSTypeCode(propertyType), NSFileTypeForHFSTypeCode(classType), index];
	return parameterString;	
}

- (NSString *)eventParameterStringForTestObject:(DescType)objectType forProperty:(DescType)propertyType forIntValue:(int)value
{
	NSString *parameterString = [NSString stringWithFormat:@"obj { form:test, want:type(%@), from:@, seld:cmpd{relo:=, 'obj1': obj{ form:prop, want:type(prop), seld:type(%@), from:exmn()}, obj2:%d}}",
		 NSFileTypeForHFSTypeCode(objectType),
		NSFileTypeForHFSTypeCode(propertyType),
		value];
	return parameterString;		
}

- (NSString *)eventParameterStringForSearchingType:(DescType)objectType withTest:(NSString *)testString
{
	NSString *parameterString = [NSString stringWithFormat:@"'----':obj { form:indx, want:type(%@), seld:'abso'('any '), from:%@ }",
		NSFileTypeForHFSTypeCode(objectType),
		testString];
	return parameterString;
}



#pragma mark -
#pragma mark Get/Set Object "Property"
#pragma mark -

- (BOOL) setPropertyWithValue:(AEDesc *)valueDesc ofType:(DescType)descType forObject:(AEDesc *)targetObject;
{
	OSErr err;
	AppleEvent setEvent;

	err = AEBuildAppleEvent(kAECoreSuite,
							'setd',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&setEvent,
							NULL,
							[[self eventParameterStringForSettingProperty:descType] lossyCString], 
							valueDesc,
							targetObject);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return NO;
	}
	
	err = AESendMessage(&setEvent, NULL, kAENoReply, kAEDefaultTimeout);
	AEDisposeDesc(&setEvent);	
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		return NO;
	}
	
	return YES;
	
}

- (AppleEvent *) getPropertyOfType:(DescType)descType forObject:(AEDesc *)targetObject;
{
	OSErr err;
	AppleEvent getEvent;
	AppleEvent *replyEvent = nil;
	
	err = AEBuildAppleEvent(kAECoreSuite,
							'getd',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&getEvent,
							NULL,
							[[self eventParameterStringForProperty:descType] lossyCString], 
							targetObject);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return nil;
	}
	
	replyEvent = malloc(sizeof(AppleEvent));
	err = AESendMessage(&getEvent, replyEvent, kAEWaitReply + kAENeverInteract, kAEDefaultTimeout);
	AEDisposeDesc(&getEvent);	
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		free(replyEvent);
		return nil;
	}

	return replyEvent;
}


- (AppleEvent *) getPropertyOfType:(DescType)descType;
{
	return [self getPropertyOfType:descType forObject:refDescriptor];
}


- (BOOL) setPropertyWithValue:(AEDesc *)value ofType:(DescType)descType;
{
	return [self setPropertyWithValue:value ofType:descType forObject:refDescriptor];
}

#pragma mark -
#pragma mark Count/Get/Set Object Elements
#pragma mark -

- (int) getCountOfElementsOfClass:(DescType)descType
{
	OSErr err;
	AppleEvent getEvent;
	AppleEvent *replyEvent = nil;
	DescType	resultType;
	Size		resultSize;	
	int count;
	
	err = AEBuildAppleEvent(kAECoreSuite,
							'cnte',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&getEvent,
							NULL,
							[[self eventParameterStringForCountElementsOfClass:descType] lossyCString], 
							refDescriptor);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return -1;
	}

	replyEvent = malloc(sizeof(AppleEvent));
	err = AESendMessage(&getEvent, replyEvent, kAEWaitReply + kAENeverInteract, kAEDefaultTimeout);
	AEDisposeDesc(&getEvent);
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		free(replyEvent);
		return -1;
	}
	
	err = AEGetParamPtr(replyEvent, keyDirectObject, typeInteger, &resultType, 
						&count, sizeof(count), &resultSize);
	if (err != noErr) {
		ETLog(@"Unable to get parameter of reply: %d", err);
		return -1;
	}
	
	AEDisposeDesc(replyEvent);
	free(replyEvent);
	
	return count;
} 

- (AppleEvent *) deleteAllElementsOfClass:(DescType)descType
{
	OSErr err;
	AppleEvent getEvent;
	AppleEvent *replyEvent = nil;
	
	
	err = AEBuildAppleEvent(kAECoreSuite,
							'delo',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&getEvent,
							NULL,
							[[self eventParameterStringForDeleteElementsOfClass:descType] lossyCString], 
							refDescriptor);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return nil;
	}
	
	replyEvent = malloc(sizeof(AppleEvent));
	err = AESendMessage(&getEvent, replyEvent, kAEWaitReply + kAENeverInteract, kAEDefaultTimeout);
	AEDisposeDesc(&getEvent);
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		free(replyEvent);
		return nil;
	}
	
	return replyEvent;
} 

- (AppleEvent *) deleteElement:(int)index OfClass:(DescType)descType
{
	OSErr err;
	AppleEvent getEvent;
	AppleEvent *replyEvent = nil;
	
	
	err = AEBuildAppleEvent(kAECoreSuite,
							'delo',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&getEvent,
							NULL,
							[[self eventParameterStringForElementOfClass:descType atIndex:(index+1)] lossyCString], 
							refDescriptor);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return nil;
	}
	
	replyEvent = malloc(sizeof(AppleEvent));
	err = AESendMessage(&getEvent, replyEvent, kAEWaitReply + kAENeverInteract, kAEDefaultTimeout);
	AEDisposeDesc(&getEvent);
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		free(replyEvent);
		return nil;
	}
	
	return replyEvent;
} 


- (AppleEvent *) getElementOfClass:(DescType)classType atIndex:(int)index;
{
	OSErr err;
	AppleEvent getEvent;
	AppleEvent *replyEvent = nil;
	
	err = AEBuildAppleEvent(kAECoreSuite,
							'getd',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&getEvent,
							NULL,
							[[self eventParameterStringForElementOfClass:classType atIndex:(index+1)] lossyCString], 
							refDescriptor);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return nil;
	}

	replyEvent = malloc(sizeof(AppleEvent));
	err = AESendMessage(&getEvent, replyEvent, kAEWaitReply + kAENeverInteract, kAEDefaultTimeout);
	AEDisposeDesc(&getEvent);
	
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		free(replyEvent);
		return nil;
	}
	
	return replyEvent;
}

- (AppleEvent *)	getElementOfClass:(DescType)classType byKey:(DescType)key withIntValue:(int)value
{
	OSErr err;
	AppleEvent getEvent;
	AppleEvent *replyEvent = nil;
	
	// TODO: make this generic (not specific to just int values)
	NSString *testString = [self eventParameterStringForTestObject:classType forProperty:key forIntValue:value];
	NSString *eventString = [self eventParameterStringForSearchingType:classType withTest:testString];
	
	err = AEBuildAppleEvent(kAECoreSuite,
							'getd',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&getEvent,
							NULL,
							[eventString lossyCString],
							refDescriptor);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return nil;
	}
	
	replyEvent = malloc(sizeof(AppleEvent));
	err = AESendMessage(&getEvent, replyEvent, kAEWaitReply + kAENeverInteract, kAEDefaultTimeout);
	AEDisposeDesc(&getEvent);
	
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		free(replyEvent);
		return nil;
	}
	
	return replyEvent;
}

- (BOOL) setElementOfClass:(DescType)classType atIndex:(int)index withValue:(AEDesc *)value
{
	OSErr err;
	AppleEvent setEvent;
	
	err = AEBuildAppleEvent(kAECoreSuite,
							'setd',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&setEvent,
							NULL,
							[[self eventParameterStringForSettingElementOfClass:classType atIndex:(index+1)] lossyCString],
							value,
							refDescriptor);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return NO;
	}
	

	err = AESendMessage(&setEvent, NULL, kAENoReply, kAEDefaultTimeout);
	AEDisposeDesc(&setEvent);
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		return NO;
	}
	
	return YES;
}

- (BOOL) setProperty:(DescType)propertyType OfElementOfClass:(DescType)classType atIndex:(int)index withValue:(AEDesc *)value
{
	OSErr err;
	AppleEvent setEvent;
	
	err = AEBuildAppleEvent(kAECoreSuite,
							'setd',
							typeApplSignature,
							&targetApplCode,
							sizeof(targetApplCode),
							kAutoGenerateReturnID,
							kAnyTransactionID,
							&setEvent,
							NULL,
							[[self eventParameterStringForSettingProperty:propertyType OfElementOfClass:classType atIndex:(index+1)] lossyCString],
							value,
							refDescriptor);
	
	if (err != noErr) {
		ETLog(@"Error creating Apple Event: %d", err);
		return NO;
	}
	
	
	err = AESendMessage(&setEvent, NULL, kAENoReply, kAEDefaultTimeout);
	AEDisposeDesc(&setEvent);
	if (err != noErr) {
		ETLog(@"Error sending Apple Event: %d", err);
		return NO;
	}
	
	return YES;
}




#pragma mark -
#pragma mark Get/Set Integer/String (Common Types) as Property
#pragma mark -


- (int) getPropertyAsIntegerForDesc:(DescType)descType
{
	OSErr err;
	
	int			replyValue = -1;
	DescType	resultType;
	Size		resultSize;
	
	AppleEvent *replyEvent = [self getPropertyOfType:descType];
	
	if (!replyEvent) {
		// TODO: raise exception?
		return -1;
	}
	
	/* Read Results */
	err = AEGetParamPtr(replyEvent, keyDirectObject, typeInteger, &resultType, 
						&replyValue, sizeof(replyValue), &resultSize);
	if (err != noErr) {
		ETLog(@"Error extracting parameters from reply: %d", err);
	}
	
	AEDisposeDesc(replyEvent);
	free(replyEvent);
	return replyValue;
}

- (NSString *)getPropertyAsStringForDesc:(DescType)descType
{
	OSErr err;
	
	UniChar		*replyValue = NULL;
	DescType	resultType;
	Size		resultSize;
	NSString	*replyString = nil;
	
	AppleEvent *replyEvent = [self getPropertyOfType:descType];
	if (!replyEvent) {
		// TODO: raise exception?
		return nil;
	}
	
	err = AESizeOfParam(replyEvent, keyDirectObject, &resultType, &resultSize);
	if (err != noErr) {
		ETLog(@"Unable to find length of reply string: %d", err);
		goto cleanup_reply;
	}
	
	replyValue = malloc(resultSize + 1);
	if (replyValue == NULL) {
		// TODO: raise No Memory Exception
		ETLog(@"No Memory Available");
		goto cleanup_reply;
	}
	
	
	err = AEGetParamPtr(replyEvent, keyDirectObject, typeUnicodeText, &resultType, 
						replyValue, resultSize, &resultSize);
	if (err != noErr) {
		// TODO: raise error
		ETLog(@"Unable to get parameter of reply: %d", err);
		goto cleanup_reply_and_tempstring;
	}
	
	replyString = [[[NSString alloc] initWithBytes:replyValue 
											length:resultSize 
										  encoding:NSUnicodeStringEncoding] autorelease];
	
cleanup_reply_and_tempstring:
		free(replyValue);
cleanup_reply:
		AEDisposeDesc(replyEvent);
	free(replyEvent);
	replyEvent = NULL;
	
	return replyString;
}

- (NSString *) getPropertyAsPathForDesc:(DescType)descType
{
	NSString *urlString = [self getPropertyAsPathURLForDesc:descType];
	if (urlString && [[NSURL URLWithString:urlString] isFileURL]) {
		return [[NSURL URLWithString:urlString] path];
	}
	return nil;
}

- (NSString *) getPropertyAsPathURLForDesc:(DescType)descType
{
	OSErr err;
	
	FSRef		fsRef;
	DescType	resultType;
	Size		resultSize;
	NSString	*urlString = nil;
	
	AppleEvent *replyEvent = [self getPropertyOfType:descType];
	
	if (!replyEvent) {
		// TODO: raise exception?
		return nil;
	}
	
	/* Read Results */
	err = AEGetParamPtr(replyEvent, keyDirectObject, typeFSRef, &resultType, 
						&fsRef, sizeof(fsRef), &resultSize);
	if (err != noErr) {
		ETLog(@"Error extracting parameters from reply: %d", err);
	}
	AEDisposeDesc(replyEvent);
	free(replyEvent);
	
	/* Convert Alias to NSString */
	CFURLRef resolvedURL = CFURLCreateFromFSRef(NULL, &fsRef);
	if (resolvedURL) {
		urlString = [(NSURL *)resolvedURL absoluteString];
		CFRelease(resolvedURL);
	}
	
	return urlString;
}


- (NSDate *) getPropertyAsDateForDesc:(DescType)descType
{
	OSErr err;

	LongDateTime replyValue;	
	DescType	resultType;
	Size		resultSize;
	
	CFAbsoluteTime absoluteDate;
	NSDate		*resultDate = nil;

		
	AppleEvent *replyEvent = [self getPropertyOfType:descType];
	
	if (!replyEvent) {
		// TODO: raise exception?
		return nil;
	}
	
	/* Read Results */
	err = AEGetParamPtr(replyEvent, keyDirectObject, typeLongDateTime, &resultType, 
						&replyValue, sizeof(replyValue), &resultSize);
	if (err != noErr) {
		ETLog(@"Error extracting parameters from reply: %d", err);
	}
	
	err = UCConvertLongDateTimeToCFAbsoluteTime(replyValue, &absoluteDate);
	if (err != noErr) {
		ETLog(@"Error converting Long Date to CFAbsoluteTime");
	}
	
	resultDate = [NSDate dateWithTimeIntervalSinceReferenceDate:absoluteDate];
	
	AEDisposeDesc(replyEvent);
	free(replyEvent);
	return resultDate;
}


- (BOOL) setPropertyWithInteger:(int)value forDesc:(DescType)descType;
{
	OSErr err;
	AEDesc valueDesc;
	BOOL success;
	
	err = AEBuildDesc(&valueDesc, NULL, "long(@)", value);
	if (err != noErr) {
		ETLog(@"Error constructing parameters for set command: %d", err);
		return NO;
	}
	
	success = [self setPropertyWithValue:&valueDesc ofType:descType];
	AEDisposeDesc(&valueDesc);
	return success;
}

- (BOOL) setPropertyWithString:(NSString *)value forDesc:(DescType)descType;
{
	OSErr err;
	AEDesc valueDesc;
	BOOL success = NO;
	
	int len = [value lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
	
	err = AEBuildDesc(&valueDesc, NULL, "'utxt'(@)", len,  [value cStringUsingEncoding:NSUnicodeStringEncoding]);
	if (err != noErr) {
		ETLog(@"Error constructing parameters for set command: %d", err);
		return NO;
	}
	
	
	success = [self setPropertyWithValue:&valueDesc ofType:descType];
	AEDisposeDesc(&valueDesc);
	return success;
}

- (BOOL) setPropertyWithDate:(NSDate *)value forDesc:(DescType)descType;
{
	OSErr err;
	AEDesc valueDesc;
	BOOL success = NO;
	LongDateTime longDate;
	
	err = UCConvertCFAbsoluteTimeToLongDateTime([value timeIntervalSinceReferenceDate], &longDate);
	if (err != noErr) {
		ETLog(@"Error converting Date: %d", err);
		return NO;
	}
	
	err = AEBuildDesc(&valueDesc, NULL, "'ldt '(@)", sizeof(longDate), &longDate);
	if (err != noErr) {
		ETLog(@"Error constructing parameters for set command: %d", err);
		return NO;
	}
	
	
	success = [self setPropertyWithValue:&valueDesc ofType:descType];
	AEDisposeDesc(&valueDesc);
	return success;
}

/* OLD RETIRED CODE -- HERE JUST IN CASE I NEED IT */

#pragma mark -
#pragma mark Old Retired Code
#pragma mark -
#if 0

- (NSString *)_parameterStringForProperty:(DescType)descType
{
	NSString *parameterString = [NSString stringWithFormat:@"'obj '{ form:'prop', want:type('prop'), seld:type(%@), from:@ }", NSFileTypeForHFSTypeCode(descType)];
	return parameterString;
}

- (AppleEvent *) getPropertyWithDesc:(DescType)descType;
{
	OSErr err;
	NSException *resultingException = nil;
	AppleEvent *replyEvent;
	AEAddressDesc *iTunesDescriptor = [[EyeTunes sharedInstance] iTunesDescriptor];
	AppleEvent *getEvent = [[EyeTunes sharedInstance] newPropertyGetEvent];
	
	if (!getEvent) {
		[[NSException exceptionWithName:@"EyeTunesAppleEventException"
								 reason:@"Unable to create AppleEvent Object"
							   userInfo:nil] raise];
		return nil;
	}
	
	
	/* Build Params */
	AEDesc parameterDescriptor;
	err = AEBuildDesc(&parameterDescriptor, NULL,
					  [[self _parameterStringForProperty:descType] lossyCString],
					  trackDescriptor);
	if (err != noErr) {
		NSDictionary *errorDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:err] forKey:@"Error Code"];
		resultingException = [NSException exceptionWithName:@"EyeTunesAppleEventException"
													 reason:@"Unable to build AppleEvent Parameter Descriptor"
												   userInfo:errorDict];
		goto cleanup_1;
	}
	
	/* attach parameters */
	err = AEPutParamDesc(getEvent, keyDirectObject, &parameterDescriptor);
	if (err != noErr) {
		NSDictionary *errorDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:err] forKey:@"Error Code"];
		resultingException = [NSException exceptionWithName:@"EyeTunesAppleEventException"
													 reason:@"Unable to attach Parameter Descriptor to AppleEvent"
												   userInfo:errorDict];
		goto cleanup_2;
	}
	
	/* send event */
	replyEvent = malloc(sizeof(AppleEvent));
	err = AESendMessage(getEvent, replyEvent, kAEWaitReply + kAENeverInteract, kAEDefaultTimeout);
	if (err != noErr) {
		NSDictionary *errorDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:err] forKey:@"Error Code"];
		resultingException = [NSException exceptionWithName:@"EyeTunesAppleEventException"
													 reason:@"Failed to send AppleEvent"
												   userInfo:errorDict];
		replyEvent = NULL;
	}
	
cleanup_2:	
		AEDisposeDesc(&parameterDescriptor);
cleanup_1:
		[[EyeTunes sharedInstance] releaseEvent:getEvent];
	if (resultingException != nil) {
		[resultingException raise];
	}
	return replyEvent;
}
#endif



@end
