//
//  ListViewController.h
//  List
//
//  Created by Arpit Agarwal on 14/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "ListViewController.h"
#import "CommonFunctions.h"
#import "ListTableViewCell.h"
#import "ListItem.h"

typedef NS_ENUM(NSInteger, PastSectionType) {
    PastSectionTypeToday,
    PastSectionTypeYesterday,
    PastSectionTypeEarlierThisWeek,
    PastSectionTypeEarlierThisMonth,
    PastSectionTypeSomeMonth,
    PastSectionTypeSomeYear
};

@interface ListViewController ()<UITableViewDataSource , UITableViewDelegate, ListTableViewCellDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UITableView *pastTableView;
@property (nonatomic, strong) UIView *pastContainerView;

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UIView *listContainerView;
@property (nonatomic)CGFloat scrollPosn;

@property (nonatomic, strong) UIPanGestureRecognizer *listPanGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *listSwipeGesture;
@property (nonatomic) CGFloat panGestureStartY;
@property (nonatomic) CGFloat panGestureDeltaY;
@property (nonatomic) BOOL shouldEndPanGesture;

@property (nonatomic) BOOL isKeyboardShowingCurrently;

@property (nonatomic, strong) UIView *headingScrollerView;
//@property (nonatomic) BOOL isCellSwipingInProgress;

@property (nonatomic, strong) UIToolbar *statusBarBGToolbar;

@end

@implementation ListViewController

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
    [self getSavedData];
    [self createViews];
    [self observeNotifications];
}

- (void)observeNotifications {
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.listTableView setAlpha:0.0f];
    [self.listTableView setTransform:CGAffineTransformMakeTranslation(0.0f, 60.f)];
    [UIView animateWithDuration:0.6f animations:^{
        [self.listTableView setAlpha:1.0f];
        [self.listTableView setTransform:CGAffineTransformIdentity];
    }];
}

#pragma mark - Create Views
- (void)createViews {
    [self createPastViews];
    [self createListViews];
    [self createStatusBarView];
}

- (void)createStatusBarView {
    self.statusBarBGToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0.0f, [CommonFunctions getPhoneWidth], 20.5f)];
    [self.statusBarBGToolbar setBarStyle:UIBarStyleBlackTranslucent];
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, [CommonFunctions getPhoneWidth], 20.5f)];
    //    [view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.statusBarBGToolbar];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 20.0f, [CommonFunctions getPhoneWidth], 0.5f)];
    [bottomLine setBackgroundColor:UIColorFromRGBWithAlpha(ColorSeparator, 0.2)];
    [self.statusBarBGToolbar addSubview:bottomLine];
}

- (void)createPastViews {
    //past container view
    self.pastContainerView = [[UIView alloc] init];
    [self.pastContainerView setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
    [self.pastContainerView setFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight])];
    [self.view addSubview:self.pastContainerView];
    
    //table view
    self.pastTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight]) style:UITableViewStylePlain];
    [self.pastTableView setTableHeaderView:[self getPastHeaderView]];
    [self.pastTableView setScrollIndicatorInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self.pastContainerView addSubview:self.pastTableView];
    
    //customize
    [self.pastTableView setAllowsMultipleSelectionDuringEditing:NO];
    [self.pastTableView setBackgroundColor:[UIColor clearColor]];
    [self.pastTableView setDataSource:self];
    [self.pastTableView setDelegate:self];
    [self.pastTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 200.0)]];
    [self.pastTableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 100.0f, 0)];
    
    //separators
    [self.pastTableView setSeparatorColor:UIColorFromRGB(ColorSeparator)];
    
    //patch view
    //    UIView *patchView = [[UIView alloc] initWithFrame:CGRectMake(0, [CommonFunctions getPhoneHeight] - 40.0f, [CommonFunctions getPhoneWidth], 40.0f)];
    //    [self.pastContainerView addSubview:patchView];
    //    [patchView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
}

