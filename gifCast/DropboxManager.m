//
//  DropboxManager.m
//  gifCast
//
//  Created by Paulius on 8/19/15.
//
///Users/paulius/proj/gifCast/gifCast/dropbox-osx-sdk-1.3.13/DropboxSDK

#import "DropboxManager.h"
#import <DropboxOSX/DropboxOSX.h>
#import <stdlib.h>
#import <time.h>


@implementation DropboxManager{
    
    DBSession *dbSession;
    NSString* appKey;
    NSString* appSecret;
    NSString* root;
    
    AppDelegate* del;
    
}

-(id)initSession:(AppDelegate*)appDelegate{

    del = appDelegate;
    
    appKey = @"24ts8e3emtru28n";
    appSecret = @"rwg7l25cttgcjfs";
    
    
    root = kDBRootAppFolder; // Should be either kDBRootDropbox or kDBRootAppFolder
    
    
    DBSession *session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
    [DBSession setSharedSession:session];
    
    NSDictionary *plist = [[NSBundle mainBundle] infoDictionary];
    NSString *actualScheme = [[[[plist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
    NSString *desiredScheme = [NSString stringWithFormat:@"db-%@", appKey];
    NSString *alertText = nil;
    if ([appKey isEqual:@"APP_KEY"] || [appSecret isEqual:@"APP_SECRET"] || root == nil) {
        alertText = @"Fill in appKey, appSecret, and root in AppDelegate.m to use this app";
        
    } else if (![actualScheme isEqual:desiredScheme]) {
        alertText = [NSString stringWithFormat:@"Set the url scheme to %@ for the OAuth authorize page to work correctly is: %@", desiredScheme, actualScheme];
    }
    

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(authHelperStateChangedNotification:)
     name:DBAuthHelperOSXStateChangedNotification
     object:[DBAuthHelperOSX sharedHelper]];

    
    if ([[DBSession sharedSession] isLinked]) {
        NSLog(@"DropBox acc linked");
    }
    
    return self;
}

- (IBAction)linkDropboxAcc:(id)sender {
    if ([[DBSession sharedSession] isLinked]) {
        // The link button turns into an unlink button when you're linked
        [[DBSession sharedSession] unlinkAll];
        //restClient = nil;
        NSLog(@"[[DBSession sharedSession] isLinked");
    } else {
        [[DBAuthHelperOSX sharedHelper] authenticate];
    }
}

//
- (void)authHelperStateChangedNotification:(NSNotification *)notification {
    if ([[DBSession sharedSession] isLinked]) {
        // You can now start using the API!
        [del updateLinkStatus:YES];
        
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
     //   self.restClient.delegate = self;
    }
}

-(void)saveFile:(NSURL*)localFile{
    // Write a file to the local documents directory
    NSString *text = @"Hello world.";
    NSString *filename = @"working-draft.txt";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
}



@end
