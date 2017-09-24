//
//  ListTableViewCell.m
//  List
//
//  Created by Arpit Agarwal on 14/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "ListTableViewCell.h"
#import "ItemTextField.h"
#import "CommonFunctions.h"
#import "AABookmarkView.h"

@interface ListTableViewCell () <UITextFieldDelegate, UIGestureRecognizerDelegate, ItemTextFieldDelegate> {
    UIColor *highlightButtonColorEmpty;
    UIColor *highlightButtonColorFill;
    
}

@property (nonatomic, strong) ItemTextField *textField;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CAGradientLayer *highlightingLayer;

@property (nonatomic, strong) CAGradientLayer *bgGradientLayer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic) CGFloat panGestureStartX;
@property (nonatomic) CGFloat panGestureDeltaX;
@property (nonatomic) BOOL shouldEndPanGesture;

@property (nonatomic, strong) ListItem *listItem;
@property (nonatomic)BOOL isStandingOut;

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *restoreButton;

@property (nonatomic) NSInteger backspaceCount;

@property (nonatomic, strong) AABookmarkView *bookmarkBGView;

@property (nonatomic, strong) UIButton *highlightButtonLeft;
@property (nonatomic, strong) UIButton *highlightButtonRight;

@end

@implementation ListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setDefaults];
        [self createViews];
    }
    
    return self;
}

- (void)setDefaults {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setShouldStandOut:NO isUserAction:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    self.backspaceCount = 0;
    
    //colors
    highlightButtonColorEmpty = UIColorFromRGBWithAlpha(ColorHighlight, 0.8f);
    highlightButtonColorFill = UIColorFromRGBWithAlpha(ColorWhite, 0.8f);
}

