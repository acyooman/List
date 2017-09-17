//
//  ListItem.m
//  List
//
//  Created by Arpit Agarwal on 17/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

+ (ListItem *)itemWithText:(NSString *)text {
    ListItem *item = [[ListItem alloc] init];
    item.dateOfCreation = [NSDate date];
    item.text = text;
    
    return item;
}

@end