- (void)createListViews {
    //list container view
    self.listContainerView = [[UIView alloc] init];
    [self.listContainerView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
    [self.listContainerView setFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight])];
    
    [self.listContainerView.layer setShadowColor:UIColorFromRGB(ColorJetBlack).CGColor];
    [self.listContainerView.layer setShadowOffset:CGSizeMake(0, -4)];
    [self.listContainerView.layer setShadowRadius:5.0f];
    [self.listContainerView.layer setShadowOpacity:0.3f];
    [self.view addSubview:self.listContainerView];
    
    //table view
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight]) style:UITableViewStylePlain];
    [self.listTableView setTableHeaderView:[self getListHeaderView]];
    [self.listContainerView addSubview:self.listTableView];
    [self.listTableView setScrollIndicatorInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    
    //customize
    [self.listTableView setAllowsMultipleSelectionDuringEditing:NO];
    [self.listTableView setBackgroundColor:[UIColor clearColor]];
    [self.listTableView setDataSource:self];
    [self.listTableView setDelegate:self];
    [self.listTableView setTableFooterView:[self getListFooterView]];
    [self.listTableView setContentOffset:CGPointMake(0, self.scrollPosn)];

    //separators
    [self.listTableView setSeparatorColor:UIColorFromRGB(ColorSeparator)];
    
    //gestures
    [self setupListGestures];
}

- (void)setupListGestures {
    //swipeUp Gesture
    self.listSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listSwipeUpGestureCallback:)];
    [self.listSwipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.listSwipeGesture setEnabled:NO];
    [self.listSwipeGesture setDelegate:self];
    [self.listTableView addGestureRecognizer:self.listSwipeGesture];
    
    //pan gesture
    self.listPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(listPanGestureCallback:)];
    [self.listPanGesture setDelegate:self];
    [self.listTableView addGestureRecognizer:self.listPanGesture];
}

