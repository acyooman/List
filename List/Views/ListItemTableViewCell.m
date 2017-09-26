//
//  ListItemCellTableViewCell.m
//  Listix
//
//  Created by Arpit Agarwal on 24/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "ListItemTableViewCell.h"
#import "ListItemTextView.h"
#import "CommonFunctions.h"
#import "AABookmarkView.h"

@interface ListItemTableViewCell() <ListItemTextViewDelegate>

@property (nonatomic, strong) ListItemTextView *textView;
@property (nonatomic, strong) ListItem *listItem;

@property (nonatomic, strong) UIView *topSeparator;
@property (nonatomic, strong) UIView *bottomSeparator;

@property (nonatomic, strong) AABookmarkView *bookmarkView;

@property (nonatomic) NSInteger backspaceCount;


@end

@implementation ListItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setDefaults];
        [self createViews];
    }
    return self;
}

- (void)setDefaults {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    self.backspaceCount = 0;
}

- (void)createViews {
    [self createTextView];
    [self createSeparators];
}

- (void)createTextView {
    //setup textview
    self.textView = [[ListItemTextView alloc] init];
    [self.textView setListItemTextViewDelegate:self];
    [self.textView setFont:FontSemibold(18)];
    [self.textView setExclusiveTouch:YES];
    [self.contentView addSubview:self.textView];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    
    //keyboard
    [self.textView setTintColor:UIColorFromRGB(ColorWhite)];
    [self.textView setKeyboardType:UIKeyboardTypeDefault];
    [self.textView setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.textView setScrollEnabled:NO];
    
    //constraints
    [self.textView setTopView:self.contentView constant:(kPaddingSmall)];
    [self.textView setLeadingView:self.contentView constant:kPaddingRegular];
    [self.textView setTrailingView:self.contentView constant:kPaddingRegular];
    [self.textView setBottomView:self.contentView constant:(kPaddingSmall)];
}

- (void)createSeparators {
    //top separator
    self.topSeparator = [[UIView alloc] init];
    [self.contentView addSubview:self.topSeparator];
    [self.topSeparator setBackgroundColor:UIColorFromRGB(ColorSeparator)];
    [self.topSeparator setViewHeight:0.5f];

    [self.topSeparator setLeadingView:self.contentView constant:kPaddingRegular];
    [self.topSeparator setTrailingView:self.contentView constant:kPaddingRegular];
    [self.topSeparator setTopView:self.contentView];
    
    //bottom separator
    self.bottomSeparator = [[UIView alloc] init];
    [self.contentView addSubview:self.bottomSeparator];
    [self.bottomSeparator setBackgroundColor:UIColorFromRGB(ColorSeparator)];
    [self.bottomSeparator setViewHeight:0.5f];
    
    [self.bottomSeparator setLeadingView:self.contentView constant:kPaddingRegular];
    [self.bottomSeparator setTrailingView:self.contentView constant:kPaddingRegular];
    [self.bottomSeparator setBottomView:self.contentView];
}

- (void)createBookmarkView {
//    self.bookmarkView = book
}

#pragma mark - Reuse
- (void)prepareForReuse {
    [super prepareForReuse];
    [self.textView setText:@""];
}

#pragma mark - Data
- (void)setListItem:(ListItem *)listItem {
    _listItem = listItem;
}

#pragma mark - Setters
- (void)setShouldHideTopSeparator:(BOOL)shouldHideTopSeparator {
    _shouldHideTopSeparator = shouldHideTopSeparator;
}

- (void)setShouldHideBottomSeparator:(BOOL)shouldHideBottomSeparator {
    _shouldHideBottomSeparator = shouldHideBottomSeparator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected) {
        [self.textView becomeFirstResponder];
    }else {
        [self.textView resignFirstResponder];
    }
}

#pragma mark - ListItemTextViewDelegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didTapNextOnCellIndex:)]) {
            [self.delegate didTapNextOnCellIndex:self.cellIndex];
            [textView resignFirstResponder];
        }
        return NO;
        
    }
    return YES;
}

- (void)didAdjustHeight {
    if ([self.delegate respondsToSelector:@selector(didUpdateCellHeight:)]) {
        [self.delegate didUpdateCellHeight:self.cellIndex];
    }
}

@end
