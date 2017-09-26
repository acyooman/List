//
//  ListItemTextView.m
//  Listix
//
//  Created by Arpit Agarwal on 24/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "ListItemTextView.h"
#import "CommonFunctions.h"

@interface ListItemTextView ()

@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic) BOOL shouldAnimatePlaceholder;
@end

@implementation ListItemTextView

@synthesize listItemTextViewDelegate = _listItemTextViewDelegate;

- (instancetype)init {
    if (self = [super init]) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit {
    self.shouldAnimatePlaceholder = YES;
    [self setupTextView];
    [self layoutUI];
}

- (void)setupTextView {
    self.font = FontMedium(18);
    self.textColor = UIColorFromRGB(ColorWhite);
    self.textAlignment = NSTextAlignmentNatural;
    self.clipsToBounds = NO;
    self.scrollEnabled = NO;
    self.textContainerInset = UIEdgeInsetsMake(0,  - 5.0, 0, kPaddingRegular - 5.0);
    
    [self getHeightConstraint].active = NO;
    
    self.heightConstraint = [self.heightAnchor constraintGreaterThanOrEqualToConstant:30.0];
    self.heightConstraint.identifier = kHeightIdentifier;
    self.heightConstraint.active = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutUI) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutUI) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutUI) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutUI];
}

- (void)layoutUI {
    // calculate size needed for the text to be visible without scrolling
    CGSize sizeThatFits = [self sizeThatFits:self.frame.size];
    float newHeight = sizeThatFits.height;
    //    [self updatePlaceHolder];
    
    if (self.heightConstraint.constant != newHeight) {
        // update the height constraint
        self.heightConstraint.constant = newHeight;
        [self.superview layoutIfNeeded];
        if ([self.listItemTextViewDelegate respondsToSelector:@selector(didAdjustHeight)]) {
            [self.listItemTextViewDelegate didAdjustHeight];
        }
    }
}

- (void)setListItemTextViewDelegate:(id<ListItemTextViewDelegate>)listItemTextViewDelegate {
    _listItemTextViewDelegate = listItemTextViewDelegate;
    self.delegate = listItemTextViewDelegate;
}

- (id<ListItemTextViewDelegate>)listItemTextViewDelegate {
    return _listItemTextViewDelegate;
}

@end
