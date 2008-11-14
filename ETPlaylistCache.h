//
//  ETPlaylistCache.h
//  EyeTunes
//
//  Created by Ruotger Skupin on 26.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ETPlaylist;

@interface ETPlaylistCache : NSObject 
{
	NSMutableDictionary * playlists;
	NSMutableDictionary * userPlaylists;
}

+ (id) sharedInstance;

- (void) reload;
- (ETPlaylist*) playlistForPersistentId:(long long int)persistentId;
- (ETPlaylist*) userPlaylistForPersistentId:(long long int)persistentId;
@end
