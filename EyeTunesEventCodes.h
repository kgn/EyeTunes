/* EyeTunesEventCodes.h - Extracted AppleEvent Constants that iTunes Uses */

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

enum {
	kETPlayerStateStopped		= 'kPSS',
	kETPlayerStatePlaying		= 'kPSP',
	kETPlayerStatePaused		= 'kPSp',
	kETPlayerStateFastForwarding = 'kPSF',
	kETPlayerStateRewinding		= 'kPSR'
};

enum {
	kETRepeatModeOff			= 'kRp0',
	kETRepeatModeOne			= 'kRp1',
	kETRepeatModeAll			= 'kRpA'
};

enum {
	kETVideoSizeSmall			= 'kVSS',
	kETVideoSizeMedium			= 'kVSM',
	kETVideoSizeLarge			= 'kVSL'
};

enum {
	kETSourceLibrary			= 'kLib',
	kETSourceiPod				= 'kPod',
	kETSourceAudioCD			= 'kACD',
	kETSourceMP3CD				= 'kMCD',
	kETSourceDevice				= 'kDev',
	kETSourceRadioTuner			= 'kTun',
	kETSourceSharedLibrary		= 'kShd',
	kETSourceUnknown			= 'kUnk'
};

enum {
	kETSearchAttributeAlbums	= 'kSrL',
	kETSearchAttributeAll		= 'kSrA',
	kETSearchAttributeArtist	= 'kSrR',
	kETSearchAttributeComposers	= 'kSrC',
	kETSearchAttributeDisplayed	= 'kSrV',
	kETSearchAttributeSongs		= 'kSrs'	
};

#if ITUNES_VERSION < ITUNES_6_0
enum {
	kETSpecialPlaylistNone				= 'kSpN',
	kETSpecialPlaylistPartyShuffle		= 'kSpS',
	kETSpecialPlaylistPodcasts			= 'kSpP',
	kETSpecialPlaylistPurchasedMusic	= 'kSpM',
}; 
#else
enum {
	kETSpecialPlaylistNone				= 'kSpN',
	kETSpecialPlaylistFolder			= 'kSpF',
	kETSpecialPlaylistPartyShuffle		= 'kSpS',
	kETSpecialPlaylistPodcasts			= 'kSpP',
	kETSpecialPlaylistPurchasedMusic	= 'kSpM',
	kETSpecialPlaylistVideo				= 'kSpV',
#if ITUNES_VERSION >= ITUNES_7_0	
	kETSpecialPlaylistAudiobooks		= 'kSpA',
	kETSpecialPlaylistMovies			= 'kSpI',
	kETSpecialPlaylistMusic				= 'kSpZ',
	kETSpecialPlaylistTVShows			= 'kSpT',
#endif	
}; // ET_PLAYLIST_SPECIAL_KIND (eSpK)
#endif

enum {
	kETSpecialPlaylistRoot = 0,
	kETSpecialPlaylistCategoryLibrary = 1,
	kETSpecialPlaylistCategoryStore = 2,
	kETSpecialPlaylistCategoryPlaylists = 3,	
};

#if ITUNES_VERSION >= ITUNES_7_0
enum {
	kETVideoKindUnknown					= 'kVdN',
	kETVideoKindMovie					= 'kVdM',
	kETVideoKindMusicVideo				= 'kVdV',
	kETVideoKindTVShow					= 'kVdT',
};
#endif

enum {
	pETTrackLocation					= 'pLoc'
};


// --- itunes commmands start ---
#define ET_ADD_FILE			'Add '
#define ET_BACK_TRACK		'Back'
#define ET_CONVERT			'Conv'
#define ET_FAST_FORWARD		'Fast'
#define ET_NEXT_TRACK		'Next'
#define ET_PAUSE			'Paus'
#define ET_PLAY				'Play'
#define ET_PLAYPAUSE		'PlPs'
#define ET_PREVIOUS_TRACK	'Prev'
#define ET_REFRESH			'Rfrs'
#define ET_RESUME			'Resu'
#define ET_REWIND			'Rwnd'
#define ET_SEARCH			'Srch'
#define	ET_STOP				'Stop'
#define ET_UPDATE			'Updt'
#define ET_EJECT			'Ejct'
#define ET_SUBSCRIBE		'pSub'
#if ITUNES_VERSION >= ITUNES_7_2
#define ET_REVEAL_SELECT	'Revl'
#endif

#if ITUNES_VERSION >= ITUNES_6_0
#define ET_UPDATE_ALL_PODCASTS	'Updp'
#define ET_UPDATE_ONE_PODCAST	'Upd1'
#define ET_DOWNLOAD_PODCAST		'Dwnl'
#endif
// --- itunes commmands end ---


