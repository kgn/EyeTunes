#import "EyeTunes.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	EyeTunes *e = [EyeTunes sharedInstance];
	
	//[e playPause];
	
	ETTrack *curTrack = [e currentTrack];
	
	NSLog(@"Name: %@ Album: %@ Artist: %@ Rating: %d", [curTrack name], [curTrack album], [curTrack artist], [curTrack rating]);
	
	[curTrack setArtwork:nil atIndex:0];
	
	/*
	if ([curTrack podcast] == YES) {
		NSLog(@"isPodcast");
	}
	else if ([curTrack podcast] == NO) {
		NSLog(@"is Not Podcast");
	}
	NSLog(@"Added Date: %@", [curTrack playedDate]);
	
	ETPlaylist *curPlaylist = [e currentPlaylist];
	NSLog(@"Playlist Name: %@", [curPlaylist name]);
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

