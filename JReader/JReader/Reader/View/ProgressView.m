//
//  ProgressView.m
//  JReader
//
//  Created by Jerry on 2017/10/19.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *chapterNameLabel;

@end

@implementation ProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 对外方法
#pragma mark 刷新View
- (void)updateViewWithProgress:(CGFloat)progress chapterName:(NSString *)chapterName time:(NSInteger)time {
    self.timeLabel.text = [NSString stringWithFormat:@"已读%zd分钟", time];
    [self.timeLabel wd_updateLayout];
    
    self.slider.value = progress;
    
    self.chapterNameLabel.text = chapterName;
    [self.chapterNameLabel wd_updateLayout];

}

#pragma mark - 内部方法
#pragma mark 初始化 View
- (void)initView {
    self.backgroundColor = kFFFFFFColor;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:tapGes];
    
    [self addSubview:self.timeLabel];
    self.timeLabel.wd_layout
    .topSpaceToSuperView(10)
    .centerXEqualToSuperView()
    .autoresizingMaxWidth(0)
    .autoHeightRatio(0);
    
    [self addSubview:self.leftButton];
    self.leftButton.wd_layout
    .centerYEqualToSuperView()
    .leftSpaceToSuperView(15)
    .width(50)
    .height(50);
    
    [self addSubview:self.rightButton];
    self.rightButton.wd_layout
    .topEqualToView(self.leftButton)
    .rightSpaceToSuperView(15)
    .widthEqualToView(self.leftButton)
    .heightEqualToView(self.leftButton);
    
    [self addSubview:self.slider];
    self.slider.wd_layout
    .centerYEqualToView(self.leftButton)
    .leftSpaceToView(self.leftButton, 5)
    .rightSpaceToView(self.rightButton, 5)
    .height(30);
    
    [self addSubview:self.chapterNameLabel];
    self.chapterNameLabel.wd_layout
    .centerXEqualToSuperView()
    .bottomSpaceToSuperView(10)
    .autoresizingMaxWidth(0)
    .autoHeightRatio(0);
    
}
#pragma mark 按钮响应事件
- (void)buttonClick: (UIButton *)button {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(@(button.tag));
    }
}
#pragma mark 拖动响应事件
- (void)sliderClick: (UISlider *)slider {
    if (self.sliderClickBlock) {
        self.sliderClickBlock(@(slider.value));
    }
}

#pragma mark - get/set
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [Tools createLabel:@"" font:Font(14) color:k515151Color];
    }
    return _timeLabel;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [Tools createButton:@"" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _leftButton.tag = 1;
        [_leftButton setImage:[UIImage imageNamed:@"leftButtonImage"] forState:UIControlStateNormal];
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [Tools createButton:@"" font:Font(14) color:k515151Color target:self action:@selector(buttonClick:)];
        _rightButton.tag = 2;
        [_rightButton setImage:[UIImage imageNamed:@"rightButtonImage"] forState:UIControlStateNormal];
    }
    return _rightButton;
}
- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.continuous = NO;
        _slider.minimumTrackTintColor = k515151Color;
        _slider.maximumTrackTintColor = k999999Color;
        [_slider setThumbImage:[UIImage imageNamed:@"concentricCirclesImage"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
- (UILabel *)chapterNameLabel {
    if (!_chapterNameLabel) {
        _chapterNameLabel = [Tools createLabel:@"" font:Font(14) color:k515151Color];
    }
    return _chapterNameLabel;
}

@end
