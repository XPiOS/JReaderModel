//
//  PageGenerationManager.h
//  创新版
//
//  Created by XuPeng on 16/5/20.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageAnimationViewController.h"
#import "AutomaticReadingViewController.h"

@class PageGenerationManager;

// 数据源标记
typedef enum {
    PreviousContent = -1,// 前一章
    CurrentContent  = 0, // 当前章
    NextContent     = 1  // 下一章
}DataSourceTag;


////////////////////////////////////////////////////////////////////////////////
//  数据源
////////////////////////////////////////////////////////////////////////////////
@protocol PageGenerationManagerDataSource <NSObject>
@optional
/**
 *  获取章内容 返回的是内容
 *
 *  @param pageGenerationManager 当前控制器
 *  @param dataSourceTag         数据源标记，上一章，当前章，下一章
 *
 *  @return 章节内容字符串
 */
- (NSString *)PageGenerationManagerDataSourceTagString:(DataSourceTag)dataSourceTag;

/**
 *  获取章内容 返回的是文件地址
 *
 *  @param pageGenerationManager 当前控制器
 *  @param dataSourceTag         数据源标记，上一章，当前章，下一章
 *
 *  @return 章节地址
 */
- (NSString *)PageGenerationManagerDataSourceTagFilePath:(DataSourceTag)dataSourceTag;

@end

@protocol PageGenerationManagerDelegate <NSObject>

@optional
/**
 *  菜单显示状态
 *
 *  @param isShowMenu YES显示菜单  NO隐藏菜单
 */
- (void)PageGenerationManagerIsShowMenu:(BOOL)isShowMenu;

/**
 *  自动阅读菜单显示状态
 *
 *  @param isShowMenu YES显示菜单  NO隐藏菜单
 */
- (void)PageGenerationManagerAutomaticReadingIsShowMenu:(BOOL)isShowMenu;

/**
 *  获取页眉
 *
 *  @param pageGenerationManager 当前控制器
 *
 *  @return 页眉视图
 */
- (UIView *)PageGenerationManagerHeader:(PageGenerationManager *)pageGenerationManager;
/**
 *  获取页脚
 *
 *  @param pageGenerationManager 当前控制器
 *
 *  @return 页脚视图
 */
- (UIView *)PageGenerationManagerFooter:(PageGenerationManager *)pageGenerationManager;
/**
 *  添加笔记
 *
 *  @param notesContentDic 笔记内容
 */
- (void)PageGenerationManagerAddNotes:(NSMutableDictionary *)notesContentDic;
/**
 *  删除笔记
 *
 *  @param notesContentDic 笔记内容
 */
- (void)PageGenerationManagerDeleteNotes:(NSMutableDictionary *)notesContentDic;
@end

@interface PageGenerationManager : UIViewController

// 代理
@property (nonatomic, weak) id<PageGenerationManagerDataSource>dataSource;
@property (nonatomic, weak) id<PageGenerationManagerDelegate>delegate;

// 属性
@property (nonatomic, assign) CGFloat               fontSize;// 字体大小
@property (nonatomic, assign) CGRect                pageRect;// 分页所需的页面大小
@property (nonatomic, assign) NSInteger             currentPage;// 当前页数
@property (nonatomic, strong) NSString              *currentPageStr;// 当前页面内容
@property (nonatomic, copy  ) UIImage               *backgroundImage;// 背景图
@property (nonatomic, copy  ) UIColor               *fontColor;// 字体颜色
@property (nonatomic, copy  ) NSString              *bookName;// 书籍名称
@property (nonatomic, copy  ) NSString              *chapterName;// 章节名称
@property (nonatomic, assign) AnimationTypes        animationTypes;// 翻页模式
@property (nonatomic, assign) NSInteger             pageCount;// 总页数
@property (nonatomic, strong) NSMutableArray        *notesArr;// 笔记数组
@property (nonatomic, strong) NSMutableArray        *bookmarksArr;// 书签数组
@property (nonatomic, assign) BOOL                  notesFunctionState;// 笔记功能开关
@property (nonatomic, assign) BOOL                  isShowMenu;// 是否为显示菜单
@property (nonatomic, assign) AutomaticReadingTypes automaticReadingTypes;// 自动阅读模式

/**
 *  创建阅读引擎
 *
 *  @return 返回阅读引擎对象
 */
+ (PageGenerationManager *)sharePageGenerationManager;

/**
 *  刷新阅读引擎
 */
- (void)refreshViewController;

/**
 *  设置夜间模式
 *
 *  @param isNight 夜间模式状态
 */
- (void)nightModel:(BOOL)isNight;

/**
 *  跳转到指定字符串所在位置
 *
 *  @param str 指定的字符串
 */
- (void)jumpStringPage:(NSString *)str;

/**
 *  开启自动阅读
 *
 *  @param automaticReadingTypes 自动阅读类型
 *
 *  @param speed                 自动阅读速度
 */
- (void)automaticReading:(AutomaticReadingTypes)automaticReadingTypes speed:(NSInteger)speed;

/**
 *  设置自动阅读模式
 *
 *  @param automaticReadingTypes 自动阅读类型
 */
- (void)automaticReadingModel:(AutomaticReadingTypes)automaticReadingTypes;

/**
 *  设置自动阅读速度
 *
 *  @param speed 速度值
 */
- (void)automaticReadingSpeed:(NSInteger)speed;
@end
