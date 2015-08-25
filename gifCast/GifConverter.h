//
//  GifConverter.h
//  gifCast
//
//  Created by Paulius on 8/17/15.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef void (^CompleteConversionSession)(NSImage* convertedImage);

@interface GifConverter : NSObject


@property (copy, nonatomic) CompleteConversionSession completeConversionSession;

- (void)convert : (NSURL*)file :(void (^)(NSImage* convertedImage))finishBlock;

@end
