//
//  AutomaticReadingViewController.h
//  创新版
//
//  Created by XuPeng on 16/6/13.
//  Copyright © 2016年 cxb. All rights reserved.
//  自动阅读控制器

#import <UIKit/UIKit.h>
@class AutomaticReadingViewController;

@protocol AutomaticReadingViewControllerDelegate <NSObject>

/**
 *  获取下一页页面控制器
 *
 *  @param automaticReadingViewController 当前控制器
 *
 *  @return 下一页页面控制器
 */
- (UIViewController *)AutomaticReadingViewControllerNextViewController:(AutomaticReadingViewController *)automaticReadingViewController;

/**
 *  是否显示菜单
 *
 *  @param isShowMenu 菜单状态
 */
- (void)AutomaticReadingViewControllerIsShowMenu:(BOOL)isShowMenu;

/**
 *  退出自动阅读
 */
- (void)AutomaticReadingViewControllerExit;

@end

@interface AutomaticReadingViewController : UIViewController

// 自动翻页模式
typedef NS_ENUM(NSInteger, AutomaticReadingTypes) {
    CoverPatterns  = 1,// 覆盖模式
    ScrollMode     = 2 // 滚动模式
};

@property (nonatomic, assign) id<AutomaticReadingViewControllerDelegate>delegate;

@property (nonatomic, retain) UIViewController      *currentViewController;// 当前展示视图控制器
@property (nonatomic, retain) UIViewController      *nextViewController;// 下一个展示视图控制器
@property (nonatomic, assign) CGFloat               topHeight;// 上边距
@property (nonatomic, assign) CGFloat               bottomHeight;//下边距
@property (nonatomic, assign) NSInteger             speed; // 自动阅读速度
@property (nonatomic, assign) AutomaticReadingTypes automaticReadingTypes; // 自动阅读模式

/**
 *  创建自动阅读控制器
 *
 *  @param currentViewController 当前展示视图控制器
 *  @param nextViewController    下一个展示视图控制器
 *  @param topHeight             距离顶部高度
 *  @param bottomHeight          距离底部高度
 *
 *  @return 自动阅读控制器
 */
+ (AutomaticReadingViewController *)shareAutomaticReadingViewController:(UIViewController *)currentViewController topHeight:(CGFloat)topHeight bottomHeight:(CGFloat)bottomHeight automaticReadingTypes:(AutomaticReadingTypes)automaticReadingTypes speed:(NSInteger)speed;

/**
 *  刷新自动阅读控制器
 */
- (void)refreshViewController;

/**
 *  设置自动阅读速度
 *
 *  @param speed 速度值
 */
- (void)automaticReadingSpeed:(NSInteger)speed;

/**
 *  设置自动阅读模式
 *
 *  @param automaticReadingTypes 自动阅读类型
 */
- (void)automaticReadingModel:(AutomaticReadingTypes)automaticReadingTypes;

/**
 *  暂停自动阅读
 */
- (void)automaticStopReading;
@end
