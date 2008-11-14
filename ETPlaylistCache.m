//
//  ETPlaylistCache.m
//  EyeTunes
//
//  Created by Ruotger Skupin on 26.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ETPlaylistCache.h"
#import "ETPlaylist.h"
#import "ETPlaylistEnumerator.h"

// this class caches all playlists and builds the playlist tree. Every playlist only knows its parent,
// so we have to iterate through all playlists and the children ids to their parents

@implementation ETPlaylistCache

+ (id) sharedInstance;
{
	static ETPlaylistCache * sharedInstance = nil;
	if (!sharedInstance)
	{
		sharedInstance = [[ETPlaylistCache alloc] init];
		[sharedInstance reload];
	}
	
	return sharedInstance;
}

- (id) init
{
	if (![super init])
		return nil;
	
	playlists = [[NSMutableDictionary alloc] init];
	
	return self;
}


- (void) reload;
{
	[playlists removeAllObjects];
	
	ETPlaylistEnumerator * en = [[[ETPlaylistEnumerator alloc] init] autorelease];
	
	ETPlaylist * rootPlaylist = [[[ETPlaylist alloc] init] autorelease];
	[rootPlaylist setPersistentId:kETSpecialPlaylistRoot];
	[playlists setObject:rootPlaylist forKey:[NSNumber numberWithLongLong:kETSpecialPlaylistRoot]];
	
	// category playlists
	ETPlaylist * libraryCategory = [[[ETPlaylist alloc] init] autorelease];
	[libraryCategory setParentPlaylistId:kETSpecialPlaylistRoot];
	[libraryCategory setPersistentId:kETSpecialPlaylistCategoryLibrary];
	[playlists setObject:libraryCategory forKey:[NSNumber numberWithLongLong:kETSpecialPlaylistCategoryLibrary]];
	
	ETPlaylist * storeCategory = [[[ETPlaylist alloc] init] autorelease];
	[storeCategory setParentPlaylistId:kETSpecialPlaylistRoot];
	[storeCategory setPersistentId:kETSpecialPlaylistCategoryStore];
	[playlists setObject:storeCategory forKey:[NSNumber numberWithLongLong:kETSpecialPlaylistCategoryStore]];
	
	ETPlaylist * playlistsCategory = [[[ETPlaylist alloc] init] autorelease];
	[playlistsCategory setParentPlaylistId:kETSpecialPlaylistRoot];
	[playlistsCategory setPersistentId:kETSpecialPlaylistCategoryPlaylists];
	[playlists setObject:playlistsCategory forKey:[NSNumber numberWithLongLong:kETSpecialPlaylistCategoryPlaylists]];
	
	// add all playlists
	ETPlaylist * playlist = nil;
	while ((playlist = [en nextObject])) 
	{
		[playlists setObject:playlist forKey:[NSNumber numberWithLongLong:[playlist persistentId]]];
	}

	// find special playlists
	NSEnumerator * en2 = [playlists objectEnumerator];
	unsigned int count = 0;
	while ((playlist = [en2 nextObject])) 
	{
		count++;
		if ([playlist persistentId] >= 0 && [playlist persistentId] <= 3) // root or categories
			continue;
				
		/*
		if ([playlist persistentId] == 6554597091219814194ll) // not sure that this is a good idea...
		{
			mediathek = playlist;
			continue;
		}
		if ([playlist persistentId] == 6114773995509758539ll) // not sure that this is a good idea...
		{
			genius = playlist;
			continue;
		}
*/		
		NSLog (@"playlist: %@ (%@)", [playlist name], [playlist stringForOSType:[playlist specialKind]]);

		switch ([playlist specialKind]) 
		{
			case kETSpecialPlaylistPodcasts:
			case kETSpecialPlaylistVideo:
			case kETSpecialPlaylistAudiobooks:
			case kETSpecialPlaylistMovies:
			case kETSpecialPlaylistMusic:
			case kETSpecialPlaylistTVShows:
				[playlist setParentPlaylistId:kETSpecialPlaylistCategoryLibrary];
				break;
				
			case kETSpecialPlaylistPurchasedMusic:
				[playlist setParentPlaylistId:kETSpecialPlaylistCategoryStore];
				break;
				
			case kETSpecialPlaylistPartyShuffle:
				[playlist setParentPlaylistId:kETSpecialPlaylistCategoryPlaylists];
				break;
				
			case kETSpecialPlaylistNone:
			case kETSpecialPlaylistFolder:
				{
					ETPlaylist * parentPlaylist = [playlist parentPlaylist];
					long long parentPersistentId = [parentPlaylist persistentId];
					if (!parentPersistentId)
						[playlist setParentPlaylistId:kETSpecialPlaylistCategoryPlaylists];
					else
						[playlist setParentPlaylistId:parentPersistentId];
				}					
				break;	
				
			default:
				break;
		}		
	}		
	
	// add children
	en2 = [playlists objectEnumerator];
	while ((playlist = [en2 nextObject])) 
	{
		unsigned long long playlistPersistentID = [playlist persistentId];
		NSString * playlistName = [playlist name];
		if (playlistPersistentID == 0) // root
			continue;
		
		long long parentPersistentId = [playlist parentPlaylistId];
		
		ETPlaylist * parentPlaylist = (parentPersistentId != 0) ? [self playlistForPersistentId:parentPersistentId] : rootPlaylist;
		NSLog (@"playlist: %@ (%@) [%qi] -- parent: %@", playlistName, [playlist stringForOSType:[playlist specialKind]], [playlist persistentId], [parentPlaylist name]);
		[parentPlaylist addChildPlaylistId:[playlist persistentIdNumber]];
	}	
}

- (ETPlaylist*) playlistForPersistentId:(long long int)persistentId;
{
	return [playlists objectForKey:[NSNumber numberWithLongLong:persistentId]];
}


- (ETPlaylist*) rootUserPlaylist;
{
	return nil;
}
@end
