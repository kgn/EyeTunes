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

	
	int x = [e playerPosition];
	NSAttributedString *str = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n",x]] autorelease];
	[text appendAttributedString:str];
	

}

@end