#pragma mark - Data
- (void)getSavedData {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"listItemsArray"]) {

        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"listItemsArray"];
        NSArray *savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.itemsArray = [[NSMutableArray alloc] initWithArray:savedArray];
    
        //        //list strings
        //            if([[NSUserDefaults standardUserDefaults] valueForKey:@"listArrayData"]){
        //                NSMutableArray *diskArray = [[NSMutableArray alloc] init];
        //                diskArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"listArrayData"]];
        //
        //                //done values
        //                NSMutableArray *doneValuesArray = [[NSMutableArray alloc] init];
        //                if([[NSUserDefaults standardUserDefaults] valueForKey:@"doneValuesData"]){
        //                    doneValuesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"doneValuesData"]];
        //                }else {
        //                    for (NSInteger i=0; i<diskArray.count; i++) {
        //                        [doneValuesArray addObject:@(0)];
        //                    }
        //                }
        //
        //                //highlights
        //                NSMutableArray *highlightsArray = [[NSMutableArray alloc] init];
        //                if([[NSUserDefaults standardUserDefaults] valueForKey:@"highlightsData"]){
        //                    highlightsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"highlightsData"]];
        //                }else {
        //                    for (NSInteger i=0; i<diskArray.count; i++) {
        //                        [highlightsArray addObject:@(0)];
        //                    }
        //                }
        //
        //                //temp array
        //                NSMutableArray *tempObjectsArray = [[NSMutableArray alloc] init];
        //
        //                //strings
        //                for (NSInteger i=0;i<diskArray.count;i++) {
        //                    NSString *stringObj = [diskArray objectAtIndex:i];
        //                    ListItem *listItem = [ListItem itemWithText:stringObj];
        //
        //                    NSNumber *tempNumber = [highlightsArray objectAtIndex:i];
        //                    listItem.isHighlighted = tempNumber.boolValue;
        //
        //                    tempNumber = [doneValuesArray objectAtIndex:i];
        //                    listItem.isDone = tempNumber.boolValue;
        //
        //                    [tempObjectsArray addObject:listItem];
        //                }
        //
        //                self.itemsArray = [NSMutableArray arrayWithArray:tempObjectsArray];
        
    }else {
        ListItem *highlightedItem = [ListItem itemWithText:@"Double tap to highlight anything 👆👆"];
        highlightedItem.isHighlighted  = YES;
        
        NSArray *startArray = @[[ListItem itemWithText:@"Swipe 👉 or 👈 to send this to past"],
                                [ListItem itemWithText:@"Pull down this list to see past stuff ⏬"],
                                [ListItem itemWithText:@"# 👈 Prefix with # to bookmark"],
                                [ListItem itemWithText:@"Double tap to highlight anything 👆👆"],
                                highlightedItem,
                                [ListItem itemWithText:@"Be awesome now 😎"]
                                ];
        self.itemsArray = [[NSMutableArray alloc]initWithArray:startArray];
    }
    
    //scroll position
    self.scrollPosn = [[NSUserDefaults standardUserDefaults] floatForKey:@"listScrollValue"];
    
    //reload tables
    [self refreshViews];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.listTableView) {
        return 1;
    }else {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.listTableView) {
        return self.itemsArray.count;
    }else {
        if (section == 0) {
            NSArray *array = [self getDoneItemsForSection:PastSectionTypeToday];
            return array.count;
        }else if(section == 1){
            NSArray *array = [self getDoneItemsForSection:PastSectionTypeYesterday];
            return array.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.pastTableView) {
        return 48+20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.pastTableView) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 48+40)];
        
        //        [view setBackgroundColor:UIColorFromRGBWithAlpha(ColorLessDarkBG, 0.98f)];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(-10.0f, 8.0f+20, 120.0, 32.0f)];
        UIView *bgViewShadowView = [[UIView alloc] initWithFrame:bgView.bounds];
        [bgView setBackgroundColor:UIColorFromRGBWithAlpha(ColorWhite, 0.92)];
        [bgView.layer setCornerRadius:5.0f];
        [bgView.layer setMasksToBounds:YES];
        [view addSubview:bgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 8+20, 100.0f, 32.0f)];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:UIColorFromRGB(ColorLessDarkBG)];
        [label setFont:FontSemibold(18)];
        [view addSubview:label];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
        [countLabel setBackgroundColor:UIColorFromRGBWithAlpha(ColorLessDarkBG, 1.0f)];
        [countLabel setTextColor:UIColorFromRGBWithAlpha(ColorWhite, 0.95)];
        [countLabel setFont:FontSemibold(11)];
        [countLabel.layer setCornerRadius:10.0f];
        [countLabel setTextAlignment:NSTextAlignmentCenter];
        [countLabel.layer setMasksToBounds:YES];
        [bgView addSubview:countLabel];
        
        if (section == 0) {
            [label setText:@"Today"];
            NSArray *todayArray = [self getDoneItemsForSection:PastSectionTypeToday];
            [countLabel setText:[NSString stringWithFormat:@"%@", @(todayArray.count)]];
        }else {
            [bgView setFrameWidth:150.0f];
            [bgViewShadowView setFrameWidth:150.0f];
            
            NSArray *yesterdayArray = [self getDoneItemsForSection:PastSectionTypeYesterday];
            [countLabel setText:[NSString stringWithFormat:@"%@", @(yesterdayArray.count)]];
            
            [label setText:@"Yesterday"];
        }
        
        [countLabel setCenterY:bgView.bounds.size.height/2];
        [countLabel setFrameX:bgView.frame.size.width - countLabel.frame.size.width - 8.0f];

        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.listTableView) {
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
        if (!cell) {
            cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
        }
        ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
        if (!item.isDone) {
            [cell setListItem:item];
            [cell setCellIndex:indexPath.row];
            [cell setDelegate:self];
            [cell setHidden:NO];
            
            if ([item.text hasPrefix:@"#"]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, [CommonFunctions getPhoneWidth])];
            }else {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 24, 0, 24)];
            }
            
        }else {
            [cell setHidden:YES];
        }
        
        //check for separator
        if (self.itemsArray.count >= indexPath.row+1) {
            ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
            if (!item.isDone) {
                if ([item.text hasPrefix:@"#"]) {
                    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, [CommonFunctions getPhoneWidth])];
                }
            }
            
        }
        
        return cell;
    }
    
    else {
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pastItemCell"];
        if (!cell) {
            cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pastItemCell"];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 24, 0, 24)];
        }
        
        if (indexPath.section == 0) {
            NSArray *todayArray = [self getDoneItemsForSection:PastSectionTypeToday];
            ListItem *item = [todayArray objectAtIndex:indexPath.row];
            [cell setListItem:item];
            [cell setCellIndex:indexPath.row];
            //            [cell setDelegate:self];
            [cell setHidden:NO];
            
            return cell;
        }else if(indexPath.section == 1){
            NSArray *yesterdayArray = [self getDoneItemsForSection:PastSectionTypeYesterday];
            ListItem *item = [yesterdayArray objectAtIndex:indexPath.row];
            [cell setListItem:item];
            [cell setCellIndex:indexPath.row];
            //            [cell setDelegate:self];
            [cell setHidden:NO];
            return cell;
        }
        
        //        ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
        //        if (item.isDone) {
        //            [cell setListItem:item];
        //            [cell setCellIndex:indexPath.row];
        //            [cell setDelegate:self];
        //            [cell setHidden:NO];
        //        }else {
        //            [cell setHidden:YES];
        //        }
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.listTableView) {
        ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
        if (item.isDone) {
            return 0.0;
        }
        return 60;
    }else {
        return 60;
    }
    
    return 0.0f;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSUserDefaults standardUserDefaults] setFloat:scrollView.contentOffset.y forKey:@"listScrollValue"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

