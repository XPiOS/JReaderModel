//
//  JReaderNoneAnimationViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/14.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderNoneAnimationViewController.h"

@interface JReaderNoneAnimationViewController ()

@end

@implementation JReaderNoneAnimationViewController

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
        [self.currentViewController removeFromParentViewController];
        [self.currentViewController.view removeFromSuperview];
        self.currentViewController = self.nextViewController;
        self.nextViewController = nil;
        // 动画结束
        if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
            [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:YES];
        }
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
        self.nextViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
        [self.currentViewController removeFromParentViewController];
        [self.currentViewController.view removeFromSuperview];
        self.currentViewController = self.nextViewController;
        self.nextViewController = nil;
    }
    // 动画结束
    if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
        [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:YES];
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
        self.nextViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
    }
}
#pragma mark 拖动过程中
- (void)panGesChanged: (CGFloat)pointX {
    [super panGesChanged:pointX];
}
#pragma mark 拖动结束
- (void)panGesEnded: (CGFloat)pointX {
    [super panGesEnded:pointX];
    if (self.nextViewController) {
        if (self.isLeftPan) {
            if (self.panGesRecMax >= pointX) {
                // 动画结束
                if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                    [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:YES];
                }
                [self.currentViewController removeFromParentViewController];
                [self.currentViewController.view removeFromSuperview];
                self.currentViewController = self.nextViewController;
                self.nextViewController = nil;
            } else {
                // 动画结束
                if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                    [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:NO];
                }
                [self.nextViewController.view removeFromSuperview];
                [self.nextViewController removeFromParentViewController];
                self.nextViewController = nil;
            }
        } else {
            if (self.panGesRecMax <= pointX) {
                // 动画结束
                if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                    [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:YES];
                }
                [self.currentViewController removeFromParentViewController];
                [self.currentViewController.view removeFromSuperview];
                self.currentViewController = self.nextViewController;
                self.nextViewController = nil;
            } else {
                // 动画结束
                if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
                    [self.delegate jReaderBaseAnimationViewController:self didFinishAnimating:YES transitionCompleted:NO];
                }
                [self.nextViewController.view removeFromSuperview];
                [self.nextViewController removeFromParentViewController];
                self.nextViewController = nil;
            }
        }
    }
}
@end
