#import "EyeTunes.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	EyeTunes *e = [EyeTunes sharedInstance];
	
	//[e playPause];
	/*
	ETTrack *curTrack = [e currentTrack];
	
	ETLog(@"Name: %@ Album: %@ Artist: %@ Rating: %d", [curTrack name], [curTrack album], [curTrack artist], [curTrack rating]);

	ETPlaylist *playlist = [e currentPlaylist];
	ETLog(@"Playlist: %@", [playlist name]);
	
	ETLog(@"Fixed Indexing: %d", [e fixedIndexing]);
	*/
	ETTrack *t = [[e libraryPlaylist] trackWithDatabaseId:4141];
	NSLog(@"Title: %@", [t name]);
	[e playTrack:t];
	
	/* 
	// ### Test getting tracks of playlist and getting by databaseId
	NSEnumerator *en = [[playlist tracks] objectEnumerator];
	int i = 0;
	ETTrack *track = nil;
	while (track = [en nextObject]) {
		ETLog(@"Name: %@ Play Count: %d Database Id: %d", [track name], [track playedCount], [track databaseId]);
		if (i > 10) break;
		i++;
	}
	
	if (track) {
		ETTrack *thisTrackAgain = [playlist trackWithDatabaseId:[track databaseId]];
		ETLog(@"track name: %@", [thisTrackAgain name]);
	}
	*/
	
	/* 
	// ### Test getting Playlists 
	NSArray *allPlaylists = [e playlists];
	NSEnumerator *ep = [allPlaylists objectEnumerator];
	ETPlaylist *pl = nil;
	while (pl = [ep nextObject]){
		ETLog(@"Playlist Name: %@", [pl name]);
	}
	*/
	
	/*
	if ([curTrack podcast] == YES) {
		ETLog(@"isPodcast");
	}
	else if ([curTrack podcast] == NO) {
		ETLog(@"is Not Podcast");
	}
	ETLog(@"Added Date: %@", [curTrack playedDate]);
	
	ETPlaylist *curPlaylist = [e currentPlaylist];
	ETLog(@"Playlist Name: %@", [curPlaylist name]);
	NSArray *tracks = [e search:[e libraryPlaylist] forString:@"Daniel Powter" inField:kETSearchAttributeArtist];
	
	NSEnumerator *ee = [tracks objectEnumerator];
	ETTrack *t = nil;
	while (t = [ee nextObject]) {
		NSArray *artworks = [t artwork];
		if (artworks) {
			NSImage *artwork = (NSImage *)[artworks objectAtIndex:0];
			NSRect artRect = NSMakeRect(0, 0, [artwork size].width, [artwork size].height);
			NSImage *jpeged = [[NSImage alloc] initWithSize:[artwork size]];
			[jpeged lockFocus];
			[[NSColor whiteColor] drawSwatchInRect:artRect];
			[artwork drawInRect:artRect fromRect:artRect operation:NSCompositeCopy fraction:1.0];
			NSBitmapImageRep *bitmap = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:artRect] autorelease];
			[jpeged unlockFocus];
			[[bitmap representationUsingType:NSJPEGFileType properties:nil] writeToFile:@"/Users/liquidx/art.jpg" atomically:YES];
			[jpeged release];
		}
	}
	*/
	[pool release];
    return 0;
}

