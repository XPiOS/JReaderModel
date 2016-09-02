//
//  NoteContentButton.h
//  创新版
//
//  Created by XuPeng on 16/5/27.
//  Copyright © 2016年 cxb. All rights reserved.
//  笔记详情按钮

#import <UIKit/UIKit.h>

@interface NoteContentButton : UIView<UIGestureRecognizerDelegate,UITextViewDelegate>

+ (NoteContentButton *)shareNoteContentButton:(UIColor *)color noteContent:(NSString *)noteContent isNight:(BOOL)isNight;


@end
