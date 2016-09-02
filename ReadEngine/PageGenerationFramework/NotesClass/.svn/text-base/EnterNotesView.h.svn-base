//
//  EnterNotesView.h
//  创新版
//
//  Created by XuPeng on 16/5/27.
//  Copyright © 2016年 cxb. All rights reserved.
//  输入笔记页面

#import <UIKit/UIKit.h>
@class EnterNotesView;


@protocol EnterNotesViewDelegate <NSObject>

/**
 *  导航上方 放弃/完成按钮点击事件代理
 *
 *  @param enterNotesView 当前View
 *  @param isSave         是否保存
 */
- (void)enterNotesViewGoBack:(EnterNotesView *)enterNotesView isSave:(BOOL)isSave;

@end

@interface EnterNotesView : UIView<UITextViewDelegate>

@property (nonatomic, assign) id<EnterNotesViewDelegate>delegate;
@property (nonatomic, copy  ) NSString *color; // 输入笔记页面保存的下划线颜色
@property (nonatomic, strong) NSString *selectedContentStr;
@property (nonatomic, strong) NSString *noteContentStr;

- (instancetype)init;

@end
