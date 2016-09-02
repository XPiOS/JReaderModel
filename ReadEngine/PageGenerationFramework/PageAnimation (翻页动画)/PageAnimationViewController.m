//
//  PageAnimation ViewController.m
//  zwsc
//
//  Created by XuPeng on 16/3/2.
//  Copyright © 2016年 中文万维. All rights reserved.
//

#import "PageAnimationViewController.h"
#import "BackViewController.h"
#import "SlidingViewController.h"
#import "KeepOutViewController.h"
#import "NoAnimationViewController.h"

@implementation PageAnimationViewController {
    BOOL                               _isResponseGestures;
    AnimationTypes                     _animationType;
    UIPageViewController               *_pageViewController;
    KeepOutViewController              *_keepOutViewController;
    SlidingViewController              *_slidingViewController;
    NoAnimationViewController          *_noAnimationViewController;
    CGFloat                            _alpha;
    Class                              _className;
    UIViewController                   *_currentViewController;
    UIViewController                   *_beforeViewController;
    UIImage                            *_backgroundImage;
    BOOL                               _isPageAnimation;
}
- (instancetype)initWithViewController:(UIViewController *)viewController className:(__unsafe_unretained Class)className backgroundImage:(UIImage *)backgroundImage {
    self = [super init];
    if (self) {
        _animationType         = TheSimulationEffectOfPage;
        _currentViewController = viewController;
        _className             = className;
        _alpha                 = 0.2;
        _backgroundImage        = backgroundImage;
        _isResponseGestures    = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updata];
}

- (BOOL)updata {
    if (_pageViewController != nil) {
        [_pageViewController.view removeFromSuperview];
        [_pageViewController removeFromParentViewController];
        _isPageAnimation           = NO;
        _pageViewController        = nil;
    }
    if (_keepOutViewController != nil) {
        [_keepOutViewController.view removeFromSuperview];
        [_keepOutViewController removeFromParentViewController];
        _keepOutViewController     = nil;
    }
    if (_slidingViewController) {
        [_slidingViewController.view removeFromSuperview];
        [_slidingViewController removeFromParentViewController];
        _slidingViewController     = nil;
    }
    if (_noAnimationViewController) {
        [_noAnimationViewController.view removeFromSuperview];
        [_noAnimationViewController removeFromParentViewController];
        _noAnimationViewController = nil;
    }
    switch (_animationType) {
        case TheSimulationEffectOfPage:
        default:{
            _pageViewController                      = [[UIPageViewController alloc] init];
            _pageViewController.delegate             = self;
            _pageViewController.dataSource           = self;
            _pageViewController.view.backgroundColor = [UIColor blackColor];
            _pageViewController.doubleSided          = YES;
            [self addChildViewController:_pageViewController];
            [self.view addSubview:_pageViewController.view];
            [_pageViewController setViewControllers:@[_currentViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL finished) {
                                         }];
            
            return YES;
        }
        case TheKeepOutEffectOfPage: {
            _keepOutViewController          = [[KeepOutViewController alloc] initWithView:_currentViewController];
            _keepOutViewController.delegate = self;
            [self addChildViewController:_keepOutViewController];
            [self.view addSubview:_keepOutViewController.view];
            return YES;
        }
        case TheSlidingEffectOfPage:{
            _slidingViewController          = [[SlidingViewController alloc] initWithView:_currentViewController];
            _slidingViewController.delegate = self;
            [self.view addSubview:_slidingViewController.view];
            return YES;
        }
        case TheNoAnimationEffectOfPage:{
            _noAnimationViewController = [[NoAnimationViewController alloc] initWithView:_currentViewController];
            _noAnimationViewController.delegate = self;
            [self.view addSubview:_noAnimationViewController.view];
            return YES;
        }
    }
    return NO;
}
- (BOOL)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    return YES;
}

- (BOOL)setAnimationTypes:(AnimationTypes)animationTypes {
    _animationType = animationTypes;
    return [self updata];
}

