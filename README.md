EyeTunes framework
======

EyeTunes.framework is a Cocoa Framework that abstracts away all the ugly Carbon Apple Events magic and allows you to directly control iTunes from any Cocoa Application.

This is a fork of the original [EyeTunes](http://www.liquidx.net/eyetunes/) project with support for iTunes 10 and other updates.

Features
------

* AppStore compliant.
* Get all references to iTunes playlists, tracks and album art.
* Add playlists, update playlists and delete tracks.
* Set any writable fields that iTunes exposes such as Track name, artwork and much more.
* Control iTunes and select playlists and tracks by using either track filenames or database ids.
* Search the iTunes library just like the search box does.
* Extract persistent ID and fetch tracks using such ids.
* Launch and quit iTunes.

Example
------

To grab an NSImage from the current playing track (say you're implementing some new album art viewier), you can use this simple snippet:

    #import <EyeTunes/EyeTunes.h>
    
    - (NSImage *)getArtworkOfPlayingSong{
        EyeTunes *eyetunes = [EyeTunes sharedInstance];
        ETTrack *currentTrack = [eyetunes currentTrack];
        if(currentTrack){
            NSArray *artwork = [currentTrack artwork];
            if([artwork count]){
                return [artwork objectAtIndex:0];
            }
        }
        return nil;
    }
