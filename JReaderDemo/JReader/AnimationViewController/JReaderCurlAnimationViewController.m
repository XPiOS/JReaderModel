//
//  JReaderCurlAnimationViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/15.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderCurlAnimationViewController.h"
#import "JReaderViewController.h"
#import "JReaderBackViewController.h"

@interface JReaderCurlAnimationViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation JReaderCurlAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pageViewController setViewControllers:@[self.currentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 父类方法
- (void)jumpViewController:(UIViewController *)viewController {
    self.currentViewController = viewController;
    JReaderViewController *readerVC1 = (JReaderViewController *)self.currentViewController;
    JReaderViewController *readerVC2 = (JReaderViewController *)[self pageViewController:self.pageViewController viewControllerBeforeViewController:readerVC1];
    if (readerVC1 && readerVC2) {
        [self.pageViewController setViewControllers:@[readerVC1] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
        }];
    }
}
- (void)gotoPreviousPage {
    JReaderViewController *readerVC1 = self.pageViewController.viewControllers.lastObject;
    JReaderViewController *readerVC2 = (JReaderViewController *)[self pageViewController:self.pageViewController viewControllerBeforeViewController:readerVC1];
    JReaderViewController *readerVC3 = (JReaderViewController *)[self pageViewController:self.pageViewController viewControllerBeforeViewController:readerVC2];
    JReaderBackViewController *readerVC4 = [[JReaderBackViewController alloc] initWithViewController:readerVC3];
    if (readerVC1 && readerVC2 &&readerVC3 && readerVC4) {
        [self.pageViewController setViewControllers:@[readerVC3, readerVC4] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        }];
    }
}
#pragma mark 跳转到下一页
- (void)gotoNextPage {
    JReaderViewController *readerVC1 = self.pageViewController.viewControllers.lastObject;
    JReaderViewController *readerVC2 = (JReaderViewController *)[self pageViewController:self.pageViewController viewControllerAfterViewController:readerVC1];
    JReaderViewController *readerVC3 = (JReaderViewController *)[self pageViewController:self.pageViewController viewControllerAfterViewController:readerVC2];
    JReaderBackViewController *readerVC4 = [[JReaderBackViewController alloc] initWithViewController:readerVC3];
    if (readerVC1 && readerVC2 &&readerVC3 && readerVC4) {
        [self.pageViewController setViewControllers:@[readerVC3, readerVC4] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:)]) {
        [self.delegate jReaderBaseAnimationViewController:self];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentViewController = self.nextViewController;
    }
    if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
        [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:finished transitionCompleted:completed];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[JReaderViewController class]]) {
        return [[JReaderBackViewController alloc] initWithViewController:viewController];
    } else {
        if ([self.dataSource respondsToSelector:@selector(jReaderBaseAnimationViewController:viewControllerBeforeViewController:)]) {
            self.nextViewController = [self.dataSource jReaderBaseAnimationViewController:self viewControllerBeforeViewController:self.currentViewController];
            return self.nextViewController;
        }
        return nil;
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[JReaderViewController class]]) {
        return [[JReaderBackViewController alloc] initWithViewController:viewController];
    } else {
        if ([self.dataSource respondsToSelector:@selector(jReaderBaseAnimationViewController:viewControllerAfterViewController:)]) {
            self.nextViewController = [self.dataSource jReaderBaseAnimationViewController:self viewControllerAfterViewController:self.currentViewController];
            return self.nextViewController;
        }
        return nil;
    }
}

#pragma mark - get/set
- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionSpineLocationKey:@10}];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.view.backgroundColor = [UIColor clearColor];
        _pageViewController.doubleSided = YES;
    }
    return _pageViewController;
}

@end
