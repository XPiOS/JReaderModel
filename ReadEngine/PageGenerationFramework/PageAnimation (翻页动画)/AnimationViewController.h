//
//  AnimationViewController.h
//  zwsc
//
//  Created by XuPeng on 16/3/5.
//  Copyright © 2016年 中文万维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnimationViewController;

// 全局变量
#define kScreenWidth                     ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight                    ([[UIScreen mainScreen] bounds].size.height)
#define AnimationViewControllerTime      0.4f

@protocol AnimationViewControllerDelegate <NSObject>

/**
 *  动画开始
 *
 *  @param animationViewController 当前控制器
 *  @param pendingViewControllers  将要展示内容的控制器
 */
- (void)animationViewController:(AnimationViewController *)animationViewController willTransitionToViewControllers:(UIViewController*)pendingViewControllers;

/**
 *  动画结束
 *
 *  @param animationViewController 当前控制器
 *  @param finished                动画是否完成
 *  @param previousViewControllers 前一个控制器
 *  @param completed               翻页是否成功
 */
- (void)animationViewController:(AnimationViewController *)animationViewController didFinishAnimating:(BOOL)finished previousViewControllers:(UIViewController *)previousViewControllers transitionCompleted:(BOOL)completed;

/**
 *  获得向前翻展示的控制器
 *
 *  @param animationViewController 当前的控制器
 *  @param viewController          当前用来展示视图的控制器
 *
 *  @return 前翻展示控制器
 */
- (UIViewController *)animationViewController:(AnimationViewController *)animationViewController viewControllerBeforeViewController:(UIViewController *)viewController;

/**
 *  获得向后翻的展示控制器
 *
 *  @param animationViewController 当前的控制器
 *  @param viewController          当前用来展示视图的控制器
 *
 *  @return 后翻展示控制器
 */
- (UIViewController *)animationViewController:(AnimationViewController*)animationViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end


@interface AnimationViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<AnimationViewControllerDelegate> delegate;

// 当前页
@property (nonatomic, retain) UIViewController *currentViewController;
// 下一页
@property (nonatomic, retain) UIViewController *nextViewController;


- (instancetype)initWithView:(UIViewController *)viewController;

/**
 *  是否响应用户手势
 *
 *  @param gestureRecognizerState 是或否
 *
 *  @return 是否成功
 */
- (BOOL)setGestureRecognizerState:(BOOL)gestureRecognizerState;

/**
 *  点击手势前翻
 */
- (void)gotoPreviousPage;
/**
 *  点击手势后翻
 */
- (void)gotoNextPage;

/**
 *  拖动后，后翻成功
 */
- (void)nextPageSuccessful;
/**
 *  拖动后，后翻失败
 */
- (void)nextPageFailure;

/**
 *  拖动后，前翻成功
 */
- (void)previousPageSuccessful;
/**
 *  拖动后，前翻失败
 */
- (void)previousPageFailure;
/**
 *  第一次拖动，向前翻
 */
- (void)dragForTheFirstTimePreviousPage:(CGFloat)changeValue;
/**
 *  第一次拖动，向后翻
 */
- (void)dragForTheFirstTimeNextPage:(CGFloat)changeValue;
/**
 *  正常拖动，前翻
 */
- (void)dragChangePreviousPage:(CGFloat)changeValue;
/**
 *  正常拖动中，后翻
 */
- (void)dragChangeNextPage:(CGFloat)changeValue;

@end
