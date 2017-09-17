//
//  UIView+Shorthands.h
//  ZUIKit
//
//  Created by Arpit Agarwal on 02/07/15.
//  Copyright (c) 2015 Zomato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  This category class contains shorthand functions for typing commong code faster related to UIViews.
 */

@interface UIView (Shorthands)


/**
 *  Shorthands for setting frames. These methods change the individual metric of the current UIView frame.
 */
- (void)setFrameX:(CGFloat)x;
- (void)setFrameY:(CGFloat)y;
- (void)setFrameHeight:(CGFloat)height;
- (void)setFrameWidth:(CGFloat)width;
- (void)setFrameOrigin:(CGPoint)origin;
- (void)setFrameSize:(CGSize)size;

//- (void)setTopShadow;
//- (void)setBottomShadow;
//- (void)setShadow;
//- (void)setBorder;

- (void)setCenterY:(CGFloat)y;
- (void)setCenterX:(CGFloat)x;


@end
