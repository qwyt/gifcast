//
//  GifConverter.h
//  gifCast
//
//  Created by Paulius on 8/17/15.
//
//

#import <Foundation/Foundation.h>

typedef void (^CompleteConversionSession)(NSURL* tempFile);

@interface GifConverter : NSObject


@property (copy, nonatomic) CompleteConversionSession completeConversionSession;

- (void)convert : (NSURL*)file :(void (^)(NSURL* tempFile))finishBlock;

@end