#pragma mark - Helpers
- (void)refreshViews {
    [self.listTableView reloadData];
    [self.pastTableView reloadData];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    NSArray *indexPaths = self.listTableView.indexPathsForSelectedRows;
    for (NSIndexPath *indexPath in indexPaths) {
        [self.listTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)restoreItemAtIndex:(NSInteger)index {
    ListItem *item = [self.itemsArray objectAtIndex:index];
    item.isDone = NO;
    item.dateOfMarkingDone = [NSDate date];
    [self.itemsArray replaceObjectAtIndex:index withObject:item];
    [self refreshViews];
    [self saveListDataToDisk];
}


- (void)markListItemDoneAtIndex:(NSInteger)index {
    ListItem *item = [self.itemsArray objectAtIndex:index];
    
    if (item.text.length > 0) {
        item.isDone = YES;
        item.dateOfMarkingDone = [NSDate date];
        [self.itemsArray replaceObjectAtIndex:index withObject:item];
        [self refreshViews];
        [self saveListDataToDisk];
    }else {
        //just delete the blank items when swiped away
        [self removeListItemAtIndex:index shouldMoveUp:NO];
    }
}

- (void)saveListDataToDisk {
//    NSMutableArray *listStringsArray = [[NSMutableArray alloc] init];
//    NSMutableArray *highlightNumbersArray = [[NSMutableArray alloc] init];
//    NSMutableArray *doneNumbersArray = [[NSMutableArray alloc] init];
//
//    for (ListItem *item in self.itemsArray) {
//        [listStringsArray addObject:item.text];
//        [highlightNumbersArray addObject:@(item.isHighlighted)];
//        [doneNumbersArray addObject:@(item.isDone)];
//    }
    
//    [[NSUserDefaults standardUserDefaults] setValue:doneNumbersArray forKey:@"doneValuesData"];
//    [[NSUserDefaults standardUserDefaults] setValue:highlightNumbersArray forKey:@"highlightsData"];
//    [[NSUserDefaults standardUserDefaults] setValue:listStringsArray forKey:@"listArrayData"];
    
    //whole array
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:self.itemsArray];
    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"listItemsArray"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)copyListToPasteboardWithDone:(BOOL)doneFlag{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    for (ListItem *item in self.itemsArray) {
        if (item.isDone == doneFlag) {
            [string appendString:item.text];
            [string appendString:@"\n"];
        }
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:doneFlag?@"Done items copied" :@"List items copied" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Awesome" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (UIView *)getListFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 400.0)];
    [view setUserInteractionEnabled:YES];
    
    //tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSelector)];
    [view addGestureRecognizer:tapGesture];
    
    return view;
}

- (UIView *)getListHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 68+24+20)];
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 24+20, [CommonFunctions getPhoneWidth], 68)];
    [headingLabel setText:@"Next"];
    [headingLabel setFont:FontBold(50)];
    [headingLabel setTextColor:[UIColor whiteColor]];
    
    [view setUserInteractionEnabled:YES];
    
    //tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listHeaderTapGesture)];
    [view addGestureRecognizer:tapGesture];
    
    [view addSubview:headingLabel];
    return view;
}

- (void)listHeaderTapGesture {
    if (self.listContainerView.frame.origin.y == 0) {
        [self copyListToPasteboardWithDone:NO];
    }else {
        [self maximizeListContainer];
    }
    
}

