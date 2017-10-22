//
//  ReaderDirectoryViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/26.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ReaderDirectoryViewController.h"
#import "MarkTableViewCell.h"
#import "BookModel.h"

@interface ReaderDirectoryViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) BookModel *bookModel;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) UITableView *directoryTableView;
@property (nonatomic, strong) UITableView *markTableView;
@property (nonatomic, strong) NSMutableArray<ChapterModel *> *chapterArr;
@property (nonatomic, strong) NSMutableArray<MarkModel *> *markArr;
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
    .height(44);
    
    [self.view addSubview:self.lineView];
    self.lineView.wd_layout
    .topSpaceToView(self.segment, 0)
    .leftEqualToView(self.segment)
    .rightEqualToView(self.segment)
    .height(0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDirectoryView {
    
}
- (void)hiddnDirectoryView {
    
}

- (void)refreshViewWithBookModel:(BookModel *)bookModel {
    self.bookModel = bookModel;
}

- (void)tapGestureRecognizerClick: (UITapGestureRecognizer *)tap {
    if (self.cancelClickBlock) {
        self.cancelClickBlock(self);
    }
}

- (void)segmentedControlClick: (UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:
            if (self.currentTableView != self.directoryTableView) {
                [self.currentTableView removeFromSuperview];
                [self.view addSubview:self.directoryTableView];
                self.directoryTableView.wd_layout
                .topSpaceToView(self.lineView, 0)
                .leftEqualToSuperView()
                .bottomEqualToSuperView()
                .rightSpaceToSuperView(60);
                [self.directoryTableView reloadData];
                self.currentTableView = self.directoryTableView;
            }
            break;
        case 1:
            break;
        case 2:
            if (self.currentTableView != self.markTableView) {
                [self.currentTableView removeFromSuperview];
                [self.view addSubview:self.markTableView];
                self.markTableView.wd_layout
                .topSpaceToView(self.lineView, 0)
                .leftEqualToSuperView()
                .bottomEqualToSuperView()
                .rightSpaceToSuperView(60);
                [self.markTableView reloadData];
                self.currentTableView = self.markTableView;
            }
            break;
        default:
            break;
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
    if (tableView == self.directoryTableView) {
        return self.chapterArr.count;
    }
    if (tableView == self.markTableView) {
        return self.markArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.directoryTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chapterCell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chapterCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = self.chapterArr[indexPath.row].chapterName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = k191E25Color;
        cell.textLabel.font = Font(14);
        return cell;
    } else if (tableView == self.markTableView) {
        MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"markCell"];
        if (cell==nil) {
            cell = [[MarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"markCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.markModel = self.markArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        return [[UITableViewCell alloc] init];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.directoryTableView && self.chapterCellClickBlock) {
        self.chapterCellClickBlock(@(indexPath.row));
    }
    if (tableView == self.markTableView && self.markCellClickBlock) {
        self.markCellClickBlock(@(indexPath.row));
    }
}

#pragma mark - get/set
- (void)setBookModel:(BookModel *)bookModel {
    _bookModel = bookModel;
    self.segment.selectedSegmentIndex = 0;
    self.chapterArr = bookModel.bookChapterArr;
    self.markArr = bookModel.bookMarkArr;;
    [self segmentedControlClick:self.segment];
}
- (UITableView *)directoryTableView {
    if (!_directoryTableView) {
        _directoryTableView = [[UITableView alloc] init];
        _directoryTableView.backgroundColor = kF4F4F6Color;
        _directoryTableView.delegate = self;
        _directoryTableView.dataSource = self;
        _directoryTableView.rowHeight = 50;
        _directoryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _directoryTableView;
}
- (UITableView *)markTableView {
    if (!_markTableView) {
        _markTableView = [[UITableView alloc] init];
        _markTableView.backgroundColor = kF4F4F6Color;
        _markTableView.rowHeight = 100;
        _markTableView.delegate = self;
        _markTableView.dataSource = self;
    }
    return _markTableView;
}
- (UISegmentedControl *)segment {
    if (!_segment) {
        NSArray *array = [NSArray arrayWithObjects:@"目录",@"想法",@"书签", nil];
        _segment = [[UISegmentedControl alloc]initWithItems:array];
        _segment.backgroundColor = kFFFFFFColor;
        _segment.tintColor = [UIColor clearColor];
        [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName: k515151Color} forState:UIControlStateNormal];
        [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName: k1A71EAColor} forState:UIControlStateSelected];
        [_segment addTarget:self action:@selector(segmentedControlClick:) forControlEvents:UIControlEventValueChanged];
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