- (void)createViews {
    //Buttons
    
    //restore button
    self.restoreButton = [self getListButtonWithX:0.0f text:@"Restore"];
    [self.restoreButton addTarget:self action:@selector(didTapRestoreButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.restoreButton];
    
    //delete button
    self.deleteButton = [self getListButtonWithX:[CommonFunctions getPhoneWidth]/2 text:@"Delete"];
    [self.deleteButton addTarget:self action:@selector(didTapDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    
    //green gradient
    self.bgGradientLayer = [CAGradientLayer layer];
    [self.bgGradientLayer setFrame:self.bounds];
    [self.bgGradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [self.bgGradientLayer setEndPoint:CGPointMake(1.0, 0.5)];
    [self.bgGradientLayer setHidden:YES];
    [self.bgGradientLayer setColors:[self getGradientForBackground]];
    [self.contentView.layer insertSublayer:self.bgGradientLayer atIndex:0];
    
    //container view
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.containerView];
    
    //highlighting
    self.highlightingLayer = [CAGradientLayer layer];
    [self.highlightingLayer setFrame:self.bounds];
    [self.highlightingLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [self.highlightingLayer setEndPoint:CGPointMake(1.0, 0.5)];
    [self.highlightingLayer setHidden:YES];
    [self.highlightingLayer setColors:[self getGradientForHighlight]];
    [self.containerView.layer insertSublayer:self.highlightingLayer atIndex:0];
    
    //pan gesture for swipe
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
    [self.containerView addGestureRecognizer:self.panGesture];
    [self.panGesture setDelegate:self];
    [self.panGesture setEnabled:YES];
    
    //bookmark background
    self.bookmarkBGView = [[AABookmarkView alloc] init];
    [self.bookmarkBGView setHidden:YES];
    [self.containerView addSubview:self.bookmarkBGView];
    
    //text field
    self.textField = [[ItemTextField alloc] initWithFrame:CGRectMake(24, 20, [CommonFunctions getPhoneWidth]-40, 24)];
    [self.containerView addSubview:self.textField];
    [self.textField setDelegate:self];
    
    //text field - customize
    [self.textField setFont:FontSemibold(18)];
    [self.textField setTintColor:[UIColor whiteColor]];
    [self.textField setTextColor:UIColorFromRGB(0xFAFAFA)];
    [self.textField setClearButtonMode:UITextFieldViewModeNever];
    
    //text field - keyboard
    [self.textField setKeyboardType:UIKeyboardTypeDefault];
    [self.textField setKeyboardAppearance:UIKeyboardAppearanceDark];
    //    [self.textField setAdjustsFontSizeToFitWidth:YES];
    [self.textField setReturnKeyType:UIReturnKeyNext];
    
    //highlight button
    self.highlightButtonLeft = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.highlightButtonLeft setFrame:CGRectMake(0.0f, 0.0f, 120.0f, 70)];
    [self.highlightButtonLeft addTarget:self action:@selector(didTapHighlightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.highlightButtonLeft setBackgroundColor:UIColorFromRGB(ColorRed)];
    [self.highlightButtonLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.highlightButtonLeft setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    //    [self.highlightButton setHitTestEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 44)];
    [self.highlightButtonLeft setTitle:@"◦" forState:UIControlStateNormal];
    [self.highlightButtonLeft setTitleEdgeInsets:UIEdgeInsetsMake(0, 7.0f, 0.0, 0.0)];
    [self.highlightButtonLeft.titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [self.highlightButtonLeft.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3]];
    [self.highlightButtonLeft setTitleColor:UIColorFromRGBWithAlpha(ColorHighlight, 0.8f) forState:UIControlStateNormal];
    [self.highlightButtonLeft setBackgroundColor:[UIColor clearColor]];
    [self.containerView addSubview:self.highlightButtonLeft];
}

- (UIButton *)getListButtonWithX:(CGFloat)x text:(NSString *)text {
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [actionButton setTitle:text forState:UIControlStateNormal];
    [actionButton.titleLabel setFont:FontRegular(18)];
    [actionButton setTitleColor:UIColorFromRGB(ColorLessDarkBG) forState:UIControlStateNormal];
    [actionButton setFrame:CGRectMake(x, 0, [CommonFunctions getPhoneWidth]/2, self.bounds.size.height)];
    
    return actionButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.restoreButton setFrameHeight:self.bounds.size.height];
    [self.deleteButton setFrameHeight:self.bounds.size.height];
    
    [self.containerView setFrame:self.bounds];
    [self.highlightingLayer setFrame:self.bounds];
    [self.highlightButtonLeft setFrameHeight:self.bounds.size.height];
    [self.bookmarkBGView setCenterY:self.bounds.size.height/2];
    [self.containerView setTransform:CGAffineTransformIdentity];
    [self.textField setFrame:CGRectMake(24, 20, [CommonFunctions getPhoneWidth]-40, 24)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.textField becomeFirstResponder];
    } else {
        [self.textField resignFirstResponder];
    }
}

#pragma mark - Button Delegates
- (void)didTapRestoreButton {
    if([self.delegate respondsToSelector:@selector(didTapRestoreOnCellIndex:)]) {
        [self.delegate didTapRestoreOnCellIndex:self.cellIndex];
    }
}

- (void)didTapDeleteButton {
    if([self.delegate respondsToSelector:@selector(didTapDeleteOnCellIndex:)]) {
        [self.delegate didTapDeleteOnCellIndex:self.cellIndex];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:[self superview]];
        
        // Check for horizontal gesture
        if (fabs(translation.x) > fabs(translation.y)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGesture && gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        return NO;
    }
    return YES;
}

#pragma mark  - Pan Gesture Stuff
- (void)panGestureCallback:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translatedPoint = [gestureRecognizer translationInView:self];
    CGPoint velocityInView = [gestureRecognizer velocityInView:self];
    CGFloat dismissThresh = [CommonFunctions getPhoneWidth]/2;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.panGestureStartX = translatedPoint.x;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            self.panGestureDeltaX = translatedPoint.x - self.panGestureStartX;
            NSLog(@"Pangesture delta = %@\ntranslatedPoint = %@, velocity = %@", @(self.panGestureDeltaX), @(translatedPoint), @(velocityInView));
            [self.containerView setTransform:CGAffineTransformMakeTranslation(self.panGestureDeltaX, 0.0f)];
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (fabs(self.panGestureDeltaX) > dismissThresh) {
                if (self.panGestureDeltaX > 0) {
                    [self swipeOffToRight];
                }else {
                    [self swipeOffToLeft];
                }
            }else if (fabs(velocityInView.x) > 1000.f) {
                if (velocityInView.x < 0) {
                    [self swipeOffToLeft];
                }else {
                    [self swipeOffToRight];
                }
            }else {
                [self resetSwipeToCenter];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)resetSwipeToCenter {
    [UIView animateWithDuration:0.3 animations:^{
        //        [self.containerView setAlpha:1.0f];
        [self.containerView setTransform:CGAffineTransformIdentity];
    }completion:^(BOOL finished) {
    }];
}

- (void)swipeOffToRight {
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        //        [self.containerView setAlpha:0.0f];
        [self.containerView setTransform:CGAffineTransformMakeTranslation([CommonFunctions getPhoneWidth],0.0f)];
    }completion:^(BOOL finished) {
        if (!self.listItem.isDone) {
            [self swipeOffCompleted];
        }
        
    }];
}

- (void)swipeOffToLeft {
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //        [self.containerView setAlpha:0.0f];
                         [self.containerView setTransform:CGAffineTransformMakeTranslation(-[CommonFunctions getPhoneWidth],0.0f)];
                     }completion:^(BOOL finished) {
                         if (!self.listItem.isDone) {
                             [self swipeOffCompleted];
                         }
                     }];
}

