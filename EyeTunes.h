/* EyeTunes.h - Interface to iTunes Application */

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

/*
0.2 : backwards incompatible changes
  * ETAppleEventObject : getCountofElementClass.. returns int rather than AppleEvent*
  * ETTrack : databaseID renamed to databaseId
	          group renamed to grouping, type changed from int to NSString*
 
*/

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

// guard against exporting features that are not in earlier version

#define ITUNES_6_0_2	0x0602
#define ITUNES_6_0_1	0x0601
#define ITUNES_6_0		0x0600
#define ITUNES_4_0		0x0400
#ifndef ITUNES_VERSION
#define		ITUNES_VERSION ITUNES_6_0_2
#endif

#define	ET_EXPERIMENTAL_PERSISTENT_ID 0

#import "ETDebug.h"
#import "EyeTunesEventCodes.h"
#import "ETAppleEventObject.h"
#import "ETTrack.h"
#import "ETPlaylist.h"

@interface EyeTunes : ETAppleEventObject {
}

+ (EyeTunes *) sharedInstance;

// things that return a Track object
- (NSArray *)search:(ETPlaylist *)playlist forString:(NSString *)searchString inField:(DescType)typeCode;

// get all playlists
- (int)playlistCount;
- (NSArray *)playlists;
- (NSEnumerator *)playlistEnumerator;

// search for playlist by reference
#if ET_EXPERIMENTAL_PERSISTENT_ID
- (ETPlaylist *)playlistWithPersistentId:(int)persistentId;
#endif

// parameters
- (ETTrack *)currentTrack;
- (ETPlaylist *)currentPlaylist;
- (ETPlaylist *)libraryPlaylist;
- (BOOL) fixedIndexing;
- (void) setFixedIndexing:(BOOL)useFixedIndexing;

// no return value
- (void)backTrack;
- (void)fastForward;
- (void)nextTrack;
- (void)pause;
- (void)play;
- (void)playTrack:(ETTrack *)track;
- (void)playTrackWithPath:(NSString *)path;
- (void)playPause;
- (void)previousTrack;
- (void)resume;
- (void)rewind;
- (void)stop;

// TODO: - (id)addTrack:(NSURL *)fromlocation toLocation:(NSURL *)toLocation;
// TODO: - (id)convertTrack:(id)trackReference;
// TODO: - (void)refresh:(id)fileTrack;
// TODO: - (void)update:(id)iPod;
// TODO: - (void)eject:(id)iPod;
// TODO: - (void)subscribe:(NSString *)streamURL;

@end
