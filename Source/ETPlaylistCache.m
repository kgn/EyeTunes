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
	userPlaylists = [[NSMutableDictionary alloc] init];
	
	return self;
}


// as a singleton we are never dealloced but the clang statc analyzer doesn't know this
- (void) dealloc
{
	[playlists release];
	[userPlaylists release];
	
	[super dealloc];
}

- (void) reload;
{
	[playlists removeAllObjects];
	[userPlaylists removeAllObjects];
	
	
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
	ETPlaylistEnumerator * en = [[[ETPlaylistEnumerator alloc] init] autorelease];
	ETPlaylist * playlist = nil;
	while ((playlist = [en nextObject])) 
	{
		[playlists setObject:playlist forKey:[NSNumber numberWithLongLong:[playlist persistentId]]];
	}

	// set parents
	NSEnumerator * en2 = [playlists objectEnumerator];
	while ((playlist = [en2 nextObject])) 
	{
		if ([playlist persistentId] >= 0 && [playlist persistentId] <= 3) // root or categories
			continue;

		if (NO) NSLog (@"playlist: %@ (%@)", [playlist name], [playlist stringForOSType:[playlist specialKind]]);

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
		
		ETPlaylist * parentPlaylist = [self playlistForPersistentId:parentPersistentId];
		if (NO) NSLog (@"playlist: %@ (%@) [%qi] -- parent: %@", playlistName, [playlist stringForOSType:[playlist specialKind]], [playlist persistentId], [parentPlaylist name]);
		[parentPlaylist addChildPlaylistId:[playlist persistentIdNumber]];
	}	
	
	// ==== user playlist tree
	//
	
	ETPlaylist * rootUserPlaylist = [[[ETPlaylist alloc] init] autorelease];
	[rootUserPlaylist setPersistentId:kETSpecialPlaylistRoot];
	[userPlaylists setObject:rootUserPlaylist forKey:[NSNumber numberWithLongLong:kETSpecialPlaylistRoot]];
		
	en = [[[ETPlaylistEnumerator alloc] init] autorelease];
	while ((playlist = [en nextObject])) 
	{
		if ([playlist specialKind] == kETSpecialPlaylistNone || [playlist specialKind] == kETSpecialPlaylistFolder)
		{
			[userPlaylists setObject:playlist forKey:[NSNumber numberWithLongLong:[playlist persistentId]]];
		}
	}
	
	// set parents
	en2 = [userPlaylists objectEnumerator];
	while ((playlist = [en2 nextObject])) 
	{
		if ([playlist persistentId] >= 0 && [playlist persistentId] <= 3) // root or categories
			continue;
		
		if ([playlist specialKind] == kETSpecialPlaylistNone || [playlist specialKind] == kETSpecialPlaylistFolder)
		{
			ETPlaylist * parentPlaylist = [playlist parentPlaylist];
			long long parentPersistentId = [parentPlaylist persistentId];
			if (!parentPersistentId)
				[playlist setParentPlaylistId:kETSpecialPlaylistRoot];
			else
				[playlist setParentPlaylistId:parentPersistentId];			
		}
	}
	
	en2 = [userPlaylists objectEnumerator];
	while ((playlist = [en2 nextObject])) 
	{
		unsigned long long playlistPersistentID = [playlist persistentId];
		NSString * playlistName = [playlist name];
		if (playlistPersistentID == 0) // root
			continue;
		
		long long parentPersistentId = [playlist parentPlaylistId];
		
		ETPlaylist * parentPlaylist = [self userPlaylistForPersistentId:parentPersistentId];
		if (NO) NSLog (@"playlist: %@ (%@) [%qi] -- parent: %@", playlistName, [playlist stringForOSType:[playlist specialKind]], [playlist persistentId], [parentPlaylist name]);
		[parentPlaylist addChildPlaylistId:[playlist persistentIdNumber]];
	}	
}


- (ETPlaylist*) playlistForPersistentId:(long long int)persistentId;
{
	return [playlists objectForKey:[NSNumber numberWithLongLong:persistentId]];
}


- (ETPlaylist*) userPlaylistForPersistentId:(long long int)persistentId;
{
	return [userPlaylists objectForKey:[NSNumber numberWithLongLong:persistentId]];
}


@end
