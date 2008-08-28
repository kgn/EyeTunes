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
#import "ETTrack.h"

#import "NSString+LongLongValue.h"

#import "ETDebug.h"

@implementation ETTrack

- (id) initWithDescriptor:(AEDesc *)desc
{
	// iTunes 7.7.1 returns a list with one track item rather than the track directly.
	if (desc->descriptorType == typeAEList) {
		AEDesc trackDesc;
		if (noErr == AEGetNthDesc((AEDescList*)desc, 1, typeWildCard, NULL, &trackDesc)) {
			desc = &trackDesc;
		}
	}
	self = [super initWithDescriptor:desc applCode:ET_APPLE_EVENT_OBJECT_DEFAULT_APPL];
	return self;
}

- (void)setArtwork:(NSArray *)artworks
{
	int i = 0;
	
	if (artworks == nil) { 
		[self deleteAllElementsOfClass:ET_CLASS_ARTWORK];
	}
	else {
		for (i = 0; i < [artworks count]; i++) {
			[self setArtwork:[artworks objectAtIndex:i] atIndex:i];
		}
	}
}

- (BOOL)setArtwork:(NSImage *)artwork atIndex:(int)index
{
	AEDesc pictDesc;
	OSErr err;
	NSPasteboard *pboard = nil;
	NSData	*tiffData;
	
	if (artwork != nil) {
		tiffData = [artwork TIFFRepresentation];
		if (tiffData == nil) {
			ETLog(@"Unable to convert NSImage to TIFF");
			return NO;
		}
		
		// force NSPasteboard to do conversion for us?
		pboard = [NSPasteboard pasteboardWithName:@"EyeTunes"];
		[pboard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType] owner:nil];
		[pboard setData:tiffData forType:NSTIFFPboardType];
		[pboard types]; // need this for some reason to force pboard to present more datatypes
		NSData *pictData = [pboard dataForType:NSPICTPboardType];
		[pboard releaseGlobally];
		
		if ([pictData length] < 512) {
			ETLog(@"Unable to convert to PICT");
			return NO;
		}
		
		err = AEBuildDesc(&pictDesc, NULL, "'PICT'(@)",
							[pictData length],
							[pictData bytes]);
		
		if (err != noErr) {
			ETLog(@"Error with constructing PICT: %d", err);
			return NO;
		}

		/* execute send command */
		BOOL success = NO;
		success = [self setProperty:ET_ARTWORK_PROP_DATA 
					 OfElementOfClass:ET_CLASS_ARTWORK 
							atIndex:index 
							withValue:&pictDesc];
		AEDisposeDesc(&pictDesc);
	
		return success;		
	}
	else {
		[self deleteElement:index OfClass:ET_CLASS_ARTWORK];
	}
	
	return NO;

}


- (NSArray *)artwork
{
	OSErr err;
	NSMutableArray *artworkArray = [NSMutableArray array];
	int i;
	DescType	resultType;
	Size		resultSize; 
	
	/* count the number of artworks */	
	int			elementCount = [self getCountOfElementsOfClass:ET_CLASS_ARTWORK];
	
	/* get all the artwork data */

	for (i = 0; i < elementCount; i++) {
		AEDesc artworkDescriptor;
		AppleEvent *replyEvent = [self getElementOfClass:ET_CLASS_ARTWORK atIndex:i];
		if (!replyEvent) {
			ETLog(@"Failed to retrieve artwork number: %d", i);
			break;
		}
		
		err = AEGetParamDesc(replyEvent, keyDirectObject, typeWildCard, &artworkDescriptor);
		AEDisposeDesc(replyEvent);
		free(replyEvent);			
		if (err != noErr) {
			ETLog(@"Failed to get reference to artwork: %d", err);
			break;
		}
			
		AppleEvent *dataReplyEvent = [self getPropertyOfType:ET_ARTWORK_PROP_DATA forObject:&artworkDescriptor];
		if (!dataReplyEvent) {
			ETLog(@"Failed to get data Reply Event: %d", err);
			AEDisposeDesc(&artworkDescriptor);
			break;
		}
		
		err = AESizeOfParam(dataReplyEvent, keyDirectObject, &resultType, &resultSize);
		if (err != noErr) {
			ETLog(@"Failed to get size and type of data returned: %d", err);
			AEDisposeDesc(&artworkDescriptor);
			AEDisposeDesc(dataReplyEvent);
			free(dataReplyEvent);
			break;
		}
		
		unsigned char *pictBytes = malloc(resultSize);
		err = AEGetParamPtr(dataReplyEvent, keyDirectObject, typePict, &resultType, 
							pictBytes, resultSize, &resultSize);
		if (err != noErr) {
			ETLog(@"Failed to extract PICT data to buffer: %d", err);
			AEDisposeDesc(&artworkDescriptor);
			AEDisposeDesc(dataReplyEvent);
			free(dataReplyEvent);
			free(pictBytes);
			break;
		}
		
		NSData *pictData = [NSData dataWithBytesNoCopy:pictBytes length:resultSize freeWhenDone:YES];
		if (pictData != nil) {
			NSImage *artworkImage = [[[NSImage alloc] initWithData:pictData] autorelease];
			if (artworkImage != nil) {
				[artworkArray addObject:artworkImage];
			}
		}
			
		AEDisposeDesc(&artworkDescriptor);
		AEDisposeDesc(dataReplyEvent);
		free(dataReplyEvent);
	}

	return artworkArray;
}


