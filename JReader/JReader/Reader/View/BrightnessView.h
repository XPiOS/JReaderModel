//
//  BrightnessView.h
//  JReader
//
//  Created by Jerry on 2017/10/19.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrightnessView : UIView

@property (nonatomic, copy) Parameter1Block buttonClickBlock;

- (void)updateViewWithTag: (NSInteger)tag;

@end
