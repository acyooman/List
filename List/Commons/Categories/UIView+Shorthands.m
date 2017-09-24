//
//  UIView+Shorthands.m
//  ZUIKit
//
//  Created by Arpit Agarwal on 02/07/15.
//  Copyright (c) 2015 Zomato. All rights reserved.
//

#import "UIView+Shorthands.h"

@implementation UIView (Shorthands)

- (void)setFrameX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    [self setFrame:frame];
}

- (void)setFrameY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    [self setFrame:frame];
}

- (void)setFrameHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}

- (void)setFrameWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    [self setFrame:frame];
}

- (void)setFrameOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    [self setFrame:frame];
}

- (void)setFrameSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    [self setFrame:frame];
}

//
//- (void)setTopShadow {
//    self.layer.masksToBounds = NO;
//    self.layer.shadowColor = UIColorFromRGB(ZCOLOR_TEXT).CGColor;
//    self.layer.shadowOpacity = 0.2;
//    self.layer.shadowRadius = 3.0;
//    self.layer.shadowOffset = CGSizeMake(-0.5f, -0.5f);
//}
//
//- (void)setBottomShadow {    
//    self.layer.masksToBounds = NO;
//    self.layer.shadowColor = UIColorFromRGB(ZCOLOR_TEXT).CGColor;
//    self.layer.shadowOpacity = 0.2;
//    self.layer.shadowRadius = 3.0;
//    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
//}
//
//- (void)setShadow {
//    self.layer.masksToBounds = NO;
//    self.layer.shadowColor = UIColorFromRGB(ZCOLOR_TEXT).CGColor;
//    self.layer.shadowOpacity = 0.1;
//    self.layer.shadowRadius = 2.0;
//    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//}
//
//- (void)setBorder {
//    self.layer.masksToBounds = YES;
//    self.layer.borderWidth = 1.0f;
//    self.layer.borderColor = UIColorFromRGBWithAlpha(ZCOLOR_TEXT, 0.2).CGColor;
//}

- (void)setCenterY:(CGFloat)y {
    self.center = CGPointMake(self.center.x, y);
}

- (void)setCenterX:(CGFloat)x {
    self.center = CGPointMake(x, self.center.y);
}


@end
