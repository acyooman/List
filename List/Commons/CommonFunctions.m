//
//  CommonFunctions.m
//  List
//
//  Created by Arpit Agarwal on 14/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions

+ (CGFloat)getPhoneWidth{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)getPhoneHeight{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (void)addListShadowToView:(UIView *)view{
    view.layer.shadowColor = UIColorFromRGB(0x606060).CGColor;
    view.layer.shadowOpacity = 0.38;
    view.layer.shadowRadius = 10;
    view.layer.shadowOffset = CGSizeMake(0, 1.0f);
    [view.layer setMasksToBounds:NO];
}


//SIZES
CGFloat const kPaddingSmallest = 8.0f;
CGFloat const kPaddingSmall = 16.0f;
CGFloat const kPaddingRegular = 24.0f;
CGFloat const kPaddingLarge = 32.0;
CGFloat const kPaddingLargest = 40.0f;

CGFloat const kPadding80 = 80.0f;

CGFloat const kCornerRadius2 = 2.0;
CGFloat const kCornerRadius4 = 4.0;
CGFloat const kCornerRadius8 = 8.0;

CGFloat const kStandardCellHeight = 64.0;

CGFloat const kTableBottomInset = 160.0;

//COLORS
NSInteger const ColorWhite = 0xFFFFFF;
NSInteger const ColorDarkBG = 0x1B1B1E;
NSInteger const ColorLessDarkBG = 0x555559;
NSInteger const ColorHighlight = 0x673BEC;
NSInteger const ColorSeparator = 0x343438; //0x27272A

NSInteger const ColorJetBlack = 0x000000;
NSInteger const ColorText = 0x173143;
NSInteger const ColorGrey  = 0x9D9D9D;
NSInteger const ColorDivider = 0xAAAAAA;

NSInteger const ColorGreen = 0x01B460;
NSInteger const ColorBlue = 0x4990E2;
NSInteger const ColorPink = 0xF64976;
NSInteger const ColorYellow = 0xFFC900;
NSInteger const ColorGold = 0xC17314;

NSInteger const ColorDarkText = 0x0F1F2A;
NSInteger const ColorParagraphGrey = 0x214A65;

NSInteger const ColorHomeBackGround = 0xF7F7F4;
NSInteger const ColorLightBlue = 0xE5F3FB;

+ (CAGradientLayer *)gradientLayerType:(GradientLayerType)type{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    //left to right
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    
    switch (type) {
        case GradientLayerTypeDoneBg: {
            //top to bottom
            gradientLayer.startPoint = CGPointMake(0.5, 0);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
            gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x404045) CGColor], (id)[UIColorFromRGB(0x1E1E21) CGColor], nil];
        }
            break;
            
        case GradientLayerTypeListBg: {
            //top to bottom
            gradientLayer.startPoint = CGPointMake(0.5, 0);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
            gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x404045) CGColor], (id)[UIColorFromRGB(0x1E1E21) CGColor], nil];
        }
            break;
            
        default:
            break;
    }
    
    return gradientLayer;
}
@end
