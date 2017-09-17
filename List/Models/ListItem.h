//
//  ListItem.h
//  List
//
//  Created by Arpit Agarwal on 17/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic) BOOL isHighlighted;
@property (nonatomic) BOOL isDone;

@property (nonatomic, strong) NSDate *dateOfCreation;
@property (nonatomic, strong) NSDate *dateOfModification;
@property (nonatomic, strong) NSDate *dateOfMarkingDone;

+ (ListItem *)itemWithText:(NSString *)text;

@end
