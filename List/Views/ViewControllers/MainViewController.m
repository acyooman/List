//
//  MainViewController.m
//  Listix
//
//  Created by Arpit Agarwal on 24/09/17.
//  Copyright © 2017 acyooman. All rights reserved.
//

#import "MainViewController.h"
#import "ListTableView.h"
#import "ListItemTableViewCell.h"
#import "CommonFunctions.h"

@interface MainViewController () <ListItemTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ListTableView *listTableView;
@property (nonatomic, strong) CAGradientLayer *bgGradientLayer;

@end

@implementation MainViewController

#pragma mark - Status Bar
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - View Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
}

#pragma mark - View Creation
- (void)createViews {
    [self createBgLayer];
    [self createTableView];
}

- (void)createBgLayer{
//    self.bgGradientLayer = [CommonFunctions gradientLayerType:GradientLayerTypeListBg];
//    [self.bgGradientLayer setFrame:self.view.bounds];
//    [self.view.layer insertSublayer:self.bgGradientLayer atIndex:0];
    [self.view setBackgroundColor:UIColorFromRGB(ColorDarkBG)];
}

- (void)createTableView {
    self.listTableView = [[ListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.listTableView setBackgroundColor:[UIColor clearColor]];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedSectionHeaderHeight = 0;
    self.listTableView.sectionHeaderHeight = 0;
    self.listTableView.estimatedRowHeight = 60.0f;
    
    if (@available(iOS 11.0, *)) {
        self.listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.listTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //keyboard
    [self.listTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    
    //constaints
    [self.listTableView setSameLeadingTrailingView:self.view];
    [self.listTableView setTopView:self.view];
    [self.listTableView setBottomView:self.view];
}

#pragma mark TableView Stuff
#pragma mark - UITableViewCellDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listItemCell"];
    
    if (!cell) {
        cell = [[ListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listItemCell"];
        [cell setDelegate:self];
    }
    
    //set stuff for the cell
    [cell setCellIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewCellDelegate



#pragma mark - Misc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ListItemTableViewCellDelegate methods
- (void)didUpdateCellHeight:(NSInteger)cellIndex {
    [self.listTableView beginUpdates];
    [self.listTableView endUpdates];
}

- (void)didTapNextOnCellIndex:(NSInteger)cellIndex {
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex+1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

@end