#pragma mark -
#pragma mark Getters
#pragma mark -

- (NSString *)name
{
	return [self getPropertyAsStringForDesc:ET_ITEM_PROP_NAME];
}

- (NSString *)album
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_ALBUM];
}

- (NSString *)artist
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_ARTIST];
}

- (NSString *)albumArtist
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_ALBUM_ARTIST];
}


- (int)bitrate
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_BITRATE];
}

- (int)bpm
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_BPM];
}

- (int)bookmark
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_BOOKMARK];
}


- (BOOL)bookmarkable
{
	return (BOOL)[self getPropertyAsIntegerForDesc:ET_TRACK_PROP_BOOKMARKABLE];
}

- (NSString *)category
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_CATEGORY];
}


- (NSString *)comment
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_COMMENT];
}

- (BOOL)compilation
{
	return (BOOL)[self getPropertyAsIntegerForDesc:ET_TRACK_PROP_COMPILATION];
}

- (NSString *)composer
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_COMPOSER];
}

- (int)databaseId
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_DATABASE_ID];
}

- (NSDate *)dateAdded
{
	return [self getPropertyAsDateForDesc:ET_TRACK_PROP_DATE_ADDED];
}

- (NSString *)description
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_DESCRIPTION];
}


- (int)discCount
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_DISC_COUNT];
}

- (int)discNumber
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_DISC_NUMBER];
}

- (int)duration
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_DURATION];
}

- (NSString *)episodeId
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_EPISODE_ID];
}

- (int)episodeNumber
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_EPISODE_NUMBER];
}

- (BOOL)enabled
{
	return (BOOL)[self getPropertyAsIntegerForDesc:ET_TRACK_PROP_ENABLED];
}

- (NSString *)eq
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_EQ];
}

- (int)finish
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_FINISH];
}

- (BOOL)gapless
{
	return (BOOL)[self getPropertyAsIntegerForDesc:ET_TRACK_PROP_GAPLESS];
}


- (NSString *)genre
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_GENRE];
}

- (NSString *)grouping
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_GROUPING];
}

- (NSString *)kind
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_KIND];
}

- (NSString *)location
{
	return [self getPropertyAsPathURLForDesc:pETTrackLocation];
}

- (NSString *)longDescription
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0_2])
		return nil;
	
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_LONG_DESCRIPTION];
}


- (NSString *)lyrics
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0_1])
		return nil;

	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_LYRICS];
}

- (NSDate *)modificationDate
{
	return [self getPropertyAsDateForDesc:ET_TRACK_PROP_MOD_DATE];
}

- (long long int) persistentId
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0]) {
		ETLog(@"persistentId Unsupported");
		return -1;
	}
	
	if ([[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_2_1] ||
		[[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2])
		return [self getPropertyAsLongIntegerForDesc:ET_ITEM_PROP_PERSISTENT_ID]; 
	else {
		NSString *persistentId = [NSString stringWithFormat:@"0x%@",[self getPropertyAsStringForDesc:ET_ITEM_PROP_PERSISTENT_ID]];
		return [persistentId longlongValue];
	}
}

- (NSString *) persistentIdAsString
{
	// Trying a different way of doing version comparison:
	//
	// - The newer versions are checked for first because it's most likely that the user is running
	//	 the latest version of iTunes
	//
	// - Direct integer comparison is used for efficiency and to make reading the code easier
	//
	// If you like it, I can go ahead and change the other code to use this style
	// If you don't, we can change it back. AK/2007-07-03
	int version = [[EyeTunes sharedInstance] versionNumber];
	
	if (version >= ITUNES_7_3)
		return [self getPropertyAsStringForDesc:ET_ITEM_PROP_PERSISTENT_ID_STRING];
	else if (version >= ITUNES_7_2)
		return [self getPropertyAsStringForDesc:ET_ITEM_PROP_PERSISTENT_ID];
	else if (version >= ITUNES_6_0)
		return [[NSString stringWithFormat:@"%016llX",[self getPropertyAsLongIntegerForDesc:ET_ITEM_PROP_PERSISTENT_ID]] uppercaseString];
	else {
		ETLog(@"persistentIdAsString Unsupported");
		return nil;
	}
}

- (int)playedCount
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_PLAYED_COUNT];
}

- (NSDate *)playedDate
{
	return [self getPropertyAsDateForDesc:ET_TRACK_PROP_PLAYED_DATE];
}

- (BOOL)podcast
{
	return (BOOL)[self getPropertyAsIntegerForDesc:ET_TRACK_PROP_PODCAST];

}

