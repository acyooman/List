//
//  UIView+AutoLayout.m
//  List
//
//  Created by Arpit Agarwal on 19/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "UIView+AutoLayout.h"
#import <objc/runtime.h>

NSString *kHeightIdentifier = @"lxHeightIdentifier";
NSString *kWidthIdentifier = @"lxWidthIdentifier";

@implementation UIView (AutoLayout)
@dynamic topConstraint, bottomConstraint, leadingConstraint, trailingConstraint, centerXConstraint, centerYConstraint, heightConstraint, widthConstraint;

- (void)setLeadingView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:constant];
    self.leadingConstraint.active = YES;
}

- (void)setLeadingView:(UIView *)view {
    [self setLeadingView:view constant:0];
}


- (void)setAfterView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:view.trailingAnchor constant:constant];
    self.leadingConstraint.active = YES;

}

- (void)setAfterView:(UIView *)view {
    [self setAfterView:view constant:0];
}

- (void)setTrailingView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-constant];
    self.trailingConstraint.active = YES;
}

- (void)setTrailingView:(UIView *)view {
    [self setTrailingView:view constant:0];
}

- (void)setBeforeView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:view.leadingAnchor constant:-constant];
    self.trailingConstraint.active = YES;
}

- (void)setBeforeView:(UIView *)view {
    [self setBeforeView:view constant:0];
}

- (void)setTopView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.topConstraint = [self.topAnchor constraintEqualToAnchor:view.topAnchor constant:constant];
    self.topConstraint.active = YES;
}

- (void)setTopView:(UIView *)view {
    [self setTopView:view constant:0];
}

- (void)setBelowView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.topConstraint = [self.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:constant];
    self.topConstraint.active = YES;
}

- (void)setBelowView:(UIView *)view {
    [self setBelowView:view constant:0];
}


- (void)setAboveView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:view.topAnchor constant:-constant];
    self.bottomConstraint.active = YES;
}

- (void)setAboveView:(UIView *)view {
    [self setAboveView:view constant:0];
    
}


- (void)setBottomView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-constant];
    self.bottomConstraint.active = YES;

}

- (void)setBottomView:(UIView *)view {
    [self setBottomView:view constant:0];
}

- (void)setCenterXView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.centerXConstraint = [self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:constant];
    self.centerXConstraint.active = YES;

}
- (void)setCenterXView:(UIView *)view {
    [self setCenterXView:view constant:0];
}

- (void)setCenterYView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.centerYConstraint = [self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:constant];
    self.centerYConstraint.active = YES;
}

- (void)setCenterYView:(UIView *)view {
    [self setCenterYView:view constant:0];

}

- (void)setCenterView:(UIView *)view constant:(CGFloat)constant {
    if (![self validate:view]) {
        return;
    }
    self.centerYConstraint = [self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:constant];
    self.centerYConstraint.active = YES;
    self.centerXConstraint = [self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:constant];
    self.centerXConstraint.active = YES;
}

- (void)setCenterView:(UIView *)view {
    [self setCenterView:view constant:0];

}

- (void)setViewWidth:(CGFloat)constant {
    if (![self validate:self]) {
        return;
    }
    self.widthConstraint = [self.widthAnchor constraintEqualToConstant:constant];
    self.widthConstraint.active = YES;
}

- (void)setViewHeight:(CGFloat)constant {
    if (![self validate:self]) {
        return;
    }
    self.heightConstraint = [self.heightAnchor constraintEqualToConstant:constant];
    self.heightConstraint.active = YES;
}

- (void)setViewSize:(CGSize)size {
    if (![self validate:self]) {
        return;
    }
    [self setViewWidth:size.width];
    [self setViewHeight:size.height];
}

- (void)setConstraintsEqualToView:(UIView *)view {
    [self setConstraintsEqualToView:view innerPadding:0];
}

- (void)setConstraintsEqualToView:(UIView *)view innerPadding:(CGFloat)padding {
    if (![self validate:view]) {
        return;
    }
    self.leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:padding];
    self.leadingConstraint.active = YES;
    self.trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-padding];
    self.trailingConstraint.active = YES;
    self.topConstraint = [self.topAnchor constraintEqualToAnchor:view.topAnchor constant:padding];
    self.topConstraint.active = YES;
    self.bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-padding];
    self.bottomConstraint.active = YES;
}


