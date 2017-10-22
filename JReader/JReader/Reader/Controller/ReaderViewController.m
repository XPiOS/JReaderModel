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
#import "BookModel.h"
#import "SetMenuView.h"
#import "ReaderDirectoryViewController.h"
#import "ProgressView.h"
#import "BrightnessView.h"
#import "SetMenuView.h"
#import "ReaderModel.h"

#define kReaderModelFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"ReaderModel"]
#define kBookModelFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"BookModel"]

#define kTopMenuViewHeight (SCREEN_HEIGHT == 812 ? 84 : 64)
#define kBottomMenuViewHeight (SCREEN_HEIGHT == 812 ? 70 : 50)

@interface ReaderViewController () <JReaderManagerDelegate, JReaderManagerDataSource>

@property (nonatomic, strong) BookModel *bookModel;
@property (nonatomic, strong) ReaderModel *readerModel;
@property (nonatomic, strong) JReaderManager *jReaderManager;
@property (nonatomic, strong) ReaderDirectoryViewController *readerDirectoryViewController;
@property (nonatomic, assign) CGRect menuRect;
@property (nonatomic, assign) BOOL isNightState;
@property (nonatomic, strong) TopMenuView *topMenuView;
@property (nonatomic, strong) BottomMenuView *bottomMenuView;
@property (nonatomic, strong) SetMenuView *setMenuView;
@property (nonatomic, strong) ProgressView *progressView;
@property (nonatomic, strong) BrightnessView *brightnessView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) UIColor *textColor;

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
    self.currentDate = [NSDate date];
    self.statusBarHidden = YES;
    self.menuRect = CGRectMake(SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3, SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3);
    
    UIColor *backgroundColor;
    switch (self.readerModel.jReaderBackground) {
        default:
        case 1:{
            self.textColor = k000000Color;
            backgroundColor = kF4F4F6Color;
            break;
        }
        case 2:{
            self.textColor = k000000Color;
            backgroundColor = kF2ECD1Color;
            break;
        }
        case 3:{
            self.textColor = k000000Color;
            backgroundColor = kB4EBBAColor;
            break;
        }
        case 4:{
            self.textColor = kA0A0A0Color;
            backgroundColor = k161618Color;
            break;
        }
    }
    
    ChapterModel *chapterModel = self.bookModel.bookChapterArr[self.bookModel.chapterIndex];
    JReaderModel *jReaderModel = [[JReaderModel alloc] init];
    jReaderModel.jReaderBookName = self.bookModel.bookName;
    jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont] textColor:self.textColor];
    if (SCREEN_HEIGHT == 812) {
        jReaderModel.jReaderFrame = CGRectMake(15, 64, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 128);
    } else {
        jReaderModel.jReaderFrame = CGRectMake(15, 44, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 88);
    }
    jReaderModel.jReaderBackgroundColor = backgroundColor;
    jReaderModel.jReaderTransitionStyle = self.readerModel.jReaderPageTransitionStyle;
    jReaderModel.jReaderChapterName = chapterModel.chapterName;
    jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont + 6] textColor:self.textColor];
    NSString *text = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
    jReaderModel.jReaderTextString = text;
    
    self.jReaderManager = [[JReaderManager alloc] initWithJReaderModel:jReaderModel pageIndex:1];
    self.jReaderManager.delegate = self;
    self.jReaderManager.dataSource = self;
    self.jReaderManager.userDefinedProperty = @(self.bookModel.chapterIndex);
    [self.view addSubview:self.jReaderManager.view];
    [self.jReaderManager jReaderManagerReload];
    
    [self.view addSubview:self.topMenuView];
    self.topMenuView.wd_layout
    .topSpaceToSuperView(-kTopMenuViewHeight)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(kTopMenuViewHeight);
    
    [self.view addSubview:self.bottomMenuView];
    self.bottomMenuView.wd_layout
    .topSpaceToSuperView(SCREEN_HEIGHT)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(kBottomMenuViewHeight);
    
    [self.view addSubview:self.progressView];
    self.progressView.wd_layout
    .topSpaceToSuperView(SCREEN_HEIGHT)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(100);
    
    [self.view addSubview:self.setMenuView];
    self.setMenuView.wd_layout
    .topSpaceToSuperView(SCREEN_HEIGHT)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(100);
    
    [self.view addSubview:self.brightnessView];
    self.brightnessView.wd_layout
    .topSpaceToSuperView(SCREEN_HEIGHT)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(100);
}
#pragma mark - 设置富文本属性
- (NSDictionary *)getAttributes: (UIFont *)font textColor: (UIColor *)color {
    // 段的样式设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = self.readerModel.jReaderFont / 3;
    paragraphStyle.paragraphSpacing = self.readerModel.jReaderFont / 2;
    // 对齐
    paragraphStyle.alignment = NSTextAlignmentJustified;
    return @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: font, NSForegroundColorAttributeName: color};
}

