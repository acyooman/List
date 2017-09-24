//
//  UIView+AutoLayout.h
//  Zomato
//
//  Created by Anurag on 27/04/17.
//  Copyright © 2017 Zomato Media Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kHeightIdentifier;
extern NSString *kWidthIdentifier;

@interface UIView (AutoLayout)

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *trailingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *centerXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *centerYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

- (void)setLeadingView:(UIView *)view constant:(CGFloat)constant;
- (void)setLeadingView:(UIView *)view;

- (void)setAfterView:(UIView *)view constant:(CGFloat)constant;
- (void)setAfterView:(UIView *)view;

- (void)setTrailingView:(UIView *)view constant:(CGFloat)constant;
- (void)setTrailingView:(UIView *)view;

- (void)setBeforeView:(UIView *)view constant:(CGFloat)constant;
- (void)setBeforeView:(UIView *)view;

- (void)setTopView:(UIView *)view constant:(CGFloat)constant;
- (void)setTopView:(UIView *)view;

- (void)setBelowView:(UIView *)view constant:(CGFloat)constant;
- (void)setBelowView:(UIView *)view;

- (void)setAboveView:(UIView *)view constant:(CGFloat)constant;
- (void)setAboveView:(UIView *)view;

- (void)setBottomView:(UIView *)view constant:(CGFloat)constant;
- (void)setBottomView:(UIView *)view;

- (void)setCenterXView:(UIView *)view constant:(CGFloat)constant;
- (void)setCenterXView:(UIView *)view;

- (void)setCenterYView:(UIView *)view constant:(CGFloat)constant;
- (void)setCenterYView:(UIView *)view;

- (void)setCenterView:(UIView *)view constant:(CGFloat)constant;
- (void)setCenterView:(UIView *)view;


- (void)setViewWidth:(CGFloat)constant;
- (void)setViewHeight:(CGFloat)constant;
- (void)setViewSize:(CGSize)size;

- (void)setConstraintsEqualToView:(UIView *)view;
- (void)setConstraintsEqualToView:(UIView *)view innerPadding:(CGFloat)padding;

- (void)setLeadingOriginView:(UIView *)view point:(CGPoint)point;
- (void)setLeadingOriginView:(UIView *)view;

- (void)setTrailingOriginView:(UIView *)view point:(CGPoint)point;
- (void)setTrailingOriginView:(UIView *)view;

- (void)setSameConstraintViewBelowView:(UIView *)view padding:(CGFloat)padding;

- (void)setSameLeadingTrailingView:(UIView *)view;

- (NSLayoutConstraint *)getLeadingConstraint;
- (NSLayoutConstraint *)getTrailingConstraint;
- (NSLayoutConstraint *)getTopConstraint;
- (NSLayoutConstraint *)getBottomConstraint;
- (NSLayoutConstraint *)getWidthConstraint;
- (NSLayoutConstraint *)getHeightConstraint;
- (NSLayoutConstraint *)getCenterXConstraint;
- (NSLayoutConstraint *)getCenterYConstraint;


@end
