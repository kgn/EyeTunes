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

static const BOOL doLog = NO;

@implementation ETPlaylist



- (id) initWithDescriptor:(AEDesc *)desc
{
	if (![super initWithDescriptor:desc applCode:ET_APPLE_EVENT_OBJECT_DEFAULT_APPL])
		return nil;
	
	parentPlaylistId = -1;
	persistentId = -1;
	return self;
}

- (void) dealloc
{
	[childPlaylistIds release];
	
	[super dealloc];
}

- (NSString *)name
{
	if ([self persistentId] == kETSpecialPlaylistRoot)
		return NSLocalizedString(@"iTunes", @"EyeTunes root playlist name");
	if ([self persistentId] == kETSpecialPlaylistCategoryLibrary)
		return NSLocalizedString(@"LIBRARY", @"EyeTunes category playlist name");
	if ([self persistentId] == kETSpecialPlaylistCategoryStore)
		return NSLocalizedString(@"STORE", @"EyeTunes category playlist name");
	if ([self persistentId] == kETSpecialPlaylistCategoryPlaylists)
		return NSLocalizedString(@"PLAYLISTS", @"EyeTunes category playlist name");
	return [self getPropertyAsStringForDesc:ET_ITEM_PROP_NAME];
}


- (DescType) specialKind;
{
	return [self getPropertyAsEnumForDesc:ET_PLAYLIST_PROP_SPECIAL_KIND];
}

- (NSArray *)tracks
{
	return [[self trackEnumerator] allObjects];
}

- (int) trackCount
{
	return [self getCountOfElementsOfClass:ET_CLASS_TRACK];
}

- (ETPlaylist*) parentPlaylist
{
	AppleEvent *replyEvent = [self getPropertyOfType:ET_PLAYLIST_PROP_PARENT];
	
	if (!replyEvent) 
	{
		// TODO: raise exception?
		return nil;
	}
	
	Handle stringHandle;
	OSErr err = AEPrintDescToHandle(replyEvent, &stringHandle);
	if (doLog) NSLog(@"-[ETPlaylist parentplaylist] %@ -- replyEvent: %s (AEPrintDescToHandle result %d)", [self name], *stringHandle, err);
	
	/* Read Results */
	AEDesc playlistDescriptor;
	err = AEGetParamDesc((const AppleEvent *)replyEvent, keyDirectObject, typeWildCard, &playlistDescriptor);
	if (err != noErr) 
	{
		DescType		playlistDesc;
		int			replyValue = -1;
		Size		resultSize;
		err = AEGetParamPtr(replyEvent, keyErrorNumber, typeWildCard, &playlistDesc, 
							&replyValue, sizeof(replyValue), &resultSize);
		if (replyValue != errAENoSuchObject)
		{
			ETLog(@"ERROR in -[ETPlaylist parentplaylist] \"%@\" -- replyEvent: %s (AEGetParamPtr result %d)", [self name], *stringHandle, err);
		}
		return nil;
	}
	
	ETPlaylist * parentPlaylist = [[[ETPlaylist alloc] initWithDescriptor:&playlistDescriptor] autorelease];
	AEDisposeDesc(replyEvent);
	free(replyEvent);
	
	return parentPlaylist;
}

- (unsigned long long) parentPlaylistId;
{
	if (parentPlaylistId == -1)
	{
		parentPlaylistId = [[self parentPlaylist] persistentId];
	}
	return parentPlaylistId;
}

// we need to be able to overwrite this value to move the playlist to a different location in the tree
- (void) setParentPlaylistId:(unsigned long long)inParentPlaylistId;
{
	parentPlaylistId = inParentPlaylistId;
}

- (NSArray*) childPlaylistIds;
{
	if (!areChildrenSorted)
	{
		[childPlaylistIds sortUsingSelector:@selector(comparePlaylistName:)];
		areChildrenSorted = YES;
	}
	
	return [NSArray arrayWithArray:childPlaylistIds];
}


- (void) addChildPlaylistId:(NSNumber*)childPlaylistId;
{
	if (!childPlaylistIds)
		childPlaylistIds = [[NSMutableArray alloc] init];
	
	[childPlaylistIds addObject:childPlaylistId];
	areChildrenSorted = NO;
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

- (ETTrack *)trackWithPersistentId:(long long int)inPersistentId
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0])
		return nil;

	ETTrack *foundTrack = nil;
	AppleEvent *replyEvent;

	if ([[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_2_1] ||
		[[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2]) {
		replyEvent = [self getElementOfClass:ET_CLASS_TRACK
									   byKey:ET_ITEM_PROP_PERSISTENT_ID 
							withLongIntValue:inPersistentId];
	}
	else {
		replyEvent = [self getElementOfClass:ET_CLASS_TRACK
									   byKey:ET_ITEM_PROP_PERSISTENT_ID 
							 withStringValue:[NSString stringWithFormat:@"%016llX", inPersistentId]];
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

- (ETTrack *)trackWithPersistentIdString:(NSString *)inPersistentId
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0])
		return nil;
	
	ETTrack *foundTrack = nil;
	AppleEvent *replyEvent;
	
	if ([[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_2_1] ||
		[[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2]) {
		replyEvent = [self getElementOfClass:ET_CLASS_TRACK
									   byKey:ET_ITEM_PROP_PERSISTENT_ID 
							withLongIntValue:[inPersistentId longlongValue]];
	}
	else {
		replyEvent = [self getElementOfClass:ET_CLASS_TRACK
									   byKey:ET_ITEM_PROP_PERSISTENT_ID 
							 withStringValue:inPersistentId];
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


- (void) setPersistentId:(long long int)inPersistentId;
{
	persistentId = inPersistentId;
}


- (long long int) persistentId
{
	if (persistentId != -1)
		return persistentId;
	
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0]) {
		ETLog(@"persistentId Unsupported");
		return -1;
	}
	
	if ([[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_2_1] ||
		[[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2])
		return [self getPropertyAsLongIntegerForDesc:ET_ITEM_PROP_PERSISTENT_ID];	
	else {
		NSString *persistentIDString = [NSString stringWithFormat:@"0x%@",[self getPropertyAsStringForDesc:ET_ITEM_PROP_PERSISTENT_ID]];
		persistentId = [persistentIDString longlongValue];
		return persistentId;
	}
}

- (NSNumber*)persistentIdNumber;
{
	return [NSNumber numberWithLongLong:[self persistentId]];
}

- (NSString *) persistentIdAsString
{
	
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0]) {
		ETLog(@"persistentIdAsString Unsupported");
		return nil;
	}
	
	if ([[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_2_1] ||
		[[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2]) 
		return [[NSString stringWithFormat:@"%016llX",[self getPropertyAsLongIntegerForDesc:ET_ITEM_PROP_PERSISTENT_ID]] uppercaseString];
	else 
		return [self getPropertyAsStringForDesc:ET_ITEM_PROP_PERSISTENT_ID];
}


- (BOOL) isSpecialKind;
{
	NSLog (@"WARNING: not yet implemented");
	return NO;
}

- (BOOL) isCached;
{
	NSLog (@"WARNING: not yet implemented");
	return NO;
}

@end
