//
//  BottomMenuView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BottomMenuView.h"

@interface BottomMenuView ()

@property (nonatomic, strong) UIButton *beforeButton;
@property (nonatomic, strong) UIButton *afterButton;
@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *directoryButton;
@property (nonatomic, strong) UIButton *nightButton;
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

- (void)setProgress:(CGFloat)progress {
    self.progressSlider.value = progress;
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithRed:77 / 255.0 green:61 / 255.0 blue:31 / 255.0 alpha:0.97];
    
    [self addSubview:self.beforeButton];
    self.beforeButton.wd_layout
    .topEqualToSuperView()
    .leftSpaceToSuperView(15)
    .width(44)
    .height(44);
    
    [self addSubview:self.afterButton];
    self.afterButton.wd_layout
    .topEqualToSuperView()
    .rightSpaceToSuperView(15)
    .widthEqualToView(self.beforeButton)
    .heightEqualToView(self.beforeButton);
    
    [self addSubview:self.progressSlider];
    self.progressSlider.wd_layout
    .centerYEqualToView(self.beforeButton)
    .leftSpaceToView(self.beforeButton, 10)
    .rightSpaceToView(self.afterButton, 10);

    [self addSubview:self.lineView];
    self.lineView.wd_layout
    .topSpaceToView(self.beforeButton, 0)
    .leftEqualToSuperView()
    .rightEqualToSuperView()
    .height(0.5);
    
    [self addSubview:self.directoryButton];
    self.directoryButton.wd_layout
    .topSpaceToView(self.lineView, 0)
    .leftSpaceToSuperView(5)
    .width(44)
    .height(44);
    
    [self addSubview:self.nightButton];
    self.nightButton.wd_layout
    .topEqualToView(self.directoryButton)
    .centerXEqualToSuperView()
    .width(44)
    .height(44);
    
    [self addSubview:self.setButton];
    self.setButton.wd_layout
    .topEqualToView(self.directoryButton)
    .rightSpaceToSuperView(5)
    .width(44)
    .height(44);
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

- (UIButton *)createButtont: (NSInteger)tag {
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button setTitleColor:[UIColor colorWithRed:155 / 255.0 green:140 / 255.0 blue:104 / 255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - get/set
- (UIButton *)beforeButton {
    if (!_beforeButton) {
        _beforeButton = [self createButtont:1];
        [_beforeButton setTitle:@"上一章" forState:UIControlStateNormal];
    }
    return _beforeButton;
}
- (UIButton *)afterButton {
    if (!_afterButton) {
        _afterButton = [self createButtont:2];
        [_afterButton setTitle:@"下一章" forState:UIControlStateNormal];
    }
    return _afterButton;
}
- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        _progressSlider.minimumValue = 0;
        _progressSlider.maximumValue = 1;
        _progressSlider.value = 0;
        _progressSlider.continuous = YES;
        _progressSlider.minimumTrackTintColor = [UIColor colorWithRed:147 / 255.0 green:81 / 255.0 blue:44 / 255.0 alpha:1];
        _progressSlider.maximumTrackTintColor = [UIColor colorWithRed:82 / 255.0 green:69 / 255.0 blue:33 / 255.0 alpha:1];
        _progressSlider.thumbTintColor = [UIColor colorWithRed:147 / 255.0 green:81 / 255.0 blue:44 / 255.0 alpha:1];
        [_progressSlider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _progressSlider;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:85 / 255.0 green:71 / 255.0 blue:36 / 255.0 alpha:1];
    }
    return _lineView;
}
- (UIButton *)directoryButton {
    if (!_directoryButton) {
        _directoryButton = [self createButtont:3];
        [_directoryButton setImage:[UIImage imageNamed:@"directoryImage"] forState:UIControlStateNormal];
    }
    return _directoryButton;
}
- (UIButton *)nightButton {
    if (!_nightButton) {
        _nightButton = [self createButtont:4];
        [_nightButton setImage:[UIImage imageNamed:@"nightImage"] forState:UIControlStateNormal];
    }
    return _nightButton;
}
- (UIButton *)setButton {
    if (!_setButton) {
        _setButton = [self createButtont:5];
        [_setButton setTitle:@"Aa" forState:UIControlStateNormal];
        _setButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _setButton;
}
//@property (nonatomic, strong) UIButton *setButton;

@end
