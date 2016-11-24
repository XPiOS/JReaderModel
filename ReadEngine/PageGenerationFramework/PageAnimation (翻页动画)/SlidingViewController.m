//
//  SlidingViewController.m
//  zwsc
//
//  Created by XuPeng on 16/3/5.
//  Copyright © 2016年 中文万维. All rights reserved.
//

#import "SlidingViewController.h"

@interface SlidingViewController ()

@end

@implementation SlidingViewController

/**
 *  重写实现父类的几个方法
 */
#pragma mark - 拖动中，第一次拖动，后翻
- (void)dragForTheFirstTimeNextPage:(CGFloat)changeValue {
    
    // 去下一页
    // 1、获取下一页的ViewController
    self.nextViewController               = [self.delegate animationViewController:self viewControllerAfterViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    // 2、设置下一个视图的位置
    self.nextViewController.view.frame    = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    // 3、添加下一个视图到当前视图
    [self.view addSubview:self.nextViewController.view];
    // 4、设置当前视图的移动位置
    CGRect currentRect                    = CGRectMake(changeValue, 0, kScreenWidth, kScreenHeight);
    CGRect nextRect                       = CGRectMake(currentRect.origin.x + currentRect.size.width, 0, kScreenWidth, kScreenHeight);

    // 5、移动当前视图到这个位置
    self.currentViewController.view.frame = currentRect;
    self.nextViewController.view.frame    = nextRect;
}
#pragma mark - 正常拖动，后翻
- (void)dragChangeNextPage:(CGFloat)changeValue {
    if (self.nextViewController == nil) {
        return;
    }
    // 翻到下一页的，视图的右侧顶点不在手指位置，操作的是self.currentViewController
    CGRect currentRect   = self.currentViewController.view.frame;
    // 当前的位置减去上次的位置，为改变的大小
    currentRect.origin.x = currentRect.origin.x + changeValue;
    
    if (currentRect.origin.x > 0) {
        currentRect.origin.x = 0;
    }
    CGRect nextRect                       = currentRect;
    nextRect.origin.x                     = currentRect.origin.x + currentRect.size.width;
    // 当前页随手指的移动改变位置
    self.currentViewController.view.frame = currentRect;
    self.nextViewController.view.frame    = nextRect;
}

#pragma mark - 拖动后，后翻成功
- (void)nextPageSuccessful {
    if (self.nextViewController == nil) {
        return;
    }
    // 翻页成功 当前页移除
    // 将当前控制器移到最左面，下一个控制器移动到屏幕中间
    
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        // 动画结束，翻页成功
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];

        [self.currentViewController.view removeFromSuperview];
        self.currentViewController = nil;
        self.currentViewController = self.nextViewController;
        self.nextViewController    = nil;
    }];
}

#pragma mark - 拖动后，后翻失败
- (void)nextPageFailure {
    if (self.nextViewController == nil) {
        return;
    }
    // 当前视图返回到屏幕中央，下一个控制器视图移动到屏幕最右侧,并且移除self.nextViewController,并通知翻页失败
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        
        self.currentViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        // 动画结束，翻页失败
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:NO];
        
        [self.nextViewController.view removeFromSuperview];
        self.nextViewController = nil;
    }];
}

#pragma mark - 拖动后，前翻成功
- (void)previousPageSuccessful {
    if (self.nextViewController == nil) {
        return;
    }
    // 翻页成功 当前页移除
    // 当前视图移动到屏幕右侧，下一个视图移动到屏幕中央
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        // 动画结束，翻页成功
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];

        [self.currentViewController.view removeFromSuperview];
        self.currentViewController = nil;
        self.currentViewController = self.nextViewController;
        self.nextViewController    = nil;
    }];
}

#pragma mark - 拖动后，前翻失败
- (void)previousPageFailure {
    if (self.nextViewController == nil) {
        return;
    }
    // 当前控制器返回屏幕中央，下一个控制器移动到屏幕左面
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        // 动画结束，翻页失败
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:NO];
        
        [self.nextViewController.view removeFromSuperview];
        self.nextViewController = nil;
    }];
}

#pragma mark - 拖动中，第一次拖动，前翻
- (void)dragForTheFirstTimePreviousPage:(CGFloat)changeValue {
    // 去上一页
    // 1. 获取上一页ViewController
    self.nextViewController = [self.delegate animationViewController:self viewControllerBeforeViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    // 2、设置下一个视图位置
    self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    // 3、添加下一个视图到当前视图
    [self.view addSubview:self.nextViewController.view];
    // 4、设置视图要移动的位置
    CGRect nextRect    = CGRectMake(-kScreenWidth + changeValue, 0, kScreenWidth, kScreenHeight);
    CGRect currentRect = CGRectMake(nextRect.origin.x + nextRect.size.width, 0, kScreenWidth, kScreenHeight);
    // 5、动画方式移动到手指点击位置
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 下一个视图移动到手指位置，当前控制器移动到下一个控制器的右侧
        self.nextViewController.view.frame    = nextRect;
        self.currentViewController.view.frame = currentRect;
        
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 正常拖动，前翻
- (void)dragChangePreviousPage:(CGFloat)changeValue {
    if (self.nextViewController == nil) {
        return;
    }
    // 如果是翻到上一页的，视图的右侧顶点应该快速滑动到手指位置，操作的是self.nextViewController
    CGRect nextRect                       = CGRectMake(-kScreenWidth + changeValue, 0, kScreenWidth, kScreenHeight);
    CGRect currentRect                    = nextRect;
    currentRect.origin.x                  = nextRect.origin.x + nextRect.size.width;

    self.nextViewController.view.frame    = nextRect;
    self.currentViewController.view.frame = currentRect;
}

#pragma mark - 点击跳转到下一页
- (void)gotoNextPage {
    // 1.获取下一页
    self.nextViewController = [self.delegate animationViewController:self viewControllerAfterViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    // 2.将下一页添加到当前视图
    self.nextViewController.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [self.view bringSubviewToFront:self.currentViewController.view];
    // 3.缓慢移走当前视图
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];

        self.currentViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
    } completion:^(BOOL finished) {
        // 动画结束
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        
        // 将当前视图移除，然后指向屏幕中间的视图
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = nil;

        self.currentViewController = self.nextViewController;
        self.nextViewController    = nil;
    }];
}
#pragma mark - 点击跳转到上一页
- (void)gotoPreviousPage {
    // 1.获取下一个视图
    self.nextViewController = [self.delegate animationViewController:self viewControllerBeforeViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    // 2.将下一个视图添加到当前视图
    self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    
    // 3.下一个视图移动到屏幕中间，移除当前页视图，然后当前页视图指向下一个视图
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
        self.currentViewController.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        // 动画结束
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = nil;

        self.currentViewController = self.nextViewController;
        self.nextViewController    = nil;
    }];
}

@end