- (UIView *)getPastHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 68+24+20)];
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 24+20, [CommonFunctions getPhoneWidth], 68)];
    [headingLabel setText:@"Past"];
    [headingLabel setFont:FontBold(50)];
    [headingLabel setTextColor:[UIColor whiteColor]];
    
    [view setUserInteractionEnabled:YES];
    
    //tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyPastItems)];
    [view addGestureRecognizer:tapGesture];
    
    
    [view addSubview:headingLabel];
    return view;
}

- (void)copyPastItems {
    [self copyListToPasteboardWithDone:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tapGestureSelector{
    if (self.listContainerView.frame.origin.y == 0.0f) {
        if (self.isKeyboardShowingCurrently) {
            [self dismissKeyboard];
        }else {
            [self addNewItemAtTheEnd];
        }
    }else {
        [self maximizeListContainer];
    }
    
}

- (void)minimizeListContainer {
    [UIView animateWithDuration:0.9f delay:0.0f usingSpringWithDamping:0.95f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.listContainerView setFrameY:[CommonFunctions getPhoneHeight] - 114.0f];
        [self.statusBarBGToolbar setTintColor:UIColorFromRGB(ColorOrange)];
        [self.pastContainerView setFrameY:0.0f];
    } completion:^(BOOL finished) {
        [self.listSwipeGesture setEnabled:YES];
        [self.listPanGesture setEnabled:NO];
    }];
}

- (void)maximizeListContainer {
    [self.listTableView setScrollEnabled:YES];
    [UIView animateWithDuration:0.9f delay:0.0 usingSpringWithDamping:0.95f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.listContainerView setFrameY:0.0f];
        [self.view setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
        [self.statusBarBGToolbar setAlpha:1.0f];
        
        [self.pastContainerView setFrameY:-1*([CommonFunctions getPhoneHeight]-124*3)];
    } completion:^(BOOL finished) {
        [self.listPanGesture setEnabled:YES];
        [self.view setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
    }];
}

