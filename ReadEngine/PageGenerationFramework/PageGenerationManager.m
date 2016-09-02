//
//  PageGenerationManager.m
//  创新版
//
//  Created by XuPeng on 16/5/20.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "PageGenerationManager.h"
#import "FormatString.h"
#import "Paging.h"
#import "ReaderViewController.h"

#define kHeaderViewX             _pageRect.origin.x
#define kHeaderViewY             0.0f
#define kHeaderViewWidth         _pageRect.size.width
#define kHeaderViewHeight        44.0f

#define kFooterViewX             _pageRect.origin.x
#define kFooterViewY             (_pageRect.origin.y + _pageRect.size.height)
#define kFooterViewWidth         _pageRect.size.width
#define kFooterViewHeight        44.0f

@interface PageGenerationManager ()<PageAnimationViewControllerDelegate,ReaderViewControllerDelegate,AutomaticReadingViewControllerDelegate>

@property (nonatomic, assign) BOOL                           isNextPage;
@property (nonatomic, assign) BOOL                           isNewDataSource;
@property (nonatomic, copy  ) NSString                       *txtContent;
@property (nonatomic, strong) Paging                         *paging;
@property (nonatomic, strong) ReaderViewController           *readerViewController;
@property (nonatomic, strong) PageAnimationViewController    *pageAnimationViewController;
@property (nonatomic, strong) AutomaticReadingViewController *automaticReadingViewController;
@property (nonatomic, strong) UIView                         *headerView;
@property (nonatomic, strong) UIView                         *footerView;

@end


@implementation PageGenerationManager {
    BOOL                  _isNight;
    NSInteger             _speed;
}

@synthesize fontSize = _fontSize, pageRect = _pageRect, currentPage = _currentPage, currentPageStr = _currentPageStr, backgroundImage = _backgroundImage, fontColor = _fontColor, bookName = _bookName, chapterName = _chapterName, animationTypes = _animationTypes,  pageCount = _pageCount, notesArr = _notesArr, bookmarksArr = _bookmarksArr,notesFunctionState = _notesFunctionState;


