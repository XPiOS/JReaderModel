//
//  TapMenuView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "TapMenuView.h"

@interface TapMenuView ()

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation TapMenuView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.backButton];
    self.backButton.frame = CGRectMake(10, 20, 44, 44);
}

- (void)buttonClick: (UIButton *)button {
    if (self.backButtonBlock) {
        self.backButtonBlock(button);
    }
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    }
    return _backButton;
}

@end
