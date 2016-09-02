//
//  PageAnimationViewController.h
//  zwsc
//
//  Created by XuPeng on 16/3/2.
//  Copyright © 2016年 中文万维. All rights reserved.
//  覆盖翻页

#import <UIKit/UIKit.h>
#import "AnimationViewController.h"

@class PageAnimationViewController;

@protocol PageAnimationViewControllerDelegate <NSObject>

/**
 *  获得向前翻的控制器
 *
 *  @param viewController              当前用来展示视图的控制器
 *
 *  @return 前翻的控制器
 */
- (UIViewController *)pageAnimationViewControllerBeforeViewController:(UIViewController *)viewController;;

/**
 *  获得向后翻的控制器
 *
 *  @param viewController              当前用来展示视图的控制器
 *
 *  @return 后翻的控制器
 */
- (UIViewController *)pageAnimationViewControllerAfterViewController:(UIViewController *)viewController;

/**
 *  动画开始
 *
 *  @param pendingViewControllers      将要展示内容的控制器
 */
- (void)pageAnimationViewControllerToViewControllers:(UIViewController *)pendingViewControllers;

/**
 *  动画结束
 *
 *  @param completed 翻页是否成功
 */
- (void)pageAnimationViewControllerCompleted:(BOOL)completed;

@end

@interface PageAnimationViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,AnimationViewControllerDelegate>

// 动画样式
typedef NS_ENUM(NSInteger, AnimationTypes) {
    TheSimulationEffectOfPage  = 0,// 仿真翻页
    TheKeepOutEffectOfPage     = 1,// 覆盖翻页
    TheSlidingEffectOfPage     = 2,// 滑动页面
    TheNoAnimationEffectOfPage = 3 // 没有动画
};

@property (nonatomic, assign) id<PageAnimationViewControllerDelegate>delegate;

- (instancetype)initWithViewController:(UIViewController *)viewController className:(__unsafe_unretained Class)className backgroundImage:(UIImage *)backgroundImage;

/**
 *  设置背景的透明度
 *
 *  @param alpha 透明度
 *
 *  @return 设置状态
 */
- (BOOL)setAlpha:(CGFloat)alpha;

/**
 *  设置翻页方式
 *
 *  @param animationTypes 翻页方式
 *
 *  @return 设置状态
 */
- (BOOL)setAnimationTypes:(AnimationTypes)animationTypes;

/**
*  设置是否响应用户手势
*
*  @param gestureRecognizerState 手势状态
*
*  @return 设置状态
*/
- (BOOL)setGestureRecognizerState:(BOOL)gestureRecognizerState;

/**
 *  从新设置当前页面
 *
 *  @param viewController 展示控制器
 */
- (void)setViewControllers:(UIViewController *)viewController;
@end
