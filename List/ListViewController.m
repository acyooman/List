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

@interface ListViewController ()<UITableViewDataSource , UITableViewDelegate, ListTableViewCellDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic) NSInteger currentlySelectedItem;
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
    [self createListViews];
}

- (void)createListViews {
    //list container view
    self.listContainerView = [[UIView alloc] init];
    [self.listContainerView setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
    [self.listContainerView setFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight])];
    [self.view addSubview:self.listContainerView];
    
    //table view
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], [CommonFunctions getPhoneHeight]) style:UITableViewStylePlain];
    [self.listTableView setTableHeaderView:[self getListHeaderView]];
    [self.listContainerView addSubview:self.listTableView];
    
    //customize
    [self.listTableView setAllowsMultipleSelectionDuringEditing:NO];
    [self.listTableView setBackgroundColor:[UIColor clearColor]];
    [self.listTableView setDataSource:self];
    [self.listTableView setDelegate:self];
    [self.listTableView setDecelerationRate:UIScrollViewDecelerationRateFast];
    [self.listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 300)]];
    [self.listTableView setContentOffset:CGPointMake(0, self.scrollPosn)];

    //separators
    [self.listTableView setSeparatorColor:UIColorFromRGB(ColorSeparator)];
    
    //
    [self setupListGestures];
    
}

- (void)setupListGestures {
    //swipeUp Gesture
    self.listSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listSwipeUpGestureCallback:)];
    [self.listSwipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.listSwipeGesture setEnabled:NO];
    [self.listSwipeGesture setDelegate:self];
    [self.listTableView addGestureRecognizer:self.listSwipeGesture];
    
    //tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSelector)];
    [self.listTableView addGestureRecognizer:tapGesture];
    
    //pan gesture
    self.listPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(listPanGestureCallback:)];
    [self.listPanGesture setDelegate:self];
    [self.listTableView addGestureRecognizer:self.listPanGesture];
}

#pragma mark - Data
- (void)getSavedData {
    //list strings
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"listArrayData"]){
        NSMutableArray *diskArray = [[NSMutableArray alloc] init];
        diskArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"listArrayData"]];
        
        //highlights
        NSMutableArray *highlightsArray = [[NSMutableArray alloc] init];
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"highlightsData"]){
            highlightsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"highlightsData"]];
        }else {
            for (NSInteger i=0; i<diskArray.count; i++) {
                [highlightsArray addObject:@(0)];
            }
        }
        
        //temp array
        NSMutableArray *tempObjectsArray = [[NSMutableArray alloc] init];
        
        //strings
        for (NSInteger i=0;i<diskArray.count;i++) {
            NSString *stringObj = [diskArray objectAtIndex:i];
            ListItem *listItem = [ListItem itemWithText:stringObj];
            
            NSNumber *tempNumber = [highlightsArray objectAtIndex:i];
            listItem.isHighlighted = tempNumber.boolValue;
            
            [tempObjectsArray addObject:listItem];
        }
        
        self.itemsArray = [NSMutableArray arrayWithArray:tempObjectsArray];
        
    }else {
        NSArray *startArray = @[[ListItem itemWithText:@"Swipe 👉 or 👈 to past"],
                                [ListItem itemWithText:@"Pull down this list to see past stuff ⏬"],
                                [ListItem itemWithText:@"Double tap to highlight 👆👆"],
                                [ListItem itemWithText:@"Be awesome now 😘"]
                                ];
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
    return self.itemsArray.count; //same in both
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.listTableView) {
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
        if (!cell) {
            cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 24, 0, 24)];
        }
        ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
        if (!item.isDone) {
            [cell setListItem:item];
            [cell setCellIndex:indexPath.row];
            [cell setDelegate:self];
            [cell setSelected:NO];
        }
        return cell;
    }
    
    else {
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pastItemCell"];
        if (!cell) {
            cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pastItemCell"];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 24, 0, 24)];
        }
        ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
        if (item.isDone) {
            [cell setListItem:item];
            [cell setCellIndex:indexPath.row];
            [cell setDelegate:self];
            [cell setSelected:NO];
        }
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListItem *item = [self.itemsArray objectAtIndex:indexPath.row];
    
    if (tableView == self.listTableView) {
        if (item.isDone) {
            return 0.0;
        }
        return 60;
    }else {
        if (!item.isDone) {
            return 0.0;
        }
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
- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)markListItemDoneAtIndex:(NSInteger)index {
    ListItem *item = [self.itemsArray objectAtIndex:index];
    item.isDone = YES;
    item.dateOfMarkingDone = [NSDate date];
    [self.listTableView reloadData];
    [self saveListDataToDisk];
}

- (void)saveListDataToDisk {
    NSMutableArray *listStringsArray = [[NSMutableArray alloc] init];
    NSMutableArray *doneStringsArray = [[NSMutableArray alloc] init];
    NSMutableArray *highlightNumbersArray = [[NSMutableArray alloc] init];
    for (ListItem *item in self.itemsArray) {
        if (item.isDone) {
            [doneStringsArray addObject:item.text];
        }else {
            [listStringsArray addObject:item.text];
        }
        [highlightNumbersArray addObject:@(item.isHighlighted)];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:highlightNumbersArray forKey:@"highlightsData"];
    [[NSUserDefaults standardUserDefaults] setValue:listStringsArray forKey:@"listArrayData"];
    [[NSUserDefaults standardUserDefaults] setValue:listStringsArray forKey:@"listDataBackup"];
    [[NSUserDefaults standardUserDefaults] setValue:doneStringsArray forKey:@"listDataDone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIView *)getListHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 68+24)];
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 24, [CommonFunctions getPhoneWidth], 68)];
    [headingLabel setText:@"List"];
    [headingLabel setFont:FontBold(50)];
    [headingLabel setTextColor:[UIColor whiteColor]];
    
    [view setUserInteractionEnabled:YES];
    
    [view addSubview:headingLabel];
    return view;
}

