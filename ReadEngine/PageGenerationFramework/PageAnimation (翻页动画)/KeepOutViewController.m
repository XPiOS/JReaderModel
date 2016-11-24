//
//  KeepOutViewController.m
//  zwsc
//
//  Created by XuPeng on 16/3/2.
//  Copyright © 2016年 中文万维. All rights reserved.
//

#import "KeepOutViewController.h"


@implementation KeepOutViewController

#pragma mark - 拖动后，后翻成功
- (void)nextPageSuccessful {
    // 翻页成功 当前页移除
    // 将当前页移动到最右侧,并将当前ViewController指向下一个ViewController
    
    if (self.nextViewController == nil) {
        return;
    }
    
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
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
    
    // 当前视图返回到屏幕中央，并且移除self.nextViewController,并通知翻页失败
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        
        self.currentViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
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
    // 将self.nextViewController 移动到屏幕中间，并且将self.currentViewController 移除，并指向self.nextViewController
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
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
    // 将self.nextViewController 移动到最左侧，并且将self.nextViewController 移除
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        
        self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
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
    self.nextViewController = [self get_previousViewController];
    
    if (self.nextViewController == nil) {
        return;
    }
    
    // 2、设置下一个视图位置
    self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    // 3、添加下一个视图到当前视图
    [self.view addSubview:self.nextViewController.view];
    // 4、设置视图要移动的位置
    CGRect rect                        = CGRectMake(-kScreenWidth + changeValue, 0, kScreenWidth, kScreenHeight);
    // 5、动画方式移动到手指点击位置
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.nextViewController.view.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 拖动中，第一次拖动，后翻
- (void)dragForTheFirstTimeNextPage:(CGFloat)changeValue {
    
    // 去下一页
    // 1、获取下一页的ViewController
    self.nextViewController = [self get_nextViewController];
    
    if (self.nextViewController == nil) {
        return;
    }
    // 2、设置下一个视图的位置
    self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    // 3、添加下一个视图到当前视图
    [self.view addSubview:self.nextViewController.view];
    [self.view bringSubviewToFront:self.currentViewController.view];
    // 4、设置当前视图的移动位置
    CGRect rect                           = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    rect.origin.x                         = rect.origin.x + (changeValue);
    // 5、移动当前视图到这个位置
    self.currentViewController.view.frame = rect;
}
#pragma mark - 正常拖动，后翻
- (void)dragChangeNextPage:(CGFloat)changeValue {
    if (self.nextViewController == nil) {
        return;
    }
    // 翻到下一页的，视图的右侧顶点不在手指位置，操作的是self.currentViewController
    CGRect rect   = self.currentViewController.view.frame;
    // 当前的位置减去上次的位置，为改变的大小
    rect.origin.x = rect.origin.x + changeValue;

    // 如果拖动到右侧了，则设置X为0
    if (rect.origin.x >= 0) {
        rect.origin.x = 0;
    }
    
    // 当前页随手指的移动改变位置
    self.currentViewController.view.frame = rect;
}
#pragma mark - 正常拖动，前翻
- (void)dragChangePreviousPage:(CGFloat)changeValue {
    if (self.nextViewController == nil) {
        return;
    }
    // 如果是翻到上一页的，视图的右侧顶点应该快速滑动到手指位置，操作的是self.nextViewController
    CGRect rect                        = CGRectMake(-kScreenWidth + changeValue, 0, kScreenWidth, kScreenHeight);
    self.nextViewController.view.frame = rect;
}
#pragma mark - 点击跳转到下一页
- (void)gotoNextPage {
    
    // 1.获取下一页
    self.nextViewController = [self get_nextViewController];
    
    if (self.nextViewController == nil) {
        return;
    }
    // 2.将下一页添加到当前视图
    self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [self.view bringSubviewToFront:self.currentViewController.view];
    // 3.缓慢移走当前视图
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 调用动画开始
        [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
        self.currentViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        // 调用动画结束
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
    self.nextViewController = [self get_previousViewController];
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
        
        self.nextViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = nil;
        
        self.currentViewController = self.nextViewController;
        self.nextViewController    = nil;
    }];
}


#pragma mark - 获取下一页
- (UIViewController *)get_nextViewController {
    UIViewController *viewController        = [self.delegate animationViewController:self viewControllerAfterViewController:self.currentViewController];
    // 给当前页加阴影
    // 阴影颜色为黑色
    self.currentViewController.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    // 阴影偏移量
    self.currentViewController.view.layer.shadowOffset  = CGSizeMake(10, 10);
    // 阴影透明度
    self.currentViewController.view.layer.shadowOpacity = 0.5;

    return viewController;
}

#pragma mark - 获取上一页
- (UIViewController *)get_previousViewController {
    UIViewController *viewController = [self.delegate animationViewController:self viewControllerBeforeViewController:self.currentViewController];
    // 阴影颜色为黑色
    viewController.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    // 阴影偏移量
    viewController.view.layer.shadowOffset  = CGSizeMake(10, 10);
    // 阴影透明度
    viewController.view.layer.shadowOpacity = 0.5;
    return viewController;
}
@end
