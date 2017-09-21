//
//  JReaderAnimationViewController.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JReaderModel.h"

@protocol JReaderAnimationViewControllerDelegate;
@protocol JReaderAnimationViewControllerDataSource;

@interface JReaderAnimationViewController : UIViewController

@property (nonatomic, weak, nullable) id<JReaderAnimationViewControllerDelegate> delegate;
@property (nonatomic, weak, nullable) id<JReaderAnimationViewControllerDataSource>dataSource;
/**
 预留自定义字段  可以用来存储 章节索引，防止章节混乱
 */
@property (nonatomic, copy, nullable) id userDefinedProperty;
/**
 阅读相关数据
 */
@property (nonatomic, strong, nullable) JReaderModel *jReaderModel;
/**
 翻页动画类型
 */
@property (nonatomic, assign) PageViewControllerTransitionStyle jReaderTransitionStyle;

/**
 当前页面索引
 */
@property (nonatomic, assign) NSInteger jReaderPageIndex;

/**
 当前页面内容
 */
@property (nonatomic, copy, nullable) NSString *jReaderPageString;

/**
 根据页面内容，获取从新分页后的索引

 @param pageStr 页面内容
 @return 从新分页后的索引
 */
- (NSInteger)jReaderPageIndexWith: (nullable NSString *)pageStr;

@end


/**
 动画翻页控制器代理
 */
@protocol JReaderAnimationViewControllerDelegate <NSObject>
/**
 翻页动画开始
 
 @param jReaderAnimationViewController 当前控制器
 */
- (void)jReaderAnimationViewController:(nullable JReaderAnimationViewController *)jReaderAnimationViewController;

/**
 翻页动画结束
 
 @param jReaderAnimationViewController 当前控制器
 @param finished 是否结束
 @param completed 是否成功
 */
- (void)jReaderAnimationViewController:(nullable JReaderAnimationViewController *)jReaderAnimationViewController didFinishAnimating:(BOOL)finished transitionCompleted:(BOOL)completed;

/**
 数据发生异常

 @param jReaderAnimationViewController 当前控制器
 @param userDefinedProperty 用户自定义字段
 */
- (void)jReaderAnimationViewController: (nullable JReaderAnimationViewController *)jReaderAnimationViewController dataException: (nullable id)userDefinedProperty;

/**
 点击手势回调（一般用来判断是否显示菜单)

 @param jReaderAnimationViewController 当前控制器
 @param tapGestureRecognizer 点击手势
 @return 是否响应手势
 */
- (BOOL)jReaderAnimationViewController: (nullable JReaderAnimationViewController *)jReaderAnimationViewController tapGestureRecognizer: (nullable UITapGestureRecognizer *)tapGestureRecognizer;

@end

/**
 动画翻页控制器数据源
 */
@protocol JReaderAnimationViewControllerDataSource <NSObject>

/**
 获取前一章内容
 
 @param jReaderAnimationViewController 当前控制器
 @return 前一章内容
 */
- (nullable NSString *)beforeContent:(nullable JReaderAnimationViewController *)jReaderAnimationViewController;

/**
 获取下一章内容
 
 @param jReaderAnimationViewController 当前控制器
 @return 下一章内容
 */
- (nullable NSString *)afterContent:(nullable JReaderAnimationViewController *)jReaderAnimationViewController;

@end
