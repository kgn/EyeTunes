//
//  DebugController.m
//  EyeTunes
//
//  Created by Alastair on 11/02/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DebugController.h"

@implementation DebugController


- (void) _append:(NSString *)string
{
	if (string != nil) {
		NSAttributedString *str = [[[NSAttributedString alloc] initWithString:string] autorelease];
		[[output textStorage] appendAttributedString:str];
	}
}


- (void) awakeFromNib
{
	[self setDoShowOnlyUser:YES];
	[self _append:@"Version: "];
	[self _append:[[EyeTunes sharedInstance] versionString]];
	[self _append:@"\n"];
	
	[self _append:@"Is greater than 7.3?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_3] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is greater than 7.2.1?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_2_1] ? @"YES" : @"NO"];
	[self _append:@"\n"];
	
	
	[self _append:@"Is greater than 7.2?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_2] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is greater than 7.1?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:ITUNES_7_1] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is less than 7.3?"];
	[self _append:[[EyeTunes sharedInstance] versionLessThan:ITUNES_7_3] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is less than 7.2?"];
	[self _append:[[EyeTunes sharedInstance] versionLessThan:ITUNES_7_2] ? @"YES" : @"NO"];
	[self _append:@"\n"];
	
	
	[self _append:@"Is less than 6.0?"];
	[self _append:[[EyeTunes sharedInstance] versionLessThan:ITUNES_6_0] ? @"YES" : @"NO"];
	[self _append:@"\n"];
	
	[[EyeTunes sharedInstance] versionNumber];
	
	[ETPlaylistCache sharedInstance];
	[outlineView reloadData];
}

- (IBAction) prev:(id)sender
{
	[[EyeTunes sharedInstance] previousTrack];
}

- (IBAction) next:(id)sender
{
	[[EyeTunes sharedInstance] nextTrack];
}
	
- (IBAction) playPause:(id)sender
{
	[[EyeTunes sharedInstance] playPause];
}


- (IBAction) enumerate:(id)sender;
{
	EyeTunes *et = [EyeTunes sharedInstance];
	NSTextStorage *text = [output textStorage];
	
	NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSFont fontWithName:@"Monaco" size:12], NSFontAttributeName, nil];

	NSArray * playlists = [et playlists];
	unsigned int i=0;
	for (i=0; i<[playlists count]; i++)
	{
		ETPlaylist * playlist = [playlists objectAtIndex:i];
		[self _append:[playlist name]];
		[self _append:[NSString	stringWithFormat:@" (%@)", [playlist stringForOSType:[playlist specialKind]]]];
		ETPlaylist * parentPlaylist = [playlist parentPlaylist];
		if (parentPlaylist)
			[self _append:[NSString stringWithFormat:@"   --- parent: %@", [parentPlaylist name]]];
		[self _append:@"\n"];
	}	
}


- (IBAction) enumerateUser:(id)sender;
{
	EyeTunes *et = [EyeTunes sharedInstance];
	NSTextStorage *text = [output textStorage];
	
	NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSFont fontWithName:@"Monaco" size:12], NSFontAttributeName, nil];
	
	NSArray * playlists = [et userPlaylists];
	unsigned int i;
	for (i=0; i<[playlists count]; i++)
	{
		ETPlaylist * playlist = [playlists objectAtIndex:i];
		[self _append:[playlist name]];
		[self _append:@"\n"];
	}	
}


- (IBAction) addTrack:(id)sender;
{
	EyeTunes *et = [EyeTunes sharedInstance];

	NSArray * playlists = [et playlists];
	ETPlaylist * playlist = nil;
	unsigned int i;
	for (i=0; i<[playlists count]; i++)
	{
		playlist = [playlists objectAtIndex:i];
		if ([[playlist name] isEqualToString:@"Test"])
			break;
	}	

	if (![[playlist name] isEqualToString:@"Test"])
	{
		NSRunAlertPanel(@"Needs Playlist called 'Test'", @"To run this test please create a playlist called Test", @"Ok", nil, nil);
		return;
	}
	
	NSOpenPanel * panel = [NSOpenPanel openPanel];
	if ([panel runModalForTypes:[NSArray arrayWithObjects:@"mp3", @"m4a", @"mp4", nil]] == NSCancelButton)
		return;

	if (![[panel URLs] count])
		return;
		
	[et addTrack:[[panel URLs] objectAtIndex:0] toPlaylist:playlist];	
	[self _append:[NSString stringWithFormat:@"added %@ to playlist %@", [[[panel URLs] objectAtIndex:0] path], [playlist name]]];

}


