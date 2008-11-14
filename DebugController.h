//
//  DebugController.h
//  EyeTunes
//
//  Created by Alastair on 11/02/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <EyeTunes/EyeTunes.h>

@interface DebugController : NSObject {
	IBOutlet	NSWindow	*window;
	IBOutlet	NSTextView	*output;
	IBOutlet	NSButton	*goButton;
	
	IBOutlet	NSButton	*prevButton;
	IBOutlet	NSButton	*playButton;
	IBOutlet	NSButton	*nextButton;
	IBOutlet	NSImageView	*imageView;
	IBOutlet	NSTextField	*albumName;
	IBOutlet	NSTextField	*artistName;
	IBOutlet	NSTextField	*trackName;
	
	IBOutlet	NSOutlineView *outlineView;
	BOOL doShowOnlyUser;
}

- (IBAction) prev:(id)sender;
- (IBAction) next:(id)sender;
- (IBAction) playPause:(id)sender;

- (IBAction) enumerate:(id)sender;
- (IBAction) enumerateUser:(id)sender;
- (IBAction) addTrack:(id)sender;

- (IBAction) goButtonPressed:(id)sender;

- (BOOL) doShowOnlyUser;
- (void) setDoShowOnlyUser:(BOOL)inDoShowOnlyUser;

@end
