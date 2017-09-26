//
//  ReaderDirectoryViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/26.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ReaderDirectoryViewController.h"
#import "ChapterModel.h"

@interface ReaderDirectoryViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *directoryTableView;
@property (nonatomic, strong) NSMutableArray<ChapterModel *> *chapterArr;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation ReaderDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self.view addSubview:self.segment];
    self.segment.wd_layout
    .topEqualToSuperView()
    .leftEqualToSuperView()
    .rightSpaceToSuperView(60)
    .height(30);
    
    [self.view addSubview:self.lineView];
    self.lineView.wd_layout
    .topSpaceToView(self.segment, 0)
    .leftEqualToView(self.segment)
    .rightEqualToView(self.segment)
    .height(0.5);
    
    [self.view addSubview:self.directoryTableView];
    self.directoryTableView.wd_layout
    .topSpaceToView(self.lineView, 0)
    .leftEqualToSuperView()
    .bottomEqualToSuperView()
    .rightSpaceToSuperView(60);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView:(NSMutableArray *)chapterArr {
    self.segment.selectedSegmentIndex = 0;
    self.chapterArr = chapterArr;
    [self.directoryTableView reloadData];
}

- (void)tapGestureRecognizerClick: (UITapGestureRecognizer *)tap {
    if (self.cancelClickBlock) {
        self.cancelClickBlock(self);
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.view];
    CGRect rect = CGRectMake(SCREEN_WIDTH - 60, 0, 60, SCREEN_HEIGHT);
    if (CGRectContainsPoint(rect, point)) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapterArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chapterCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chapterCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.chapterArr[indexPath.row].chapterName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellClickBlock) {
        self.cellClickBlock(@(indexPath.row));
    }
}

#pragma mark - get/set
- (UITableView *)directoryTableView {
    if (!_directoryTableView) {
        _directoryTableView = [[UITableView alloc] init];
        _directoryTableView.backgroundColor = [UIColor whiteColor];
        _directoryTableView.delegate = self;
        _directoryTableView.dataSource = self;
    }
    return _directoryTableView;
}
- (UISegmentedControl *)segment {
    if (!_segment) {
        NSArray *array = [NSArray arrayWithObjects:@"目录",@"想法",@"书签", nil];
        _segment = [[UISegmentedControl alloc]initWithItems:array];
        _segment.backgroundColor = [UIColor whiteColor];
    }
    return _segment;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}
- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}
@end
