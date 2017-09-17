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

@interface ListViewController ()<UITableViewDataSource , UITableViewDelegate, ListTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableDictionary *highlightsArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger currentlySelectedItem;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *listViewContainer;
@property (nonatomic)CGFloat scrollPosn;
@end

@implementation ListViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
    [self getSavedData];
    [self createViews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView setAlpha:0.0f];
    [self.tableView setTransform:CGAffineTransformMakeTranslation(0.0f, 60.f)];
    [UIView animateWithDuration:0.6f animations:^{
        [self.tableView setAlpha:1.0f];
        [self.tableView setTransform:CGAffineTransformIdentity];
    }];
}

#pragma mark - Create Table view
- (void)createViews{
    
    //list view curved background
    self.backgroundView = [[UIView alloc] init];
    [self.backgroundView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
//    [self.backgroundView.layer setCornerRadius:6.0f];
//    [self.backgroundView.layer setMasksToBounds:YES];
    [CommonFunctions addListShadowToView:self.backgroundView];
//    [self.backgroundView setFrame:CGRectMake(0, 24, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight])];

    [self.backgroundView setFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight])];
    [self.backgroundView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
    [self.view addSubview:self.backgroundView];
                //background shadow
    
    
    //list view container
    
    //table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight]) style:UITableViewStylePlain];
    [self.tableView setTableHeaderView:[self getHeaderView]];
    [self.view addSubview:self.tableView];
    
    //customize
    [self.tableView setAllowsMultipleSelectionDuringEditing:NO];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setDecelerationRate:UIScrollViewDecelerationRateFast];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 300)]];
    [self.tableView setContentOffset:CGPointMake(0, self.scrollPosn)];

    //separators
    [self.tableView setSeparatorColor:UIColorFromRGB(ColorSeparator)];
    
    //tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSelector)];
    [self.tableView addGestureRecognizer:tapGesture];
}

#pragma mark - Data
- (void)getSavedData {
    //highlights
    asdf
    self.highlightsArray = [[NSMutableArray alloc] init];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"listData"]){
        self.highlightsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"higlightsData"]];
    }else {
        
    }
    
    //list strings
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"listData"]){
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        tempArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"listData"]];
        
        for (NSInteger i=0;i<tempArray.count;i++) {
            NSString *stringObj = [tempArray objectAtIndex:i];
            ListItem *tListItem = [ListItem itemWithText:stringObj];
            NSNumber *isHlNum = [self.highlightsArray objectAtIndex:i];
            tListItem.isHighlighted =
        }
        self.itemsArray = [NSMutableArray arrayWithArray:tempArray];
        
    }else {
        NSArray *startArray = @[[ListItem itemWithText:@"Tap here to edit this"],
                                [ListItem itemWithText:@"Swipe left to delete this"],
                                [ListItem itemWithText:@"Tap anywhere else to add something"]];
        self.itemsArray = [[NSMutableArray alloc]initWithArray:startArray];
    }
    
    //scroll position
    self.scrollPosn = [[NSUserDefaults standardUserDefaults] floatForKey:@"listScrollValue"];
    self.currentlySelectedItem = -1;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    if (!cell) {
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 24, 0, 24)];
    }
    ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
    [cell setItemText:item.text];
    [cell setCellIndex:indexPath.row];
    [cell setDelegate:self];
    [cell setSelected:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
    if (item.isDone) {
        return 0.0;
    }
    return 60;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self removeListItemAtIndex:indexPath.row];
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSUserDefaults standardUserDefaults] setFloat:scrollView.contentOffset.y forKey:@"listScrollValue"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationDidScrollList" object:nil];
}

#pragma mark - Helpers
- (void)markListItemDoneAtIndex:(NSInteger)index {
    ListItem *item = [self.itemsArray objectAtIndex:index];
    item.isDone = YES;
    item.dateOfMarkingDone = [NSDate date];
    [self.tableView reloadData];
    [self saveListToDisk];
}

- (void)saveListToDisk {
    
    NSMutableArray *listStringsArray = [[NSMutableArray alloc] init];
    NSMutableArray *doneStringsArray = [[NSMutableArray alloc] init];
    for (ListItem *item in self.itemsArray) {
        if (item.isDone) {
            [doneStringsArray addObject:item.text];
        }else {
            [listStringsArray addObject:item.text];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:listStringsArray forKey:@"listData"];
    [[NSUserDefaults standardUserDefaults] setValue:listStringsArray forKey:@"listDataBackup"];
    [[NSUserDefaults standardUserDefaults] setValue:doneStringsArray forKey:@"listDataDone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIView *)getHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 68+24)];
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 24, [CommonFunctions getPhoneWidth], 68)];
    [headingLabel setText:@"List"];
    [headingLabel setFont:FontBold(50)];
    [headingLabel setTextColor:[UIColor whiteColor]];
    
    [view setUserInteractionEnabled:YES];
    
    [view addSubview:headingLabel];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ListTableViewCellDelegate
- (void)didUpdateWithText:(NSString *)text cellIndex:(NSInteger)cellIndex {
    ListItem *item = [self.itemsArray objectAtIndex:cellIndex];
    item.text = text;
    item.dateOfModification = [NSDate date];
    [self saveListToDisk];
}

- (void)didTapNextOnCellIndex:(NSInteger)cellIndex {
    if (cellIndex < self.itemsArray.count-1) {
        [self addNewItemAtIndex:cellIndex+1];
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex+1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else {
        [self addNewItemAtTheEnd];
    }
}

- (void)didFinishEmptyEditingAtCellIndex:(NSInteger)cellIndex {
}

- (void)didSwipeOutCellIndex:(NSInteger)cellIndex {
    [self markListItemDoneAtIndex:cellIndex];
}

#pragma mark - Tap Gesture Selector
- (void)tapGestureSelector{
    [self addNewItemAtTheEnd];
}

- (void)addNewItemAtIndex:(NSInteger)index {
    ListItem *newListItem = [ListItem itemWithText:@""];
    [self.itemsArray insertObject:newListItem atIndex:index];
    [self.tableView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)addNewItemAtTheEnd {
    if (self.itemsArray.count > 0) {
        ListItem *lastListItem = [self.itemsArray lastObject];
        if (lastListItem.text.length != 0) {
            [self.itemsArray addObject:[ListItem itemWithText:@""]];
            [self.tableView reloadData];
        }
    }else {
        [self.itemsArray addObject:[ListItem itemWithText:@""]];
        [self.tableView reloadData];
    }
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.itemsArray.count-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

@end
