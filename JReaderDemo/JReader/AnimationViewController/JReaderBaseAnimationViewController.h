//
//  JReaderBaseAnimationViewController.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JReaderModel.h"

@protocol JReaderBaseAnimationViewControllerDelegate;
@protocol JReaderBaseAnimationViewControllerDataSource;

@interface JReaderBaseAnimationViewController : UIViewController

@property (nonatomic, weak, nullable) id<JReaderBaseAnimationViewControllerDelegate>delegate;
@property (nonatomic, weak, nullable) id<JReaderBaseAnimationViewControllerDataSource>dataSource;

/**
 当前页面控制器
 */
@property (nonatomic, strong, nullable) UIViewController *currentViewController;

/**
 下一个页面控制器
 */
@property (nonatomic, strong, nullable) UIViewController *nextViewController;

/**
 阅读相关数据
 */
@property (nonatomic, strong, nullable) JReaderModel *jReaderModel;

/**
 拖动起始位置
 */
@property (nonatomic, assign) CGFloat panGesRecBeganX;

/**
 拖动过程中的最大值
 */
@property (nonatomic, assign) CGFloat panGesRecMax;

/**
 拖动过程中 向左/向右
 */
@property (nonatomic, assign) BOOL isLeftPan;


- (nullable instancetype)initWithViewController: (nullable UIViewController *)viewController;

/**
 *  点击手势前翻
 */
- (void)gotoPreviousPage;

/**
 *  点击手势后翻
 */
- (void)gotoNextPage;

/**
 开始拖动

 @param pointX 开始拖动位置
 */
- (void)panGesBegan: (CGFloat)pointX;

/**
 拖动过程中

 @param pointX 改变值
 */
- (void)panGesChanged: (CGFloat)pointX;

/**
 拖动结束

 @param pointX 结束位置
 */
- (void)panGesEnded: (CGFloat)pointX;

@end

/**
 翻页动画控制器代理
 */
@protocol JReaderBaseAnimationViewControllerDelegate <NSObject>


/**
 点击手势回调

 @param jReaderBaseAnimationViewController 当前控制器
 @param tapGestureRecognizer 点击手势
 @return  是否响应点击事件
 */
- (BOOL)jReaderBaseAnimationViewController: (nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController tapGestureRecognizer: (nullable UITapGestureRecognizer *)tapGestureRecognizer;

/**
 翻页动画开始
 
 @param jReaderBaseAnimationViewController 当前控制器
 */
- (void)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController;

/**
 翻页动画结束
 
 @param jReaderBaseAnimationViewController 当前控制器
 @param finished 是否结束
 @param completed 是否成功
 */
- (void)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController didFinishAnimating:(BOOL)finished transitionCompleted:(BOOL)completed;

@end

/**
 翻页动画控制器数据源
 */
@protocol JReaderBaseAnimationViewControllerDataSource <NSObject>

/**
 获取上一页控制器

 @param jReaderBaseAnimationViewController 当前控制器
 @param viewController 正在显示的阅读控制器
 @return 将要显示的控制器
 */
- (nullable UIViewController *)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController viewControllerBeforeViewController:(nullable UIViewController *)viewController;

/**
 获取下一页控制器

 @param jReaderBaseAnimationViewController 当前控制器
 @param viewController 正在显示的阅读控制器
 @return 将要显示的控制器
 */
- (nullable UIViewController *)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController viewControllerAfterViewController:(nullable UIViewController *)viewController;

@end
