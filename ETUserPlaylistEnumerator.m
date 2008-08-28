//
//  ETUserPlaylistEnumerator.m
//  EyeTunes
//
//  Created by Ruotger Skupin on 15.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ETUserPlaylistEnumerator.h"
#import "EyeTunesEventCodes.h"
#import "ETPlaylist.h"

@implementation ETUserPlaylistEnumerator

- (id) nextObject
{
	// iTunes (well 7.7.1 anyway) returns all non-folder playlists if you ask for ET_CLASS_USER_PLAYLIST
	// so we filter here and only return truly non-special playlists, Ruotger
	while (YES)
	{
		ETPlaylist * result = [super nextObject];
		if (!result || [result specialKind] == kETSpecialPlaylistNone)
			return result;
	}
}


- (DescType) appleEventClass
{
	return ET_CLASS_USER_PLAYLIST;
}

@end