- (int)rating
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_RATING];
}

- (int)sampleRate
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_SAMPLE_RATE];
}

- (int)seasonNumber
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_SEASON_NUMBER];
}

- (int)size
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_SIZE];
}

- (NSString *)show
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_SHOW];
}

- (int)skippedCount
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_SKIPPED_COUNT];
}

- (NSDate *)skippedDate
{
	return [self getPropertyAsDateForDesc:ET_TRACK_PROP_SKIPPED_DATE];
}


- (int)start
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_START];
}

- (NSString *)time
{
	return [self getPropertyAsStringForDesc:ET_TRACK_PROP_TIME];
}

- (int)trackCount
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_TRACK_COUNT];
}

- (int)trackNumber
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_TRACK_NUMBER];
}

- (BOOL)unplayed
{
	return !![self getPropertyAsIntegerForDesc:ET_TRACK_PROP_UNPLAYED];
}


- (DescType)videoKind
{
	return 0; //TODO
}


- (int)volumeAdjustment
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_VOLUME_ADJ];
}

- (int)year
{
	return [self getPropertyAsIntegerForDesc:ET_TRACK_PROP_YEAR];
}

#pragma mark -
#pragma mark Setters
#pragma mark -


- (void)setName:(NSString *)newValue
{
	 [self setPropertyWithString:newValue forDesc:ET_ITEM_PROP_NAME];
}

- (void)setAlbum:(NSString *)newValue
{
	 [self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_ALBUM];
}

- (void)setAlbumArtist:(NSString *)newValue
{
	[self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_ALBUM_ARTIST];
}

- (void)setArtist:(NSString *)newValue
{
	 [self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_ARTIST];
}

- (void)setBpm:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_BPM];
}

- (void)setBookmark:(int)newValueSeconds
{
	[self setPropertyWithInteger:newValueSeconds forDesc:ET_TRACK_PROP_BOOKMARK];
}

- (void)setBookmarkable:(BOOL)newValue
{
	[self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_BOOKMARKABLE];
}

- (void)setCategory:(NSString *)newValue
{
	[self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_CATEGORY];
}

- (void)setComment:(NSString *)newValue
{
	 [self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_COMMENT];
}

- (void)setCompilation:(BOOL)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_COMPILATION];
}

- (void)setComposer:(NSString *)newValue
{
	 [self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_COMPOSER];
}

- (void)setDescription:(NSString *)newValue
{
	[self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_DESCRIPTION];
}

- (void)setDiscCount:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_DISC_COUNT];
}

- (void)setDiscNumber:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_DISC_NUMBER];
}

- (void)setEnabled:(BOOL)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_ENABLED];
}

- (void)setEpisodeId:(NSString *)newValue
{
	[self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_EPISODE_ID];
}

- (void)setEpisodeNumber:(int)newValue
{
	[self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_EPISODE_NUMBER];
}


- (void)setEq:(NSString *)newValue
{
	 [self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_EQ];
}

- (void)setFinish:(int)newValueSeconds
{
	 [self setPropertyWithInteger:newValueSeconds forDesc:ET_TRACK_PROP_FINISH];
}

- (void)setGapless:(BOOL)newValue
{
	[self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_GAPLESS];
}

- (void)setGenre:(NSString *)newValue
{
	 [self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_GENRE];
}

- (void)setGrouping:(NSString *)newValue
{
	 [self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_GROUPING];
}

- (void)setLongDescription:(NSString *)newValue
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0_1])
		return;
	
	[self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_LONG_DESCRIPTION];
}

- (void)setLyrics:(NSString *)newValue
{
	if ([[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0_1])
		return;
	
	[self setPropertyWithString:newValue forDesc:ET_TRACK_PROP_LYRICS];
}

- (void)setPlayedCount:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_PLAYED_COUNT];
}

- (void)setPlayedDate:(NSDate *)newValue
{
	 [self setPropertyWithDate:newValue forDesc:ET_TRACK_PROP_PLAYED_DATE];
}

- (void)setRating:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_RATING];
}

- (void)setSeasonNumber:(int)newValue
{
	[self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_SEASON_NUMBER];
}

- (void)setSkippedCount:(int)newValue
{
	[self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_SKIPPED_COUNT];
}

- (void)setSkippedDate:(NSDate *)newValue
{
	[self setPropertyWithDate:newValue forDesc:ET_TRACK_PROP_SKIPPED_DATE];
}

- (void)setStart:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_START];
}

- (void)setTrackCount:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_TRACK_COUNT];
}

- (void)setTrackNumber:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_TRACK_NUMBER];
}

- (void)setUnplayed:(BOOL)newValue
{
	[self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_UNPLAYED];
}

- (void)setVideoKind:(DescType)newValue
{
	return; // TODO
}


- (void)setVolumeAdjustment:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_VOLUME_ADJ];
}

- (void)setYear:(int)newValue
{
	 [self setPropertyWithInteger:newValue forDesc:ET_TRACK_PROP_YEAR];
}

@end
