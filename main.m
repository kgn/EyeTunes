#import "EyeTunes.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	EyeTunes *e = [EyeTunes sharedInstance];
	
	//[e playPause];
	
	ETTrack *curTrack = [e currentTrack];

	NSLog(@"Name: %@ Album: %@ Artist: %@ Rating: %d", [curTrack name], [curTrack album], [curTrack artist], [curTrack rating]);
	if ([curTrack podcast] == YES) {
		NSLog(@"isPodcast");
	}
	else if ([curTrack podcast] == NO) {
		NSLog(@"is Not Podcast");
	}
	NSLog(@"Added Date: %@", [curTrack playedDate]);
	
	ETPlaylist *curPlaylist = [e currentPlaylist];
	NSLog(@"Playlist Name: %@", [curPlaylist name]);
	NSArray *tracks = [e search:[e libraryPlaylist] forString:@"Twins" inField:kETSearchAttributeAlbums];
	
	NSEnumerator *ee = [tracks objectEnumerator];
	ETTrack *t = nil;
	NSString *location = nil;
	while (t = [ee nextObject]) {
		NSLog([t location]);
		location = [t location];
	}
	
	[e playTrackWithPath:location];
	//[e playTrackWithPath:@"McBook:Users:liquidx:Music:iTunes:iTunes Music:A1:Best Of A1:01 Caught In The Middle.mp3"];
	
	
	//NSImage *testImage = [[[NSImage alloc] initWithContentsOfFile:@"/Users/liquidx/Desktop/liquidx.png"] autorelease];
	//[curTrack setArtwork:testImage atIndex:1];
	
	//NSLog(@"artworkArray: %@", [curTrack artwork]);
	
	[pool release];
    return 0;
}
