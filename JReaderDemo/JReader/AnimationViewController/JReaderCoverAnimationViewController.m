//
//  JReaderCoverAnimationViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/15.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderCoverAnimationViewController.h"

@interface JReaderCoverAnimationViewController ()

@end

@implementation JReaderCoverAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击手势
#pragma mark 跳转到下一页
- (void)gotoNextPage {
    [super gotoNextPage];
    
    if (self.nextViewController) {
        // 动画开始
        if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:)]) {
            [self.delegate jReaderBaseAnimationViewController:self];
        }
        
        self.nextViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
        [UIView animateWithDuration:JREADER_ANIMATION_TIME animations:^{
            self.currentViewController.view.frame = CGRectMake(-JREADER_SCREEN_WIDTH, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            // 动画结束
            if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:finished];
            }
            if (finished) {
                [self.currentViewController removeFromParentViewController];
                [self.currentViewController.view removeFromSuperview];
                self.currentViewController = self.nextViewController;
                self.nextViewController = nil;
            } else {
                self.currentViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                [self.nextViewController.view removeFromSuperview];
                [self.nextViewController removeFromParentViewController];
                self.nextViewController = nil;
            }
        }];
    }
}
#pragma mark 跳转到上一页
- (void)gotoPreviousPage {
    [super gotoPreviousPage];
    if (self.nextViewController) {
        // 动画开始
        if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:)]) {
            [self.delegate jReaderBaseAnimationViewController:self];
        }
        [self.view bringSubviewToFront:self.nextViewController.view];
        self.nextViewController.view.frame = CGRectMake(-JREADER_SCREEN_WIDTH, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
        [UIView animateWithDuration:JREADER_ANIMATION_TIME animations:^{
            self.nextViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            // 动画结束
            if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:finished];
            }
            if (finished) {
                [self.currentViewController removeFromParentViewController];
                [self.currentViewController.view removeFromSuperview];
                self.currentViewController = self.nextViewController;
                self.nextViewController = nil;
            } else {
                self.currentViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                [self.nextViewController.view removeFromSuperview];
                [self.nextViewController removeFromParentViewController];
                self.nextViewController = nil;
            }
        }];
    }
}

#pragma mark - 拖动手势
#pragma mark 拖动开始
- (void)panGesBegan: (CGFloat)pointX {
    [super panGesBegan:pointX];
    if (self.nextViewController) {
        // 动画开始
        if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:)]) {
            [self.delegate jReaderBaseAnimationViewController:self];
        }
        if (self.isLeftPan) {
            self.nextViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
        } else {
            [self.view bringSubviewToFront:self.nextViewController.view];
            self.nextViewController.view.frame = CGRectMake((self.panGesRecBeganX - JREADER_SCREEN_WIDTH), 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
        }
    }
}
#pragma mark 拖动过程中
- (void)panGesChanged: (CGFloat)pointX {
    [super panGesChanged:pointX];
    if (self.isLeftPan) {
        self.currentViewController.view.frame = CGRectMake(pointX > 0 ? 0 : pointX, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
    } else {
        self.nextViewController.view.frame = CGRectMake((self.panGesRecBeganX + pointX - JREADER_SCREEN_WIDTH), 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
    }
}
#pragma mark 拖动结束
- (void)panGesEnded: (CGFloat)pointX {
    [super panGesEnded:pointX];
    if (self.nextViewController) {
        if (self.isLeftPan) {
            if (self.panGesRecMax >= pointX) {
                [UIView animateWithDuration:JREADER_ANIMATION_TIME animations:^{
                    self.currentViewController.view.frame = CGRectMake(-JREADER_SCREEN_WIDTH, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    // 动画结束
                    if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                        [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:finished];
                    }
                    if (finished) {
                        [self.currentViewController removeFromParentViewController];
                        [self.currentViewController.view removeFromSuperview];
                        self.currentViewController = self.nextViewController;
                        self.nextViewController = nil;
                    } else {
                        self.currentViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                        [self.nextViewController.view removeFromSuperview];
                        [self.nextViewController removeFromParentViewController];
                        self.nextViewController = nil;
                    }
                }];
            } else {
                [UIView animateWithDuration:JREADER_ANIMATION_TIME animations:^{
                    self.currentViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    // 动画结束
                    if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                        [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:NO];
                    }
                    self.currentViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                    [self.nextViewController.view removeFromSuperview];
                    [self.nextViewController removeFromParentViewController];
                    self.nextViewController = nil;
                }];
            }
        } else {
            if (self.panGesRecMax <= pointX) {
                [UIView animateWithDuration:JREADER_ANIMATION_TIME animations:^{
                    self.nextViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    // 动画结束
                    if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                        [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:finished];
                    }
                    if (finished) {
                        [self.currentViewController removeFromParentViewController];
                        [self.currentViewController.view removeFromSuperview];
                        self.currentViewController = self.nextViewController;
                        self.nextViewController = nil;
                    } else {
                        self.currentViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                        [self.nextViewController.view removeFromSuperview];
                        [self.nextViewController removeFromParentViewController];
                        self.nextViewController = nil;
                    }
                }];

            } else {
                [UIView animateWithDuration:JREADER_ANIMATION_TIME animations:^{
                    self.nextViewController.view.frame = CGRectMake(-JREADER_SCREEN_WIDTH, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    // 动画结束
                    if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                        [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:NO];
                    }
                    self.currentViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
                    [self.nextViewController.view removeFromSuperview];
                    [self.nextViewController removeFromParentViewController];
                    self.nextViewController = nil;
                }];
            }
        }
    }
}

@end
