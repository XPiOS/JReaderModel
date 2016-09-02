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
    CGSize                 _size;
    UIViewController       *_currentViewController;
    UIViewController       *_nextViewController;
    UIViewController       *_thirdPageViewController;
    CGFloat                _topHeight;
    CGFloat                _bottomHeight;
    NSInteger              _speed;
    NSTimer                *_timer;
    UIImageView            *_headerAndFooterImageView;
    UIView                 *_displayFigureView;
    UIImageView            *_currentImageView;
    UIImageView            *_nextImageView;
    UIImageView            *_thirdPageImageView;
    UIImage                *_cacheNextImage;
    UIImage                *_thirdPageImage;
}
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
- (void)automaticStopReading {
    [_timer invalidate];
}
- (void)continueAutomaticReading {
    [self addTimer];
}
- (void)automaticReadingSpeed:(NSInteger)speed {
    _speed = speed;
}
- (void)initializeView {
    [self calculateScreenshots];
    [self.view addSubview:_headerAndFooterImageView];
    [self createDisplayFigureView];
    [self addTimer];
}
- (void)calculateScreenshots {
    UIGraphicsBeginImageContextWithOptions(_currentViewController.view.frame.size, NO, 0.0);
    [_currentViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image                             = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_headerAndFooterImageView removeFromSuperview];
    _headerAndFooterImageView                  = nil;
    _headerAndFooterImageView                  = [[UIImageView alloc] initWithImage:image];
    _headerAndFooterImageView.frame            = CGRectMake(0, 0, image.size.width, image.size.height);
    UIImageView *imageView                     = [[UIImageView alloc] initWithImage:image];
    imageView.frame                            = CGRectMake(0, -_topHeight, image.size.width, image.size.height);
    [_currentImageView removeFromSuperview];
    _currentImageView                          = nil;
    _currentImageView                          = [[UIImageView alloc] init];
    ReaderViewController *readerViewController = (ReaderViewController *)_currentViewController;
    CGFloat currentImageViewHeight             = readerViewController.lastLinePosition;
    _currentImageView.frame                    = CGRectMake(0, 0, imageView.frame.size.width, currentImageViewHeight);
    [_currentImageView addSubview:imageView];
    _currentImageView.clipsToBounds            = YES;
    UIGraphicsBeginImageContextWithOptions(_nextViewController.view.frame.size, NO, 0.0);
    [_nextViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    _cacheNextImage                            = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView                                  = [[UIImageView alloc] initWithImage:_cacheNextImage];
    imageView.frame                            = CGRectMake(0, -_topHeight, _cacheNextImage.size.width, _cacheNextImage.size.height);
    [_nextImageView removeFromSuperview];
    _nextImageView                             = nil;
    _nextImageView                             = [[UIImageView alloc] init];
    readerViewController                       = (ReaderViewController *)_nextViewController;
    CGFloat nextImageViewHeight                = readerViewController.lastLinePosition;
    _nextImageView.frame                       = CGRectMake(0, 0, imageView.frame.size.width, nextImageViewHeight);
    [_nextImageView addSubview:imageView];
    _nextImageView.clipsToBounds               = YES;
    [self thirdPageScreenshots];
}
- (void)createDisplayFigureView {
    [_displayFigureView removeFromSuperview];
    _displayFigureView                 = nil;
    _displayFigureView                 = [[UIView alloc] initWithFrame:CGRectMake(0, _topHeight, _size.width, self.view.frame.size.height - _bottomHeight - _topHeight)];
    _displayFigureView.backgroundColor = [UIColor whiteColor];
    _displayFigureView.clipsToBounds   = YES;
    [self.view addSubview:_displayFigureView];
    CGRect currentImageViewRect        = _currentImageView.frame;
    currentImageViewRect.origin.y      = 0;
    _currentImageView.frame            = currentImageViewRect;
    [_displayFigureView addSubview:_currentImageView];
    CGRect nextImageViewRect           = _nextImageView.frame;
    nextImageViewRect.origin.y         = _currentImageView.frame.size.height + _currentImageView.frame.origin.y;
    _nextImageView.frame               = nextImageViewRect;
    [_displayFigureView addSubview:_nextImageView];
}
- (void)addTimer {
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:(kAutomaticReadingSpeed / _speed )target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}
- (void)timerFired {
    CGRect currentImageViewRect   = _currentImageView.frame;
    currentImageViewRect.origin.y -= 0.01f;
    _currentImageView.frame       = currentImageViewRect;
    CGRect nextImageViewRect      = _nextImageView.frame;
    nextImageViewRect.origin.y    = _currentImageView.frame.size.height + _currentImageView.frame.origin.y;
    _nextImageView.frame          = nextImageViewRect;
    if ( (_nextImageView.frame.origin.y + _nextImageView.frame.size.height) <= _displayFigureView.frame.size.height && !_thirdPageImageView) {
        if ([self.delegate respondsToSelector:@selector(ScrollModeViewControllerExit)]) {
            [self.delegate ScrollModeViewControllerExit];
        }
    }
    if (_nextImageView.frame.origin.y <= 0) {
        [self showNextPage];
    }
    if (_thirdPageImageView) {
        CGRect thirdPageImageViewRect   = _thirdPageImageView.frame;
        thirdPageImageViewRect.origin.y = _nextImageView.frame.size.height + _nextImageView.frame.origin.y;
        _thirdPageImageView.frame       = thirdPageImageViewRect;
    }
}
- (void)showNextPage {
    _headerAndFooterImageView.image = _cacheNextImage;
    [_currentImageView removeFromSuperview];
    _currentImageView               = nil;
    _currentImageView               = _nextImageView;
    _nextImageView                  = _thirdPageImageView;
    _thirdPageImageView             = nil;
    _cacheNextImage                 = _thirdPageImage;
    [self thirdPageScreenshots];
}
- (void)thirdPageScreenshots {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ScrollModeViewControllerNextViewController:)]) {
        _thirdPageViewController = [self.delegate ScrollModeViewControllerNextViewController:self];
    }
    if (!_thirdPageViewController) {
        _thirdPageImageView = nil;
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(_thirdPageViewController.view.frame.size, NO, 0.0);
        [_thirdPageViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        _thirdPageImage                            = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView * imageView                    = [[UIImageView alloc] initWithImage:_thirdPageImage];
        imageView.frame                            = CGRectMake(0, -_topHeight, _thirdPageImage.size.width, _thirdPageImage.size.height);
        _thirdPageImageView                        = [[UIImageView alloc] init];
        ReaderViewController *readerViewController = (ReaderViewController *)_thirdPageViewController;
        CGFloat thirdPageImageViewHeight           = readerViewController.lastLinePosition;
        _thirdPageImageView.frame                  = CGRectMake(0, 0, imageView.frame.size.width, thirdPageImageViewHeight);
        [_thirdPageImageView addSubview:imageView];
        _thirdPageImageView.clipsToBounds          = YES;
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
