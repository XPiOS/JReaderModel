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
@property (nonatomic, assign) BOOL userInteractionEnabled;

/**
 阅读相关数据
 */
@property (nonatomic, strong, nullable) JReaderModel *jReaderModel;

/**
 预留自定义字段  可以用来存储 章节索引，防止章节混乱
 */
@property (nonatomic, copy, nullable) id userDefinedProperty;

/**
 当前页面内容
 */
@property (nonatomic, copy, nullable) NSString *jReaderPageString;

/**
 当前页面索引
 */
@property (nonatomic, assign) NSInteger jReaderPageIndex;

/**
 当前章节总页数
 */
@property (nonatomic, assign) NSInteger jReaderPageCount;

/**
 创建阅读器

 @param jReaderModel 阅读器配置
 @param pageIndex 索引页面
 @return 阅读器对象
 */
- (instancetype _Nullable )initWithJReaderModel: (nullable JReaderModel *)jReaderModel pageIndex: (NSInteger)pageIndex;

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
 获取指定章节内容
 
 @param jReaderManager 当前控制器
 @param userDefinedProperty 预留字段 通常设置为章节索引
 @return 章节内容
 */
- (nullable NSString *)jReaderManager:(nullable JReaderManager *)jReaderManager userDefinedPropertyAppoint:(nullable id)userDefinedProperty;

/**
 获取上一章内容

 @param jReaderManager 当前控制器
 @param userDefinedProperty 预留参数
 @return 上一章内容
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
