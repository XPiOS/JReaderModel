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

- (void)updateViewWithFont: (NSInteger) font pageModel: (NSInteger)pageModel;

@end
