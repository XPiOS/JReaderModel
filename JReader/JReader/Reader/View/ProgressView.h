//
//  ProgressView.h
//  JReader
//
//  Created by Jerry on 2017/10/19.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic, copy) Parameter1Block buttonClickBlock;
@property (nonatomic, copy) Parameter1Block sliderClickBlock;

- (void)updateViewWithProgress: (CGFloat)progress chapterName: (NSString *)chapterName time: (NSInteger)time;

@end
