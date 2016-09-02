//
//  CoverPatternsViewController.h
//  创新版
//
//  Created by XuPeng on 16/6/14.
//  Copyright © 2016年 cxb. All rights reserved.
//  覆盖模式

#import <UIKit/UIKit.h>
@class CoverPatternsViewController;

@protocol CoverPatternsViewControllerDelegate <NSObject>

/**
 *  获取下一页内容控制器
 *
 *  @param coverPatternsViewController 当前控制器对象
 *
 *  @return 下一页内容控制器
 */
- (UIViewController *)CoverPatternsViewControllerNextViewController:(CoverPatternsViewController *)coverPatternsViewController;

/**
 *  退出自动阅读
 */
- (void)CoverPatternsViewControllerExit;
@end


@interface CoverPatternsViewController : UIViewController

@property (nonatomic, assign) id<CoverPatternsViewControllerDelegate>delegate;

/**
 *  创建覆盖自动阅读
 *
 *  @param currentViewController 下层展示控制器
 *  @param nextViewController    上层展示控制器
 *  @param topHeight             顶部高度
 *  @param bottomHeight          底部高度
 *  @param speed                 速度
 *
 *  @return 覆盖自动阅读控制器
 */
- (instancetype)initWithCurrentViewController:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController topHeight:(CGFloat)topHeight bottomHeight:(CGFloat)bottomHeight speed:(NSInteger)speed;

/**
 *  暂停自动阅读
 */
- (void)automaticStopReading;

/**
 *  恢复自动阅读
 */
- (void)continueAutomaticReading;

/**
 *  设置自动阅读速度
 *
 *  @param speed 速度值
 */
- (void)automaticReadingSpeed:(NSInteger)speed;

@end
