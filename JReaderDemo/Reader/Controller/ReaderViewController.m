//
//  ReaderViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ReaderViewController.h"
#import "JReaderManager.h"
#import "TapMenuView.h"
#import "BottomMenuView.h"

@interface ReaderViewController () <JReaderManagerDelegate, JReaderManagerDataSource>

@property (nonatomic, strong) JReaderManager *jReaderManager;
@property (nonatomic, assign) CGRect menuRect;
@property (nonatomic, strong) TapMenuView *tapMenuView;
@property (nonatomic, strong) BottomMenuView *bottomMenuView;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) NSInteger fontSize;
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
    
    self.fontSize = 14;
    self.lineSpacing = self.fontSize / 3;
    self.paragraphSpacing = self.fontSize / 2;
    
    self.statusBarHidden = YES;
    self.menuRect = CGRectMake(SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3, SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3);
    
    JReaderModel *jReaderModel = [[JReaderModel alloc] init];
    jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize]];
    jReaderModel.jReaderFrame = CGRectMake(15, 30, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 60);
    jReaderModel.jReaderTextColor = [UIColor blackColor];
    jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:210 / 255.0 green:180 / 255.0 blue:140 / 255.0 alpha:1.0];
    jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStylePageCurl;
    jReaderModel.jReaderChapterName = @"章节名称";
    jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6]];
    jReaderModel.jReaderPageIndex = 0;
    
    NSString *text = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"text"] encoding:NSUTF8StringEncoding error:nil];
    jReaderModel.jReaderTextString = text;
    self.jReaderManager.jReaderModel = jReaderModel;
    [self.view addSubview:self.jReaderManager.view];
    
    [self.view addSubview:self.tapMenuView];
    self.tapMenuView.wd_layout
    .topSpaceToSuperView(-64)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(64);
    
    [self.view addSubview:self.bottomMenuView];
    self.bottomMenuView.wd_layout
    .topSpaceToSuperView(SCREEN_HEIGHT)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(240);
    
}
#pragma mark - 设置富文本属性
- (NSDictionary *)getAttributes: (UIFont *)font {
    // 段的样式设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = self.lineSpacing;
    paragraphStyle.paragraphSpacing = self.paragraphSpacing;
    // 对齐
    paragraphStyle.alignment = NSTextAlignmentJustified;
    // @{}  初始化不可变字典
    return @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font};
}

#pragma mark 显示菜单
- (void)showMenuView {
    NSLog(@"显示菜单");
    self.menuRect = CGRectMake(0, 0, 0, 0);
    
    self.statusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tapMenuView.wd_layout
        .topSpaceToSuperView(0);
        [self.tapMenuView wd_updateLayout];
        
        self.bottomMenuView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT - 240);
        [self.bottomMenuView wd_updateLayout];
    }];
}
#pragma mark 隐藏菜单
- (void)hiddnMenuView {
    NSLog(@"隐藏菜单");
    self.menuRect = CGRectMake(SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3, SCREEN_WIDTH / 3, SCREEN_HEIGHT / 3);
    
    self.statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tapMenuView.wd_layout
        .topSpaceToSuperView(-64);
        [self.tapMenuView wd_updateLayout];
        
        self.bottomMenuView.wd_layout
        .topSpaceToSuperView(SCREEN_HEIGHT);
        [self.bottomMenuView wd_updateLayout];
    }];
}

#pragma mark - 底部菜单点击事件响应
- (void)bottomButtonClick: (NSInteger)tag {
    switch (tag) {
        case 1: {
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:++self.fontSize]];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6]];
            break;
        }
        case 2: {
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:--self.fontSize]];
            self.jReaderManager.jReaderModel.jReaderChapterNameAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize + 6]];
            break;
        }
        case 3: {
            self.jReaderManager.jReaderModel.jReaderBrightness = (self.jReaderManager.jReaderModel.jReaderBrightness - 0.1) < 0 ? 0 : (self.jReaderManager.jReaderModel.jReaderBrightness - 0.1);
            break;
        }
        case 4: {
            self.jReaderManager.jReaderModel.jReaderBrightness = (self.jReaderManager.jReaderModel.jReaderBrightness + 0.1) > 1 ? 1 : (self.jReaderManager.jReaderModel.jReaderBrightness + 0.1);
            break;
        }
        case 5: {
            self.lineSpacing = self.lineSpacing + 0.2;
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize]];
            break;
        }
        case 6: {
            self.lineSpacing = (self.lineSpacing - 0.2) < self.fontSize / 3 ? self.fontSize / 3 : (self.lineSpacing - 0.2);
            self.jReaderManager.jReaderModel.jReaderAttributes = [self getAttributes:[UIFont systemFontOfSize:self.fontSize]];
            break;
        }
        case 7: {
            self.jReaderManager.jReaderModel.jReaderBackgroundColor = [UIColor colorWithRed:210 / 255.0 green:180 / 255.0 blue:140 / 255.0 alpha:1.0];
            break;
        }
        case 8: {
            self.jReaderManager.jReaderModel.jReaderBackgroundColor =[UIColor colorWithRed:235 / 255.0 green:243 / 255.0 blue:239 / 255.0 alpha:1.0];
            break;
        }
        case 9: {
            self.jReaderManager.jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStylePageCurl;
            break;
        }
        case 10: {
            self.jReaderManager.jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStyleScroll;
            break;
        }
        case 11: {
            self.jReaderManager.jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStyleCover;
            break;
        }
        case 12: {
            self.jReaderManager.jReaderModel.jReaderTransitionStyle = PageViewControllerTransitionStyleNone;
            break;
        }
        default:
            break;
    }
}

#pragma mark - JReaderManagerDelegate
- (void)jReaderManager: (nullable JReaderManager *)jReaderManager dataException: (nullable id)userDefinedProperty {
    NSLog(@"数据异常");
}
- (void)jReaderManager:(nullable JReaderManager *)jReaderManager {
    NSLog(@"动画开始");
    [self hiddnMenuView];
}
- (void)jReaderManager:(nullable JReaderManager *)jReaderManager didFinishAnimating:(BOOL)finished transitionCompleted:(BOOL)completed {
    NSLog(@"动画结束");
}
- (BOOL)jReaderManager:(JReaderManager *)jReaderManager tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint point = [tapGestureRecognizer locationInView:self.view];
    if (self.menuRect.size.width == 0) {
        [self hiddnMenuView];
        return YES;
    }
    if (CGRectContainsPoint(self.menuRect, point)) {
        [self showMenuView];
        return NO;
    }
    return YES;
}

#pragma mark - JReaderManagerDataSource
- (nullable NSString *)jReaderManager:(nullable JReaderManager *)jReaderManager userDefinedPropertyBefore: (nullable id)userDefinedProperty {
    return [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"text"] encoding:NSUTF8StringEncoding error:nil];
}
- (nullable NSString *)jReaderManager:(nullable JReaderManager *)jReaderManager userDefinedPropertyAfter: (nullable id)userDefinedProperty {
    return [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"text"] encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - get/set
- (JReaderManager *)jReaderManager {
    if (!_jReaderManager) {
        _jReaderManager = [[JReaderManager alloc] init];
        _jReaderManager.delegate = self;
        _jReaderManager.dataSource = self;
    }
    return _jReaderManager;
}
- (TapMenuView *)tapMenuView {
    if (!_tapMenuView) {
        _tapMenuView = [[TapMenuView alloc] init];
        __weak typeof(self) weakSelf = self;
        _tapMenuView.backButtonBlock = ^(id parameter) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _tapMenuView;
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
@end
