//
//  ItemTextField.m
//  List
//
//  Created by Arpit Agarwal on 17/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "ItemTextField.h"

@implementation ItemTextField
@dynamic delegate;

- (void)deleteBackward {
    [super deleteBackward];
    
    NSLog(@"BackSpace Detected");
    if([self.delegate respondsToSelector:@selector(didDeleteBackward:)]) {
        [self.delegate didDeleteBackward:self];
    }
}

@end