+ (PageGenerationManager *)sharePageGenerationManager {
    PageGenerationManager *pageGenerationManager = [[PageGenerationManager alloc] init];
    return pageGenerationManager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _fontSize        = 22.0f;
        _pageRect        = CGRectMake(15, 53, [[UIScreen mainScreen] bounds].size.width - 30, [[UIScreen mainScreen] bounds].size.height - 106);

        _pageCount       = 0;
        _currentPage     = 0;
        _backgroundImage = [UIImage imageNamed:@"羊皮纸"];
        _fontColor       = [UIColor blackColor];
        _animationTypes  = TheSimulationEffectOfPage;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)refreshViewController {
    [self initializeController];
}
- (void)nightModel:(BOOL)isNight {
    _isNight = isNight;
}
- (void)jumpStringPage:(NSString *)str {
    for (int i = 0; i < self.paging.pageCount; i++) {
        NSString *pageStr = [self.paging stringOfPage:i];
        if ([pageStr rangeOfString:str].location != NSNotFound) {
            _currentPage = i;
            return;
        }
    }
    _currentPage = 0;
}
- (void)automaticReading:(AutomaticReadingTypes)automaticReadingTypes speed:(NSInteger)speed{
    if (automaticReadingTypes == 0) {
        _automaticReadingTypes = 0;
        [self refreshViewController];
        return;
    }
    [self.pageAnimationViewController removeFromParentViewController];
    [self.pageAnimationViewController.view removeFromSuperview];
    if (self.automaticReadingViewController) {
        return;
    }
    _automaticReadingTypes                       = automaticReadingTypes;
    _speed                                       = speed;
    self.readerViewController                    = [self createReaderViewController];
    self.automaticReadingViewController          = [AutomaticReadingViewController shareAutomaticReadingViewController:self.readerViewController topHeight:_pageRect.origin.y bottomHeight:self.view.frame.size.height - kFooterViewY  automaticReadingTypes:_automaticReadingTypes speed:speed];
    self.automaticReadingViewController.delegate = self;
    [self.view addSubview:self.automaticReadingViewController.view];
    [self.automaticReadingViewController refreshViewController];
}
- (void)automaticReadingModel:(AutomaticReadingTypes)automaticReadingTypes {
    if (_automaticReadingTypes == automaticReadingTypes) {
        return;
    }
    _currentPage--;
    if (_automaticReadingTypes == ScrollMode) {
        _currentPage--;
    }
    _automaticReadingTypes = automaticReadingTypes;
    [self.automaticReadingViewController automaticReadingModel:automaticReadingTypes];
    [self.automaticReadingViewController automaticStopReading];
}
- (void)automaticReadingSpeed:(NSInteger)speed {
    _speed = speed;
    [self.automaticReadingViewController automaticReadingSpeed:_speed];
}
- (void)initializeController {
    if (self.dataSource) {
        [self getData:CurrentContent];
    }
    if (_automaticReadingTypes == 0) {
        if (self.automaticReadingViewController.view) {
            [self.automaticReadingViewController.view removeFromSuperview];
            self.automaticReadingViewController = nil;
        }
        [self addPageAnimationViewController];
    }
}
- (BOOL)getData:(DataSourceTag)dataSourceTag {
    NSString *txtContent;
    if([self.dataSource respondsToSelector:@selector(PageGenerationManagerDataSourceTagString:)]){
        txtContent = [self.dataSource PageGenerationManagerDataSourceTagString:dataSourceTag];
    }
    if (!txtContent) {
        return NO;
    }
    self.txtContent = txtContent;
    self.txtContent = [FormatString formatString:self.txtContent];
    self.paging     = [[Paging alloc] initWithFont:_fontSize pageRect:_pageRect];
    [self.paging paginate:self.txtContent];
    _pageCount      = [self.paging pageCount];
    return YES;
}
- (void)addPageAnimationViewController {
    if (self.pageAnimationViewController) {
        [self.pageAnimationViewController.view removeFromSuperview];
        [self.pageAnimationViewController removeFromParentViewController];
    }
    self.readerViewController                 = [self createReaderViewController];
    self.pageAnimationViewController          = [[PageAnimationViewController alloc] initWithViewController:_readerViewController className:[ReaderViewController class] backgroundImage:_backgroundImage];
    [self.pageAnimationViewController setAlpha:0.4f];
    [self.pageAnimationViewController setAnimationTypes:_animationTypes];
    self.pageAnimationViewController.delegate = self;
    [self addChildViewController:self.pageAnimationViewController];
    [self.view addSubview:self.pageAnimationViewController.view];
}
- (ReaderViewController *)createReaderViewController {
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithPageRect:self.pageRect fontSize:self.fontSize fontColor:self.fontColor contentString:[self.paging stringOfPage:_currentPage] backgroundColorImage:_backgroundImage isNight:_isNight];

    [readerViewController openOrClosedNotesFunction:self.notesFunctionState];
    readerViewController.notesArr              = self.notesArr;
    readerViewController.delegate              = self;
    NSString *currentPageStr                   = [self.paging stringOfPage:_currentPage];
    for (NSMutableDictionary *bookmarkDic in _bookmarksArr) {
        NSString *bookmarkStr = bookmarkDic[@"markContent"];
        NSString *str;
        if (bookmarkStr.length > 30) {
            str = [bookmarkStr substringToIndex:30];
        } else {
            str = [NSString stringWithString:bookmarkStr];
        }
        if ([currentPageStr rangeOfString:str].location != NSNotFound) {
            [readerViewController setBookmarkState:YES];
            break;
        }
    }
    if([self.detegale respondsToSelector:@selector(PageGenerationManagerHeader:)]){
        self.headerView       = [self.detegale PageGenerationManagerHeader:self];
        self.headerView.frame = CGRectMake(kHeaderViewX, kHeaderViewY, kHeaderViewWidth, kHeaderViewHeight);
        [readerViewController.view addSubview:self.headerView];
    }
    if([self.detegale respondsToSelector:@selector(PageGenerationManagerFooter:)]){
        self.footerView       = [self.detegale PageGenerationManagerFooter:self];
        self.footerView.frame = CGRectMake(kFooterViewX, kFooterViewY, kFooterViewWidth, kFooterViewHeight);
        [readerViewController.view addSubview:self.footerView];
    }
    if (_currentPage == 0) {
        readerViewController.titleStr = _chapterName;
    }
    return readerViewController;
}

#pragma mark - ReaderViewControllerDelegate
- (void)ReaderViewControllerShowMenu:(ReaderViewController *)readerViewController {
    
    if([self.detegale respondsToSelector:@selector(PageGenerationManagerIsShowMenu:)]) {
        [self.pageAnimationViewController setGestureRecognizerState:NO];
        [self.detegale PageGenerationManagerIsShowMenu:YES];
    }
}
- (void)ReaderViewControllerHiddenMenu:(ReaderViewController *)readerViewController {
    if([self.detegale respondsToSelector:@selector(PageGenerationManagerIsShowMenu:)]) {
        [self.pageAnimationViewController setGestureRecognizerState:YES];
        [self.detegale PageGenerationManagerIsShowMenu:NO];
    }
}
- (void)ReaderViewControllerPageState:(BOOL)pageState {
    [self.pageAnimationViewController setGestureRecognizerState:pageState];
}
- (void)ReaderViewControllerAddNotes:(NSMutableDictionary *)notesContentDic {
    if([self.detegale respondsToSelector:@selector(PageGenerationManagerAddNotes:)]) {
        [self.detegale PageGenerationManagerAddNotes:notesContentDic];
    }
}
- (void)ReaderViewControllerDeleteNotes:(NSMutableDictionary *)notesContentDic {
    if ([self.detegale respondsToSelector:@selector(PageGenerationManagerDeleteNotes:)]) {
        [self.detegale PageGenerationManagerDeleteNotes:notesContentDic];
    }
}