- (void)swipeOffCompleted {
    if (self.listItem.isDone) {
        if ([self.delegate respondsToSelector:@selector(didSwipeOutCellIndex:)]) {
            [self.delegate didSwipeOutCellIndex:self.cellIndex];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(didSwipeOutCellIndex:)]) {
            [self.delegate didSwipeOutCellIndex:self.cellIndex];
        }
    }
}

#pragma mark - Double Tap Interaction Highlight
- (void)didTapHighlightButton {
    if (self.listItem.isDone) {
        return;
    }
    self.isStandingOut = !self.isStandingOut;
    [self setShouldStandOut:self.isStandingOut isUserAction:YES];
}

- (void)doubleTapGestureCallback {
    if (self.listItem.isDone) {
        return;
    }
    self.isStandingOut = !self.isStandingOut;
    [self setShouldStandOut:self.isStandingOut isUserAction:YES];
    [self.textField resignFirstResponder];
}

#pragma mark - Reuse
- (void)prepareForReuse {
    [super prepareForReuse];
    self.backspaceCount = 0;
    [self setShouldStandOut:NO isUserAction:NO];
    self.textField.text = @"";
    [self.bookmarkBGView setHidden:YES];
    [self.containerView setTransform:CGAffineTransformIdentity];
    [self.containerView setAlpha:1.0f];
    
    //highlighting buttons
    [self.highlightButtonLeft setHidden:YES];
    [self.highlightButtonRight setHidden:YES];
    
    //if changed for bookmark
    [self.textField setTintColor:[UIColor whiteColor]];
    [self.textField setTextColor:UIColorFromRGB(0xFAFAFA)];
}

#pragma mark - Helpers
- (NSArray *)getGradientForBookmark {
    return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xFFFFFF) CGColor], (id)[UIColorFromRGB(0xEFEFEF) CGColor], nil];
}

- (NSArray *)getGradientForBackground {
    return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x69A7EE) CGColor], (id)[UIColorFromRGB(0x4990E2) CGColor], nil];
}

- (NSArray *)getGradientForHighlight {
    UIColor *startColor = UIColorFromRGB(0x673BEC);
    UIColor *endColor = UIColorFromRGB(0xA63FF9);
    return [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
}

#pragma mark - UITextFieldDelegate, ItemTextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(didTapNextOnCellIndex:)]) {
        [self.delegate didTapNextOnCellIndex:self.cellIndex];
        return YES;
    }
    return YES;
}

- (void)didDeleteBackward:(ItemTextField *)textField {
    if(textField.text.length == 0) {
        self.backspaceCount += 1;
        if (self.backspaceCount == 2) {
            self.backspaceCount = 0;
            if ([self.delegate respondsToSelector:@selector(didBackspaceEmptyCell:)]) {
                [self.delegate didBackspaceEmptyCell:self.cellIndex];
            }
        }
        
    }
}


#pragma mark - Setters

- (void)setShouldStandOut:(BOOL)shouldStandOut isUserAction:(BOOL)isUserAction {
    
    if ([self.listItem.text hasPrefix:@"#"]) {
        //sanity checks to prevent bookmarks from highlight
        shouldStandOut = NO;
    }
    
    self.isStandingOut = shouldStandOut;
    
    if (isUserAction) {
        //animate in case of user action
        //        [self.highlightingLayer setAffineTransform:CGAffineTransformMakeTranslation(shouldStandOut?-10:0.0f, 0.0f)];
        [self.highlightingLayer setOpacity:!shouldStandOut?1.0f:0.0f];
        [self.highlightingLayer setOpacity:!shouldStandOut?1.0f:0.0f];
        [self.highlightingLayer setHidden:NO];
        
        [UIView animateWithDuration:0.4f animations:^{
            [self.highlightingLayer setOpacity:shouldStandOut?1.0f:0.0f];
            [self.textField setAlpha:shouldStandOut?1.0f:0.9f];
            //            [self.highlightingLayer setAffineTransform:CGAffineTransformMakeTranslation(!shouldStandOut?-10:0.0f, 0.0f)];
            if (shouldStandOut) {
                [self.highlightButtonLeft setTitleColor:highlightButtonColorFill forState:UIControlStateNormal];
                [self.highlightButtonLeft setTitle:@"•" forState:UIControlStateNormal];
            }else {
                [self.highlightButtonLeft setTitleColor:highlightButtonColorEmpty forState:UIControlStateNormal];
                [self.highlightButtonLeft setTitle:@"◦" forState:UIControlStateNormal];
            }
        } completion:^(BOOL finished) {
            if(!shouldStandOut) {
                [self.highlightingLayer setHidden:YES];
            }
            
            [self.highlightingLayer setOpacity:1.0f];
            
            if([self.delegate respondsToSelector:@selector(didToggleStandOutStateAtIndex:isStandingOut:)]){
                [self.delegate didToggleStandOutStateAtIndex:self.cellIndex isStandingOut:shouldStandOut];
            }
        }];
    }else {
        [self.highlightingLayer setHidden:!shouldStandOut];
        [self.textField setAlpha:shouldStandOut?1.0f:0.9f];
        
        if (shouldStandOut) {
            [self.highlightButtonLeft setTitleColor:highlightButtonColorFill forState:UIControlStateNormal];
            [self.highlightButtonLeft setTitle:@"•" forState:UIControlStateNormal];
        }else {
            [self.highlightButtonLeft setTitleColor:highlightButtonColorEmpty forState:UIControlStateNormal];
            [self.highlightButtonLeft setTitle:@"◦" forState:UIControlStateNormal];
        }
    }
}

