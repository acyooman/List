//
//  AABookmarkView.m
//  List
//
//  Created by Arpit Agarwal on 19/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "AABookmarkView.h"
#import "CommonFunctions.h"

const CGFloat kBookmarkHeight = 40.0f;
const CGFloat kBookmarkTipWidth = 25.0f;
const CGFloat kLeftPadding = 25.0f;

@interface AABookmarkView ()
@property (nonatomic) CGFloat textWidth;
@property (nonatomic,strong) UIView* rectView;
@property (nonatomic,strong) UIImageView *tipView;
@property (nonatomic,strong) CAGradientLayer *gradientlayer;
@end

@implementation AABookmarkView

- (instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, kLeftPadding+kBookmarkTipWidth, kBookmarkHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    [self setFrameHeight:kBookmarkHeight];
    
    //shadow
    [self setClipsToBounds:NO];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.layer setShadowOpacity:0.5];
    [self.layer setShadowRadius:2.0f];
    
    //rectview
    self.rectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.textWidth, kBookmarkHeight)];
    [self.rectView setBackgroundColor:UIColorFromRGB(0xF1F1F1)];
    [self addSubview:self.rectView];

    //    //gradient
    //    self.gradientlayer = [CAGradientLayer layer];
    //    [self.gradientlayer setFrame:self.rectView.bounds];
    //    [self.gradientlayer setStartPoint:CGPointMake(0.0, 0.5)];
    //    [self.gradientlayer setEndPoint:CGPointMake(1.0, 0.5)];
    //    [self.gradientlayer setColors:[self getGradientForBookmark]];
    //    [self.rectView.layer insertSublayer:self.gradientlayer atIndex:0];
    
    //tip image
    self.tipView = [[UIImageView alloc] initWithFrame:CGRectMake(self.textWidth+kBookmarkTipWidth, 0, kBookmarkTipWidth, kBookmarkHeight)];
    [self.tipView setContentMode:UIViewContentModeScaleAspectFit];
    [self.tipView setImage:[UIImage imageNamed:@"boomark-tip"]];
    [self addSubview:self.tipView];
}

- (void)setText:(NSString *)text {
    _text = text;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 30.0f)];
    [label setFont:FontSemibold(18)];
    [label setText:text];
    [label sizeToFit];
    
    self.textWidth = label.frame.size.width + 4.0f;
    [self updateSize];
}

- (void)updateSize {
    [self setFrameWidth:self.textWidth+kBookmarkTipWidth+kLeftPadding];
    [self.rectView setFrameWidth:self.textWidth+kLeftPadding];
    //    [self.gradientlayer setFrame:self.rectView.bounds];
    [self.tipView setFrameX:self.textWidth+kLeftPadding];
}

- (NSArray *)getGradientForBookmark {
    return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xFFFFFF) CGColor], (id)[UIColorFromRGB(0XF1F1F1) CGColor], nil];
}

@end
