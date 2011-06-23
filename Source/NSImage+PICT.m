//
//  NSImage+PICT.m
//  EyeTunes
//
//  Created by David Keegan on 6/23/11.
//  Copyright 2011 InScopeApps {+}. All rights reserved.
//
//  From: http://www.cocoabuilder.com/archive/cocoa/82390-nsimage-to-pict.html
//

#import <QuickTime/QuickTime.h>
#import "NSImage+PICT.h"

@implementation NSImage (PICT)

- (NSData*) pictRepresentation
{
    MovieImportComponent importer;
    
    if (OpenADefaultComponent(GraphicsImporterComponentType,
                              kQTFileTypeTIFF, &importer) != noErr)
    {
        CloseComponent(importer);
        return nil;
    }
    
    Handle imageHandle;
    NSData *imageData = [self TIFFRepresentation];
    long int dataSize = [imageData length];
    (void)PtrToHand([imageData bytes], &imageHandle, dataSize);
    
    OSErr err = GraphicsImportSetDataHandle(importer, imageHandle);
    if (err != noErr)
    {
        return nil;
    }
    
    PicHandle resultPicHandle = (PicHandle)NewHandleClear(20);
    err = GraphicsImportGetAsPicture(importer, &resultPicHandle) ;
    
    NSData *returnValue = [NSData dataWithBytes:*resultPicHandle
                                         length:(int)GetHandleSize((Handle)resultPicHandle)];
    DisposeHandle((Handle)resultPicHandle);
    
    return returnValue;
}

@end