- (void)setListItem:(ListItem *)listItem {
    _listItem = listItem;
    [self.textField setText:listItem.text];
    [self setCellDoneStuff:listItem.isDone];
    
    //highlight buttons enable/disable
    [self updateHighlightButtons];
    
}

- (void)setCellDoneStuff:(BOOL)isDone {
    if (isDone) {
        [self setShouldStandOut:NO isUserAction:NO];
        [self.containerView setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
        [self.contentView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
        [self.textField setEnabled:NO];
        [self.restoreButton setAlpha:1.0f];
        [self.deleteButton setAlpha:1.0f];
        [self.bookmarkBGView setHidden:YES];
        [self.highlightButtonLeft setHidden:YES];
        [self.highlightButtonRight setHidden:YES];
        [self setUserInteractionEnabled:NO]; //TODO:CELL REMOVE STUFF
    }else {
        [self setShouldStandOut:self.listItem.isHighlighted isUserAction:NO];
        [self.textField setEnabled:YES];
        [self.containerView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
        [self.contentView setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
        [self.restoreButton setAlpha:0.0f];
        [self.deleteButton setAlpha:0.0f];
        
        [self.highlightButtonLeft setHidden:NO];
        [self.highlightButtonRight setHidden:NO];
        [self checkIfBookmark:NO];
        [self setUserInteractionEnabled:YES]; //TODO:CELL REMOVE STUFF
    }
}

- (void)checkIfBookmark:(BOOL)animated {
    if ([self.textField.text hasPrefix:@"#"]) {
        BOOL wasHidden = self.bookmarkBGView.hidden;
        [self.bookmarkBGView setHidden:NO];
        [self.bookmarkBGView setText:self.textField.text];
        
        if (self.textField.text.length == 1 && animated && wasHidden) {
            [self.bookmarkBGView setTransform:CGAffineTransformMakeTranslation(-80.0f, 0.0)];
            [self.bookmarkBGView setAlpha:0.0];
            [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self.bookmarkBGView setTransform:CGAffineTransformMakeTranslation(0.0, 0.0f)];
                [self.bookmarkBGView setAlpha:1.0];
            } completion:^(BOOL finished) {
                
            }];
        }
        
        //changed to light bookmark
        [self.textField setTintColor:UIColorFromRGB(ColorDarkBG)];
        [self.textField setTextColor:UIColorFromRGB(ColorDarkBG)];
    }else {
        [self.bookmarkBGView setHidden:YES];
        
        //reset
        [self.textField setTintColor:[UIColor whiteColor]];
        [self.textField setTextColor:UIColorFromRGB(0xFAFAFA)];
    }
    
    [self updateHighlightButtons];
}

#pragma mark - Notification
-(void)updateHighlightButtons{
    //highlight buttons enable/disable
    BOOL isEmpty = (self.textField.text.length == 0);
    BOOL isBookmark = [self.textField.text hasPrefix:@"#"];
    BOOL shouldHide = isEmpty || isBookmark || self.listItem.isDone;
    
    [self.highlightButtonLeft setHidden:shouldHide];
    [self.highlightButtonRight setHidden:shouldHide];
}

- (void)textDidUpdateCallback {
    [self checkIfBookmark:YES];
    
    //highlight buttons enable/disable
    [self updateHighlightButtons];
    
    if ([self.delegate respondsToSelector:@selector(didUpdateWithText:cellIndex:)]) {
        [self.delegate didUpdateWithText:self.textField.text cellIndex:self.cellIndex];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidUpdateCallback) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
