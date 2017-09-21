//
//  CommonFunctions.h
//  List
//
//  Created by Arpit Agarwal on 14/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Shorthands.h"
#import "UIButton+HitTest.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define FontRegular(X)                 [UIFont fontWithName:@"AvenirNext-Regular"   size:X]
#define FontMedium(X)                  [UIFont fontWithName:@"AvenirNext-Medium"   size:X]
#define FontSemibold(X)                [UIFont fontWithName:@"AvenirNext-DemiBold" size:X]
#define FontBold(X)                    [UIFont fontWithName:@"AvenirNext-Bold"     size:X]

#define FontSFRegular(X)                 [ZFonts regularFontWithName:@".SFUIText" size:X]


//COLORS

//Backgrounds
extern NSInteger const ColorDarkBG;
extern NSInteger const ColorLessDarkBG;

//Primary blacks and greys
extern NSInteger const ColorJetBlack;
extern NSInteger const ColorText;
extern NSInteger const ColorGrey;
extern NSInteger const ColorDivider;
extern NSInteger const ColorSeparator;

//Primary colors
extern NSInteger const ColorYellow;
extern NSInteger const ColorGreen;
extern NSInteger const ColorBlue;
extern NSInteger const ColorPink;
extern NSInteger const ColorGold;

//Extras
extern NSInteger const ColorRed;
extern NSInteger const ColorNonVeg;
extern NSInteger const ColorWhite;
extern NSInteger const ColorDisabled;
extern NSInteger const ColorTreatsPink;
extern NSInteger const ColorOrange;
extern NSInteger const ColorGolden;

extern NSInteger const ColorDarkText;
extern NSInteger const ColorParagraphGrey;

extern NSInteger const ColorHomeBackGround;
extern NSInteger const ColorLightBlue;

extern NSInteger const ColorHighlight;

@interface CommonFunctions : NSObject
+ (CGFloat)getPhoneWidth;
+ (CGFloat)getPhoneHeight;

+ (void)addListShadowToView:(UIView *)view;
@end
