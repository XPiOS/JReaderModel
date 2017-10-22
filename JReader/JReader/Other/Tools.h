//
//  Tools.h
//  JReader
//
//  Created by Jerry on 2017/10/19.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

/**
 创建Label
 
 @param text 文案
 @param font 字体大小
 @param color 字体颜色
 @return Label
 */
+ (UILabel *_Nullable)createLabel: (NSString *_Nullable)text font: (UIFont *_Nullable)font color: (UIColor *_Nullable)color;

/**
 创建按钮
 
 @param title 文案
 @param font 字体大小
 @param color 字体颜色
 @param target 点击相应对象
 @param action 点击相应事件
 @return  Button
 */
+ (UIButton *_Nullable)createButton: (NSString *_Nullable)title font: (UIFont *_Nullable)font color: (UIColor *_Nullable)color target:(nullable id)target action:(SEL _Nullable )action;

@end
