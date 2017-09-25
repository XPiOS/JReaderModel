//
//  SetMenuView.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/25.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetMenuView : UIView

@property (nonatomic, copy) Parameter1Block buttonClickBlock;
@property (nonatomic, copy) Parameter1Block sliderClickBlock;

/**
 设置当前亮度

 @param brightnessValue 当前亮度值
 */
- (void)setBrightness: (CGFloat)brightnessValue;

/**
 设置当前字号

 @param font 当前字号
 */
- (void)setFont: (NSInteger)font;

@end
