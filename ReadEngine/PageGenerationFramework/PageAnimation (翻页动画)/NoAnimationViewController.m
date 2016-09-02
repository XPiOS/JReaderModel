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

- (void)nextPageSuccessful {
    [self gotoNextPage];
}

- (void)previousPageSuccessful {
    [self gotoPreviousPage];
}

- (void)gotoNextPage {
    self.nextViewController = [self.delegate animationViewController:self viewControllerAfterViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [self.view bringSubviewToFront:self.currentViewController.view];
    [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
    [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController         = nil;
    self.currentViewController         = self.nextViewController;
    self.nextViewController            = nil;
}

- (void)gotoPreviousPage {
    self.nextViewController = [self.delegate animationViewController:self viewControllerBeforeViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
    [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController         = nil;
    self.currentViewController         = self.nextViewController;
    self.nextViewController            = nil;
}

@end
