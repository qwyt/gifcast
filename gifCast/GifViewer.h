//
//  GifViewer.h
//  gifCast
//
//  Created by Paulius on 8/23/15.
//
//--
// Handles file proccesing after creation, saving to disk or dropbox folder.
//--
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
//#import "DropboxManager.h"

@import Quartz;

typedef void (^CompleteViewerSession)(BOOL saveLocally);

@interface GifViewer : NSObject

@property (copy, nonatomic) CompleteViewerSession completeViewerSession;


//
- (id) initWithSettings:(NSWindow*)window viewerImage:(IKImageView*)imageView   progressBar:(NSProgressIndicator*)progressBar convertingTextField:(NSTextField*)convertingTextField;
    
- (void)getResponseAfterCompletion:(void (^)(BOOL saveLocally))finishBlock;
-(void)showImage:(NSURL*)imageURL;

-(void)saveToDropbox;
-(void)saveLocally;
-(void)discard;


@end
