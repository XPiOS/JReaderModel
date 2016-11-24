//
//  InputTextView.m
//  创新版
//
//  Created by XuPeng on 16/5/30.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "InputTextView.h"

@implementation InputTextView {
    UITextView             *_inputTextView;
    NSString               *_textStr;
}

- (instancetype)initWithTextStr:(NSString *)textStr {
    self = [super init];
    if (self) {
        _textStr = textStr;
    }
    return self;
}

#pragma mark - 对外暴露方法
- (NSString *)get_inputTextViewContent {
    return _inputTextView.text;
}
- (void)closeTheKeyboard {
    [_inputTextView resignFirstResponder];
}

#pragma mark - 重写父类方法
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _inputTextView                   = [[UITextView alloc] init];
    _inputTextView.frame                          = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _inputTextView.backgroundColor                = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1];
    // 设置文本样式
    NSMutableParagraphStyle *inputParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    inputParagraphStyle.lineSpacing              = 10;// 字体的行间距
    
    if (_textStr && _textStr.length > 0) {
        NSDictionary *inputAttributes                = @{
                                                         NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                         NSForegroundColorAttributeName:[UIColor blackColor],
                                                         NSParagraphStyleAttributeName:inputParagraphStyle
                                                         };
       _inputTextView.attributedText                 = [[NSAttributedString alloc] initWithString:_textStr attributes:inputAttributes];
    } else {
        NSDictionary *inputAttributes                = @{
                                                         NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                         NSForegroundColorAttributeName:[UIColor colorWithRed:217 / 255.0 green:217 / 255.0 blue:217 / 255.0 alpha:1],
                                                         NSParagraphStyleAttributeName:inputParagraphStyle
                                                         };
        _inputTextView.attributedText                 = [[NSAttributedString alloc] initWithString:@"请输入您想说的话" attributes:inputAttributes];
    }
    
    _inputTextView.textContainerInset             = UIEdgeInsetsMake(10, 10, 10, 0);//设置页边距
    _inputTextView.delegate = self;
    [self addSubview:_inputTextView];
}

#pragma mark - UITextView代理
//开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"开始编辑");
    textView.textColor = [UIColor blackColor];
    if (!_textStr || _textStr.length == 0) {
        textView.text = @"";
    }
}

@end
