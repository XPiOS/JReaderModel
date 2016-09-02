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

@property (nonatomic, copy  ) UIColor                *fontColor;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) ReaderView             *readerView;
@property (nonatomic, strong) UIImageView            *bookmarkView;

@end

@implementation ReaderViewController

- (instancetype)initWithPageRect:(CGRect)pageRect fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor contentString:(NSString *)contentString backgroundColorImage:(UIImage *)backgroundColorImage isNight:(BOOL)isNight {
    self = [super init];
    if (self) {
        self.view.frame           = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundColorImage];
        self.fontColor            = fontColor;
        self.readerView           = [[ReaderView alloc] initWithFontSize:fontSize pageRect:pageRect fontColor:fontColor txtContent:contentString backgroundColorImage:backgroundColorImage isNight:isNight];
        self.readerView.delegate  = self;
        [self.view addSubview:self.readerView];
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
    [self initializeController];
}
- (void)initializeController {
    [self add_TapGestureRecognizer];
}
- (void)openOrClosedNotesFunction:(BOOL)notesState {
    [self.readerView openOrClosedNotesFunction:notesState];
}
- (void)setBookmarkState:(BOOL)bookmarkState {
    self.bookmarkView.hidden = !bookmarkState;
}
- (void)add_TapGestureRecognizer {
    if (self.tapGestureRecognizer) {
        [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    }
    self.tapGestureRecognizer          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}
- (void)tapGestureRecognizerClick:(UITapGestureRecognizer *)tapGesture {
    if (self.delegate) {
        if (self.isShowMenu) {
            self.isShowMenu = NO;
            [self.delegate ReaderViewControllerHiddenMenu:self];
        } else {
            self.isShowMenu = YES;
            [self.delegate ReaderViewControllerShowMenu:self];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.isShowMenu) {
        return YES;
    }
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
- (void)readerViewAddNotes:(ReaderView *)readerView notesContentDic:(NSMutableDictionary *)notesContentDic {
    [self.delegate ReaderViewControllerAddNotes:notesContentDic];
}
- (void)readerViewDeleteNotes:(ReaderView *)readerView notesContentDic:(NSMutableDictionary *)notesContentDic {
    [self.delegate ReaderViewControllerDeleteNotes:notesContentDic];
}
- (void)readerViewStartEditMode:(ReaderView *)readerView {
    self.tapGestureRecognizer.enabled = NO;
    [self.delegate ReaderViewControllerPageState:NO];
}
- (void)readerViewCloseEditMode:(ReaderView *)readerView {
    self.tapGestureRecognizer.enabled = YES;
    [self.delegate ReaderViewControllerPageState:YES];
}

#pragma mark - set/get
- (void)setNotesArr:(NSMutableArray *)notesArr {
    _notesArr                     = notesArr;
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
