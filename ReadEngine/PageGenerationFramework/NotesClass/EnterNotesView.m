//
//  EnterNotesView.m
//  创新版
//
//  Created by XuPeng on 16/5/27.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "EnterNotesView.h"
#import "InputTextView.h"

#define kMainViewWidth       [[UIScreen mainScreen] bounds].size.width
#define kMainViewHeight      [[UIScreen mainScreen] bounds].size.height

@implementation EnterNotesView {
    InputTextView     *_inputTextView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame           = CGRectMake(0, 0, kMainViewWidth, kMainViewHeight);
        self.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
        [self initializeView];
    }
    return self;
}
- (void)initializeView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIView *navigationView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainViewWidth, 64)];
    navigationView.backgroundColor = [UIColor colorWithRed:252 /255.0 green:136 / 255.0 blue:68 / 255.0 alpha:1];
    [self addSubview:navigationView];
    UILabel *titleLabel            = [[UILabel alloc] initWithFrame:CGRectMake(kMainViewWidth / 2 - 22, 20, 44, 44)];
    titleLabel.backgroundColor     = [UIColor colorWithRed:252 /255.0 green:136 / 255.0 blue:68 / 255.0 alpha:1];
    titleLabel.textColor           = [UIColor whiteColor];
    titleLabel.textAlignment       = NSTextAlignmentCenter;
    titleLabel.font                = [UIFont systemFontOfSize:18.0f];
    titleLabel.text                = @"笔记";
    [navigationView addSubview:titleLabel];
    UIButton *leftButton           = [UIButton buttonWithType:0];
    leftButton.frame               = CGRectMake(0, 20, 100, 44);
    leftButton.tag                 = 1;
    UILabel *leftButtonTitle       = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0, 44, 44)];
    leftButtonTitle.text           = @"放弃";
    leftButtonTitle.font           = [UIFont systemFontOfSize:15.0f];
    leftButtonTitle.textColor      = [UIColor whiteColor];
    leftButtonTitle.textAlignment  = NSTextAlignmentLeft;
    [leftButton addSubview:leftButtonTitle];
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:leftButton];
    UIButton *rightButton          = [UIButton buttonWithType:0];
    rightButton.frame              = CGRectMake(kMainViewWidth - 100, 20, 100, 44);
    rightButton.tag                = 2;
    UILabel *rightButtonTitle      = [[UILabel alloc] initWithFrame:CGRectMake(100 - 12 - 44, 0, 44, 44)];
    rightButtonTitle.text          = @"完成";
    rightButtonTitle.font          = [UIFont systemFontOfSize:15.0f];
    rightButtonTitle.textColor     = [UIColor whiteColor];
    rightButtonTitle.textAlignment = NSTextAlignmentRight;
    [rightButton addSubview:rightButtonTitle];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:rightButton];
}
- (void)buttonClick:(UIButton *)button {
    self.noteContentStr = [_inputTextView get_inputTextViewContent];
    [_inputTextView closeTheKeyboard];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (button.tag == 1) {
        [self.delegate enterNotesViewGoBack:self isSave:NO];
    } else if (button.tag == 2) {
        [self.delegate enterNotesViewGoBack:self isSave:YES];
    }
}
- (void)setSelectedContentStr:(NSString *)selectedContentStr {
    if (!selectedContentStr) {
        selectedContentStr = @"";
    }
    _selectedContentStr                     = selectedContentStr;
    UITextView *showTextView                = [[UITextView alloc] init];
    showTextView.frame                      = CGRectMake(0, 64, kMainViewWidth, 112);
    showTextView.backgroundColor            = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1];
    showTextView.delegate                   = self;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = 10;
    NSDictionary *attributes                = @{
                                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                     NSParagraphStyleAttributeName:paragraphStyle
                                                     };
    showTextView.attributedText             = [[NSAttributedString alloc] initWithString:selectedContentStr attributes:attributes];
    showTextView.textContainerInset         = UIEdgeInsetsMake(10, 10, 10, 0);
    [self addSubview:showTextView];
    UIView *lineTop                         = [[UIView alloc] init];
    lineTop.frame                           = CGRectMake(0, showTextView.frame.origin.y + showTextView.frame.size.height, showTextView.frame.size.width, 1);
    lineTop.backgroundColor                 = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    [self addSubview:lineTop];
    UIView *lineBottom                      = [[UIView alloc] init];
    lineBottom.frame                        = CGRectMake(0, lineTop.frame.origin.y + lineTop.frame.size.height + 10, lineTop.frame.size.width, 1);
    lineBottom.backgroundColor              = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    [self addSubview:lineBottom];
    _inputTextView                          = [[InputTextView alloc] initWithTextStr:self.noteContentStr];
    _inputTextView.frame                    = CGRectMake(0, lineBottom.frame.origin.y + lineBottom.frame.size.height, kMainViewWidth, kMainViewHeight - lineBottom.frame.origin.y - lineBottom.frame.size.height);
    [self addSubview:_inputTextView];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

@end
