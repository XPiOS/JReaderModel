//
//  TopMenuView
//  JReaderDemo
//
//  Created by Jerry on 2017/9/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "TopMenuView.h"

@interface TopMenuView ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *markButton;
@end

@implementation TopMenuView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:77 / 255.0 green:61 / 255.0 blue:31 / 255.0 alpha:0.97];
        [self addSubview:self.backButton];
        self.backButton.wd_layout
        .topSpaceToSuperView(20)
        .leftSpaceToSuperView(10)
        .width(44)
        .height(44);
        
        [self addSubview:self.markButton];
        self.markButton.wd_layout
        .topSpaceToSuperView(20)
        .rightSpaceToSuperView(10)
        .width(44)
        .height(44);
    }
    return self;
}

- (void)buttonClick: (UIButton *)button {
    if (self.backButtonBlock) {
        self.backButtonBlock(@(button.tag));
    }
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        _backButton.tag = 1;
        [_backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_backButton setTitleColor:[UIColor colorWithRed:155 / 255.0 green:140 / 255.0 blue:104 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    }
    return _backButton;
}
- (UIButton *)markButton {
    if (!_markButton) {
        _markButton = [[UIButton alloc] init];
        _markButton.tag = 2;
        [_markButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _markButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_markButton setTitleColor:[UIColor colorWithRed:155 / 255.0 green:140 / 255.0 blue:104 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_markButton setTitle:@"书签" forState:UIControlStateNormal];
    }
    return _markButton;
}
@end
