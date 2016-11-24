//
//  ScrollModeViewController.m
//  创新版
//
//  Created by XuPeng on 16/6/15.
//  Copyright © 2016年 cxb. All rights reserved.
//  

#import "ScrollModeViewController.h"
#import "ReaderViewController.h"

#define kAutomaticReadingSpeed         0.0005f//0.01f

@interface ScrollModeViewController ()

@end

@implementation ScrollModeViewController {
    CGSize                 _size; // 整个页面的大小
    UIViewController       *_currentViewController; // 第一页的阅读页面
    UIViewController       *_nextViewController; // 第二页的阅读页面
    UIViewController       *_thirdPageViewController; // 第三页阅读页面
    
    CGFloat                _topHeight; // 顶部页眉高度
    CGFloat                _bottomHeight;// 底部页脚高度
    NSInteger              _speed; // 自动翻页速度
    NSTimer                *_timer; // 定时器
    UIImageView            *_headerAndFooterImageView; // 页眉页脚图
    UIView                 *_displayFigureView; // 滚动展示区域
    
    UIImageView            *_currentImageView; // 第一页截图
    UIImageView            *_nextImageView; // 第二页截图
    UIImageView            *_thirdPageImageView; // 第三页展示截图
    // 缓存数据
    
    UIImage                *_cacheNextImage; // 第二页缓存
    UIImage                *_thirdPageImage; // 第三页缓存
}

#pragma mark - 对外方法
#pragma mark 初始化
- (instancetype)initWithCurrentViewController:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController topHeight:(CGFloat)topHeight bottomHeight:(CGFloat)bottomHeight speed:(NSInteger)speed {
    self = [super init];
    if (self) {
        _currentViewController = currentViewController;
        _size                  = currentViewController.view.frame.size;
        _nextViewController    = nextViewController;
        _topHeight             = topHeight;
        _bottomHeight          = bottomHeight;
        _speed                 = speed;
    }
    return self;
}
#pragma mark 暂停自动阅读
- (void)automaticStopReading {
    [_timer invalidate];
}
#pragma mark 恢复自动阅读
- (void)continueAutomaticReading {
    [self addTimer];
}
#pragma mark 设置自动阅读速度
- (void)automaticReadingSpeed:(NSInteger)speed {
    _speed = speed;
}

