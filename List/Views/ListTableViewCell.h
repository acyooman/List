//
//  ListTableViewCell.h
//  List
//
//  Created by Arpit Agarwal on 14/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListTableViewCellDelegate <NSObject>

- (void)didUpdateWithText:(NSString *)text cellIndex:(NSInteger)cellIndex;
- (void)didFinishEmptyEditingAtCellIndex:(NSInteger)cellIndex;
- (void)didSwipeOutCellIndex:(NSInteger)cellIndex;
- (void)didToggleStandOutStateAtIndex:(NSInteger)cellIndex isStandingOut:(BOOL)isStandingOut;
- (void)didTapNextOnCellIndex:(NSInteger)cellIndex;

@end

@interface ListTableViewCell : UITableViewCell

@property (nonatomic) BOOL shouldStandOut;

@property (nonatomic) NSInteger cellIndex;
@property (nonatomic)id<ListTableViewCellDelegate> delegate;

- (void)setItemText:(NSString *)text;

@end
