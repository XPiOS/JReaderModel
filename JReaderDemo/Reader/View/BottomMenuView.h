//
//  BottomMenuView.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomMenuView : UIView

@property (nonatomic, copy) Parameter1Block buttonClickBlock;
@property (nonatomic, copy) Parameter1Block sliderClickBlock;

/**
 设置当前进度

 @param progress 当前进度值
 */
- (void)setProgress:(CGFloat)progress;

@end
