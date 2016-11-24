//
//  NotesMenuView.h
//  创新版
//
//  Created by XuPeng on 16/5/25.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesMenuView;

@protocol NotesMenuViewDelegate <NSObject>

/**
 *  绘制底线
 *
 *  @param color 底线颜色
 */
- (void)drawBottomLineColor:(NSInteger)colorIndex;

/**
 *  删除按钮点击
 *
 *  @param notesMenuView 当前视图
 */
- (void)notesMenuViewDelete:(NotesMenuView *)notesMenuView;

/**
 *  复制按钮点击
 *
 *  @param notesMenuView 当前视图
 */
- (void)notesMenuViewCopy:(NotesMenuView *)notesMenuView;

/**
 *  笔记按钮点击
 *
 *  @param notesMenuView 当前视图
 */
- (void)notesMenuViewNotes:(NotesMenuView *)notesMenuView;
/**
 *  收起菜单
 *
 *  @param notesMenuView 当前视图
 */
- (void)deleteNotesMenuView:(NotesMenuView *)notesMenuView;
@end

@interface NotesMenuView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<NotesMenuViewDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *notesContentDic; // 菜单页保存的笔记数组

+ (NotesMenuView *)shareNotesMenuView:(CGPoint)point isUp:(BOOL)isUp;

@end
