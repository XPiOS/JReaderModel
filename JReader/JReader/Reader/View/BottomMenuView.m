//
//  BottomMenuView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BottomMenuView.h"

@interface BottomMenuView ()

@property (nonatomic, strong) UIButton *directoryButton;
@property (nonatomic, strong) UIButton *progressButton;
@property (nonatomic, strong) UIButton *brightnessButton;
@property (nonatomic, strong) UIButton *setButton;

@end

@implementation BottomMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = kFFFFFFColor;

    CGFloat spaceWidth = (SCREEN_WIDTH - 44 * 4) / 5;

    [self addSubview:self.directoryButton];
    self.directoryButton.wd_layout
        .centerYEqualToSuperView()
    .leftSpaceToSuperView(spaceWidth)
    .width(44)
    .height(44);
    
    [self addSubview:self.progressButton];
    self.progressButton.wd_layout
    .topEqualToView(self.directoryButton)
    .leftSpaceToView(self.directoryButton, spaceWidth)
    .widthEqualToView(self.directoryButton)
    .heightEqualToView(self.directoryButton);
    
    [self addSubview:self.brightnessButton];
    self.brightnessButton.wd_layout
    .topEqualToView(self.directoryButton)
    .leftSpaceToView(self.progressButton, spaceWidth)
    .widthEqualToView(self.directoryButton)
    .heightEqualToView(self.directoryButton);
    
    [self addSubview:self.setButton];
    self.setButton.wd_layout
    .topEqualToView(self.directoryButton)
    .leftSpaceToView(self.brightnessButton, spaceWidth)
    .widthEqualToView(self.directoryButton)
    .heightEqualToView(self.directoryButton);
}
- (void)buttonClick: (UIButton *)button {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(@(button.tag));
    }
}

#pragma mark - get/set
- (UIButton *)directoryButton {
    if (!_directoryButton) {
        _directoryButton = [Tools createButton:@"" font:Font(12) color:kFFFFFFColor target:self action:@selector(buttonClick:)];
        _directoryButton.tag = 1;
        [_directoryButton setImage:[UIImage imageNamed:@"directoryImage"] forState:UIControlStateNormal];
    }
    return _directoryButton;
}
- (UIButton *)progressButton {
    if (!_progressButton) {
        _progressButton = [Tools createButton:@"" font:Font(12) color:kFFFFFFColor target:self action:@selector(buttonClick:)];
        _progressButton.tag = 2;
        [_progressButton setImage:[UIImage imageNamed:@"progressImage"] forState:UIControlStateNormal];
    }
    return _progressButton;
}
- (UIButton *)brightnessButton {
    if (!_brightnessButton) {
        _brightnessButton = [Tools createButton:@"" font:Font(12) color:kFFFFFFColor target:self action:@selector(buttonClick:)];
        _brightnessButton.tag = 3;
        [_brightnessButton setImage:[UIImage imageNamed:@"highBrightnessImage"] forState:UIControlStateNormal];
    }
    return _brightnessButton;
}
- (UIButton *)setButton {
    if (!_setButton) {
        _setButton = [Tools createButton:@"" font:Font(12) color:kFFFFFFColor target:self action:@selector(buttonClick:)];
        _setButton.tag = 4;
        [_setButton setImage:[UIImage imageNamed:@"setImage"] forState:UIControlStateNormal];
    }
    return _setButton;
}
//@property (nonatomic, strong) UIButton *setButton;

@end
