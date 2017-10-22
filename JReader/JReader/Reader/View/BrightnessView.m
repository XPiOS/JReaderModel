//
//  BrightnessView.m
//  JReader
//
//  Created by Jerry on 2017/10/19.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BrightnessView.h"

@interface BrightnessView ()

@property (nonatomic, strong) UIImageView *lowBrightnessImageView;
@property (nonatomic, strong) UIImageView *highBrightnessImageView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *backgroundButton1;
@property (nonatomic, strong) UIButton *backgroundButton2;
@property (nonatomic, strong) UIButton *backgroundButton3;
@property (nonatomic, strong) UIButton *backgroundButton4;
@property (nonatomic, strong) UIButton *currentButton;

@end

@implementation BrightnessView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 对外方法
- (void)updateViewWithTag:(NSInteger)tag {
    self.currentButton.layer.borderWidth = 0;
    self.slider.value = [UIScreen mainScreen].brightness;
    switch (tag) {
        default:
        case 1: {
            self.currentButton = self.backgroundButton1;
            break;
        }
        case 2: {
            self.currentButton = self.backgroundButton2;
            break;
        }
        case 3: {
            self.currentButton = self.backgroundButton3;
            break;
        }
        case 4: {
            self.currentButton = self.backgroundButton4;
            break;
        }
    }
    self.currentButton.layer.masksToBounds = YES;
    self.currentButton.layer.borderColor = k515151Color.CGColor;
    self.currentButton.layer.borderWidth = 2;
}

#pragma mark - 内部方法
#pragma mark 初始化
- (void)initView {
    self.backgroundColor = kFFFFFFColor;
    [self addSubview:self.lowBrightnessImageView];
    self.lowBrightnessImageView.wd_layout
    .topSpaceToSuperView(13)
    .leftSpaceToSuperView(15 + 13)
    .width(24)
    .height(24);
    
    [self addSubview:self.highBrightnessImageView];
    self.highBrightnessImageView.wd_layout
    .topEqualToView(self.lowBrightnessImageView)
    .rightSpaceToSuperView(15 + 13)
    .widthEqualToView(self.lowBrightnessImageView)
    .heightEqualToView(self.lowBrightnessImageView);
    
    [self addSubview:self.slider];
    self.slider.wd_layout
    .centerYEqualToView(self.lowBrightnessImageView)
    .leftSpaceToView(self.lowBrightnessImageView, 13 + 5)
    .rightSpaceToView(self.highBrightnessImageView, 13 + 5)
    .height(30);
    
    CGFloat buttonWidth = (SCREEN_WIDTH - 28 * 2 - 10 * 3) / 4;
    [self addSubview:self.backgroundButton1];
    self.backgroundButton1.wd_layout
    .leftSpaceToSuperView(15 + 13)
    .bottomSpaceToSuperView(12.5)
    .width(buttonWidth)
    .height(25);
    
    [self addSubview:self.backgroundButton2];
    self.backgroundButton2.wd_layout
    .topEqualToView(self.backgroundButton1)
    .leftSpaceToView(self.backgroundButton1, 10)
    .widthEqualToView(self.backgroundButton1)
    .heightEqualToView(self.backgroundButton1);
    
    [self addSubview:self.backgroundButton3];
    self.backgroundButton3.wd_layout
    .topEqualToView(self.backgroundButton1)
    .leftSpaceToView(self.backgroundButton2, 10)
    .widthEqualToView(self.backgroundButton1)
    .heightEqualToView(self.backgroundButton1);
    
    [self addSubview:self.backgroundButton4];
    self.backgroundButton4.wd_layout
    .topEqualToView(self.backgroundButton1)
    .leftSpaceToView(self.backgroundButton3, 10)
    .widthEqualToView(self.backgroundButton1)
    .heightEqualToView(self.backgroundButton1);
}
#pragma mark 拖动响应事件
- (void)sliderClick: (UISlider *)slider {
    [UIScreen mainScreen].brightness = slider.value;
}
#pragma mark 按钮响应事件
- (void)buttonClick: (UIButton *)button {
    self.currentButton.layer.borderWidth = 0;
    self.currentButton = button;
    self.currentButton.layer.masksToBounds = YES;
    self.currentButton.layer.borderColor = k515151Color.CGColor;
    self.currentButton.layer.borderWidth = 2;
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(@(button.tag));
    }
}

#pragma mark - get/set
- (UIImageView *)lowBrightnessImageView {
    if (!_lowBrightnessImageView) {
        _lowBrightnessImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lowBrightnessImage"]];
    }
    return _lowBrightnessImageView;
}
- (UIImageView *)highBrightnessImageView {
    if (!_highBrightnessImageView) {
        _highBrightnessImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"highBrightnessImage"]];
    }
    return _highBrightnessImageView;
}
- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.minimumTrackTintColor = k515151Color;
        _slider.maximumTrackTintColor = k999999Color;
        [_slider setThumbImage:[UIImage imageNamed:@"concentricCirclesImage"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
- (UIButton *)backgroundButton1 {
    if (!_backgroundButton1) {
        _backgroundButton1 = [Tools createButton:@"" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _backgroundButton1.backgroundColor = kF4F4F6Color;
        _backgroundButton1.tag = 1;
    }
    return _backgroundButton1;
}
- (UIButton *)backgroundButton2 {
    if (!_backgroundButton2) {
        _backgroundButton2 = [Tools createButton:@"" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _backgroundButton2.backgroundColor = kF2ECD1Color;
        _backgroundButton2.tag = 2;
    }
    return _backgroundButton2;
}
- (UIButton *)backgroundButton3 {
    if (!_backgroundButton3) {
        _backgroundButton3 = [Tools createButton:@"" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _backgroundButton3.backgroundColor = kB4EBBAColor;
        _backgroundButton3.tag = 3;
    }
    return _backgroundButton3;
}
- (UIButton *)backgroundButton4 {
    if (!_backgroundButton4) {
        _backgroundButton4 = [Tools createButton:@"" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _backgroundButton4.backgroundColor = k161618Color;
        _backgroundButton4.tag = 4;
    }
    return _backgroundButton4;
}

@end