// --- itunes application parameters start ---
#define ET_CLASS_LIBRARY_PLAYLIST	'cLiP'
#define ET_APP_ENCODER				'pEnc'
#define ET_APP_EQ_PRESET			'pEQP'
#define ET_APP_CURRENT_PLAYLIST		'pPla'
#define ET_APP_CURRENT_STREAM_TITLE	'pStT'
#define ET_APP_CURRENT_STREAM_URL	'pStU'
#define ET_APP_CURRENT_TRACK		'pTrk'
#define ET_APP_CURRENT_VISUAL		'pVis'
#define ET_APP_FIXED_INDEXING		'pFix'
#define ET_APP_PLAYER_POSITION      'pPos'
#define ET_APP_PLAYER_STATE         'pPlS'
#define ET_APP_SELECTION			'sele'
#define ET_APP_VERSION				'vers'
// --- itunes application parameters end ---

// --- track artwork start ---
#define ET_CLASS_ARTWORK			'cArt'
#define ET_ARTWORK_PROP_FORMAT		'pFmt' // type (r)
#define ET_ARTWORK_PROP_DATA		'pPCT' // PICT (rw)
#define ET_ARTWORK_PROP_KIND		'pKnd' // integer (rw)
#if ITUNES_VERSION >= ITUNES_7_0
#define ET_ARTWORK_PROP_DOWNLOAD_FROM_ITMS	'pDlA' // bool
#endif

// --- track artwork end ---

// --- generic applescript item codes start ---
#define ET_CLASS_ITEM				'cobj'
#define ET_ITEM_PROP_CONTAINER		'cntr' // object (r)
#define ET_ITEM_PROP_NAME			'pnam' // utxt (rw)
#if ITUNES_VERSION >= ITUNES_6_0_1
#define	ET_ITEM_PROP_PERSISTENT_ID	'pPID' // double int (r)
#endif
#if ITUNES_VERSION >= ITUNES_7_3
#define ET_ITEM_PROP_PERSISTENT_ID_STRING	'pPIS' // string (r)
#endif
// --- generic applescript item codes end ---

// --- itunes track parameters start ---
#define ET_CLASS_TRACK				'cTrk'
#define ET_TRACK_PROP_ALBUM			'pAlb' // utxt
#define ET_TRACK_PROP_ARTIST		'pArt' // utxt
#define ET_TRACK_PROP_BITRATE		'pBRt' // integer
#define ET_TRACK_PROP_BPM			'pBPM' // integer
#define ET_TRACK_PROP_COMMENT		'pCmt' // utxt
#define ET_TRACK_PROP_COMPILATION	'pAnt' // bool
#define ET_TRACK_PROP_COMPOSER		'pCmp' // utxt
#define ET_TRACK_PROP_DATABASE_ID	'pDID' // integer
#define ET_TRACK_PROP_DATE_ADDED	'pAdd' // ldt
#define ET_TRACK_PROP_DISC_COUNT	'pDsC' // integer
#define ET_TRACK_PROP_DISC_NUMBER	'pDsN' // integer
#define ET_TRACK_PROP_DURATION		'pDur' // integer
#define ET_TRACK_PROP_ENABLED		'enbl' // bool
#define ET_TRACK_PROP_EQ			'pEQp' // utxt
#define ET_TRACK_PROP_FINISH		'pStp' // integer
#define ET_TRACK_PROP_GENRE			'pGen' // utxt
#define ET_TRACK_PROP_GROUPING		'pGrp' // utxt
#define ET_TRACK_PROP_KIND			'pKnd' // utxt
#define ET_TRACK_PROP_MOD_DATE		'asmo' // ldt
#define ET_TRACK_PROP_PLAYED_COUNT	'pPlC' // integer
#define ET_TRACK_PROP_PLAYED_DATE	'pPlD' // ldt
#define ET_TRACK_PROP_PODCAST		'pTPc' // bool
#define ET_TRACK_PROP_RATING		'pRte' // integer
#define ET_TRACK_PROP_SAMPLE_RATE	'pSRt' // integer
#define ET_TRACK_PROP_SIZE			'pSiz' // integer
#define ET_TRACK_PROP_START			'pStr' // integer
#define ET_TRACK_PROP_TIME			'pTim' // utxt
#define ET_TRACK_PROP_TRACK_COUNT	'pTrC' // integer
#define ET_TRACK_PROP_TRACK_NUMBER	'pTrN' // integer
#define ET_TRACK_PROP_VOLUME_ADJ	'pAdj' // integer
#define ET_TRACK_PROP_YEAR			'pYr ' // integer

