//
//  BackViewController.h
//  zwsc
//
//  Created by XuPeng on 16/2/29.
//  Copyright © 2016年 中文万维. All rights reserved.
//  控制仿真翻页的背面   为正面的翻转，并加透明

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"

@interface BackViewController : UIViewController

@property (assign, nonatomic) ReaderViewController *currentViewController;

- (void)updateWithViewController:(ReaderViewController *)viewController;
// 设置透明度
- (void)setAlpha:(CGFloat)alpha;

@end
