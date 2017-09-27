//
//  ReaderViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ReaderViewController.h"
#import "JReaderManager.h"
#import "TopMenuView.h"
#import "BottomMenuView.h"
#import "ReaderModel.h"
#import "SetMenuView.h"
#import "ReaderDirectoryViewController.h"

#define kReaderModelFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"ReaderModel"]

@interface ReaderViewController () <JReaderManagerDelegate, JReaderManagerDataSource>

@property (nonatomic, strong) ReaderModel *readerModel;
@property (nonatomic, strong) JReaderManager *jReaderManager;
@property (nonatomic, strong) ReaderDirectoryViewController *readerDirectoryViewController;
@property (nonatomic, assign) CGRect menuRect;
@property (nonatomic, assign) BOOL isNightState;
@property (nonatomic, strong) TopMenuView *topMenuView;
@property (nonatomic, strong) BottomMenuView *bottomMenuView;
@property (nonatomic, strong) SetMenuView *setMenuView;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSInteger chapterIndex;

/**
 行间距
 */
@property (nonatomic, assign) CGFloat lineSpacing;
/**
 段间距
 */
@property (nonatomic, assign) CGFloat paragraphSpacing;

@end

@implementation ReaderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - 初始化页面
- (void)initView {
    
    self.chapterIndex = 0;
    
    self.fontSize = 14;
    self.lineSpacing = self.fontSize / 3;
    self.paragraphSpacing = self.fontSize / 2;
    self.textColor = [UIColor blackColor];
    
    self.statusBarHidden = YES;
    self.menuRect = CGRectMake(SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3, SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3);
    
    ChapterModel *chapterModel = self.readerModel.bookChapterArr[self.chapterIndex];
    JReaderModel *jReaderModel = [[JReaderModel alloc] init];
    jReaderModel.jReaderBookName = self.readerModel.bookName;
    jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
    jReaderModel.jReaderFrame = CGRectMake(15, 44, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 88);
    jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:163 / 255.0 green:147 / 255.0 blue:108 / 255.0 alpha:1];
    jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStylePageCurl;
    jReaderModel.jReaderChapterName = chapterModel.chapterName;
    jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
    NSString *text = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
    jReaderModel.jReaderTextString = text;
    
    self.jReaderManager = [[JReaderManager alloc] initWithJReaderModel:jReaderModel pageIndex:1];
    self.jReaderManager.delegate = self;
    self.jReaderManager.dataSource = self;
    self.jReaderManager.userDefinedProperty = @(self.chapterIndex);
    [self.view addSubview:self.jReaderManager.view];
    
    [self.view addSubview:self.topMenuView];
    self.topMenuView.wd_layout
    .topSpaceToSuperView(-64)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(64);
    
    [self.view addSubview:self.bottomMenuView];
    self.bottomMenuView.wd_layout
    .topSpaceToSuperView(SCREEN_HEIGHT)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(88);
    
    [self.view addSubview:self.setMenuView];
    self.setMenuView.wd_layout
    .topSpaceToSuperView(SCREEN_HEIGHT)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(220);
}
#pragma mark - 设置富文本属性
- (NSDictionary *)getAttributes: (UIFont *)font textColor: (UIColor *)color {
    // 段的样式设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = self.lineSpacing;
    paragraphStyle.paragraphSpacing = self.paragraphSpacing;
    // 对齐
    paragraphStyle.alignment = NSTextAlignmentJustified;
    return @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: font, NSForegroundColorAttributeName: color};
}

#pragma mark 显示菜单
- (void)showMenuView {
    self.menuRect = CGRectMake(0, 0, 0, 0);
    self.statusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.bottomMenuView setProgress:self.jReaderManager.jReaderPageIndex / (self.jReaderManager.jReaderPageCount * 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        self.topMenuView.wd_layout
        .topSpaceToSuperView(0);
        [self.topMenuView wd_updateLayout];
        
        self.bottomMenuView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT - 88);
        [self.bottomMenuView wd_updateLayout];
    }];
}
#pragma mark 隐藏菜单
- (void)hiddnMenuView:(void (^)(void))completion {
    self.menuRect = CGRectMake(SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3, SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3);
    self.statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:0.3 animations:^{
        self.topMenuView.wd_layout
        .topSpaceToSuperView(-64);
        [self.topMenuView wd_updateLayout];
        
        self.bottomMenuView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT);
        [self.bottomMenuView wd_updateLayout];
        
        self.setMenuView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT);
        [self.setMenuView wd_updateLayout];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}
#pragma mark 获取当前时间戳
- (NSString *)getCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

