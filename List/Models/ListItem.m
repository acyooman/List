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

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.text = [decoder decodeObjectForKey:@"text"];
        self.isHighlighted = [decoder decodeBoolForKey:@"isHighlighted"];
        self.isDone = [decoder decodeBoolForKey:@"isDone"];
        self.dateOfCreation = [decoder decodeObjectForKey:@"dateOfCreation"];
        self.dateOfModification = [decoder decodeObjectForKey:@"dateOfModification"];
        self.dateOfMarkingDone = [decoder decodeObjectForKey:@"dateOfMarkingDone"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeBool:self.isHighlighted forKey:@"isHighlighted"];
    [encoder encodeBool:self.isDone forKey:@"isDone"];
    [encoder encodeObject:self.dateOfCreation forKey:@"dateOfCreation"];
    [encoder encodeObject:self.dateOfMarkingDone forKey:@"dateOfMarkingDone"];
    [encoder encodeObject:self.dateOfModification forKey:@"dateOfModification"];
}

@end