- (IBAction) goButtonPressed:(id)sender
{
	EyeTunes *e = [EyeTunes sharedInstance];
	NSTextStorage *text = [output textStorage];
	
	NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont fontWithName:@"Monaco" size:12], NSFontAttributeName, nil];

	ETTrack * currentTrack = [e currentTrack];
	
	[self _append:[currentTrack name]];
	[self _append:@"\n"];	
	[self _append:@"Persistent ID for track: (String): "];	
	
	[self _append:[currentTrack persistentIdAsString]];
	[self _append:@"\n"];
	long long int trackId = [currentTrack persistentId];
	NSString *trackIdString = [currentTrack persistentIdAsString];
	[self _append:@"Persistent ID for track (long): "];
	[self _append:[NSString stringWithFormat:@"%016llX",trackId]];
	[self _append:@"\n"];
	
	long long int playlistId = [[e libraryPlaylist] persistentId];
	[self _append:@"Persistent ID for playlist: "];
	[self _append:[NSString stringWithFormat:@"%016llX",playlistId]];
	[self _append:@"\n"];
	ETPlaylist *playlist = [e playlistWithPersistentId:playlistId];
	[self _append:@"Fetched playlist using persistent ID: "];
	[self _append:[playlist name]];
	[self _append:@"\n"];

	
	ETTrack *track = [e trackWithPersistentId:trackId];
	[self _append:@"Fetched track using persistent ID by long long int: "];
	[self _append:[track name]];
	[self _append:@"\n"];

	
	track = [e trackWithPersistentIdString:trackIdString];
	[self _append:@"Fetched track using persistent ID by NSString: "];
	[self _append:[track name]];
	[self _append:@"\n"];
	
	NSArray *artworks = [track artwork];
	
	if ([artworks count] > 0) 
	{
		[self _append:@"Artwork found"];
		NSImage *testImage = [artworks objectAtIndex:0]; 
		[imageView setImage:testImage];
		//[track setArtwork:testImage atIndex:1];
	}
	else {
		[self _append:@"No artwork found"];
	}
	[self _append:@"\n"];
	
	[self _append:[NSString stringWithFormat:@"'ID  ': %d", [track getPropertyAsIntegerForDesc:'ID  ']]];
	[self _append:@"\n"];
	
	[self _append:[NSString stringWithFormat:@"database ID: %d", [track databaseId]]];
	[self _append:@"\n"];

	[trackName setStringValue:[NSString stringWithFormat:@"track name: %@",[track name]]];
	[albumName setStringValue:[NSString stringWithFormat:@"album name: %@",[track album]]];
	[artistName setStringValue:[NSString stringWithFormat:@"artist name: %@",[track artist]]];
}


- (BOOL) doShowOnlyUser;
{
	return doShowOnlyUser;
}
- (void) setDoShowOnlyUser:(BOOL)inDoShowOnlyUser;
{
	doShowOnlyUser = inDoShowOnlyUser;
	[[ETPlaylistCache sharedInstance] reload];
	[outlineView reloadData];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
	ETPlaylist * playlist = (ETPlaylist*)item;
	if (!playlist)
	{
		if (doShowOnlyUser)			
			playlist = [[EyeTunes sharedInstance] rootUserPlaylist];
		else
			playlist = [[EyeTunes sharedInstance] rootPlaylist];
	}	
	if (![playlist isKindOfClass:[ETPlaylist class]])
		return nil;
	
	NSNumber * playlistId = [[playlist childPlaylistIds] objectAtIndex:index];
	if (doShowOnlyUser)
		return [[ETPlaylistCache sharedInstance] userPlaylistForPersistentId:[playlistId longLongValue]];
	else
		return [[ETPlaylistCache sharedInstance] playlistForPersistentId:[playlistId longLongValue]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	if (![item isKindOfClass:[ETPlaylist class]])
		return NO;

	return [[(ETPlaylist*)item childPlaylistIds] count];
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (!item)
	{
		ETPlaylist * rootPlaylist = nil;
		if (doShowOnlyUser)
			rootPlaylist = [[EyeTunes sharedInstance] rootUserPlaylist];
		else
			rootPlaylist = [[EyeTunes sharedInstance] rootPlaylist];
		
		return [[rootPlaylist childPlaylistIds] count];
	}

	if (![item isKindOfClass:[ETPlaylist class]])
		return 0;

	return [[(ETPlaylist*)item childPlaylistIds] count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if (![item isKindOfClass:[ETPlaylist class]])
		return @"wrong class";

	return [(ETPlaylist*)item name];
}

@end
