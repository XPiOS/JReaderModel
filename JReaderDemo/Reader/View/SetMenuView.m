//
//  SetMenuView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/25.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "SetMenuView.h"

@interface SetMenuView ()

@property (nonatomic, strong) UIImageView *lowBrightnessImageView;
@property (nonatomic, strong) UIImageView *highBrightnessImageView;
@property (nonatomic, strong) UISlider *brightnessSlider;

@property (nonatomic, strong) UIButton *fontAddButton;
@property (nonatomic, strong) UIButton *fontSubButton;
@property (nonatomic, strong) UILabel *fontLabel;

@property (nonatomic, strong) UIButton *backgroundColorButton1;
@property (nonatomic, strong) UIButton *backgroundColorButton2;
@property (nonatomic, strong) UIButton *backgroundColorButton3;
@property (nonatomic, strong) UIButton *backgroundColorButton4;
@property (nonatomic, strong) UIButton *backgroundColorButton5;
@property (nonatomic, strong) UIButton *backgroundColorButton6;

@property (nonatomic, strong) UIButton *spaceButton1;
@property (nonatomic, strong) UIButton *spaceButton2;
@property (nonatomic, strong) UIButton *spaceButton3;

@property (nonatomic, strong) UIButton *curlButton;
@property (nonatomic, strong) UIButton *scrollButton;
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UIButton *noneButton;

@end

@implementation SetMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)setBrightness:(CGFloat)brightnessValue {
    self.brightnessSlider.value = brightnessValue;
}

