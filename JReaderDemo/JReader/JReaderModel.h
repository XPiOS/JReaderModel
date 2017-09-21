//
//  JReaderModel.h
//  JReaderDemo
//
//  Created by Jerry on 2017/8/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define JREADER_SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define JREADER_SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define JREADER_ANIMATION_TIME   0.3f

typedef NS_ENUM(NSInteger, PageViewControllerTransitionStyle) {
    PageViewControllerTransitionStylePageCurl = 1 <<  0, // 仿真翻页
    PageViewControllerTransitionStyleScroll = 1 <<  1, // 平滑
    PageViewControllerTransitionStyleCover = 1 <<  2, // 覆盖
    PageViewControllerTransitionStyleNone = 1 <<  3 // 无动画
};

@interface JReaderModel : NSObject

/**
 阅读页面大小
 */
@property (nonatomic, assign) CGRect jReaderFrame;

/**
 页面索引
 */
@property (nonatomic, assign) NSInteger jReaderPageIndex;

/**
 阅读页面字体颜色
 */
@property (nonatomic, copy) UIColor *jReaderTextColor;

/**
 阅读页背景颜色
 */
@property (nonatomic, copy) UIColor *jReaderBackgroundColor;

/**
 阅读页背景图片
 */
@property (nonatomic, copy) UIImage *jReaderBackgroundImage;

/**
 翻页模式
 */
@property (nonatomic, assign) PageViewControllerTransitionStyle jReaderTransitionStyle;

/**
 内容字符串
 */
@property (nonatomic, copy) NSString *jReaderTextString;

/**
 页面富文本属性
 */
@property (nonatomic, copy) NSDictionary *jReaderAttributes;

/**
 章节标题
 */
@property (nonatomic, copy) NSString *jReaderChapterName;

/**
 章节标题富文本属性
 */
@property (nonatomic, copy) NSDictionary *jReaderChapterNameAttributes;

/**
 屏幕亮度  0~1  数值越大，透明度越低
 */
@property (nonatomic, assign) CGFloat jReaderBrightness;

@end