- (void)setLeadingOriginView:(UIView *)view point:(CGPoint)point {
    if (![self validate:view]) {
        return;
    }
    self.leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:point.x];
    self.leadingConstraint.active = YES;
    self.topConstraint = [self.topAnchor constraintEqualToAnchor:view.topAnchor constant:point.y];
    self.topConstraint.active = YES;
}

- (void)setLeadingOriginView:(UIView *)view {
    [self setLeadingOriginView:view point:CGPointZero];
}


- (void)setTrailingOriginView:(UIView *)view point:(CGPoint)point {
    if (![self validate:view]) {
        return;
    }
    self.trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-point.x];
    self.trailingConstraint.active = YES;
    self.topConstraint = [self.topAnchor constraintEqualToAnchor:view.topAnchor constant:point.y];
    self.topConstraint.active = YES;
}

- (void)setTrailingOriginView:(UIView *)view {
    [self setTrailingOriginView:view point:CGPointZero];
}


- (void)setSameConstraintViewBelowView:(UIView *)view padding:(CGFloat)padding {
    if (![self validate:view]) {
        return;
    }
    self.leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor];
    self.leadingConstraint.active = YES;
    self.trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor];
    self.trailingConstraint.active = YES;
    self.topConstraint = [self.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:padding];
    self.topConstraint.active = YES;
}

- (void)setSameLeadingTrailingView:(UIView *)view {
    if (![self validate:view]) {
        return;
    }
    self.leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor];
    self.leadingConstraint.active = YES;
    self.trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor];
    self.trailingConstraint.active = YES;
}

- (NSLayoutConstraint *)getLeadingConstraint {
    return self.leadingConstraint;
}

- (NSLayoutConstraint *)getTrailingConstraint {
    return self.trailingConstraint;
}

- (NSLayoutConstraint *)getTopConstraint {
    return self.topConstraint;
}

- (NSLayoutConstraint *)getBottomConstraint {
    return self.bottomConstraint;
}

- (NSLayoutConstraint *)getHeightConstraint {
    return self.heightConstraint;
}

- (NSLayoutConstraint *)getWidthConstraint {
    return self.widthConstraint;
}

- (NSLayoutConstraint *)getCenterXConstraint {
    return self.centerXConstraint;
}

- (NSLayoutConstraint *)getCenterYConstraint {
    return self.centerYConstraint;
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    objc_setAssociatedObject(self, @selector(heightConstraint), heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heightConstraint {
    return objc_getAssociatedObject(self, @selector(heightConstraint));
}

- (void)setWidthConstraint:(NSLayoutConstraint *)widthConstraint {
    objc_setAssociatedObject(self, @selector(widthConstraint), widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)widthConstraint {
    return objc_getAssociatedObject(self, @selector(widthConstraint));
}

- (void)setTopConstraint:(NSLayoutConstraint *)topConstraint {
    objc_setAssociatedObject(self, @selector(topConstraint), topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)topConstraint {
    return objc_getAssociatedObject(self, @selector(topConstraint));
}

- (void)setBottomConstraint:(NSLayoutConstraint *)bottomConstraint {
    objc_setAssociatedObject(self, @selector(bottomConstraint), bottomConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)bottomConstraint {
    return objc_getAssociatedObject(self, @selector(bottomConstraint));
}

- (void)setLeadingConstraint:(NSLayoutConstraint *)leadingConstraint {
    objc_setAssociatedObject(self, @selector(leadingConstraint), leadingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leadingConstraint {
    return objc_getAssociatedObject(self, @selector(leadingConstraint));
}

- (void)setTrailingConstraint:(NSLayoutConstraint *)trailingConstraint {
    objc_setAssociatedObject(self, @selector(trailingConstraint), trailingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)trailingConstraint {
    return objc_getAssociatedObject(self, @selector(trailingConstraint));
}

- (void)setCenterXConstraint:(NSLayoutConstraint *)centerXConstraint {
    objc_setAssociatedObject(self, @selector(centerXConstraint), centerXConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerXConstraint {
    return objc_getAssociatedObject(self, @selector(centerXConstraint));
}

- (void)setCenterYConstraint:(NSLayoutConstraint *)centerYConstraint {
    objc_setAssociatedObject(self, @selector(centerYConstraint), centerYConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerYConstraint {
    return objc_getAssociatedObject(self, @selector(centerYConstraint));
}

- (BOOL)validate:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view == nil) {
        if (DEBUG) {
            NSAssert(YES, @"Passed and empty nil view");
        }
        return NO;
    }
    return YES;
}

@end
