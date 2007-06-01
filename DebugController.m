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
	[self _append:@"Version: "];
	[self _append:[[EyeTunes sharedInstance] versionString]];
	[self _append:@"\n"];
	
	[self _append:@"Is greater than 7.3?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:0x0730] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is greater than 7.2.1?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:0x0721] ? @"YES" : @"NO"];
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

- (IBAction) goButtonPressed:(id)sender
{
	EyeTunes *e = [EyeTunes sharedInstance];
	NSTextStorage *text = [output textStorage];
	
	NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont fontWithName:@"Monaco" size:12], NSFontAttributeName, nil];

	
	[self _append:[[e currentTrack] name]];
	[self _append:@"\n"];	
	[self _append:@"Persistent ID for track: (String): "];	
	
	[self _append:[[e currentTrack] persistentIdAsString]];
	[self _append:@"\n"];
	long long int trackId = [[e currentTrack] persistentId];
	NSString *trackIdString = [[e currentTrack] persistentIdAsString];
	[self _append:@"Persistent ID for track (long): "];
	[self _append:[NSString stringWithFormat:@"%llX",trackId]];
	[self _append:@"\n"];
	
	long long int playlistId = [[e libraryPlaylist] persistentId];
	[self _append:@"Persistent ID for playlist: "];
	[self _append:[NSString stringWithFormat:@"%llX",playlistId]];
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

}

@end
