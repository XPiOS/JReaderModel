//
//  JReaderManager.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JReaderModel.h"

@protocol JReaderManagerDataSource;
@protocol JReaderManagerDelegate;

@interface JReaderManager : UIViewController

@property (nonatomic, weak, nullable) id <JReaderManagerDataSource> dataSource;
@property (nonatomic, weak, nullable) id <JReaderManagerDelegate> delegate;

/**
 阅读相关数据
 */
@property (nonatomic, strong, nullable) JReaderModel *jReaderModel;
/**
 预留自定义字段  可以用来存储 章节索引，防止章节混乱
 */
@property (nonatomic, copy, nullable) id userDefinedProperty;
/**
 页眉
 */
@property (nonatomic, copy, nullable) UIView *jReaderPageHeaderView;
/**
 页脚
 */
@property (nonatomic, copy, nullable) UIView *jReaderPageFooterView;

/**
 当前页面内容
 */
@property (nonatomic, copy, nullable) NSString *jReaderPageString;

/**
 当前页面索引
 */
@property (nonatomic, assign) NSInteger jReaderPageIndex;

- (instancetype _Nullable )initWithJReaderModel: (nullable JReaderModel *)jReaderModel;

/**
 刷新页面
 */
- (void)jReaderManagerReload;

/**
 根据页面内容，获取从新分页后的索引(笔记功能也需要用到这个方法)
 
 @param pageStr 页面内容
 @return 从新分页后的索引
 */
- (NSInteger)jReaderPageIndexWith: (nullable NSString *)pageStr;

@end


@protocol JReaderManagerDelegate <NSObject>

/**
 点击手势回调（一般用来判断是否显示菜单)
 
 @param jReaderManager 当前控制器
 @param tapGestureRecognizer 点击手势
 @return 是否响应手势
 */
- (BOOL)jReaderManager: (nullable JReaderManager *)jReaderManager tapGestureRecognizer: (nullable UITapGestureRecognizer *)tapGestureRecognizer;

/**
 数据发生异常

 @param jReaderManager 当前控制器
 @param userDefinedProperty 自定义变量
 */
- (void)jReaderManager: (nullable JReaderManager *)jReaderManager dataException: (nullable id)userDefinedProperty;

/**
 翻页动画开始

 @param jReaderManager 当前控制器
 */
- (void)jReaderManager:(nullable JReaderManager *)jReaderManager;

/**
 翻页动画结束

 @param jReaderManager 当前控制器
 @param finished 是否结束
 @param completed 是否成功
 */
- (void)jReaderManager:(nullable JReaderManager *)jReaderManager didFinishAnimating:(BOOL)finished transitionCompleted:(BOOL)completed;

@end

@protocol JReaderManagerDataSource <NSObject>

/**
 获取前一章内容

 @param jReaderManager 当前控制器
 @param userDefinedProperty 预留参数
 @return 前一章内容
 */
- (nullable NSString *)jReaderManager:(nullable JReaderManager *)jReaderManager userDefinedPropertyBefore: (nullable id)userDefinedProperty;

/**
 获取下一章内容

 @param jReaderManager 当前控制器
 @param userDefinedProperty 预留参数
 @return 下一章内容
 */
- (nullable NSString *)jReaderManager:(nullable JReaderManager *)jReaderManager userDefinedPropertyAfter: (nullable id)userDefinedProperty;

@end