- (UIView *)getPastHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonFunctions getPhoneWidth], 68+24)];
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 24, [CommonFunctions getPhoneWidth], 68)];
    [headingLabel setText:@"Past."];
    [headingLabel setFont:FontBold(50)];
    [headingLabel setTextColor:[UIColor whiteColor]];
    
    [view setUserInteractionEnabled:YES];
    
    [view addSubview:headingLabel];
    return view;
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
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.listContainerView setFrameY:[CommonFunctions getPhoneHeight] - 100.0f];
    } completion:^(BOOL finished) {
          [self.listPanGesture setEnabled:NO];
        [self.listSwipeGesture setEnabled:YES];
    }];
}

- (void)maximizeListContainer {
    [UIView animateWithDuration:0.5f delay:0.0 usingSpringWithDamping:0.8f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.listContainerView setFrameY:0.0f];
        [self.view setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
    } completion:^(BOOL finished) {
        [self.listPanGesture setEnabled:YES];
        [self.view setBackgroundColor:UIColorFromRGB(ColorLessDarkBG)];
    }];
}

- (void)removeListItemAtIndex:(NSInteger)index {
    [self.itemsArray removeObjectAtIndex:index];
    [self.listTableView reloadData];
    [self saveListDataToDisk];
    
    if (index > 0) {
        [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)addNewItemAtIndex:(NSInteger)index {
    ListItem *newListItem = [ListItem itemWithText:@""];
    [self.itemsArray insertObject:newListItem atIndex:index];
    [self.listTableView reloadData];
    
    [self saveListDataToDisk];
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)addNewItemAtTheEnd {
    if (self.itemsArray.count > 0) {
        ListItem *lastListItem = [self.itemsArray lastObject];
        if (lastListItem.text.length != 0) {
            [self.itemsArray addObject:[ListItem itemWithText:@""]];
            [self.listTableView reloadData];
        }
    }else {
        [self.itemsArray addObject:[ListItem itemWithText:@""]];
        [self.listTableView reloadData];
    }
    
    [self saveListDataToDisk];
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.itemsArray.count-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - ListTableViewCellDelegate
- (void)didToggleStandOutStateAtIndex:(NSInteger)cellIndex isStandingOut:(BOOL)isStandingOut {
    ListItem *item = [self.itemsArray objectAtIndex:cellIndex];
    [item setIsHighlighted:isStandingOut];
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
        [self removeListItemAtIndex:cellIndex];
    }
}

- (void)didSwipeOutCellIndex:(NSInteger)cellIndex {
    [self markListItemDoneAtIndex:cellIndex];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
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
    CGFloat dismissThresh = 300.0f;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.panGestureStartY = translatedPoint.y;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            self.panGestureDeltaY = translatedPoint.y - self.panGestureStartY;
            
            if(self.panGestureDeltaY > 0 && self.listTableView.contentOffset.y <= 0) {
                [self.listContainerView setFrameY:self.panGestureDeltaY*0.55f];
                
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
                if (self.panGestureDeltaY > dismissThresh || (self.panGestureDeltaY > 100.0f && velocityInView.y > 1000.0f)) {

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

#pragma mark - Keyboard Notifications
- (void)keyboardDidShow:(NSNotification *)notif {
    self.isKeyboardShowingCurrently = YES;
}

- (void)keyboardDidHide:(NSNotification *)notif {
    self.isKeyboardShowingCurrently = NO;
}

@end
