//
//  ReaderViewController.h
//  创新版
//
//  Created by XuPeng on 16/5/21.
//  Copyright © 2016年 cxb. All rights reserved.
//  展示视图控制器和点击手势控制器

#import <UIKit/UIKit.h>
@class ReaderViewController;


@protocol ReaderViewControllerDelegate <NSObject>

/**
 *  显示菜单
 *
 *  @param readerViewController 当前控制器
 */
- (void)ReaderViewControllerShowMenu:(ReaderViewController *)readerViewController;
/**
 *  隐藏菜单
 *
 *  @param readerViewController 当前控制器
 */
- (void)ReaderViewControllerHiddenMenu:(ReaderViewController *)readerViewController;
/**
 *  添加笔记
 *
 *  @param notesContentDic 笔记内容数组
 */
- (void)ReaderViewControllerAddNotes:(NSMutableDictionary *)notesContentDic;
/**
 *  删除笔记
 *
 *  @param notesContentDic 笔记内容数组
 */
- (void)ReaderViewControllerDeleteNotes:(NSMutableDictionary *)notesContentDic;
/**
 *  设置是否响应翻页手势
 *
 *  @param pageState 状态值
 */
- (void)ReaderViewControllerPageState:(BOOL)pageState;
@end

@interface ReaderViewController : UIViewController

@property (nonatomic, assign) id<ReaderViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *notesArr;
@property (nonatomic, strong) NSString       *titleStr;
@property (nonatomic, assign) BOOL           isShowMenu;// 是否为显示菜单
@property (nonatomic, assign) CGFloat        lastLinePosition;// 最后一行的位置

/**
 *  创建展示视图控制器
 *
 *  @param pageRect             页面大小
 *  @param fontSize             字体大小
 *  @param fontColor            字体颜色
 *  @param contentString        页面内容
 *  @param backgroundColorImage 页面背景
 *
 *  @return 展示视图控制器
 */
- (instancetype)initWithPageRect:(CGRect)pageRect fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor contentString:(NSString *)contentString backgroundColorImage:(UIImage *)backgroundColorImage isNight:(BOOL)isNight;

// 开启/关闭笔记功能
- (void)openOrClosedNotesFunction:(BOOL)notesState;

/**
 *  设置书签状态
 *
 *  @param bookmarkState 书签状态
 */
- (void)setBookmarkState:(BOOL)bookmarkState;

@end
