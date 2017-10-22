//
//  SetMenuView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/25.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "SetMenuView.h"

@interface SetMenuView ()


@property (nonatomic, strong) UIImageView *leftFontImageView;
@property (nonatomic, strong) UIImageView *rightFontImageView;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIButton *curlButton;
@property (nonatomic, strong) UIButton *scrollButton;
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UIButton *noneButton;
@property (nonatomic, strong) UIButton *currentButton;

@end

@implementation SetMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 对外方法
#pragma mark 刷新View
- (void)updateViewWithFont:(NSInteger)font pageModel:(NSInteger)pageModel {
    self.slider.value = (font - 14) / 10.0;
    
    self.currentButton.layer.borderWidth = 0;
    switch (pageModel) {
            default:
        case 0: {
            self.currentButton = self.curlButton;
            break;
        }
        case 1: {
            self.currentButton = self.scrollButton;
            break;
        }
        case 2: {
            self.currentButton = self.coverButton;
            break;
        }
        case 3: {
            self.currentButton = self.noneButton;
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
    
    [self addSubview:self.rightFontImageView];
    self.rightFontImageView.wd_layout
    .topSpaceToSuperView(13)
    .rightSpaceToSuperView(15 + 13)
    .width(24)
    .height(24);
    
    [self addSubview:self.leftFontImageView];
    self.leftFontImageView.wd_layout
    .centerYEqualToView(self.rightFontImageView)
    .leftSpaceToSuperView(15 + 13)
    .width(18)
    .height(18);
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderBackgroundImage"]];
//    [self addSubview:imageView];
//    imageView.wd_layout
//    .centerYEqualToView(self.leftFontImageView)
//    .leftSpaceToView(self.leftFontImageView, 13 + 5)
//    .rightSpaceToView(self.rightFontImageView, 13 + 5)
//    .height(30);
    
    [self addSubview:self.slider];
    self.slider.wd_layout
    .centerYEqualToView(self.leftFontImageView)
    .leftSpaceToView(self.leftFontImageView, 13 + 5)
    .rightSpaceToView(self.rightFontImageView, 13 + 5)
    .height(30);
    
    CGFloat buttonWidth = (SCREEN_WIDTH - 28 * 2 - 10 * 3) / 4;
    [self addSubview:self.curlButton];
    self.curlButton.wd_layout
    .leftSpaceToSuperView(15 + 13)
    .bottomSpaceToSuperView(12.5)
    .width(buttonWidth)
    .height(25);

    [self addSubview:self.scrollButton];
    self.scrollButton.wd_layout
    .topEqualToView(self.curlButton)
    .leftSpaceToView(self.curlButton, 10)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);
    
    [self addSubview:self.coverButton];
    self.coverButton.wd_layout
    .topEqualToView(self.curlButton)
    .leftSpaceToView(self.scrollButton, 10)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);
    
    [self addSubview:self.noneButton];
    self.noneButton.wd_layout
    .topEqualToView(self.curlButton)
    .leftSpaceToView(self.coverButton, 10)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);
    
}
#pragma mark 拖动事件
- (void)sliderClick: (UISlider *)slider {
    if (self.sliderClickBlock) {
        self.sliderClickBlock(@((int)(slider.value * 10) + 14));
    }
}
#pragma mark 按钮点击事件
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
- (UIImageView *)leftFontImageView {
    if (!_leftFontImageView) {
        _leftFontImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setImage"]];
    }
    return _leftFontImageView;
}
- (UIImageView *)rightFontImageView {
    if (!_rightFontImageView) {
        _rightFontImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setImage"]];
    }
    return _rightFontImageView;
    
}
- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.minimumTrackTintColor = k515151Color;//[UIColor clearColor];
        _slider.maximumTrackTintColor = k999999Color;//[UIColor clearColor];
        [_slider setThumbImage:[UIImage imageNamed:@"concentricCirclesImage"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
- (UIButton *)curlButton {
    if (!_curlButton) {
        _curlButton = [Tools createButton:@"仿真" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _curlButton.tag = 0;
        _curlButton.backgroundColor = kE6E6E6Color;
    }
    return _curlButton;
}
- (UIButton *)scrollButton {
    if (!_scrollButton) {
        _scrollButton = [Tools createButton:@"平滑" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _scrollButton.tag = 1;
        _scrollButton.backgroundColor = kE6E6E6Color;
    }
    return _scrollButton;
}
- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [Tools createButton:@"覆盖" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _coverButton.tag = 2;
        _coverButton.backgroundColor = kE6E6E6Color;
    }
    return _coverButton;
}
- (UIButton *)noneButton {
    if (!_noneButton) {
        _noneButton = [Tools createButton:@"无" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _noneButton.tag = 3;
        _noneButton.backgroundColor = kE6E6E6Color;
    }
    return _noneButton;
}

@end
