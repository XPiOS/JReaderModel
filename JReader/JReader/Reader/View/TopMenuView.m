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
        self.backgroundColor = kFFFFFFColor;
        [self addSubview:self.backButton];
        self.backButton.wd_layout
        .leftSpaceToSuperView(10)
        .bottomSpaceToSuperView(0)
        .width(44)
        .height(44);
        
        [self addSubview:self.markButton];
        self.markButton.wd_layout
        .rightSpaceToSuperView(10)
        .bottomSpaceToSuperView(0)
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
        _backButton = [Tools createButton:@"" font:Font(12) color:kFFFFFFColor target:self action:@selector(buttonClick:)];
        _backButton.tag = 1;
        [_backButton setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
    }
    return _backButton;
}
- (UIButton *)markButton {
    if (!_markButton) {
        _markButton = [Tools createButton:@"" font:Font(12) color:kFFFFFFColor target:self action:@selector(buttonClick:)];
        _markButton.tag = 2;
        [_markButton setImage:[UIImage imageNamed:@"markImage"] forState:UIControlStateNormal];
    }
    return _markButton;
}
@end