#pragma mark 显示菜单
- (void)showMenuView {
    self.menuRect = CGRectMake(0, 0, 0, 0);
    self.statusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:kAnimateTime animations:^{
        self.topMenuView.wd_layout
        .topSpaceToSuperView(0);
        [self.topMenuView wd_updateLayout];
        
        self.bottomMenuView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight);
        [self.bottomMenuView wd_updateLayout];
    }];
}
#pragma mark 隐藏菜单
- (void)hiddnMenuView:(void (^)(void))completion {
    self.menuView = nil;
    self.menuRect = CGRectMake(SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3, SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3);
    self.statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIView animateWithDuration:kAnimateTime animations:^{
        self.progressView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT);
        [self.progressView wd_updateLayout];
        
        self.brightnessView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT);
        [self.brightnessView wd_updateLayout];
        
        self.topMenuView.wd_layout
        .topSpaceToSuperView(-kTopMenuViewHeight);
        [self.topMenuView wd_updateLayout];
        
        self.bottomMenuView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT);
        [self.bottomMenuView wd_updateLayout];
        
        self.setMenuView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT);
        [self.setMenuView wd_updateLayout];
        
    } completion:^(BOOL finished) {
        [self.progressView removeFromSuperview];
        [self.brightnessView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark 获取当前时间字符串
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
            // 保存数据
            [NSKeyedArchiver archiveRootObject:self.readerModel toFile:kReaderModelFile];
            [NSKeyedArchiver archiveRootObject:self.bookModel toFile:kBookModelFile];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2: {
            if (!self.bookModel.bookMarkArr) {
                self.bookModel.bookMarkArr = [NSMutableArray array];
            }
            // 防止书签重复添加：1、书签内容完全匹配策略。 2、书签内容 相对章节内容 偏移量起始位置是否匹配。
            MarkModel *markModel = [[MarkModel alloc] init];
            markModel.chapterName = self.jReaderManager.jReaderModel.jReaderChapterName;
            markModel.chapterIndex = self.bookModel.chapterIndex;
            markModel.markContent = self.jReaderManager.jReaderPageString;
            markModel.markTime = [self getCurrentTime];
            
            BOOL isState = YES;
            for (MarkModel *cacheMarkModel in self.bookModel.bookMarkArr) {
                if ([cacheMarkModel.markContent isEqualToString:markModel.markContent]) {
                    isState = NO;
                    break;
                }
            }
            if (isState) {
                [self.bookModel.bookMarkArr addObject:markModel];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 底部菜单点击事件响应
- (void)bottomButtonClick: (NSInteger)tag {
    switch (tag) {
        case 1: {
            self.jReaderManager.userInteractionEnabled = NO;
            [self hiddnMenuView:nil];
            [self.view addSubview:self.readerDirectoryViewController.view];
            [self addChildViewController:self.readerDirectoryViewController];
            self.readerDirectoryViewController.view.frame = CGRectMake(-SCREEN_WIDTH + 60, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.readerDirectoryViewController.view.backgroundColor = [UIColor clearColor];
            [self.readerDirectoryViewController refreshViewWithBookModel:self.bookModel];
            [UIView animateWithDuration:kAnimateTime animations:^{
                self.jReaderManager.view.frame = CGRectMake(SCREEN_WIDTH - 60, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                self.readerDirectoryViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
                self.readerDirectoryViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
            break;
        }
        case 2: {
            if (self.menuView == self.progressView) {
                return;
            }
            [self.view insertSubview:self.progressView belowSubview:self.bottomMenuView];
            ChapterModel *chapterModel = self.bookModel.bookChapterArr[self.bookModel.chapterIndex];
            CGFloat progress = self.jReaderManager.jReaderModel.jReaderPageIndex / (self.jReaderManager.jReaderModel.jReaderPageCount * 1.0);
            
            NSDate *date = [NSDate date];
            NSInteger time = round([date timeIntervalSinceDate:self.currentDate]) / 60;
            [self.progressView updateViewWithProgress:progress chapterName:chapterModel.chapterName time:time > 0 ? time : 1];
            
            if (self.menuView) {
                [self.menuView removeFromSuperview];
                self.progressView.wd_layout
                .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight - 100);
                [self.progressView wd_updateLayout];
            } else {
                self.progressView.wd_layout
                .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight);
                [self.progressView wd_updateLayout];
                [UIView animateWithDuration:kAnimateTime animations:^{
                    self.progressView.wd_layout
                    .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight - 100);
                    [self.progressView wd_updateLayout];
                }];
            }
            self.menuView = self.progressView;
            break;
        }
        case 3: {
            if (self.menuView == self.brightnessView) {
                return;
            }
            [self.view insertSubview:self.brightnessView belowSubview:self.bottomMenuView];
            [self.brightnessView updateViewWithTag:self.readerModel.jReaderBackground];
            
            if (self.menuView) {
                [self.menuView removeFromSuperview];
                self.brightnessView.wd_layout
                .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight - 100);
                [self.brightnessView wd_updateLayout];
            } else {
                self.brightnessView.wd_layout
                .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight);
                [self.brightnessView wd_updateLayout];
                [UIView animateWithDuration:kAnimateTime animations:^{
                    self.brightnessView.wd_layout
                    .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight - 100);
                    [self.brightnessView wd_updateLayout];
                }];
            }
            self.menuView = self.brightnessView;
            break;
        }
        case 4: {
            if (self.menuView == self.setMenuView) {
                return;
            }
            [self.view insertSubview:self.setMenuView belowSubview:self.bottomMenuView];
            [self.setMenuView updateViewWithFont:self.readerModel.jReaderFont pageModel:self.readerModel.jReaderPageTransitionStyle];
            
            if (self.menuView) {
                [self.menuView removeFromSuperview];
                self.setMenuView.wd_layout
                .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight - 100);
                [self.setMenuView wd_updateLayout];
            } else {
                self.setMenuView.wd_layout
                .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight);
                [self.setMenuView wd_updateLayout];
                [UIView animateWithDuration:kAnimateTime animations:^{
                    self.setMenuView.wd_layout
                    .topSpaceToSuperView(SCREEN_HEIGHT - kBottomMenuViewHeight - 100);
                    [self.setMenuView wd_updateLayout];
                }];
            }
            self.menuView = self.setMenuView;
            break;
        }
        default:
            break;
    }
}
#pragma mark - 设置菜单点击
- (void)setMenuViewSliderClick: (NSInteger)value {
    self.readerModel.jReaderFont = value;
    self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont] textColor:self.textColor];
    self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont + 6] textColor:self.textColor];
    [self.jReaderManager jReaderManagerReload];
}
- (void)setMenuViewClick: (NSInteger)tag {
    self.readerModel.jReaderPageTransitionStyle = tag;
    self.jReaderManager.jReaderModel.jReaderTransitionStyle = tag;
    [self.jReaderManager jReaderManagerReload];
}