#pragma mark - 顶部菜单点击事件响应
- (void)topMenuViewButtonClick: (NSInteger)tag {
    switch (tag) {
        case 1:
            [NSKeyedArchiver archiveRootObject:self.readerModel toFile:kReaderModelFile];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2: {
            if (!self.readerModel.bookMarkArr) {
                self.readerModel.bookMarkArr = [NSMutableArray array];
            }
            // 防止书签重复添加：1、书签内容完全匹配策略。 2、书签内容 相对章节内容 偏移量起始位置是否匹配。
            MarkModel *markModel = [[MarkModel alloc] init];
            markModel.chapterName = self.jReaderManager.jReaderModel.jReaderChapterName;
            markModel.chapterIndex = self.chapterIndex;
            markModel.markContent = self.jReaderManager.jReaderPageString;
            markModel.markTime = [self getCurrentTime];
            
            BOOL isState = YES;
            for (MarkModel *cacheMarkModel in self.readerModel.bookMarkArr) {
                if ([cacheMarkModel.markContent isEqualToString:markModel.markContent]) {
                    isState = NO;
                    break;
                }
            }
            if (isState) {
                [self.readerModel.bookMarkArr addObject:markModel];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 底部菜单点击事件响应
- (void)bottomSliderClick: (CGFloat)value {
    NSInteger pageIndex = value * self.jReaderManager.jReaderPageCount;
    self.jReaderManager.jReaderPageIndex = pageIndex >= self.jReaderManager.jReaderPageCount ? self.jReaderManager.jReaderPageCount - 1 : pageIndex;
}
- (void)bottomButtonClick: (NSInteger)tag {
    switch (tag) {
        case 1: {
            // 上一章
            self.chapterIndex = [self.jReaderManager.userDefinedProperty integerValue];
            if (self.chapterIndex > 0) {
                self.chapterIndex--;
                ChapterModel *chapterModel = self.readerModel.bookChapterArr[self.chapterIndex];
                self.jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
                self.jReaderManager.userDefinedProperty = @(self.chapterIndex);
                self.jReaderManager.jReaderPageIndex = 0;
                [self.bottomMenuView setProgress:0];
                self.jReaderManager.jReaderModel.jReaderTextString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
            }
            break;
        }
        case 2: {
            // 下一章
            self.chapterIndex = [self.jReaderManager.userDefinedProperty integerValue];
            if (self.chapterIndex < self.readerModel.bookChapterArr.count - 1) {
                self.chapterIndex++;
                ChapterModel *chapterModel = self.readerModel.bookChapterArr[self.chapterIndex];
                self.jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
                self.jReaderManager.userDefinedProperty = @(self.chapterIndex);
                self.jReaderManager.jReaderPageIndex = 0;
                [self.bottomMenuView setProgress:0];
                self.jReaderManager.jReaderModel.jReaderTextString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
            }
            break;
        }
        case 3: {
            // 去目录
            [self hiddnMenuView:nil];
            [self.view addSubview:self.readerDirectoryViewController.view];
            [self addChildViewController:self.readerDirectoryViewController];
            self.readerDirectoryViewController.view.frame = CGRectMake(-SCREEN_WIDTH + 60, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.readerDirectoryViewController.view.backgroundColor = [UIColor clearColor];
            [self.readerDirectoryViewController refreshView:self.readerModel.bookChapterArr markArr:self.readerModel.bookMarkArr];
            [UIView animateWithDuration:0.3 animations:^{
                self.jReaderManager.view.frame = CGRectMake(SCREEN_WIDTH - 60, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                self.readerDirectoryViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
                self.readerDirectoryViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
            break;
        }
        case 4: {
            // 修改 阅读背景色   修改 字体颜色  修改 亮度
            if (self.isNightState) {
                self.isNightState = NO;
                self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:163 / 255.0 green:147 / 255.0 blue:108 / 255.0 alpha:1];
                self.textColor = [UIColor blackColor];
                self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
                self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
                self.jReaderManager.jReaderModel.jReaderBrightness = 0.1;
            } else {
                self.isNightState = YES;
                self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:67 / 255.0 green:47 / 255.0 blue:14 / 255.0 alpha:1];
                self.textColor = [UIColor colorWithRed:83 / 255.0 green:68 / 255.0 blue:34 / 255.0 alpha:1];
                self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
                self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
                self.jReaderManager.jReaderModel.jReaderBrightness = 0.7;
            }
            break;
        }
        case 5: {
            // 设置
            [self hiddnMenuView:^{
                self.menuRect = CGRectMake(0, 0, 0, 0);
                [self.setMenuView setBrightness: 1 - self.jReaderManager.jReaderModel.jReaderBrightness];
                [self.setMenuView setFont:self.fontSize];
                [UIView animateWithDuration:0.3 animations:^{
                    self.setMenuView.wd_layout
                    .topSpaceToSuperView(SCREEN_HEIGHT - 220);
                    [self.setMenuView wd_updateLayout];
                }];
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark - 设置菜单点击
- (void)setMenuViewSliderClick: (CGFloat)value {
    self.jReaderManager.jReaderModel.jReaderBrightness = 1 - value;
}
- (void)setMenuViewClick: (NSInteger)tag {
    switch (tag) {
        case 1:
            self.fontSize = self.fontSize + 2;
            [self.setMenuView setFont:self.fontSize];
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
            break;
        case 2:
            self.fontSize = self.fontSize - 2;
            [self.setMenuView setFont:self.fontSize];
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
            break;
        case 3:
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:181 / 255.0 green:181 / 255.0 blue:181 / 255.0 alpha:1];
            self.jReaderManager.jReaderModel.jReaderBackgroundImage = nil;
            self.textColor = [UIColor blackColor];
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
            break;
        case 4:
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:175 / 255.0 green:167 / 255.0 blue:154 / 255.0 alpha:1];
            self.jReaderManager.jReaderModel.jReaderBackgroundImage = nil;
            self.textColor = [UIColor blackColor];
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
            break;
        case 5:
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:163 / 255.0 green:147 / 255.0 blue:108 / 255.0 alpha:1];
            self.jReaderManager.jReaderModel.jReaderBackgroundImage = nil;
            self.textColor = [UIColor blackColor];
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
            break;
        case 6:
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:128 / 255.0 green:159 / 255.0 blue:129 / 255.0 alpha:1];
            self.jReaderManager.jReaderModel.jReaderBackgroundImage = nil;
            self.textColor = [UIColor blackColor];
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
            break;
        case 7:
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:41 / 255.0 green:62 / 255.0 blue:88 / 255.0 alpha:1];
            self.jReaderManager.jReaderModel.jReaderBackgroundImage = nil;
            self.textColor = [UIColor colorWithRed:8 / 255.0 green:23 / 255.0 blue:34 / 255.0 alpha:1];
            
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
            break;
        case 8:
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:76 / 255.0 green:62 / 255.0 blue:56 / 255.0 alpha:1];
            self.jReaderManager.jReaderModel.jReaderBackgroundImage = nil;
            self.textColor = [UIColor colorWithRed:45 / 255.0 green:41 / 255.0 blue:43 / 255.0 alpha:1];
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6] textColor:self.textColor];
            break;
        case 9:
            self.lineSpacing = self.fontSize / 3;
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            break;
        case 10:
            self.lineSpacing = self.fontSize / 2;
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            break;
        case 11:
            self.lineSpacing = self.fontSize;
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize] textColor:self.textColor];
            break;
        case 12:
            self.jReaderManager.jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStylePageCurl;
            break;
        case 13:
            self.jReaderManager.jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStyleScroll;
            break;
        case 14:
            self.jReaderManager.jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStyleCover;
            break;
        case 15:
            self.jReaderManager.jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStyleNone;
            break;
        default:
            break;
    }
}

#pragma mark - 目录控制器回调
- (void)cancelDirectoryView {
    [UIView animateWithDuration:0.3 animations:^{
        self.jReaderManager.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.readerDirectoryViewController.view.backgroundColor = [UIColor clearColor];
        self.readerDirectoryViewController.view.frame = CGRectMake(-SCREEN_WIDTH + 60, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.readerDirectoryViewController.view removeFromSuperview];
        [self.readerDirectoryViewController removeFromParentViewController];
    }];
}
- (void)jumpChapter: (NSInteger)chapterIndex {
    [self cancelDirectoryView];
    self.chapterIndex = chapterIndex;
    ChapterModel *chapterModel = self.readerModel.bookChapterArr[self.chapterIndex];
    self.jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    self.jReaderManager.userDefinedProperty = @(self.chapterIndex);
    self.jReaderManager.jReaderPageIndex = 0;
    [self.bottomMenuView setProgress:0];
    self.jReaderManager.jReaderModel.jReaderTextString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
}
- (void)jumpMark: (NSInteger)markIndex {
    MarkModel *markModel = self.readerModel.bookMarkArr[markIndex];
    [self cancelDirectoryView];
    self.chapterIndex = markModel.chapterIndex;
    ChapterModel *chapterModel = self.readerModel.bookChapterArr[self.chapterIndex];
    self.jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    self.jReaderManager.userDefinedProperty = @(self.chapterIndex);
    self.jReaderManager.jReaderModel.jReaderTextString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
    // 先设置章节内容，才能搜索到书签所在页面
    self.jReaderManager.jReaderPageIndex = [self.jReaderManager jReaderPageIndexWith:markModel.markContent];
    [self.bottomMenuView setProgress:self.jReaderManager.jReaderPageIndex / (self.jReaderManager.jReaderPageCount * 1.0)];
}
#pragma mark - JReaderManagerDelegate
- (void)jReaderManager:(nullable JReaderManager *)jReaderManager {
    self.jReaderManager.view.userInteractionEnabled = NO;
    [self hiddnMenuView:nil];
}
- (void)jReaderManager:(nullable JReaderManager *)jReaderManager didFinishAnimating:(BOOL)finished transitionCompleted:(BOOL)completed {
    self.jReaderManager.view.userInteractionEnabled = YES;
}
- (BOOL)jReaderManager:(JReaderManager *)jReaderManager tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint point = [tapGestureRecognizer locationInView:self.view];
    if (self.menuRect.size.width == 0) {
        [self hiddnMenuView:nil];
        return YES;
    }
    if (CGRectContainsPoint(self.menuRect, point)) {
        [self showMenuView];
        return NO;
    }
    return YES;
}

