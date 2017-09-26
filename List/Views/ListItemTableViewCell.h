//
//  ListItemTableViewCell.h
//  Listix
//
//  Created by Arpit Agarwal on 24/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"

@protocol ListItemTableViewCellDelegate <NSObject>

- (void)didUpdateWithText:(NSString *)text cellIndex:(NSInteger)cellIndex;
- (void)didBackspaceEmptyCell:(NSInteger)cellIndex;
- (void)didSwipeOutCellIndex:(NSInteger)cellIndex;
- (void)didToggleStandOutStateAtIndex:(NSInteger)cellIndex isStandingOut:(BOOL)isStandingOut;
- (void)didTapNextOnCellIndex:(NSInteger)cellIndex;
- (void)didTapDeleteOnCellIndex:(NSInteger)cellIndex;
- (void)didTapRestoreOnCellIndex:(NSInteger)cellIndex;

- (void)didUpdateCellHeight:(NSInteger)cellIndex;

@end

@interface ListItemTableViewCell : UITableViewCell

@property (nonatomic)NSInteger cellIndex;
@property (nonatomic, weak)id<ListItemTableViewCellDelegate> delegate;

@property (nonatomic) BOOL shouldHideTopSeparator;
@property (nonatomic) BOOL shouldHideBottomSeparator;

- (void)setListItem:(ListItem *)listItem;

@end