#pragma mark - 进度菜单回调
- (void)progressViewButtonClick: (NSInteger)tag {
    if (tag == 1) {
        // 上一章
        self.bookModel.chapterIndex = [self.jReaderManager.userDefinedProperty integerValue];
        if (self.bookModel.chapterIndex > 0) {
            self.bookModel.chapterIndex--;
            [self jumpChapter:self.bookModel.chapterIndex];
        }
    } else {
        // 下一章
        self.bookModel.chapterIndex = [self.jReaderManager.userDefinedProperty integerValue];
        if (self.bookModel.chapterIndex < self.bookModel.bookChapterArr.count - 1) {
            self.bookModel.chapterIndex++;
            [self jumpChapter:self.bookModel.chapterIndex];
        }
    }
}
- (void)progressViewSliderClick: (CGFloat)value {
    NSInteger pageIndex = value * self.jReaderManager.jReaderModel.jReaderPageCount;
    self.jReaderManager.jReaderModel.jReaderPageIndex = pageIndex >= self.jReaderManager.jReaderModel.jReaderPageCount ? self.jReaderManager.jReaderModel.jReaderPageCount - 1 : pageIndex;
    [self.jReaderManager jReaderManagerReload];
}

#pragma mark - 亮度菜单回调
- (void)brightnessViewButtonClick: (NSInteger)tag {
    self.readerModel.jReaderBackground = tag;
    switch (tag) {
        case 1: {
            self.isNightState = YES;
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = kF4F4F6Color;
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont] textColor:k000000Color];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont + 6] textColor:k000000Color];
            break;
        }
        case 2: {
            self.isNightState = YES;
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = kF2ECD1Color;
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont] textColor:k000000Color];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont + 6] textColor:k000000Color];
            self.jReaderManager.jReaderModel.jReaderBrightness = 0;
            break;
        }
        case 3: {
            self.isNightState = YES;
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = kB4EBBAColor;
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont] textColor:k000000Color];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont + 6] textColor:k000000Color];
            self.jReaderManager.jReaderModel.jReaderBrightness = 0;
            break;
        }
        case 4: {
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = k161618Color;
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont] textColor:kA0A0A0Color];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.readerModel.jReaderFont + 6] textColor:kA0A0A0Color];
            self.jReaderManager.jReaderModel.jReaderBrightness = 0;
            break;
        }
        default:
            break;
    }
    [self.jReaderManager jReaderManagerReload];
}

