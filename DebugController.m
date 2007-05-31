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
	[self _append:[[EyeTunes sharedInstance] version]];
	[self _append:@"\n"];
	
	[self _append:@"Is greater than 7.3?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:@"7.3"] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is greater than 7.2.1?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:@"7.2.1"] ? @"YES" : @"NO"];
	[self _append:@"\n"];
	
	
	[self _append:@"Is greater than 7.2?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:@"7.2"] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is greater than 7.1?"];
	[self _append:[[EyeTunes sharedInstance] versionGreaterThan:@"7.1"] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is less than 7.3?"];
	[self _append:[[EyeTunes sharedInstance] versionLessThan:@"7.3"] ? @"YES" : @"NO"];
	[self _append:@"\n"];

	[self _append:@"Is less than 7.2?"];
	[self _append:[[EyeTunes sharedInstance] versionLessThan:@"7.2"] ? @"YES" : @"NO"];
	[self _append:@"\n"];
	
	
	[self _append:@"Is less than 6.0?"];
	[self _append:[[EyeTunes sharedInstance] versionLessThan:@"6.0"] ? @"YES" : @"NO"];
	[self _append:@"\n"];
	
	
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
	[self _append:[[e currentTrack] persistentIdAsString]];
	[self _append:@"\n"];
	long long int x = [[e currentTrack] persistentId];
	[self _append:[NSString stringWithFormat:@"%lld",x]];
	[self _append:@"\n"];
	
}

@end
