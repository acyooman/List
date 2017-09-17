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


NSInteger const ColorDarkBG = 0x1B1B1E;
NSInteger const ColorLessDarkBG = 0x555559;
NSInteger const ColorSeparator = 0x27272A; //0x27272A

NSInteger const ColorJetBlack = 0x000000;
NSInteger const ColorText = 0x173143;
NSInteger const ColorGrey  = 0x9D9D9D;
NSInteger const ColorDivider = 0xAAAAAA;

NSInteger const ColorGreen = 0x01B460;
NSInteger const ColorBlue = 0x4990E2;
NSInteger const ColorPink = 0xF64976;
NSInteger const ColorYellow = 0xFFC900;
NSInteger const ColorGold = 0xC17314;

NSInteger const ColorRed = 0xE23744;
NSInteger const ColorNonVeg = 0xE95A58;
NSInteger const ColorWhite = 0xFFFFFF;
NSInteger const ColorDisabled = 0xAAAAAA;
NSInteger const ColorTreatsPink  = 0xF96579;
NSInteger const ColorOrange = 0xF5A623;
NSInteger const ColorGolden = 0xab9355;

NSInteger const ColorDarkText = 0x0F1F2A;
NSInteger const ColorParagraphGrey = 0x214A65;

NSInteger const ColorHomeBackGround = 0xF7F7F4;
NSInteger const ColorLightBlue = 0xE5F3FB;


@end