#pragma mark - 目录控制器回调
- (void)cancelDirectoryView {
    [UIView animateWithDuration:kAnimateTime animations:^{
        self.jReaderManager.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.readerDirectoryViewController.view.backgroundColor = [UIColor clearColor];
        self.readerDirectoryViewController.view.frame = CGRectMake(-SCREEN_WIDTH + 60, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.jReaderManager.userInteractionEnabled = YES;
        [self.readerDirectoryViewController.view removeFromSuperview];
        [self.readerDirectoryViewController removeFromParentViewController];
    }];
}
- (void)jumpChapter: (NSInteger)chapterIndex {
    [self cancelDirectoryView];
    self.bookModel.chapterIndex = chapterIndex;
    ChapterModel *chapterModel = self.bookModel.bookChapterArr[self.bookModel.chapterIndex];
    self.jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    self.jReaderManager.userDefinedProperty = @(self.bookModel.chapterIndex);
    self.jReaderManager.jReaderModel.jReaderPageIndex = 0;
    self.jReaderManager.jReaderModel.jReaderTextString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
    [self.jReaderManager jReaderManagerReload];
}
- (void)jumpMark: (NSInteger)markIndex {
    MarkModel *markModel = self.bookModel.bookMarkArr[markIndex];
    [self cancelDirectoryView];
    self.bookModel.chapterIndex = markModel.chapterIndex;
    ChapterModel *chapterModel = self.bookModel.bookChapterArr[self.bookModel.chapterIndex];
    self.jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    self.jReaderManager.userDefinedProperty = @(self.bookModel.chapterIndex);
    self.jReaderManager.jReaderModel.jReaderTextString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
    // 先设置章节内容，才能搜索到书签所在页面
    self.jReaderManager.jReaderModel.jReaderPageIndex = [self.jReaderManager jReaderPageIndexWith:markModel.markContent];
    
}
#pragma mark - JReaderManagerDelegate
- (void)jReaderManager:(nullable JReaderManager *)jReaderManager {
    self.jReaderManager.userInteractionEnabled = NO;
    [self hiddnMenuView:nil];
}
- (void)jReaderManager:(nullable JReaderManager *)jReaderManager didFinishAnimating:(BOOL)finished transitionCompleted:(BOOL)completed {
    self.jReaderManager.userInteractionEnabled = YES;
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
    self.bookModel.chapterIndex = [userDefinedProperty integerValue];
    ChapterModel *chapterModel = self.bookModel.bookChapterArr[self.bookModel.chapterIndex];
    jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    jReaderManager.userDefinedProperty = @(self.bookModel.chapterIndex);
    return [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
}
- (NSString *)jReaderManager:(JReaderManager *)jReaderManager userDefinedPropertyBefore:(id)userDefinedProperty {
    self.bookModel.chapterIndex = [userDefinedProperty integerValue];
    self.bookModel.chapterIndex--;
    if (self.bookModel.chapterIndex < 0) {
        self.bookModel.chapterIndex = 0;
        NSLog(@"第一章");
        return nil;
    }
    ChapterModel *chapterModel = self.bookModel.bookChapterArr[self.bookModel.chapterIndex];
    jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    jReaderManager.userDefinedProperty = @(self.bookModel.chapterIndex);
    return [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:chapterModel.chapterId] encoding:NSUTF8StringEncoding error:nil];
}
- (NSString *)jReaderManager:(JReaderManager *)jReaderManager userDefinedPropertyAfter:(id)userDefinedProperty {
    self.bookModel.chapterIndex = [userDefinedProperty integerValue];
    self.bookModel.chapterIndex++;
    
    if (self.bookModel.chapterIndex >= self.bookModel.bookChapterArr.count) {
        self.bookModel.chapterIndex = self.bookModel.bookChapterArr.count - 1;
        NSLog(@"最后一章");
        return nil;
    }
    ChapterModel *chapterModel = self.bookModel.bookChapterArr[self.bookModel.chapterIndex];
    jReaderManager.jReaderModel.jReaderChapterName = chapterModel.chapterName;
    jReaderManager.userDefinedProperty = @(self.bookModel.chapterIndex);
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
            [weakSelf setMenuViewSliderClick:[parameter integerValue]];
        };
    }
    return _setMenuView;
}
- (ProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ProgressView alloc] init];
        __weak typeof(self) weakSelf = self;
        _progressView.buttonClickBlock = ^(id parameter) {
            [weakSelf progressViewButtonClick:[parameter integerValue]];
        };
        _progressView.sliderClickBlock = ^(id parameter) {
            [weakSelf progressViewSliderClick:[parameter floatValue]];
        };
    }
    return _progressView;
}
- (BrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [[BrightnessView alloc] init];
         __weak typeof(self) weakSelf = self;
        _brightnessView.buttonClickBlock = ^(id parameter) {
            [weakSelf brightnessViewButtonClick:[parameter integerValue]];
        };
    }
    return _brightnessView;
}
- (BookModel *)bookModel {
    if (!_bookModel) {
        _bookModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kBookModelFile];
        if (!_bookModel) {
            _bookModel = [[BookModel alloc] init];
            _bookModel.bookName = @"第一本测试书";
            _bookModel.chapterIndex = 0;
            _bookModel.pageIndex = 0;
            _bookModel.bookMarkArr = [NSMutableArray array];
            _bookModel.bookChapterArr = [NSMutableArray array];
            for (int i = 0; i < 5; i++) {
                ChapterModel *chapterModel = [[ChapterModel alloc] init];
                chapterModel.chapterName = [NSString stringWithFormat:@"第%d章", i + 1];
                chapterModel.chapterId = [NSString stringWithFormat:@"%d", (62447 + i)];
                [_bookModel.bookChapterArr addObject:chapterModel];
            }
        }
    }
    return _bookModel;
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
- (ReaderModel *)readerModel {
    
    if (!_readerModel) {
       _readerModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kReaderModelFile];
        if (!_readerModel) {
            _readerModel = [[ReaderModel alloc] init];
            _readerModel.jReaderFont = 14;
            _readerModel.jReaderBackground = 1;
            _readerModel.jReaderPageTransitionStyle = 0;
        }
    }
    return _readerModel;
}
@end
