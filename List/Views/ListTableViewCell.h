//
//  ListTableViewCell.h
//  List
//
//  Created by Arpit Agarwal on 14/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"

@protocol ListTableViewCellDelegate <NSObject>

- (void)didUpdateWithText:(NSString *)text cellIndex:(NSInteger)cellIndex;
- (void)didBackspaceEmptyCell:(NSInteger)cellIndex;
- (void)didSwipeOutCellIndex:(NSInteger)cellIndex;
- (void)didToggleStandOutStateAtIndex:(NSInteger)cellIndex isStandingOut:(BOOL)isStandingOut;
- (void)didTapNextOnCellIndex:(NSInteger)cellIndex;

- (void)isCurrentlySwipingCellAtIndex:(NSInteger)index;
- (void)isDoneSwipingCellAtIndex:(NSInteger)index;

@end

@interface ListTableViewCell : UITableViewCell

@property (nonatomic)NSInteger cellIndex;
@property (nonatomic, weak)id<ListTableViewCellDelegate> delegate;

- (void)setListItem:(ListItem *)listItem;

@end