- (BOOL)setGestureRecognizerState:(BOOL)gestureRecognizerState {
    _isResponseGestures = gestureRecognizerState;
    [_keepOutViewController setGestureRecognizerState:_isResponseGestures];
    [_slidingViewController setGestureRecognizerState:_isResponseGestures];
    [_noAnimationViewController setGestureRecognizerState:_isResponseGestures];
    return YES;
}

- (void)setViewControllers:(UIViewController *)viewController {
    _currentViewController = viewController;
    switch (_animationType) {
        case TheSimulationEffectOfPage:
        default:{
            [_pageViewController setViewControllers:@[_currentViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL finished) {
                                         }];
            break;
        }
        case TheKeepOutEffectOfPage: {
            _keepOutViewController.currentViewController = _currentViewController;
            break;
        }
        case TheSlidingEffectOfPage: {
            _slidingViewController.currentViewController = _currentViewController;
            break;
        }
        case TheNoAnimationEffectOfPage: {
            _noAnimationViewController.currentViewController = _currentViewController;
        }
    }
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    [self setGestureRecognizerState:NO];
    if ([_delegate respondsToSelector:@selector(pageAnimationViewControllerToViewControllers:)]) {
        [_delegate pageAnimationViewControllerToViewControllers:nil];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self setGestureRecognizerState:YES];
    _isPageAnimation = NO;
    if ([_delegate respondsToSelector:@selector(pageAnimationViewControllerCompleted:)]) {
        [_delegate pageAnimationViewControllerCompleted:completed];
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (!_isResponseGestures) {
        return nil;
    }
    if ([viewController isKindOfClass:_className]) {
        _beforeViewController                   = [_delegate pageAnimationViewControllerBeforeViewController:viewController];
        BackViewController *backViewController  = [[BackViewController alloc] init];
        backViewController.view.backgroundColor = [UIColor colorWithPatternImage:_backgroundImage];
        [backViewController setAlpha:_alpha];
        [backViewController updateWithViewController:(id)_beforeViewController];
        return backViewController;
    } else {
        _isPageAnimation                        = YES;
        return _beforeViewController;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    if (!_isResponseGestures) {
        return nil;
    }
    if ([viewController isKindOfClass:_className]) {
        BackViewController *backViewController  = [[BackViewController alloc] init];
        backViewController.view.backgroundColor = [UIColor colorWithPatternImage:_backgroundImage];
        [backViewController setAlpha:_alpha];
        [backViewController updateWithViewController:(id)viewController];
        return backViewController;
    } else {
        _isPageAnimation                        = YES;
        if ([_delegate respondsToSelector:@selector(pageAnimationViewControllerAfterViewController:)]) {
            return [_delegate pageAnimationViewControllerAfterViewController:viewController];
        } else {
            return nil;
        }
    }
}
#pragma mark - AnimationViewControllerDelegate
- (void)animationViewController:(AnimationViewController *)animationViewController willTransitionToViewControllers:(UIViewController *)pendingViewControllers {
    [self setGestureRecognizerState:NO];
    if ([_delegate respondsToSelector:@selector(pageAnimationViewControllerToViewControllers:)]) {
        [_delegate pageAnimationViewControllerToViewControllers:nil];
    }
}
- (void)animationViewController:(AnimationViewController *)animationViewController didFinishAnimating:(BOOL)finished previousViewControllers:(UIViewController *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self setGestureRecognizerState:YES];
    if ([_delegate respondsToSelector:@selector(pageAnimationViewControllerCompleted:)]) {
        [_delegate pageAnimationViewControllerCompleted:completed];
    }
}
- (UIViewController *)animationViewController:(AnimationViewController *)animationViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([_delegate respondsToSelector:@selector(pageAnimationViewControllerBeforeViewController:)]) {
        return [_delegate pageAnimationViewControllerBeforeViewController:viewController];
    } else {
        return nil;
    }
}
- (UIViewController *)animationViewController:(AnimationViewController *)animationViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([_delegate respondsToSelector:@selector(pageAnimationViewControllerAfterViewController:)]) {
        return [_delegate pageAnimationViewControllerAfterViewController:viewController];
    } else {
        return nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
