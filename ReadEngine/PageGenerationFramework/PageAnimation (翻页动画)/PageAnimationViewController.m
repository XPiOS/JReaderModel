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
    // 是否响应手势
    BOOL                               _isResponseGestures;
    // 翻页方式,默认是仿真
    AnimationTypes                     _animationType;
    // 仿真翻页控制器
    UIPageViewController               *_pageViewController;
    // 覆盖翻页控制器
    KeepOutViewController              *_keepOutViewController;
    // 滑动翻页控制器
    SlidingViewController              *_slidingViewController;
    // 没有动画控制器
    NoAnimationViewController          *_noAnimationViewController;
    // 透明度   默认为0.2
    CGFloat                            _alpha;
    // 用来判断是否绘制背面的类名
    Class                              _className;
    // 当前页
    UIViewController                   *_currentViewController;
    // 上一页
    UIViewController                   *_beforeViewController;
    
    // 背景图
    UIImage                            *_backgroundImage;
    // 改变了翻页数据，是否有翻页动画
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

#pragma mark - 初始化、刷新
- (BOOL)updata {
    if (_pageViewController != nil) {
        [_pageViewController.view removeFromSuperview];
        [_pageViewController removeFromParentViewController];
        _isPageAnimation    = NO;
        _pageViewController = nil;
    }
    if (_keepOutViewController != nil) {
        [_keepOutViewController.view removeFromSuperview];
        [_keepOutViewController removeFromParentViewController];
        _keepOutViewController = nil;
    }
    if (_slidingViewController) {
        [_slidingViewController.view removeFromSuperview];
        [_slidingViewController removeFromParentViewController];
        _slidingViewController = nil;
    }
    if (_noAnimationViewController) {
        [_noAnimationViewController.view removeFromSuperview];
        [_noAnimationViewController removeFromParentViewController];
        _noAnimationViewController = nil;
    }
    switch (_animationType) {
        case TheSimulationEffectOfPage:
        default:{
            // 创建pageViewController控制器
            _pageViewController                      = [[UIPageViewController alloc] init];

            _pageViewController.delegate             = self;
            _pageViewController.dataSource           = self;
            _pageViewController.view.backgroundColor = [UIColor blackColor];
            // 设置为双面
            _pageViewController.doubleSided          = YES;
            // 将控制器添加到当前控制器
            [self addChildViewController:_pageViewController];
            [self.view addSubview:_pageViewController.view];
            // 设置当前显示的页面
            [_pageViewController setViewControllers:@[_currentViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL finished) {
                                         }];
            
            return YES;
        }
        case TheKeepOutEffectOfPage: {
            
            // 创建覆盖控制器
            _keepOutViewController          = [[KeepOutViewController alloc] initWithView:_currentViewController];
            _keepOutViewController.delegate = self;
            // 添加到当前控制器
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

#pragma mark - 对外暴露方法
#pragma mark - 设置透明度
- (BOOL)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    return YES;
}
#pragma mark - 设置翻页方式
- (BOOL)setAnimationTypes:(AnimationTypes)animationTypes {
    _animationType = animationTypes;
    // 刷新
    return [self updata];
}
#pragma mark - 设置是否响应用户手势
- (BOOL)setGestureRecognizerState:(BOOL)gestureRecognizerState {
    _isResponseGestures = gestureRecognizerState;
    [_keepOutViewController setGestureRecognizerState:_isResponseGestures];
    [_slidingViewController setGestureRecognizerState:_isResponseGestures];
    [_noAnimationViewController setGestureRecognizerState:_isResponseGestures];
    return YES;
}
#pragma mark - 从新设置页面控制器
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

#pragma mark - pageViewController代理
#pragma mark 翻页开始
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    // 屏蔽翻页
    [self setGestureRecognizerState:NO];
    
    if ([self.delegate respondsToSelector:@selector(pageAnimationViewControllerToViewControllers:)]) {
        [self.delegate pageAnimationViewControllerToViewControllers:nil];
    }
}

#pragma mark 翻页结束
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    // 启动翻页
    [self setGestureRecognizerState:YES];
    _isPageAnimation = NO;
    if ([self.delegate respondsToSelector:@selector(pageAnimationViewControllerCompleted:)]) {
        [self.delegate pageAnimationViewControllerCompleted:completed];
    }
}
#pragma mark 上一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{

    if (!_isResponseGestures) {
        return nil;
    }
    // 是否是背面
    if ([viewController isKindOfClass:_className]) {
        @try {
            _beforeViewController = [self.delegate pageAnimationViewControllerBeforeViewController:viewController];
            BackViewController *backViewController  = [[BackViewController alloc] init];
            backViewController.view.backgroundColor = [UIColor colorWithPatternImage:_backgroundImage];
            [backViewController setAlpha:_alpha];
            [backViewController updateWithViewController:(id)_beforeViewController];
            return backViewController;
        }
        @catch (NSException *exception) {
            return nil;
        }
    } else {
        _isPageAnimation = YES;
        return _beforeViewController;
    }
}

#pragma mark 下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    if (!_isResponseGestures) {
        return nil;
    }
    // 是否是背面
    if ([viewController isKindOfClass:_className]) {
        @try {
            BackViewController *backViewController  = [[BackViewController alloc] init];
            backViewController.view.backgroundColor = [UIColor colorWithPatternImage:_backgroundImage];
            [backViewController setAlpha:_alpha];
            [backViewController updateWithViewController:(id)viewController];
            return backViewController;
        }
        @catch (NSException *exception) {
            return nil;
        }
    } else {
        _isPageAnimation = YES;
        if ([self.delegate respondsToSelector:@selector(pageAnimationViewControllerAfterViewController:)]) {
            return [self.delegate pageAnimationViewControllerAfterViewController:viewController];
        } else {
            return nil;
        }
    }
}
#pragma mark - AnimationViewController代理
#pragma mark 动画开始
- (void)animationViewController:(AnimationViewController *)animationViewController willTransitionToViewControllers:(UIViewController *)pendingViewControllers {
    // 关闭手势响应
    [self setGestureRecognizerState:NO];
    if ([self.delegate respondsToSelector:@selector(pageAnimationViewControllerToViewControllers:)]) {
        [self.delegate pageAnimationViewControllerToViewControllers:nil];
    }
}
#pragma mark 动画结束
- (void)animationViewController:(AnimationViewController *)animationViewController didFinishAnimating:(BOOL)finished previousViewControllers:(UIViewController *)previousViewControllers transitionCompleted:(BOOL)completed {
    // 开启手势响应
    [self setGestureRecognizerState:YES];
    if ([self.delegate respondsToSelector:@selector(pageAnimationViewControllerCompleted:)]) {
        [self.delegate pageAnimationViewControllerCompleted:completed];
    }
}
#pragma mark 上一页
- (UIViewController *)animationViewController:(AnimationViewController *)animationViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(pageAnimationViewControllerBeforeViewController:)]) {
        return [self.delegate pageAnimationViewControllerBeforeViewController:viewController];
    } else {
        return nil;
    }
}

#pragma mark 下一页
- (UIViewController *)animationViewController:(AnimationViewController *)animationViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(pageAnimationViewControllerAfterViewController:)]) {
        return [self.delegate pageAnimationViewControllerAfterViewController:viewController];
    } else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
