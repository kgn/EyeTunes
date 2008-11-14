//
//  NSNumber+ETPlaylistNameSorting.h
//  EyeTunes
//
//  Created by Ruotger Skupin on 26.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSNumber (ETPlaylistNameSorting)

- (NSComparisonResult) comparePlaylistName:(NSNumber*)otherPersistentId;

@end
