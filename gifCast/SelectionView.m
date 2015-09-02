//
//  SelectionView.m
//  gifCast
//
//  Created by Paulius on 9/2/15.
//
//

#import "SelectionView.h"

@implementation SelectionView{
    
    NSColor* backgroundColor;

}

-(id)initSelection:(NSRect)viewRect{
    
    self = [super initWithFrame:viewRect];
    
    [self setWantsLayer:YES];
    
    backgroundColor = [NSColor blueColor];
    
    return self;
}


@end
