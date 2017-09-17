//
//  ItemTextField.h
//  List
//
//  Created by Arpit Agarwal on 17/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemTextField;

@protocol ItemTextFieldDelegate <UITextFieldDelegate>
- (void)didDeleteBackward:(ItemTextField *)textField;
@end

@interface ItemTextField : UITextField
@property (nonatomic, weak) id<ItemTextFieldDelegate> delegate;

@end
