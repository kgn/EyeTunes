//
//  NSNumber+ETPlaylistNameSorting.m
//  EyeTunes
//
//  Created by Ruotger Skupin on 26.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+ETPlaylistNameSorting.h"
#import "ETPlaylistCache.h"
#import "ETPlaylist.h"

@implementation NSNumber (ETPlaylistNameSorting)

- (NSComparisonResult) comparePlaylistName:(NSNumber*)otherPersistentId;
{
	ETPlaylist * ownPlaylist = [[ETPlaylistCache sharedInstance] playlistForPersistentId:[self longLongValue]];
	NSString * ownName = [ownPlaylist name];
	
	ETPlaylist * otherPlaylist = [[ETPlaylistCache sharedInstance] playlistForPersistentId:[otherPersistentId longLongValue]];
	NSString * otherName = [otherPlaylist name];

	return [ownName caseInsensitiveCompare:otherName];	
}

@end