- (void)removeListItemAtIndex:(NSInteger)index shouldMoveUp:(BOOL)shouldMoveUp{
    [self.itemsArray removeObjectAtIndex:index];
    [self refreshViews];
    [self saveListDataToDisk];
    
    if (index > 0 && shouldMoveUp) {
        [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)addNewItemAtIndex:(NSInteger)index {
    ListItem *newListItem = [ListItem itemWithText:@""];
    [self.itemsArray insertObject:newListItem atIndex:index];
    [self refreshViews];
    [self saveListDataToDisk];
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)addNewItemAtTheEnd {
    if (self.itemsArray.count > 0) {
        ListItem *lastListItem = [self.itemsArray lastObject];
        if (lastListItem.text.length != 0) {
            [self.itemsArray addObject:[ListItem itemWithText:@""]];
            [self refreshViews];
        }
    }else {
        [self.itemsArray addObject:[ListItem itemWithText:@""]];
        [self refreshViews];
    }
    
    [self saveListDataToDisk];
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.itemsArray.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - ListTableViewCellDelegate
//- (void)isCurrentlySwipingCellAtIndex:(NSInteger)index {
//    self.isCellSwipingInProgress = YES;
//    [self dismissKeyboard];
//}

//- (void)isDoneSwipingCellAtIndex:(NSInteger)index {
//    self.isCellSwipingInProgress = NO;
//}
- (void)didTapRestoreOnCellIndex:(NSInteger)cellIndex {
    [self restoreItemAtIndex:cellIndex];
}

- (void)didTapDeleteOnCellIndex:(NSInteger)cellIndex {
    [self removeListItemAtIndex:cellIndex shouldMoveUp:NO];
}

- (void)didToggleStandOutStateAtIndex:(NSInteger)cellIndex isStandingOut:(BOOL)isStandingOut {
    ListItem *item = [self.itemsArray objectAtIndex:cellIndex];
    [item setIsHighlighted:isStandingOut];
    [self.itemsArray replaceObjectAtIndex:cellIndex withObject:item];
    [self saveListDataToDisk];
}

- (void)didUpdateWithText:(NSString *)text cellIndex:(NSInteger)cellIndex {
    ListItem *item = [self.itemsArray objectAtIndex:cellIndex];
    item.text = text;
    item.dateOfModification = [NSDate date];
    [self saveListDataToDisk];
}

- (void)didTapNextOnCellIndex:(NSInteger)cellIndex {
    [self addNewItemAtIndex:cellIndex+1];
}

- (void)didBackspaceEmptyCell:(NSInteger)cellIndex {
    if (cellIndex > 0) {
        [self removeListItemAtIndex:cellIndex shouldMoveUp:YES];
    }else {
        [self removeListItemAtIndex:cellIndex shouldMoveUp:NO];
    }
}

- (void)didSwipeOutCellIndex:(NSInteger)cellIndex {
    [self markListItemDoneAtIndex:cellIndex];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (gestureRecognizer == self.listPanGesture && self.isCellSwipingInProgress) {
//        return NO;
//    }
    return YES;
}

#pragma mark - Pan Gesture Callback
- (void)listSwipeUpGestureCallback:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self dismissKeyboard];
    [self maximizeListContainer];
}

- (void)listPanGestureCallback:(UIPanGestureRecognizer *)gestureRecognizer{
    
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    CGPoint velocityInView = [gestureRecognizer velocityInView:self.view];
    CGFloat dismissThresh = 200.0f;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.panGestureStartY = translatedPoint.y;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            self.panGestureDeltaY = translatedPoint.y - self.panGestureStartY;
            
            if(self.panGestureDeltaY > 0 && self.listTableView.contentOffset.y <= 0) {
                [self.listContainerView setFrameY:self.panGestureDeltaY*0.65f];
                
                if (self.listTableView) {
                    [self.listTableView setBounces:NO];
                    [self.listTableView setScrollEnabled:NO];
                }
                self.shouldEndPanGesture = YES;
            }else {
                if (self.listTableView) {
                    [self.listTableView setBounces:YES];
                    [self.listTableView setScrollEnabled:YES];
                }
                self.shouldEndPanGesture = NO;
            }
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self dismissKeyboard];
            
            if(self.shouldEndPanGesture) {
                if (self.panGestureDeltaY > dismissThresh || (self.panGestureDeltaY > 100.0f && velocityInView.y > 500.0f)) {

                    [self minimizeListContainer];
                }
                else {
                    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [self.listContainerView setFrameY:0.0f];
                    } completion:^(BOOL finished) {
                        [self.listContainerView setFrameY:0.0f];
                    }];
                }
            }else {
                [self.listContainerView setFrameY:0.0f];
            }
}
            break;
            
        default:
            break;
    }
}

#pragma mark - UIKeyboardNotification
- (void)keyboardDidShow:(NSNotification *)notif {
    self.isKeyboardShowingCurrently = YES;
}

- (void)keyboardDidHide:(NSNotification *)notif {
    self.isKeyboardShowingCurrently = NO;
}

#pragma mark - Done Data helpers
- (NSArray *)getDateSortedArray:(NSArray *)array ascending:(BOOL)ascending{
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"dateOfMarkingDone"
                                        ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedArray = [array
                                 sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

- (NSArray *)getDoneItemsForSection:(PastSectionType)sectionType {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    switch (sectionType) {
        case PastSectionTypeToday: {
            for (ListItem *item in self.itemsArray) {
                if (item.isDone) {
                    NSDate *date = item.dateOfMarkingDone;
                    if (date) {
                        if ([[NSCalendar currentCalendar] isDateInToday:date]) {
                            [array addObject:item];
                        }
                    }
                }
            }
            NSArray *sortedArray = [self getDateSortedArray:array ascending:NO];
            return sortedArray;
        }
            break;
            
        case PastSectionTypeYesterday: {
            for (ListItem *item in self.itemsArray) {
                if (item.isDone) {
                    NSDate *date = item.dateOfMarkingDone;
                    if (date) {
                        if ([[NSCalendar currentCalendar] isDateInYesterday:date]) {
                            [array addObject:item];
                        }
                    }
                }
            }
            NSArray *sortedArray = [self getDateSortedArray:array ascending:NO];
            return sortedArray;
        }
            break;
            
        case PastSectionTypeEarlierThisWeek: {
            
        }
            break;
            
        default:
            break;
    }
    return array;
}
@end
