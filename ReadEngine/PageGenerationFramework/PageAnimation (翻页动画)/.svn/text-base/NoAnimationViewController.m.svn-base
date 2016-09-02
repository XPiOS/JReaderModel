//
//  NoAnimationViewController.m
//  创新版
//
//  Created by XuPeng on 16/6/1.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "NoAnimationViewController.h"

@interface NoAnimationViewController ()

@end

@implementation NoAnimationViewController
/**
 *  重写实现父类的几个方法
 */
#pragma mark - 拖动后，后翻成功
- (void)nextPageSuccessful {
    [self gotoNextPage];
}
#pragma mark - 拖动后，前翻成功
- (void)previousPageSuccessful {
    [self gotoPreviousPage];
}
#pragma mark - 点击跳转到下一页
- (void)gotoNextPage {
    // 1.获取下一页
    self.nextViewController = [self.delegate animationViewController:self viewControllerAfterViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    // 2.将下一页添加到当前视图
    self.nextViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [self.view bringSubviewToFront:self.currentViewController.view];
    // 动画开始
    [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
    // 动画结束
    [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
    
    // 将当前视图移除，然后指向屏幕中间的视图
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = nil;
    
    self.currentViewController = self.nextViewController;
    self.nextViewController    = nil;
}
#pragma mark - 点击跳转到上一页
- (void)gotoPreviousPage {
    // 1.获取下一个视图
    self.nextViewController = [self.delegate animationViewController:self viewControllerBeforeViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    // 2.将下一个视图添加到当前视图
    self.nextViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    
    // 动画开始
    [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
    // 动画结束
    [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
    
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = nil;
    
    self.currentViewController = self.nextViewController;
    self.nextViewController    = nil;
}

@end