#pragma mark - 内部方法
#pragma mark 初始化视图
- (void)initializeView {
    // 1、计算页眉页脚等截图
    [self calculateScreenshots];
    
    // 2、绘制页眉页脚层
    [self.view addSubview:_headerAndFooterImageView];
    
    // 3、绘制内容展示层
    [self createDisplayFigureView];
    
    // 4、创建定时器
    [self addTimer];
}
#pragma mark 计算页眉页脚、上下页面截图
- (void)calculateScreenshots {

    // 1、页眉页脚图
    UIGraphicsBeginImageContextWithOptions(_currentViewController.view.frame.size, NO, 0.0);
    [_currentViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_headerAndFooterImageView removeFromSuperview];
    _headerAndFooterImageView = nil;
    _headerAndFooterImageView = [[UIImageView alloc] initWithImage:image];
    _headerAndFooterImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // 2、第一页截图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, -_topHeight, image.size.width, image.size.height);
    
    [_currentImageView removeFromSuperview];
    _currentImageView = nil;
    _currentImageView = [[UIImageView alloc] init];
    ReaderViewController *readerViewController = (ReaderViewController *)_currentViewController;
    CGFloat currentImageViewHeight = readerViewController.lastLinePosition;
    _currentImageView.frame = CGRectMake(0, 0, imageView.frame.size.width, currentImageViewHeight);
    [_currentImageView addSubview:imageView];
    _currentImageView.clipsToBounds = YES;
    
    // 3、第二页截图
    UIGraphicsBeginImageContextWithOptions(_nextViewController.view.frame.size, NO, 0.0);
    [_nextViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    _cacheNextImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView = [[UIImageView alloc] initWithImage:_cacheNextImage];
    imageView.frame = CGRectMake(0, -_topHeight, _cacheNextImage.size.width, _cacheNextImage.size.height);
    [_nextImageView removeFromSuperview];
    _nextImageView = nil;
    _nextImageView = [[UIImageView alloc] init];
    readerViewController = (ReaderViewController *)_nextViewController;
    CGFloat nextImageViewHeight = readerViewController.lastLinePosition;
    _nextImageView.frame = CGRectMake(0, 0, imageView.frame.size.width, nextImageViewHeight);
    [_nextImageView addSubview:imageView];
    _nextImageView.clipsToBounds = YES;
    
    // 4、创建第三页截图
    [self thirdPageScreenshots];
}
#pragma mark 从新创建滚动展示区域
- (void)createDisplayFigureView {
    // 1、创建滚动展示视图
    [_displayFigureView removeFromSuperview];
    _displayFigureView  = nil;
    _displayFigureView = [[UIView alloc] initWithFrame:CGRectMake(0, _topHeight, _size.width, self.view.frame.size.height - _bottomHeight - _topHeight)];
    _displayFigureView.backgroundColor = [UIColor whiteColor];
    _displayFigureView.clipsToBounds = YES;
    [self.view addSubview:_displayFigureView];
    
    // 2、上面视图放到 0 0 位置
    CGRect currentImageViewRect = _currentImageView.frame;
    currentImageViewRect.origin.y = 0;
    _currentImageView.frame = currentImageViewRect;
    [_displayFigureView addSubview:_currentImageView];
    
    // 3、下面视图放到上面视图的后面
    CGRect nextImageViewRect = _nextImageView.frame;
    nextImageViewRect.origin.y = _currentImageView.frame.size.height + _currentImageView.frame.origin.y;
    _nextImageView.frame = nextImageViewRect;
    [_displayFigureView addSubview:_nextImageView];
}
#pragma mark 添加定时器
- (void)addTimer {
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:(kAutomaticReadingSpeed / _speed )target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}
#pragma mark 定时器执行方法
- (void)timerFired {

    // 1、上面视图放到 0 0 位置
    CGRect currentImageViewRect = _currentImageView.frame;
    currentImageViewRect.origin.y -= 0.01f;
    _currentImageView.frame = currentImageViewRect;
    
    // 2、下面视图放到上面视图的后面
    
    CGRect nextImageViewRect = _nextImageView.frame;
    nextImageViewRect.origin.y = _currentImageView.frame.size.height + _currentImageView.frame.origin.y;
    _nextImageView.frame = nextImageViewRect;
    
    if ( (_nextImageView.frame.origin.y + _nextImageView.frame.size.height) <= _displayFigureView.frame.size.height && !_thirdPageImageView) {
        // 退出自动阅读
        if ([self.delegate respondsToSelector:@selector(ScrollModeViewControllerExit)]) {
            [self.delegate ScrollModeViewControllerExit];
        }
    }
    // 3、第一页视图退出了展示区域，加载下一页
    if (_nextImageView.frame.origin.y <= 0) {
        [self showNextPage];
    }
    
    // 4、第三页截图放到第二页后面
    if (_thirdPageImageView) {
        CGRect thirdPageImageViewRect = _thirdPageImageView.frame;
        thirdPageImageViewRect.origin.y = _nextImageView.frame.size.height + _nextImageView.frame.origin.y;
        _thirdPageImageView.frame = thirdPageImageViewRect;
    }
}
#pragma mark 加载下一页
- (void)showNextPage {

    // 1、更改页脚图
    _headerAndFooterImageView.image = _cacheNextImage;
    
    // 2、移除第一页截图
    [_currentImageView removeFromSuperview];
    _currentImageView = nil;
    
    // 3、第一页指向第二页
    _currentImageView = _nextImageView;
    
    // 4、第二页指向第三页
    if (!_thirdPageImageView) {
        int i = 0;
    }
    _nextImageView = _thirdPageImageView;
    _thirdPageImageView = nil;
    
    // 5、第二页缓存指向第三页缓存
    _cacheNextImage = _thirdPageImage;
    
    // 6、创建第三页
    [self thirdPageScreenshots];
    
}
#pragma mark 线程控制第三页
- (void)thirdPageScreenshots {
    if ([self.delegate respondsToSelector:@selector(ScrollModeViewControllerNextViewController:)]) {
        _thirdPageViewController = [self.delegate ScrollModeViewControllerNextViewController:self];
    }
    if (!_thirdPageViewController) {
        _thirdPageImageView = nil;
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(_thirdPageViewController.view.frame.size, NO, 0.0);
        [_thirdPageViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        _thirdPageImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        UIImageView * imageView = [[UIImageView alloc] initWithImage:_thirdPageImage];
        imageView.frame = CGRectMake(0, -_topHeight, _thirdPageImage.size.width, _thirdPageImage.size.height);

        _thirdPageImageView = [[UIImageView alloc] init];
         ReaderViewController *readerViewController = (ReaderViewController *)_thirdPageViewController;
        CGFloat thirdPageImageViewHeight = readerViewController.lastLinePosition;
        _thirdPageImageView.frame = CGRectMake(0, 0, imageView.frame.size.width, thirdPageImageViewHeight);
        [_thirdPageImageView addSubview:imageView];
        _thirdPageImageView.clipsToBounds = YES;
        // 将第三页主线程添加到展示视图上
        dispatch_async(dispatch_get_main_queue(), ^{
            [_displayFigureView addSubview:_thirdPageImageView];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
