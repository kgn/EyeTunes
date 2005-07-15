#import "EyeTunes.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	EyeTunes *e = [EyeTunes sharedInstance];
	
	[e playPause];
	
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
	NSArray *tracks = [e search:[e libraryPlaylist] forString:@"l;aksdl;" inField:kETSearchAttributeAlbums];
	
	NSEnumerator *ee = [tracks objectEnumerator];
	ETTrack *t = nil;
	while (t = [ee nextObject]) {
		NSLog([t name]);
	}
	
	//NSImage *testImage = [[[NSImage alloc] initWithContentsOfFile:@"/Users/liquidx/Desktop/liquidx.png"] autorelease];
	//[curTrack setArtwork:testImage atIndex:1];
	
	//NSLog(@"artworkArray: %@", [curTrack artwork]);
	
	[pool release];
    return 0;
}
