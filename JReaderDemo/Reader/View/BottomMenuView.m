//
//  BottomMenuView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BottomMenuView.h"

@interface BottomMenuView ()

@property (nonatomic, strong) UIButton *fontAddButton;
@property (nonatomic, strong) UIButton *fontSubButton;

@property (nonatomic, strong) UIButton *brightnessAddButton;
@property (nonatomic, strong) UIButton *brightnessSubButton;

@property (nonatomic, strong) UIButton *lineSpaceAddButton;
@property (nonatomic, strong) UIButton *lineSpaceSubButton;

@property (nonatomic, strong) UIButton *colorButton1;
@property (nonatomic, strong) UIButton *colorButton2;

@property (nonatomic, strong) UIButton *curlButton;
@property (nonatomic, strong) UIButton *scrollButton;
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UIButton *noneButton;

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
    self.backgroundColor = [UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1];
    [self addSubview:self.fontAddButton];
    self.fontAddButton.wd_layout
    .leftSpaceToSuperView(60)
    .bottomSpaceToSuperView(10)
    .width(60)
    .height(30);
    
    [self addSubview:self.fontSubButton];
    self.fontSubButton.wd_layout
    .topEqualToView(self.fontAddButton)
    .rightSpaceToSuperView(60)
    .bottomEqualToView(self.fontAddButton)
    .widthEqualToView(self.fontAddButton);
    
    [self addSubview:self.brightnessAddButton];
    self.brightnessAddButton.wd_layout
    .leftEqualToView(self.fontAddButton)
    .bottomSpaceToView(self.fontAddButton, 10)
    .rightEqualToView(self.fontAddButton)
    .heightEqualToView(self.fontAddButton);
    
    [self addSubview:self.brightnessSubButton];
    self.brightnessSubButton.wd_layout
    .leftEqualToView(self.fontSubButton)
    .bottomSpaceToView(self.fontSubButton, 10)
    .rightEqualToView(self.fontSubButton)
    .heightEqualToView(self.fontAddButton);
    
    [self addSubview:self.lineSpaceAddButton];
    self.lineSpaceAddButton.wd_layout
    .leftEqualToView(self.brightnessAddButton)
    .bottomSpaceToView(self.brightnessAddButton, 10)
    .rightEqualToView(self.brightnessAddButton)
    .heightEqualToView(self.fontAddButton);
    
    [self addSubview:self.lineSpaceSubButton];
    self.lineSpaceSubButton.wd_layout
    .leftEqualToView(self.brightnessSubButton)
    .bottomSpaceToView(self.brightnessSubButton, 10)
    .rightEqualToView(self.brightnessSubButton)
    .heightEqualToView(self.fontAddButton);
    
    [self addSubview:self.colorButton1];
    self.colorButton1.wd_layout
    .leftEqualToView(self.brightnessAddButton)
    .bottomSpaceToView(self.lineSpaceAddButton, 10)
    .rightEqualToView(self.lineSpaceAddButton)
    .heightEqualToView(self.fontAddButton);
    
    [self addSubview:self.colorButton2];
    self.colorButton2.wd_layout
    .leftEqualToView(self.lineSpaceSubButton)
    .bottomSpaceToView(self.lineSpaceSubButton, 10)
    .rightEqualToView(self.lineSpaceSubButton)
    .heightEqualToView(self.fontAddButton);
    
    CGFloat spacing = (SCREEN_WIDTH - 60 * 4) / 5;
    
    [self addSubview:self.curlButton];
    self.curlButton.wd_layout
    .leftSpaceToSuperView(spacing)
    .bottomSpaceToView(self.colorButton1, 10)
    .width(60)
    .height(30);
    
    [self addSubview:self.scrollButton];
    self.scrollButton.wd_layout
    .centerYEqualToView(self.curlButton)
    .leftSpaceToView(self.curlButton, spacing)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);
    
    [self addSubview:self.coverButton];
    self.coverButton.wd_layout
    .centerYEqualToView(self.curlButton)
    .leftSpaceToView(self.scrollButton, spacing)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);
    
    [self addSubview:self.noneButton];
    self.noneButton.wd_layout
    .centerYEqualToView(self.curlButton)
    .leftSpaceToView(self.coverButton, spacing)
    .widthEqualToView(self.curlButton)
    .heightEqualToView(self.curlButton);
    
}

- (void)buttonClick: (UIButton *)button {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(@(button.tag));
    }
}

- (UIButton *)createButton: (NSString *)title tag: (NSInteger)tag {
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    
    return button;
}

#pragma mark - get/set
- (UIButton *)fontAddButton {
    if (!_fontAddButton) {
        _fontAddButton = [self createButton:@"A+" tag:1];
    }
    return _fontAddButton;
}
- (UIButton *)fontSubButton {
    if (!_fontSubButton) {
        _fontSubButton = [self createButton:@"A-" tag:2];
    }
    return _fontSubButton;
}
- (UIButton *)brightnessAddButton {
    if (!_brightnessAddButton) {
        _brightnessAddButton = [self createButton:@"亮度+" tag:3];
    }
    return _brightnessAddButton;
}
- (UIButton *)brightnessSubButton {
    if (!_brightnessSubButton) {
        _brightnessSubButton = [self createButton:@"亮度-" tag:4];
    }
    return _brightnessSubButton;
}
- (UIButton *)lineSpaceAddButton {
    if (!_lineSpaceAddButton) {
        _lineSpaceAddButton = [self createButton:@"间距+" tag:5];
    }
    return _lineSpaceAddButton;
}
- (UIButton *)lineSpaceSubButton {
    if (!_lineSpaceSubButton) {
        _lineSpaceSubButton = [self createButton:@"间距-" tag:6];
    }
    return _lineSpaceSubButton;
}
- (UIButton *)colorButton1 {
    if (!_colorButton1) {
        _colorButton1 = [self createButton:@"颜色1" tag:7];
    }
    return _colorButton1;
}
- (UIButton *)colorButton2 {
    if (!_colorButton2) {
        _colorButton2 = [self createButton:@"颜色2" tag:8];
    }
    return _colorButton2;
}
- (UIButton *)curlButton {
    if (!_curlButton) {
        _curlButton = [self createButton:@"仿真" tag:9];
    }
    return _curlButton;
}
- (UIButton *)scrollButton {
    if (!_scrollButton) {
        _scrollButton = [self createButton:@"平滑" tag:10];
    }
    return _scrollButton;
}
- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [self createButton:@"覆盖" tag:11];
    }
    return _coverButton;
}
- (UIButton *)noneButton {
    if (!_noneButton) {
        _noneButton = [self createButton:@"无" tag:12];
    }
    return _noneButton;
}

@end
