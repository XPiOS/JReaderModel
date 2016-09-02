//
//  KeepOutViewController.m
//  zwsc
//
//  Created by XuPeng on 16/3/2.
//  Copyright © 2016年 中文万维. All rights reserved.
//

#import "KeepOutViewController.h"


@implementation KeepOutViewController

- (void)nextPageSuccessful {
    if (self.nextViewController == nil) {
        return;
    }
    
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        [self.currentViewController.view removeFromSuperview];
        self.currentViewController = nil;
        self.currentViewController = self.nextViewController;
        self.nextViewController    = nil;
    }];
}
- (void)nextPageFailure {
    if (self.nextViewController == nil) {
        return;
    }
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:NO];
        [self.nextViewController.view removeFromSuperview];
        self.nextViewController               = nil;
    }];
    
}
- (void)previousPageSuccessful {
    if (self.nextViewController == nil) {
        return;
    }
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.nextViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        if (self.delegate) {
            [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        }
        [self.currentViewController.view removeFromSuperview];
        self.currentViewController         = nil;
        self.currentViewController         = self.nextViewController;
        self.nextViewController            = nil;
    }];
}
- (void)previousPageFailure {
    if (self.nextViewController == nil) {
        return;
    }
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:NO];
        [self.nextViewController.view removeFromSuperview];
        self.nextViewController            = nil;
    }];
}
- (void)dragForTheFirstTimePreviousPage:(CGFloat)changeValue {
    self.nextViewController = [self get_previousViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    CGRect rect                        = CGRectMake(-kScreenWidth + changeValue, 0, kScreenWidth, kScreenHeight);
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.nextViewController.view.frame = rect;
    } completion:^(BOOL finished) {
    }];
}
- (void)dragForTheFirstTimeNextPage:(CGFloat)changeValue {
    self.nextViewController = [self get_nextViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [self.view bringSubviewToFront:self.currentViewController.view];
    CGRect rect                           = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    rect.origin.x                         = rect.origin.x + (changeValue);
    self.currentViewController.view.frame = rect;
}
- (void)dragChangeNextPage:(CGFloat)changeValue {
    if (self.nextViewController == nil) {
        return;
    }
    CGRect rect                           = self.currentViewController.view.frame;
    rect.origin.x                         = rect.origin.x + changeValue;
    if (rect.origin.x >= 0) {
        rect.origin.x = 0;
    }
    self.currentViewController.view.frame = rect;
}
- (void)dragChangePreviousPage:(CGFloat)changeValue {
    if (self.nextViewController == nil) {
        return;
    }
    CGRect rect                        = CGRectMake(-kScreenWidth + changeValue, 0, kScreenWidth, kScreenHeight);
    self.nextViewController.view.frame = rect;
}
- (void)gotoNextPage {
    self.nextViewController = [self get_nextViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [self.view bringSubviewToFront:self.currentViewController.view];
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
        self.currentViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        if (self.delegate != nil) {
            [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        }
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = nil;
        self.currentViewController = self.nextViewController;
        self.nextViewController    = nil;
    }];
}
- (void)gotoPreviousPage {
    self.nextViewController = [self get_previousViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
        self.nextViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        if (self.delegate) {
            [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        }
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = nil;
        self.currentViewController = self.nextViewController;
        self.nextViewController    = nil;
    }];
}
- (UIViewController *)get_nextViewController {
    UIViewController *viewController        = [self.delegate animationViewController:self viewControllerAfterViewController:self.currentViewController];
    self.currentViewController.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.currentViewController.view.layer.shadowOffset  = CGSizeMake(10, 10);
    self.currentViewController.view.layer.shadowOpacity = 0.5;
    return viewController;
}
- (UIViewController *)get_previousViewController {
    UIViewController *viewController        = [self.delegate animationViewController:self viewControllerBeforeViewController:self.currentViewController];
    viewController.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    viewController.view.layer.shadowOffset  = CGSizeMake(10, 10);
    viewController.view.layer.shadowOpacity = 0.5;
    return viewController;
}
@end
