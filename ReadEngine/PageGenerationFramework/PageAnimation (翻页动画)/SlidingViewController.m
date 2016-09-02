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


- (void)dragForTheFirstTimeNextPage:(CGFloat)changeValue {
    self.nextViewController               = [self.delegate animationViewController:self viewControllerAfterViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame    = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    CGRect currentRect                    = CGRectMake(changeValue, 0, kScreenWidth, kScreenHeight);
    CGRect nextRect                       = CGRectMake(currentRect.origin.x + currentRect.size.width, 0, kScreenWidth, kScreenHeight);
    self.currentViewController.view.frame = currentRect;
    self.nextViewController.view.frame    = nextRect;
}
- (void)dragChangeNextPage:(CGFloat)changeValue {
    if (self.nextViewController == nil) {
        return;
    }
    CGRect currentRect   = self.currentViewController.view.frame;
    currentRect.origin.x = currentRect.origin.x + changeValue;
    if (currentRect.origin.x > 0) {
        currentRect.origin.x = 0;
    }
    CGRect nextRect                       = currentRect;
    nextRect.origin.x                     = currentRect.origin.x + currentRect.size.width;
    self.currentViewController.view.frame = currentRect;
    self.nextViewController.view.frame    = nextRect;
}

- (void)nextPageSuccessful {
    if (self.nextViewController == nil) {
        return;
    }
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        [self.currentViewController.view removeFromSuperview];
        self.currentViewController            = nil;
        self.currentViewController            = self.nextViewController;
        self.nextViewController               = nil;
    }];
}

- (void)nextPageFailure {
    if (self.nextViewController == nil) {
        return;
    }
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
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
        self.currentViewController.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        [self.currentViewController.view removeFromSuperview];
        self.currentViewController            = nil;
        self.currentViewController            = self.nextViewController;
        self.nextViewController               = nil;
    }];
}

- (void)previousPageFailure {
    if (self.nextViewController == nil) {
        return;
    }
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.nextViewController];
        self.currentViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:NO];
        [self.nextViewController.view removeFromSuperview];
        self.nextViewController               = nil;
    }];
}
- (void)dragForTheFirstTimePreviousPage:(CGFloat)changeValue {
    self.nextViewController = [self.delegate animationViewController:self viewControllerBeforeViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    CGRect nextRect                    = CGRectMake(-kScreenWidth + changeValue, 0, kScreenWidth, kScreenHeight);
    CGRect currentRect                 = CGRectMake(nextRect.origin.x + nextRect.size.width, 0, kScreenWidth, kScreenHeight);
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.nextViewController.view.frame    = nextRect;
        self.currentViewController.view.frame = currentRect;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dragChangePreviousPage:(CGFloat)changeValue {
    if (self.nextViewController == nil) {
        return;
    }
    CGRect nextRect                       = CGRectMake(-kScreenWidth + changeValue, 0, kScreenWidth, kScreenHeight);
    CGRect currentRect                    = nextRect;
    currentRect.origin.x                  = nextRect.origin.x + nextRect.size.width;
    self.nextViewController.view.frame    = nextRect;
    self.currentViewController.view.frame = currentRect;
}
- (void)gotoNextPage {
    self.nextViewController = [self.delegate animationViewController:self viewControllerAfterViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [self.view bringSubviewToFront:self.currentViewController.view];
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
        self.currentViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController            = nil;
        self.currentViewController            = self.nextViewController;
        self.nextViewController               = nil;
    }];
}
- (void)gotoPreviousPage {
    self.nextViewController = [self.delegate animationViewController:self viewControllerBeforeViewController:self.currentViewController];
    if (self.nextViewController == nil) {
        return;
    }
    self.nextViewController.view.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.nextViewController.view];
    [UIView animateWithDuration:AnimationViewControllerTime delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.delegate animationViewController:self willTransitionToViewControllers:self.currentViewController];
        self.currentViewController.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.nextViewController.view.frame    = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.delegate animationViewController:self didFinishAnimating:YES previousViewControllers:self.currentViewController transitionCompleted:YES];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController            = nil;
        self.currentViewController            = self.nextViewController;
        self.nextViewController               = nil;
    }];
}

@end
