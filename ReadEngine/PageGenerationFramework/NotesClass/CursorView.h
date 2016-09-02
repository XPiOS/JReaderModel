//
//  CursorView.h
//  创新版
//
//  Created by XuPeng on 16/5/25.
//  Copyright © 2016年 cxb. All rights reserved.
//  光标类

#import <UIKit/UIKit.h>
typedef enum {
    CursorLeft = 0,
    CursorRight ,
    
} CursorType;
@interface CursorView : UIView {
    UIImageView *_dragDot;
}
@property (nonatomic,assign) CursorType direction;// 方向
@property (nonatomic,assign) float      cursorHeight;// 光标高度
@property (nonatomic,retain) UIColor    *cursorColor;// 光标颜色
@property (nonatomic,assign) CGPoint    setupPoint;// 拖动点

/**
 *  返回一个光标类
 *
 *  @param type         光标类型： 左还是右
 *  @param cursorHeight 光标的高度
 *  @param drawColor    光标的颜色
 *
 *  @return 光标类
 */
- (id)initWithType:(CursorType)type andHeight:(float)cursorHeight byDrawColor:(UIColor *)drawColor;

@end
