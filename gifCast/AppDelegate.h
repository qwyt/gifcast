//
//  AppDelegate.h
//  gifCast
//
//  Created by Paulius on 8/9/15.
//
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusItem;


- (IBAction)captureScreen:(id)sender;

@property (copy) NSURL*    file;

@end

