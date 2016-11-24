//
//  ReaderViewController.m
//  创新版
//
//  Created by XuPeng on 16/5/21.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "ReaderViewController.h"
#import "ReaderView.h"

#define kBookmarkViewX          (self.view.frame.size.width - image.size.width - 2.0f)
#define kBookmarkViewY          2.0f

@interface ReaderViewController () <UIGestureRecognizerDelegate,ReaderViewDelegate>

@property (nonatomic, copy  ) UIColor                      *fontColor;// 字体颜色
@property (nonatomic, strong) UITapGestureRecognizer       *tapGestureRecognizer;// 点击手势
@property (nonatomic, strong) ReaderView                   *readerView;// 内容View
@property (nonatomic, strong) UIImageView                  *bookmarkView; // 书签
@end

@implementation ReaderViewController

- (instancetype)initWithPageRect:(CGRect)pageRect fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor contentString:(NSString *)contentString backgroundColorImage:(UIImage *)backgroundColorImage isNight:(BOOL)isNight {
    self = [super init];
    if (self) {
        self.view.frame           = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundColorImage];
        self.fontColor            = fontColor;
        // 1.绘制页面
        self.readerView           = [[ReaderView alloc] initWithFontSize:fontSize pageRect:pageRect fontColor:fontColor txtContent:contentString backgroundColorImage:backgroundColorImage isNight:isNight];
        self.readerView.delegate  = self;
        [self.view addSubview:self.readerView];

        // 2、添加书签
        UIImage *image            = [UIImage imageNamed:@"阅读页－书签"];
        self.bookmarkView         = [[UIImageView alloc] initWithImage:image];
        self.bookmarkView.frame   = CGRectMake(kBookmarkViewX, kBookmarkViewY, image.size.width, image.size.height);
        self.bookmarkView.hidden  = YES;
        [self.view addSubview:self.bookmarkView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化控制器
    [self initializeController];
}

#pragma mark - 初始化控制器
- (void)initializeController {
    // 添加点击手势
    [self add_TapGestureRecognizer];
}

#pragma mark - 对外方法
#pragma mark 开启笔记功能
- (void)openOrClosedNotesFunction:(BOOL)notesState {
    [self.readerView openOrClosedNotesFunction:notesState];
}
#pragma mark 书签状态设置
- (void)setBookmarkState:(BOOL)bookmarkState {
    self.bookmarkView.hidden = !bookmarkState;
}

#pragma mark - 添加点击手势
- (void)add_TapGestureRecognizer {
    // 如果手势存在，就移除
    if (self.tapGestureRecognizer) {
        [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    }
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}
#pragma mark 手势响应事件
- (void)tapGestureRecognizerClick:(UITapGestureRecognizer *)tapGesture {
    if (self.isShowMenu) {
        // 菜单是显示的
        self.isShowMenu = NO;
        if ([self.delegate respondsToSelector:@selector(ReaderViewControllerHiddenMenu:)]) {
            [self.delegate ReaderViewControllerHiddenMenu:self];
        }
    } else {
        // 菜单是隐藏的
        self.isShowMenu = YES;
        if ([self.delegate respondsToSelector:@selector(ReaderViewControllerShowMenu:)]) {
            [self.delegate ReaderViewControllerShowMenu:self];
        }
    }
}
#pragma mark - 设置手势响应区域
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 响应优先级 ：1、 收起菜单
    //            2、 显示菜单
    //            3、 翻页手势

    // 1、收起菜单
    if (self.isShowMenu) {
        return YES;
    }
    // 2、显示菜单
    CGPoint point = [touch locationInView:self.view];
    CGRect rect   = CGRectMake(80, 0, self.view.frame.size.width - 160, self.view.frame.size.height);
    if (CGRectContainsPoint(rect, point)) {
        return YES;
    } else {
        return NO;
    }
    return NO;
}

#pragma mark - ReaderViewDelegate
#pragma mark 添加笔记
- (void)readerViewAddNotes:(ReaderView *)readerView notesContentDic:(NSMutableDictionary *)notesContentDic {
    [self.delegate ReaderViewControllerAddNotes:notesContentDic];
}
#pragma mark 删除笔记
- (void)readerViewDeleteNotes:(ReaderView *)readerView notesContentDic:(NSMutableDictionary *)notesContentDic {
    [self.delegate ReaderViewControllerDeleteNotes:notesContentDic];
}
#pragma mark 启动编辑模式
- (void)readerViewStartEditMode:(ReaderView *)readerView {
    NSLog(@"启动编辑模式");
    // 关闭点击手势
    self.tapGestureRecognizer.enabled = NO;
    // 关闭翻页手势
    [self.delegate ReaderViewControllerPageState:NO];
}
#pragma mark 关闭编辑模式
- (void)readerViewCloseEditMode:(ReaderView *)readerView {
    NSLog(@"关闭编辑模式");
    // 启动点击手势
    self.tapGestureRecognizer.enabled = YES;
    // 启动翻页手势
    [self.delegate ReaderViewControllerPageState:YES];
}

#pragma mark - set/get
- (void)setNotesArr:(NSMutableArray *)notesArr {
    _notesArr = notesArr;
    // 设置阅读页面的笔记数组
    self.readerView.bottomLineArr = _notesArr;
}
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    [self.readerView drawTitle:_titleStr];
}
- (CGFloat)lastLinePosition {
    return self.readerView.lastLinePosition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
