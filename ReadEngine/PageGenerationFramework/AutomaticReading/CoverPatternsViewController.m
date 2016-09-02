//
//  CoverPatternsViewController.m
//  创新版
//
//  Created by XuPeng on 16/6/14.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "CoverPatternsViewController.h"

#define kAutomaticReadingSpeed         0.004f

@interface CoverPatternsViewController ()

@end

@implementation CoverPatternsViewController {
    UIViewController       *_currentViewController;
    UIViewController       *_nextViewController;
    CGFloat                _topHeight;
    CGFloat                _bottomHeight;
    NSInteger              _speed;
    NSTimer                *_timer;
    UIImageView            *_nextImageView;
}

- (instancetype)initWithCurrentViewController:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController topHeight:(CGFloat)topHeight bottomHeight:(CGFloat)bottomHeight speed:(NSInteger)speed {
    self = [super init];
    if (self) {
        _currentViewController = currentViewController;
        _nextViewController    = nextViewController;
        _topHeight             = topHeight;
        _bottomHeight          = bottomHeight;
        _speed                 = speed;
        [self initializeView];
    }
    return self;
}
- (void)initializeView {
    _currentViewController.view.userInteractionEnabled = NO;
    [self.view addSubview:_currentViewController.view];
    [self drawUpperVeiw];
    [self addTimer];
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
- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:(kAutomaticReadingSpeed / _speed )target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}
- (void)drawUpperVeiw {
    if (_nextImageView) {
        [_nextImageView removeFromSuperview];
        _nextImageView = nil;
    }
    UIGraphicsBeginImageContextWithOptions(_nextViewController.view.frame.size, NO, 0.0);
    [_nextViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image                 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _nextImageView                 = [[UIImageView alloc] init];
    _nextImageView.frame           = CGRectMake(0, 0, image.size.width, _topHeight);
    _nextImageView.backgroundColor = [UIColor colorWithPatternImage:image];
    [[_nextImageView layer] setShadowOffset:CGSizeMake(0, 3)];
    [[_nextImageView layer] setShadowOpacity:1];
    [[_nextImageView layer] setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f].CGColor];
    [self.view addSubview:_nextImageView];
}
- (void)timerFired {
    CGRect nextImageViewRect      = _nextImageView.frame;
    nextImageViewRect.size.height += 0.1f;
    _nextImageView.frame          = nextImageViewRect;
    if (nextImageViewRect.size.height + _bottomHeight >= _nextViewController.view.frame.size.height) {
        [self showNextPage];
    }
}
- (void)showNextPage {
    [_currentViewController.view removeFromSuperview];
    _currentViewController                             = _nextViewController;
    _currentViewController.view.userInteractionEnabled = NO;
    [self.view addSubview:_currentViewController.view];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CoverPatternsViewControllerNextViewController:)]) {
        _nextViewController = [self.delegate CoverPatternsViewControllerNextViewController:self];
    }
    if (!_nextViewController) {
        if ([self.delegate respondsToSelector:@selector(CoverPatternsViewControllerExit)]) {
            [self.delegate CoverPatternsViewControllerExit];
        }
    }
    [self drawUpperVeiw];
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


@end