#if ITUNES_VERSION >= ITUNES_6_0_2
#define ET_TRACK_PROP_BOOKMARK		'pBkt' // integer
#define ET_TRACK_PROP_BOOKMARKABLE	'pBkm' // boolean
#define ET_TRACK_PROP_CATEGORY		'pCat' // utxt
#define ET_TRACK_PROP_DESCRIPTION	'pDes' // utxt
#define ET_TRACK_PROP_LONG_DESCRIPTION 'pLds' // utxt
#define ET_TRACK_PROP_LYRICS		'pLyr' // utxt
#define ET_TRACK_PROP_SHUFFABLE		'pSfa'	// bool
#endif 

#if ITUNES_VERSION >= ITUNES_7_0
#define ET_TRACK_PROP_ALBUM_ARTIST		'pAlA' // utxt
#define ET_TRACK_PROP_EPISODE_ID		'pEpD' // utxt
#define ET_TRACK_PROP_EPISODE_NUMBER	'pEpN' // integer
#define ET_TRACK_PROP_GAPLESS			'pGpl' // bool
#define ET_TRACK_PROP_SEASON_NUMBER		'pSeN' // integer
#define ET_TRACK_PROP_SKIPPED_COUNT		'pSkC' // integer
#define ET_TRACK_PROP_SKIPPED_DATE		'pSkD' // ldt
#define ET_TRACK_PROP_SHOW				'pShw' // utxt
#define ET_TRACK_PROP_VIDEO_KIND		'pVdk' // enum (see: video kind)
#endif
#if ITUNES_VERSION >= ITUNES_7_1
#define ET_TRACK_PROP_SORT_ALBUM	'pSAl' // utxt
#define ET_TRACK_PROP_SORT_ARTIST	'pSAr' // utxt
#define ET_TRACK_PROP_SORT_NAME		'pSNm' // utxt
#define ET_TRACK_PROP_SORT_COMPOSER 'pSNm' // utxt
#define ET_TRACK_PROP_SORT_SHOW		'pSSN' // utxt
#define ET_TRACK_PROP_UNPLAYED		'pUnp' // bool
#endif

// --- itunes track parameters end ---

// --- other track classes start ---
#define ET_CLASS_FILE_TRACK			'cFlT'
#define ET_CLASS_URL_TRACK			'cURT'
#define ET_CLASS_CD_TRACK			'cCDT'
#define ET_FILE_TRACK_PROP_LOCATION 'pLoc' // alis
#define ET_URL_TRACK_PROP_ADDRESS	'pURL' // utxt
#define ET_CD_TRACK_PROP_LOCATION	'pLoc' // alis
// --- other track classes end ---

// generic playlist properies ---
#define ET_CLASS_PLAYLIST				'cPly'
#define ET_PLAYLIST_PROP_DURATION		'pDur'	// integer (r)
#define ET_PLAYLIST_PROP_INTERNAL_INDEX	'pidx'	// integer (r)
#define ET_PLAYLIST_PROP_SHUFFLE		'pShf'	// bool  (rw)
#define ET_PLAYLIST_PROP_SIZE			'pSiz'	// longlong (double int) (r)
#define ET_PLAYLIST_PROP_REPEAT			'pRpt'	// eRpt? (rw)
#define ET_PLAYLIST_PROP_SPECIAL_KIND	'pSpK'	// eSpk? (r)
#define ET_PLAYLIST_PROP_TIME			'pTim'	// utxt (r)
#define ET_PLAYLIST_PROP_VISIBLE		'pvis'	// bool (r)
#define ET_PLAYLIST_PROP_PARENT			'pPlP'  // <property name="parent" code="pPlP" type="playlist" access="r" description="folder which contains this playlist (if any)"/>
// generic playlist properies ---

// -- special playlists --
#define ET_CLASS_CD_PLAYLIST			'cCDP'	// <class name="audio CD playlist" code="cCDP" description="a playlist representing an audio CD" inherits="playlist" plural="audio CD playlists">
#define ET_CLASS_DEVICE_PLAYLIST		'cDvP'	// <class name="device playlist" code="cDvP" description="a playlist representing the contents of a portable device" inherits="playlist" plural="device playlists">
#define ET_CLASS_FOLDER_PLAYLIST		'cFoP'	// <class name="folder playlist" code="cFoP" description="a folder that contains other playlists" inherits="user playlist" plural="folder playlists"/>
#define ET_CLASS_USER_PLAYLIST			'cUsP'	// <class name="user playlist" code="cUsP" description="custom playlists created by the user" inherits="playlist" plural="user playlists">
#define ET_CLASS_RADIOTUNER_PLAYLIST	'cRTP'  // <class name="radio tuner playlist" code="cRTP" description="the radio tuner playlist" inherits="playlist" plural="radio tuner playlists">

