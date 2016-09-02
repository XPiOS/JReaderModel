//
//  MagnifyingGlassView.h
//  创新版
//
//  Created by XuPeng on 16/5/24.
//  Copyright © 2016年 cxb. All rights reserved.
//  放大镜类

#import <UIKit/UIKit.h>

@interface MagnifyingGlassView : UIView

@property (nonatomic, retain) UIView  *viewToMagnify;
@property (nonatomic, assign) CGPoint touchPoint;

@end
