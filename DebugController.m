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

- (void) awakeFromNib
{
	
}

- (IBAction) goButtonPressed:(id)sender
{
	EyeTunes *e = [EyeTunes sharedInstance];
	NSTextStorage *text = [output textStorage];
	NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont fontWithName:@"Monaco" size:12], NSFontAttributeName, nil];
	
	// Find debug playlist
	NSEnumerator *iter = [e playlistEnumerator];
	ETPlaylist *pl = nil;
	while (pl = [iter nextObject]) {
		NSString *playlistName = [NSString stringWithFormat:@"Playlist: %@\n", [pl name]];
		NSAttributedString *astr = [[[NSAttributedString alloc] initWithString:playlistName attributes:attr] autorelease];
		[text appendAttributedString:astr];
		NSLog(@"Playlist Name: %@", [pl name]);
		if ([[pl name] isEqual:@"Debug"])
			break;
	}
	
	if (pl == nil) {
		NSAttributedString *ss = [[[NSAttributedString alloc] initWithString:@"Unable to find 'Debug' Playlist in your iTunes\n" attributes:attr] autorelease];
		[text appendAttributedString:ss];
		pl = [e libraryPlaylist];
	}
	
	// Found debug playlist, now we list all the songs 
	iter = [pl trackEnumerator];
	ETTrack *track = nil;
	int max = 5, i = 0;
	while (track = [iter nextObject]) {
		NSArray *result = [track getPropertyAsStringWithDumpForDesc:ET_ITEM_PROP_NAME];
		NSAttributedString *astr = [[[NSAttributedString alloc] initWithString:[result objectAtIndex:0] attributes:attr] autorelease];
		[text appendAttributedString:astr];
		
		astr = [[[NSAttributedString alloc] initWithString:@"\n" attributes:attr] autorelease];
		[text appendAttributedString:astr];
		
		astr = [[[NSAttributedString alloc] initWithString:[result objectAtIndex:1] attributes:attr] autorelease];
		[text appendAttributedString:astr];
		
		result = [track getPropertyAsDateWithDumpForDesc:ET_TRACK_PROP_DATE_ADDED];
		
		astr = [[[NSAttributedString alloc] initWithString:[[result objectAtIndex:0] description] attributes:attr] autorelease];
		[text appendAttributedString:astr];
		
		astr = [[[NSAttributedString alloc] initWithString:@"\n" attributes:attr] autorelease];
		[text appendAttributedString:astr];
		
		astr = [[[NSAttributedString alloc] initWithString:[result objectAtIndex:1] attributes:attr] autorelease];
		[text appendAttributedString:astr];
		
		result = [track getPropertyAsIntegerWithDumpForDesc:ET_TRACK_PROP_DURATION];
		
		astr = [[[NSAttributedString alloc] initWithString:[[result objectAtIndex:0] stringValue] attributes:attr] autorelease];
		[text appendAttributedString:astr];
		
		astr = [[[NSAttributedString alloc] initWithString:@"\n" attributes:attr] autorelease];
		[text appendAttributedString:astr];
		
		astr = [[[NSAttributedString alloc] initWithString:[result objectAtIndex:1] attributes:attr] autorelease];
		[text appendAttributedString:astr];
		

		
		if (i > max)
			break;
		i++;
	}
	
	

}

@end
