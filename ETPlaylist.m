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

#import "EyeTunesVersions.h"
#import "EyeTunesEventCodes.h"
#import "ETEyeTunes.h"
#import "ETTrackEnumerator.h"
#import "ETPlaylist.h"
#import "NSString+LongLongValue.h"

#import "ETDebug.h"

@implementation ETPlaylist

- (id) initWithDescriptor:(AEDesc *)desc
{
	self = [super initWithDescriptor:desc applCode:ET_APPLE_EVENT_OBJECT_DEFAULT_APPL];
	return self;
}

- (NSString *)name
{
	return [self getPropertyAsStringForDesc:ET_ITEM_PROP_NAME];
}

- (NSArray *)tracks
{
	return [[self trackEnumerator] allObjects];
}

- (int) trackCount
{
	return [self getCountOfElementsOfClass:ET_CLASS_TRACK];
}

- (NSEnumerator *)trackEnumerator
{
	return [[[ETTrackEnumerator alloc] initWithPlaylist:self] autorelease];
}

- (ETTrack *)trackWithDatabaseId:(int)databaseId
{
	
	ETTrack *foundTrack = nil;
	AppleEvent *replyEvent = [self getElementOfClass:ET_CLASS_TRACK 
											   byKey:ET_TRACK_PROP_DATABASE_ID 
										withIntValue:databaseId];
	
	/* Read Results */
	AEDesc replyObject;
	OSErr err;
	err = AEGetParamDesc(replyEvent, keyDirectObject, typeWildCard, &replyObject);
	if (err != noErr) {
		ETLog(@"Error extracting from reply event: %d", err);
		goto cleanup_reply_event;
	}
	
	foundTrack = [[[ETTrack alloc] initWithDescriptor:&replyObject] autorelease];
	
cleanup_reply_event:
	AEDisposeDesc(replyEvent);
	free(replyEvent);
	
	return foundTrack;
}

- (ETTrack *)trackWithPersistentId:(long long int)persistentId
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0])
		return nil;

	ETTrack *foundTrack = nil;
	AppleEvent *replyEvent;

	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2]) {
		replyEvent = [self getElementOfClass:ET_CLASS_TRACK
									   byKey:ET_ITEM_PROP_PERSISTENT_ID 
							withLongIntValue:persistentId];
	}
	else {
		replyEvent = [self getElementOfClass:ET_CLASS_TRACK
									   byKey:ET_ITEM_PROP_PERSISTENT_ID 
							 withStringValue:[NSString stringWithFormat:@"%llX", persistentId]];
	}
	/* Read Results */
	AEDesc replyObject;
	OSErr err;
	err = AEGetParamDesc(replyEvent, keyDirectObject, typeWildCard, &replyObject);
	if (err != noErr) {
		ETLog(@"Error extracting from reply event: %d", err);
		goto cleanup_reply_event;
	}
	
	foundTrack = [[[ETTrack alloc] initWithDescriptor:&replyObject] autorelease];
	
cleanup_reply_event:
	AEDisposeDesc(replyEvent);
	free(replyEvent);
	
	return foundTrack;
}

- (ETTrack *)trackWithPersistentIdString:(NSString *)persistentId
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0])
		return nil;
	
	ETTrack *foundTrack = nil;
	AppleEvent *replyEvent;
	
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2]) {
		replyEvent = [self getElementOfClass:ET_CLASS_TRACK
									   byKey:ET_ITEM_PROP_PERSISTENT_ID 
							withLongIntValue:[persistentId longlongValue]];
	}
	else {
		replyEvent = [self getElementOfClass:ET_CLASS_TRACK
									   byKey:ET_ITEM_PROP_PERSISTENT_ID 
							 withStringValue:persistentId];
	}
	/* Read Results */
	AEDesc replyObject;
	OSErr err;
	err = AEGetParamDesc(replyEvent, keyDirectObject, typeWildCard, &replyObject);
	if (err != noErr) {
		ETLog(@"Error extracting from reply event: %d", err);
		goto cleanup_reply_event;
	}
	
	foundTrack = [[[ETTrack alloc] initWithDescriptor:&replyObject] autorelease];
	
cleanup_reply_event:
	AEDisposeDesc(replyEvent);
	free(replyEvent);
	
	return foundTrack;
}


- (long long int) persistentId
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0]) {
		ETLog(@"persistentId Unsupported");
		return -1;
	}
	
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2])
		return [self getPropertyAsLongIntegerForDesc:ET_ITEM_PROP_PERSISTENT_ID];	
	else {
		NSString *persistentId = [NSString stringWithFormat:@"0x%@",[self getPropertyAsStringForDesc:ET_ITEM_PROP_PERSISTENT_ID]];
		return [persistentId longlongValue];
	}
}

- (NSString *) persistentIdAsString
{
	
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0]) {
		ETLog(@"persistentIdAsString Unsupported");
		return nil;
	}
	
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2]) 
		return [[NSString stringWithFormat:@"%llX",[self getPropertyAsLongIntegerForDesc:ET_ITEM_PROP_PERSISTENT_ID]] uppercaseString];
	else 
		return [self getPropertyAsStringForDesc:ET_ITEM_PROP_PERSISTENT_ID];
}

@end
