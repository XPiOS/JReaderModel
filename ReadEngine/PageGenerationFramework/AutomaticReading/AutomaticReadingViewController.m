//
//  AutomaticReadingViewController.m
//  创新版
//
//  Created by XuPeng on 16/6/13.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "AutomaticReadingViewController.h"
#import "CoverPatternsViewController.h"
#import "ScrollModeViewController.h"

@interface AutomaticReadingViewController ()<CoverPatternsViewControllerDelegate,ScrollModeViewControllerDelegate>

@end

@implementation AutomaticReadingViewController {
    BOOL                        _isShowMenu;
    UITapGestureRecognizer      *_tapGestureRecognizer;
    CoverPatternsViewController *_coverPatternsViewController;
    ScrollModeViewController    *_scrollModeViewController;
    
}

#pragma mark - 类方法
+ (AutomaticReadingViewController *)shareAutomaticReadingViewController:(UIViewController *)currentViewController topHeight:(CGFloat)topHeight bottomHeight:(CGFloat)bottomHeight automaticReadingTypes:(AutomaticReadingTypes)automaticReadingTypes speed:(NSInteger)speed {
    AutomaticReadingViewController *automaticReadingViewController = [[AutomaticReadingViewController alloc] init];
    automaticReadingViewController.currentViewController           = currentViewController;
    automaticReadingViewController.topHeight                       = topHeight;
    automaticReadingViewController.bottomHeight                    = bottomHeight;
    automaticReadingViewController.speed                           = speed;
    automaticReadingViewController.automaticReadingTypes           = automaticReadingTypes;
    return automaticReadingViewController;
}
- (void)refreshViewController {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick)];
        [self.view addGestureRecognizer:_tapGestureRecognizer];
    }
    [self automaticReadingModel:self.automaticReadingTypes];
}
- (void)automaticReadingSpeed:(NSInteger)speed {
    _speed = speed;
    [_coverPatternsViewController automaticReadingSpeed:_speed];
    [_scrollModeViewController automaticReadingSpeed:_speed];
}
- (void)automaticReadingModel:(AutomaticReadingTypes)automaticReadingTypes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerNextViewController:)]) {
        self.nextViewController = [self.delegate AutomaticReadingViewControllerNextViewController:self];
    }
    if (automaticReadingTypes == CoverPatterns) {
        [_scrollModeViewController.view removeFromSuperview];
        _scrollModeViewController = nil;
        if (_coverPatternsViewController) {
            return;
        }
        _coverPatternsViewController          = [[CoverPatternsViewController alloc] initWithCurrentViewController:self.currentViewController nextViewController:self.nextViewController topHeight:_topHeight bottomHeight:_bottomHeight speed:_speed];
        _coverPatternsViewController.delegate = self;
        [self.view addSubview:_coverPatternsViewController.view];
    } else {
        [_coverPatternsViewController.view removeFromSuperview];
        _coverPatternsViewController = nil;
        if (_scrollModeViewController) {
            return;
        }
        _scrollModeViewController          = [[ScrollModeViewController alloc] initWithCurrentViewController:self.currentViewController nextViewController:self.nextViewController topHeight:_topHeight bottomHeight:_bottomHeight speed:_speed];
        _scrollModeViewController.delegate = self;
        [_scrollModeViewController initializeView];
        [self.view addSubview:_scrollModeViewController.view];
    }
}
- (void)automaticStopReading {
    [_coverPatternsViewController automaticStopReading];
    [_scrollModeViewController automaticStopReading];
}
- (void)tapGestureRecognizerClick {
    _isShowMenu = !_isShowMenu;
    if (_isShowMenu) {
        [_coverPatternsViewController automaticStopReading];
        [_scrollModeViewController automaticStopReading];
    } else {
        [_coverPatternsViewController continueAutomaticReading];
        [_scrollModeViewController continueAutomaticReading];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerIsShowMenu:)]) {
        [self.delegate AutomaticReadingViewControllerIsShowMenu:_isShowMenu];
    }
}

#pragma mark - CoverPatternsViewControllerDelegate
- (UIViewController *)CoverPatternsViewControllerNextViewController:(CoverPatternsViewController *)coverPatternsViewController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerNextViewController:)]) {
        self.nextViewController = [self.delegate AutomaticReadingViewControllerNextViewController:self];
    }
    return self.nextViewController;
}
- (void)CoverPatternsViewControllerExit {
    if ([self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerExit)]) {
        [self.delegate AutomaticReadingViewControllerExit];
    }
}
#pragma mark - ScrollModeViewControllerDelegate
- (UIViewController *)ScrollModeViewControllerNextViewController:(ScrollModeViewController *)scrollModeViewController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerNextViewController:)]) {
        self.nextViewController = [self.delegate AutomaticReadingViewControllerNextViewController:self];
    }
    return self.nextViewController;
}
- (void)ScrollModeViewControllerExit {
    if ([self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerExit)]) {
        [self.delegate AutomaticReadingViewControllerExit];
    }
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
