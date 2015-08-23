//
//  DropboxManager.h
//  gifCast
//
//  Created by Paulius on 8/19/15.
//
//

#import <Foundation/Foundation.h>


#import <Cocoa/Cocoa.h>

#import <DropboxOSX/DropboxOSX.h>
#import <WebKit/WebKit.h>
#import "AppDelegate.h"



@interface DropboxManager : NSObject

-(id)initSession:(AppDelegate*)appDelegatea;

- (IBAction)linkDropboxAcc:(id)sender;

-(void)saveFile:(NSURL*)localFile;

@property (nonatomic, strong) DBRestClient *restClient;

@end