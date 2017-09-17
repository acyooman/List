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

@interface ListTableViewCell () <UITextFieldDelegate, UIGestureRecognizerDelegate, ItemTextFieldDelegate>
@property (nonatomic, strong) UIView *bottomSeparator;

@property (nonatomic, strong) ItemTextField *textField;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CAGradientLayer *highlightingLayer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic) CGFloat panGestureStartX;
@property (nonatomic) CGFloat panGestureDeltaX;
@property (nonatomic) BOOL shouldEndPanGesture;

@property (nonatomic, strong) ListItem *listItem;
@property (nonatomic)BOOL shouldStandOut;

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *restoreButton;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;

@property (nonatomic) NSInteger backspaceCount;

@end

@implementation ListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setDefaults];
        [self createViews];
        [self setShouldStandOut:NO];
        //        [self subscribeToNotifications];
    }
    
    return self;
}

- (void)setDefaults {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setSelected:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    self.backspaceCount = 0;
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
    
    //container view
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.containerView];
    
    //highlighting
    self.highlightingLayer = [CAGradientLayer layer];
    [self.highlightingLayer setFrame:self.bounds];
    [self.highlightingLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [self.highlightingLayer setEndPoint:CGPointMake(1.0, 0.5)];
    [self.highlightingLayer setColors:[self getGradientColorsArray]];
    [self.containerView.layer insertSublayer:self.highlightingLayer atIndex:0];
    
    //bottom separator
    //    self.bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(24, self.bounds.size.height-0.5, [CommonFunctions getPhoneWidth]-24*2, 0.5f)];
    //    [self.bottomSeparator setBackgroundColor:UIColorFromRGB(ColorSeparator)];
    
    
    //pan gesture for swipe
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
    [self.containerView addGestureRecognizer:self.panGesture];
    [self.panGesture setDelegate:self];
    [self.panGesture setEnabled:YES];
    
    //text field
    self.textField = [[ItemTextField alloc] initWithFrame:CGRectMake(24, 20, [CommonFunctions getPhoneWidth]-40, 24)];
    [self.containerView addSubview:self.textField];
    [self.textField setDelegate:self];
    
    //text field - customize
    [self.textField setFont:FontSemibold(18)];
    [self.textField setTintColor:[UIColor whiteColor]];
    [self.textField setTextColor:UIColorFromRGB(0xFAFAFA)];
    [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    //text field - keyboard
    [self.textField setKeyboardType:UIKeyboardTypeDefault];
    [self.textField setKeyboardAppearance:UIKeyboardAppearanceDark];
//    [self.textField setAdjustsFontSizeToFitWidth:YES];
    [self.textField setReturnKeyType:UIReturnKeyNext];
    
    //DOUBLE TAP GESTURE
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCallback)];
    [self.doubleTapGesture setNumberOfTapsRequired:2];
    [self.containerView addGestureRecognizer:self.doubleTapGesture];
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
    [self.containerView setTransform:CGAffineTransformIdentity];
    [self.textField setFrame:CGRectMake(24, 20, [CommonFunctions getPhoneWidth]-40, 24)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.textField becomeFirstResponder];
    }else{
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
            }else if (fabs(velocityInView.y) > 200.f) {
                if (velocityInView.y > 0) {
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
    [UIView animateWithDuration:0.3 animations:^{
        //        [self.containerView setAlpha:0.0f];
        [self.containerView setTransform:CGAffineTransformMakeTranslation([CommonFunctions getPhoneWidth],0.0f)];
    }completion:^(BOOL finished) {
        if (!self.listItem.isDone) {
            [self swipeOffCompleted];
        }
        
    }];
}

- (void)swipeOffToLeft {
    [UIView animateWithDuration:0.5 animations:^{
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

#pragma mark - Tap Interaction
- (void)singleTapGestureCallback {
    [self setSelected:YES];
}

#pragma mark - Double Tap Interaction
- (void)doubleTapGestureCallback {
    if (self.listItem.isDone) {
        return;
    }
    
    [self setSelected:NO animated:NO];
    [self setShouldStandOut:!self.shouldStandOut];
}

#pragma mark - Reuse
- (void)prepareForReuse {
    [super prepareForReuse];
    self.backspaceCount = 0;
    self.textField.text = @"";
    [self.containerView setTransform:CGAffineTransformIdentity];
    [self.containerView setAlpha:1.0f];
}

#pragma mark - Helpers
- (NSArray *)getGradientColorsArray {
    //    return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x52CB8C) CGColor], (id)[UIColorFromRGB(0x48BA5A) CGColor], nil];
    //    4198FF 5E69FF BLUE PURPLE
    //    return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x4198FF) CGColor], (id)[UIColorFromRGB(0x5E69FF) CGColor], nil];
    
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
    return NO;
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

- (void)setShouldStandOut:(BOOL)shouldStandOut {
    _shouldStandOut = shouldStandOut;
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.highlightingLayer setOpacity:shouldStandOut?1.0f:0.0f];
        [self.textField setAlpha:shouldStandOut?1.0f:0.9f];
    }completion:^(BOOL finished) {
        if([self.delegate respondsToSelector:@selector(didToggleStandOutStateAtIndex:isStandingOut:)]){
            [self.delegate didToggleStandOutStateAtIndex:self.cellIndex isStandingOut:shouldStandOut];
        }
    }];
}

- (void)setListItem:(ListItem *)listItem {
    _listItem = listItem;
    [self.textField setText:listItem.text];
    
    [self setCellDoneStuff:listItem.isDone];
}

- (void)setCellDoneStuff:(BOOL)isDone {
    if (isDone) {
        [self setShouldStandOut:NO];
        [self.containerView setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
        [self.contentView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
        [self.textField setEnabled:NO];
        [self.restoreButton setAlpha:1.0f];
        [self.deleteButton setAlpha:1.0f];
        //        [self setUserInteractionEnabled:NO];
    }else {
        [self setShouldStandOut:self.listItem.isHighlighted];
        [self.textField setEnabled:YES];
        [self.containerView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
        [self.contentView setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
        [self.restoreButton setAlpha:0.0f];
        [self.deleteButton setAlpha:0.0f];
    }
}

#pragma mark - Notification
- (void)textDidUpdateCallback {
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
