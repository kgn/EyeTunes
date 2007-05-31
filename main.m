#import "EyeTunes.h"

void test_get_tracks_by_search(EyeTunes *e) {
	NSArray *tracks = [e search:[e libraryPlaylist] forString:@"AT17" inField:kETSearchAttributeArtist];
	if (tracks) {
		NSEnumerator *e = [tracks objectEnumerator];
		ETTrack *t = nil;
		while (t = [e nextObject]) {
			NSLog(@"> %@", [t name]);
		}
	}
}

void test_get_tracks_of_playlist(EyeTunes *e, ETPlaylist *pl) {
	NSEnumerator *en = [pl trackEnumerator];
	ETTrack *t = nil;
	while (t = [en nextObject]) {
		NSLog(@"> %@", [t name]);
	}
}

void test_get_playlists(EyeTunes *e) {
	NSLog(@"Get Playlists:");
	
	NSEnumerator *en = [e playlistEnumerator];
	ETPlaylist *pl = nil;
	while (pl = [en nextObject]) {
		NSLog(@"> %@", [pl name]);
		/*
		if ([[pl name] isEqualTo:@"Chi 5 - Male"]) {
			test_get_tracks_of_playlist(e, pl);
		}
		*/
	}
}

void test_get_selected(EyeTunes *e) {
	NSLog(@"Selected Playlists:");
	NSArray *selected = [e selectedTracks];
	NSEnumerator *en = [selected objectEnumerator];
	ETTrack *t = nil;
	
	while (t = [en nextObject]) {
		NSLog(@"> %@", [t name]);
	}
}

void test_dupe_selected_image(EyeTunes *e) {
	NSLog(@"Selected Playlists:");
	NSArray *selected = [e selectedTracks];
	NSEnumerator *en = [selected objectEnumerator];
	ETTrack *t = nil;
	
	while (t = [en nextObject]) {
		NSArray *artwork = [t artwork];
		if ([artwork count] > 0) {
			NSImage *image = [artwork objectAtIndex:0];
			[t setArtwork:image atIndex:1];
		}
		NSLog(@"> %@", [t name]);
	}
}

void test_get_track(EyeTunes *e) {
	ETTrack *t = [[e libraryPlaylist] trackWithDatabaseId:4141];
	NSLog(@"Title: %@", [t name]);
}

void test_set_track_details(EyeTunes *e) {
	NSArray *selected  = [e selectedTracks];
	ETTrack *t = nil;
	if ([selected count] > 0) {
		t = [selected objectAtIndex:0];
	}
	
	NSString *trackName = [t name];
	NSLog(@"Selected Track: %@", [t name]);
	[t setName:@"EyeTunes Test !!! ~~~"];
	NSLog(@"Selected Track Renamed To: %@", [t name]);
	[t setName:trackName];
	NSLog(@"Selected Track Renamed back to: %@", [t name]);
}

void test_track_persistent_id(EyeTunes *e) {
	NSEnumerator *iter = [[e selectedTracks] objectEnumerator];
	ETTrack *t = nil;
	while (t = [iter nextObject]) {
		long long int persistentId = [t persistentId];
		NSLog(@"Track Persistent ID (%llX): %@", persistentId, [t name]);
	}
}

void test_playlist_persistent_id(EyeTunes *e) {
	ETPlaylist *pl;
	NSEnumerator *iter = [e playlistEnumerator];
	
	while (pl = [iter nextObject]) {
		long long int persistentId = [pl persistentId];
		NSString *name = [pl name];
		NSLog(@"Playlist: %@ (%llX): %lld", name, persistentId, persistentId);
		ETPlaylist *fetchTry = [e playlistWithPersistentId:persistentId];
		if (fetchTry)
			NSLog(@"Fetch successful: %@", [fetchTry name]);
	}
}
/*
void test_select_playlist_by_persistent_id(EyeTunes *e) {
	ETPlaylist *pl = [e playlistWithPersistentId:(long long int)0x226503a94aec44b2];
	NSLog(@"Playlist : %@", [pl name]);
}
*/
int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	EyeTunes *e = [EyeTunes sharedInstance];
	
	//test_get_playlists(e);
	//test_get_track(e);
	//test_get_tracks_by_search(e);
	//test_get_selected(e);
	//test_dupe_selected_image(e);
	//test_set_track_details(e);
	//test_playlist_persistent_id(e);
	//test_select_playlist_by_persistent_id(e);
	test_track_persistent_id(e);
	
	[pool release];
    return 0;
}

