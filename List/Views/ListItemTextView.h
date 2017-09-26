//
//  ListItemTextView.h
//  Listix
//
//  Created by Arpit Agarwal on 24/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListItemTextViewDelegate <UITextViewDelegate>
- (void)didAdjustHeight;
@end

@interface ListItemTextView : UITextView
@property (nonatomic, weak) id <ListItemTextViewDelegate>listItemTextViewDelegate;

@end
