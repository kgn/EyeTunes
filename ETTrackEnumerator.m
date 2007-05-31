//
//  ETTrackEnumerator.m
//  EyeTunes
//
//  Created by Alastair on 27/01/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

/*
 
 EyeTunes.framework - Cocoa iTunes Interface
 http://www.liquidx.net/eyetunes/
 
 Copyright (c) 2005-2007 Alastair Tse <alastair@liquidx.net>
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
#import "ETTrackEnumerator.h"

@implementation ETTrackEnumerator

- (id) initWithPlaylist:(ETPlaylist *)newPlaylist
{
	self = [super init];
	if (self) {
		playlist = [newPlaylist retain];
		count = [playlist trackCount];
		seq = 0;
	}
	return self;
}

- (void) dealloc
{
	[playlist release];
	[super dealloc];
}

- (id) nextObject
{
	OSErr err;
	AEDesc trackDescriptor;
	
	if (seq >= count)
		return nil;

	AppleEvent *replyEvent = [playlist getElementOfClass:ET_CLASS_TRACK atIndex:seq];
	if (!replyEvent)
		return nil;

	err = AEGetParamDesc(replyEvent, keyDirectObject, typeWildCard, &trackDescriptor);
	AEDisposeDesc(replyEvent);
	free(replyEvent);			
	if (err != noErr)
		return nil;

	ETTrack *thisTrack = [[[ETTrack alloc] initWithDescriptor:&trackDescriptor] autorelease];
	seq++;
	return thisTrack;
}

- (NSArray *)allObjects
{
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:(count - seq)];
	ETTrack *track = nil;
	while (track = [self nextObject]) {
		[objects addObject:track];
	}
	return objects;
}

@end
