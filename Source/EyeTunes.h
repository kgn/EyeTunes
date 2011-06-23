/* EyeTunes.h - Interface to iTunes Application */

/*
 
 EyeTunes.framework - Cocoa iTunes Interface
 http://www.liquidx.net/eyetunes/
 
 Copyright (c) 2005-2007, Alastair Tse <alastair@liquidx.net>
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 Neither the Alastair Tse nor the names of its contributors may
 be used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
*/

/*

1.3 : Moved the actual concrete EyeTunes object implementation to ETEyeTunes.h/m
      to avoid circular dependencies.
 
0.2 : backwards incompatible changes
  * ETAppleEventObject : getCountofElementClass.. returns int rather than AppleEvent*
  * ETTrack : databaseID renamed to databaseId
	          group renamed to grouping, type changed from int to NSString*
 
*/

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

#import "EyeTunesVersions.h"
#import "EyeTunesEventCodes.h"

#import "ETAppleEventObject.h"
#import "ETEyeTunes.h"
#import "ETTrack.h"
#import "ETPlaylist.h"
#import "ETPlaylistCache.h"