#pragma mark - JReaderManagerDataSource
- (NSString *)jReaderManager:(JReaderManager *)jReaderManager userDefinedPropertyAppoint:(id)userDefinedProperty {
    self.chapterIndex = [userDefinedProperty integerValue];
    ChapterModel *chapterModel = self.readerModel.bookChapterArr[self.chapterIndex];
    jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    jReaderManager.userDefinedProperty = @(self.chapterIndex);
    return [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
}
- (NSString *)jReaderManager:(JReaderManager *)jReaderManager userDefinedPropertyBefore:(id)userDefinedProperty {
    self.chapterIndex = [userDefinedProperty integerValue];
    self.chapterIndex--;
    if (self.chapterIndex < 0) {
        self.chapterIndex = 0;
        NSLog(@"第一章");
        return nil;
    }
    ChapterModel *chapterModel = self.readerModel.bookChapterArr[self.chapterIndex];
    jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    jReaderManager.userDefinedProperty = @(self.chapterIndex);
    return [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
}
- (NSString *)jReaderManager:(JReaderManager *)jReaderManager userDefinedPropertyAfter:(id)userDefinedProperty {
    self.chapterIndex = [userDefinedProperty integerValue];
    self.chapterIndex++;
    if (self.chapterIndex >= self.readerModel.bookChapterArr.count) {
        self.chapterIndex = self.readerModel.bookChapterArr.count - 1;
        NSLog(@"最后一章");
        return nil;
    }
    ChapterModel *chapterModel = self.readerModel.bookChapterArr[self.chapterIndex];
    jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    jReaderManager.userDefinedProperty = @(self.chapterIndex);
    return [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - get/set
- (TopMenuView *)topMenuView {
    if (!_topMenuView) {
        _topMenuView = [[TopMenuView alloc] init];
        __weak typeof(self) weakSelf = self;
        _topMenuView.backButtonBlock = ^(id parameter) {
            [weakSelf topMenuViewButtonClick:[parameter integerValue]];
        };
    }
    return _topMenuView;
}
- (BottomMenuView *)bottomMenuView {
    if (!_bottomMenuView) {
        _bottomMenuView = [[BottomMenuView alloc] init];
        __weak typeof(self) weakSelf = self;
        _bottomMenuView.buttonClickBlock = ^(id parameter) {
            [weakSelf bottomButtonClick:[parameter integerValue]];
        };
        _bottomMenuView.sliderClickBlock = ^(id parameter) {
            [weakSelf bottomSliderClick:[parameter floatValue]];
        };
    }
    return _bottomMenuView;
}
- (SetMenuView *)setMenuView {
    if (!_setMenuView) {
        _setMenuView = [[SetMenuView alloc] init];
        __weak typeof(self) weakSelf = self;
        _setMenuView.buttonClickBlock = ^(id parameter) {
            [weakSelf setMenuViewClick:[parameter integerValue]];
        };
        _setMenuView.sliderClickBlock = ^(id parameter) {
            [weakSelf setMenuViewSliderClick:[parameter floatValue]];
        };
    }
    return _setMenuView;
}
- (ReaderModel *)readerModel {
    if (!_readerModel) {
        _readerModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kReaderModelFile];
        if (!_readerModel) {
            _readerModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ReaderModel"]];
        }
    }
    return _readerModel;
}
- (ReaderDirectoryViewController *)readerDirectoryViewController {
    if (!_readerDirectoryViewController) {
        _readerDirectoryViewController = [[ReaderDirectoryViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        _readerDirectoryViewController.cancelClickBlock = ^(id parameter) {
            [weakSelf cancelDirectoryView];
        };
        _readerDirectoryViewController.chapterCellClickBlock = ^(id parameter) {
            [weakSelf jumpChapter:[parameter integerValue]];
        };
        _readerDirectoryViewController.markCellClickBlock = ^(id parameter) {
            [weakSelf jumpMark:[parameter integerValue]];
        };
    }
    return _readerDirectoryViewController;
}
@end