#pragma mark - PageAnimationViewControllerDelegate
- (UIViewController *)pageAnimationViewControllerBeforeViewController:(UIViewController *)viewController {
    self.isNextPage = NO;
    _currentPage --;
    if (_currentPage < 0) {
        self.isNewDataSource = YES;
        BOOL state           = [self getData:PreviousContent];
        if (!state) {
            _currentPage++;
            return nil;
        }
        _currentPage = _pageCount - 1;
    }
    return self.readerViewController = [self createReaderViewController];
}
- (UIViewController *)pageAnimationViewControllerAfterViewController:(UIViewController *)viewController {
    self.isNextPage = YES;
    _currentPage ++;
    if (_currentPage >= _pageCount) {
        self.isNewDataSource = YES;
        BOOL state = [self getData:NextContent];
        if (!state) {
            _currentPage--;
            return nil;
        }
        _currentPage = 0;
    }
    return self.readerViewController = [self createReaderViewController];
}
- (void)pageAnimationViewControllerToViewControllers:(UIViewController *)pendingViewControllers {
}
- (void)pageAnimationViewControllerCompleted:(BOOL)completed {
    if (!completed) {
        if (self.isNextPage) {
            if (self.isNewDataSource) {
                [self getData:PreviousContent];
                _currentPage = _pageCount - 1;
            } else {
                _currentPage --;
            }
        } else {
            if (self.isNewDataSource) {
                [self getData:NextContent];
                _currentPage = 0;
            } else {
                _currentPage ++;
            }
        }
    }
    self.isNewDataSource = NO;
}
#pragma mark - AutomaticReadingViewControllerDelegate
- (UIViewController *)AutomaticReadingViewControllerNextViewController:(AutomaticReadingViewController *)automaticReadingViewController {
    _currentPage ++;
    if (_currentPage >= _pageCount) {
        self.isNewDataSource = YES;
        BOOL state = [self getData:NextContent];
        if (!state) {
            _currentPage--;
            return nil;
        }
        _currentPage         = 0;
    }
    return self.readerViewController = [self createReaderViewController];
}
- (void)AutomaticReadingViewControllerIsShowMenu:(BOOL)isShowMenu {
    if ([self.detegale respondsToSelector:@selector(PageGenerationManagerAutomaticReadingIsShowMenu:)]) {
        [self.detegale PageGenerationManagerAutomaticReadingIsShowMenu:isShowMenu];
    }
}
- (void)AutomaticReadingViewControllerExit {
    _automaticReadingTypes = 0;
    [self refreshViewController];
}

#pragma mark - set/get
- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
}
- (CGFloat)fontSize {
    return _fontSize;
}
- (void)setPageRect:(CGRect)pageRect {
    _pageRect = pageRect;
}
- (CGRect)pageRect {
    return _pageRect;
}
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    if (_currentPage >= _pageCount) {
        _currentPage = _pageCount - 1;
    }
    if (_currentPage < 0) {
        _currentPage = 0;
    }
}
- (NSInteger)currentPage {
    return _currentPage;
}
- (NSString *)currentPageStr {
    _currentPageStr = [NSString stringWithString:[self.paging stringOfPage:_currentPage]];
    return _currentPageStr;
}
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (!backgroundImage) {
        return;
    }
    _backgroundImage = backgroundImage;
}
- (UIImage *)backgroundImage {
    return _backgroundImage;
}
- (void)setFontColor:(UIColor *)fontColor {
    if (!fontColor) {
        return;
    }
    _fontColor  = fontColor;
}
- (UIColor *)fontColor {
    return _fontColor;
}
- (void)setBookName:(NSString *)bookName {
    if (!bookName) {
        return;
    }
    _bookName = bookName;
}
- (NSString *)bookName {
    return _bookName;
}
- (void)setChapterName:(NSString *)chapterName {
    _chapterName = chapterName;
}
- (NSString *)chapterName {
    return _chapterName;
}
- (void)setAnimationTypes:(AnimationTypes)animationTypes {
    _animationTypes = animationTypes;
}
- (AnimationTypes)animationTypes {
    return _animationTypes;
}
- (NSInteger)pageCount {
    return _pageCount;
}
- (void)setNotesArr:(NSMutableArray *)notesArr {
    if (notesArr) {
        _notesArr = notesArr;
        self.readerViewController.notesArr = _notesArr;
    }
}
- (void)setBookmarksArr:(NSMutableArray *)bookmarksArr {
    if (bookmarksArr) {
        _bookmarksArr = bookmarksArr;
    }
}
- (void)setNotesFunctionState:(BOOL)notesFunctionState {
    _notesFunctionState = notesFunctionState;
    [self.readerViewController openOrClosedNotesFunction:_notesFunctionState];
}
- (BOOL)notesFunctionState {
    return _notesFunctionState;
}
- (void)setIsShowMenu:(BOOL)isShowMenu {
    if (isShowMenu) {
        self.notesFunctionState = NO;
        [self.pageAnimationViewController setGestureRecognizerState:NO];
    }
    self.readerViewController.isShowMenu = isShowMenu;
}
@end
