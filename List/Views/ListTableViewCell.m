//
//  ListTableViewCell.m
//  List
//
//  Created by Arpit Agarwal on 14/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "ListTableViewCell.h"
#import "CommonFunctions.h"

@interface ListTableViewCell () <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CAGradientLayer *highlightingLayer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic) CGFloat panGestureStartX;
@property (nonatomic) CGFloat panGestureDeltaX;
@property (nonatomic) BOOL shouldEndPanGesture;
@end

@implementation ListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setDefaults];
        [self createViews];
        [self setShouldStandOut:NO];
        [self subscribeToNotifications];
    }
    
    return self;
}

- (void)setDefaults {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setSelected:NO];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didScrollListNotificationCallback) name:@"NotificationDidScrollList" object:nil];
}

- (void)didScrollListNotificationCallback {
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
}

- (void)createViews {
    //container view
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.containerView];
    
    //colors
    [self.containerView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
    [self.contentView setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
    
    //highlighting
    self.highlightingLayer = [CAGradientLayer layer];
    [self.highlightingLayer setFrame:self.bounds];
    [self.highlightingLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [self.highlightingLayer setEndPoint:CGPointMake(1.0, 0.5)];
    [self.highlightingLayer setColors:[self getGradientColorsArray]];
    [self.containerView.layer insertSublayer:self.highlightingLayer atIndex:0];
    
    //pan gesture for swipe
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
    [self.containerView addGestureRecognizer:self.panGesture];
    [self.panGesture setDelegate:self];
    [self.panGesture setEnabled:YES];
    
    //text field
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(24, 20, [CommonFunctions getPhoneWidth]-40, 24)];
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
    [self.textField setAdjustsFontSizeToFitWidth:YES];
    [self.textField setReturnKeyType:UIReturnKeyNext];
    [self.textField setEnablesReturnKeyAutomatically:YES];
    
    //DOUBLE TAP GESTURE
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCallback)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.containerView addGestureRecognizer:doubleTapGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
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

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    // Check for horizontal gesture
    if (fabs(translation.x) > fabs(translation.y)) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (gestureRecognizer == self.panGesture) {
//        return NO;
//    }
    return YES;
}

#pragma mark  - Pan Gesture Stuff
- (void)panGestureCallback:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translatedPoint = [gestureRecognizer translationInView:self];
    //    CGPoint velocityInView = [gestureRecognizer velocityInView:self];
    CGFloat dismissThresh = [CommonFunctions getPhoneWidth]/2;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.panGestureStartX = translatedPoint.x;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            self.panGestureDeltaX = translatedPoint.x - self.panGestureStartX;
            NSLog(@"Pangesture delta = %@\ntranslatedPoint = %@", @(self.panGestureDeltaX), @(translatedPoint));
            [self.containerView setTransform:CGAffineTransformMakeTranslation(self.panGestureDeltaX, 0.0f)];
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (fabs(self.panGestureDeltaX) > dismissThresh) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.containerView setAlpha:0.0f];
                    
                    if (self.panGestureDeltaX > 0) {
                        [self.containerView setTransform:CGAffineTransformMakeTranslation([CommonFunctions getPhoneWidth],0.0f)];
                         }else {
                        [self.containerView setTransform:CGAffineTransformMakeTranslation(-[CommonFunctions getPhoneWidth],0.0f)];
                         }
                }completion:^(BOOL finished) {
                    if ([self.delegate respondsToSelector:@selector(didSwipeOutCellIndex:)]) {
                        [self.delegate didSwipeOutCellIndex:self.cellIndex];
                    }
                }];
                
            }else {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.containerView setAlpha:1.0f];
                    [self.containerView setTransform:CGAffineTransformIdentity];
                }completion:^(BOOL finished) {
                    
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Double Tap Interaction
- (void)doubleTapGestureCallback {
    [self setSelected:NO animated:NO];
    [self setShouldStandOut:!self.shouldStandOut];
}

#pragma mark - Reuse
- (void)prepareForReuse {
    [super prepareForReuse];
    self.textField.text = @"";
    [self.containerView setTransform:CGAffineTransformIdentity];
    [self.containerView setAlpha:1.0f];
    [self setShouldStandOut:NO];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textField.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didTapNextOnCellIndex:)]) {
            [self.delegate didTapNextOnCellIndex:self.cellIndex];
            return YES;
        }else {
            [textField resignFirstResponder];
            return YES;
        }
    }
    return NO;
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

- (void)setItemText:(NSString *)text{
    [self.textField setText:text];
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

    if (!self.textField.text.length) {
        if ([self.delegate respondsToSelector:@selector(didFinishEmptyEditingAtCellIndex:)]) {
            [self.delegate didFinishEmptyEditingAtCellIndex:self.cellIndex];
        }
    }
}


@end
