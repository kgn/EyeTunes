//
//  DebugController.h
//  EyeTunes
//
//  Created by Alastair on 11/02/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EyeTunes.h"

@interface DebugController : NSObject {
	IBOutlet	NSWindow	*window;
	IBOutlet	NSTextView	*output;
	IBOutlet	NSButton	*goButton;
}

- (IBAction) goButtonPressed:(id)sender;

@end