- (void)setFont:(NSInteger)font {
    self.fontLabel.text = [NSString stringWithFormat:@"%zd", font];
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithRed:77 / 255.0 green:61 / 255.0 blue:31 / 255.0 alpha:0.97];
    
    [self addSubview:self.lowBrightnessImageView];
    self.lowBrightnessImageView.wd_layout
    .topSpaceToSuperView(12)
    .leftSpaceToSuperView(15)
    .width(20)
    .height(20);
    
    [self addSubview:self.highBrightnessImageView];
    self.highBrightnessImageView.wd_layout
    .topEqualToView(self.lowBrightnessImageView)
    .rightSpaceToSuperView(15)
    .widthEqualToView(self.lowBrightnessImageView)
    .heightEqualToView(self.lowBrightnessImageView);
    
    [self addSubview:self.brightnessSlider];
    self.brightnessSlider.wd_layout
    .centerYEqualToView(self.lowBrightnessImageView)
    .leftSpaceToView(self.lowBrightnessImageView, 10)
    .rightSpaceToView(self.highBrightnessImageView, 10);
    
    [self addSubview:self.fontSubButton];
    self.fontSubButton.wd_layout
    .topSpaceToView(self.lowBrightnessImageView, 16)
    .leftEqualToView(self.lowBrightnessImageView)
    .width(90)
    .height(36);
    
    [self addSubview:self.fontAddButton];
    self.fontAddButton.wd_layout
    .topEqualToView(self.fontSubButton)
    .rightEqualToView(self.highBrightnessImageView)
    .widthEqualToView(self.fontSubButton)
    .heightEqualToView(self.fontSubButton);
    
    [self addSubview:self.fontLabel];
    self.fontLabel.wd_layout
    .centerYEqualToView(self.fontSubButton)
    .leftSpaceToView(self.fontSubButton, 0)
    .rightSpaceToView(self.fontAddButton, 0)
    .height(44);
    
    CGFloat space = (SCREEN_WIDTH - 30 * 6 - 15 * 2) / 5;
    
    [self addSubview:self.backgroundColorButton1];
    self.backgroundColorButton1.wd_layout
    .topSpaceToView(self.fontSubButton, 11)
    .leftEqualToView(self.fontSubButton)
    .width(30)
    .height(30);
    
    [self addSubview:self.backgroundColorButton2];
    self.backgroundColorButton2.wd_layout
    .topEqualToView(self.backgroundColorButton1)
    .leftSpaceToView(self.backgroundColorButton1, space)
    .widthEqualToView(self.backgroundColorButton1)
    .heightEqualToView(self.backgroundColorButton1);
    
    [self addSubview:self.backgroundColorButton3];
    self.backgroundColorButton3.wd_layout
    .topEqualToView(self.backgroundColorButton1)
    .leftSpaceToView(self.backgroundColorButton2, space)
    .widthEqualToView(self.backgroundColorButton1)
    .heightEqualToView(self.backgroundColorButton1);
    
    [self addSubview:self.backgroundColorButton4];
    self.backgroundColorButton4.wd_layout
    .topEqualToView(self.backgroundColorButton1)
    .leftSpaceToView(self.backgroundColorButton3, space)
    .widthEqualToView(self.backgroundColorButton1)
    .heightEqualToView(self.backgroundColorButton1);
    
    [self addSubview:self.backgroundColorButton5];
    self.backgroundColorButton5.wd_layout
    .topEqualToView(self.backgroundColorButton1)
    .leftSpaceToView(self.backgroundColorButton4, space)
    .widthEqualToView(self.backgroundColorButton1)
    .heightEqualToView(self.backgroundColorButton1);
    
    [self addSubview:self.backgroundColorButton6];
    self.backgroundColorButton6.wd_layout
    .topEqualToView(self.backgroundColorButton1)
    .leftSpaceToView(self.backgroundColorButton5, space)
    .widthEqualToView(self.backgroundColorButton1)
    .heightEqualToView(self.backgroundColorButton1);
    
    [self addSubview:self.spaceButton1];
    self.spaceButton1.wd_layout
    .topSpaceToView(self.backgroundColorButton1, 11)
    .leftEqualToView(self.backgroundColorButton1)
    .width(90)
    .height(36);
    
    [self addSubview:self.spaceButton2];
    self.spaceButton2.wd_layout
    .topEqualToView(self.spaceButton1)
    .centerXEqualToSuperView()
    .widthEqualToView(self.spaceButton1)
    .heightEqualToView(self.spaceButton1);
    
    [self addSubview:self.spaceButton3];
    self.spaceButton3.wd_layout
    .topEqualToView(self.spaceButton1)
    .rightEqualToView(self.backgroundColorButton6)
    .widthEqualToView(self.spaceButton1)
    .heightEqualToView(self.spaceButton1);
    
    CGFloat pageSpace = (SCREEN_WIDTH - 15 * 2 - 60 * 4) / 3;
    [self addSubview:self.curlButton];
    self.curlButton.wd_layout
    .topSpaceToView(self.spaceButton1, 8)
    .leftEqualToView(self.spaceButton1)
    .width(60)
    .height(36);
    
    [self addSubview:self.scrollButton];
    self.scrollButton.wd_layout
    .topEqualToView(self.curlButton)
    .leftSpaceToView(self.curlButton, pageSpace)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);
    
    [self addSubview:self.coverButton];
    self.coverButton.wd_layout
    .topEqualToView(self.curlButton)
    .leftSpaceToView(self.scrollButton, pageSpace)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);

    [self addSubview:self.noneButton];
    self.noneButton.wd_layout
    .topEqualToView(self.curlButton)
    .leftSpaceToView(self.coverButton, pageSpace)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);
    
}
- (UIButton *)createButtont: (NSInteger)tag {
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button setTitleColor:[UIColor colorWithRed:155 / 255.0 green:140 / 255.0 blue:104 / 255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (UIButton *)createBackgroundColorButton: (NSInteger)tag color: (UIColor *)color {
    UIButton *button = [self createButtont:tag];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 10;
    button.backgroundColor = color;
    return button;
}
- (UIButton *)createButtont: (NSInteger)tag text: (NSString *)text {
    UIButton *button = [self createButtont:tag];
    [button setTitle:text forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:155 / 255.0 green:140 / 255.0 blue:104 / 255.0 alpha:1].CGColor;
    return button;
}
- (void)sliderClick: (UISlider *)slider {
    if (self.sliderClickBlock) {
        self.sliderClickBlock(@(slider.value));
    }
}
- (void)buttonClick: (UIButton *)button {
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
- (UISlider *)brightnessSlider {
    if (!_brightnessSlider) {
        _brightnessSlider = [[UISlider alloc] init];
        _brightnessSlider.minimumValue = 0;
        _brightnessSlider.maximumValue = 1;
        _brightnessSlider.value = 0;
        _brightnessSlider.continuous = YES;
        _brightnessSlider.minimumTrackTintColor = [UIColor colorWithRed:147 / 255.0 green:81 / 255.0 blue:44 / 255.0 alpha:1];
        _brightnessSlider.maximumTrackTintColor = [UIColor colorWithRed:82 / 255.0 green:69 / 255.0 blue:33 / 255.0 alpha:1];
        _brightnessSlider.thumbTintColor = [UIColor colorWithRed:147 / 255.0 green:81 / 255.0 blue:44 / 255.0 alpha:1];
        [_brightnessSlider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _brightnessSlider;
}
- (UIButton *)fontAddButton {
    if (!_fontAddButton) {
        _fontAddButton = [self createButtont:1 text:@"A+"];
    }
    return _fontAddButton;
}
- (UIButton *)fontSubButton {
    if (!_fontSubButton) {
        _fontSubButton = [self createButtont:2 text:@"A-"];
    }
    return _fontSubButton;
}
- (UILabel *)fontLabel {
    if (!_fontLabel) {
        _fontLabel = [[UILabel alloc] init];
        _fontLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:140 / 255.0 blue:104 / 255.0 alpha:1];
        _fontLabel.font = [UIFont systemFontOfSize:20];
        _fontLabel.text = @"0";
        _fontLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _fontLabel;
}
- (UIButton *)backgroundColorButton1 {
    if (!_backgroundColorButton1) {
        _backgroundColorButton1 = [self createBackgroundColorButton:3 color:[UIColor colorWithRed:181 / 255.0 green:181 / 255.0 blue:181 / 255.0 alpha:1]];
    }
    return _backgroundColorButton1;
}
- (UIButton *)backgroundColorButton2 {
    if (!_backgroundColorButton2) {
        _backgroundColorButton2 = [self createBackgroundColorButton:4 color:[UIColor colorWithRed:175 / 255.0 green:167 / 255.0 blue:154 / 255.0 alpha:1]];
    }
    return _backgroundColorButton2;
}
- (UIButton *)backgroundColorButton3 {
    if (!_backgroundColorButton3) {
        _backgroundColorButton3 = [self createBackgroundColorButton:5 color:[UIColor colorWithRed:163 / 255.0 green:147 / 255.0 blue:108 / 255.0 alpha:1]];
    }
    return _backgroundColorButton3;
}
- (UIButton *)backgroundColorButton4 {
    if (!_backgroundColorButton4) {
        _backgroundColorButton4 = [self createBackgroundColorButton:6 color:[UIColor colorWithRed:128 / 255.0 green:159 / 255.0 blue:129 / 255.0 alpha:1]];
    }
    return _backgroundColorButton4;
}
- (UIButton *)backgroundColorButton5 {
    if (!_backgroundColorButton5) {
        _backgroundColorButton5 = [self createBackgroundColorButton:7 color:[UIColor colorWithRed:41 / 255.0 green:62 / 255.0 blue:88 / 255.0 alpha:1]];
    }
    return _backgroundColorButton5;
}
- (UIButton *)backgroundColorButton6 {
    if (!_backgroundColorButton6) {
        _backgroundColorButton6 = [self createBackgroundColorButton:8 color:[UIColor colorWithRed:76 / 255.0 green:62 / 255.0 blue:56 / 255.0 alpha:1]];
    }
    return _backgroundColorButton6;
}
- (UIButton *)spaceButton1 {
    if (!_spaceButton1) {
        _spaceButton1 = [self createButtont:9 text:@"间距1"];
    }
    return _spaceButton1;
}
- (UIButton *)spaceButton2 {
    if (!_spaceButton2) {
        _spaceButton2 = [self createButtont:10 text:@"间距2"];
    }
    return _spaceButton2;
}
- (UIButton *)spaceButton3 {
    if (!_spaceButton3) {
        _spaceButton3 = [self createButtont:11 text:@"间距3"];
    }
    return _spaceButton3;
}
- (UIButton *)curlButton {
    if (!_curlButton) {
        _curlButton = [self createButtont:12 text:@"仿真"];
    }
    return _curlButton;
}
- (UIButton *)scrollButton {
    if (!_scrollButton) {
        _scrollButton = [self createButtont:13 text:@"平滑"];
    }
    return _scrollButton;
}
- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [self createButtont:14 text:@"覆盖"];
    }
    return _coverButton;
}
- (UIButton *)noneButton {
    if (!_noneButton) {
        _noneButton = [self createButtont:15 text:@"无"];
    }
    return _noneButton;
}
@end
