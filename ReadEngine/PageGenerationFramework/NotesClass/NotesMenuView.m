//
//  NotesMenuView.m
//  创新版
//
//  Created by XuPeng on 16/5/25.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "NotesMenuView.h"

#define kNotesMenuViewX        -15.0f
#define kNotesMenuViewY        -53.0f
#define kNotesMenuViewWidth    ([[UIScreen mainScreen] bounds].size.width)
#define kNotesMenuViewHeight   ([[UIScreen mainScreen] bounds].size.height)

#define kMenuViewX             15.0f
#define kMenuViewY             0.0f
#define kMenuViewWidth         (kNotesMenuViewWidth - 30.0f)
#define kMenuViewHeight        138.0f

#define kItemWidth             (kMenuViewWidth / 5)
#define kitemButtonX           ((kItemWidth - kItemButtonWidth) / 2.0)
#define kitemButtonY           15.0f

#define kItemButtonWidth       33.0f
#define kItemButtonHeight      33.0f

#define kMainViewWidth         [[UIScreen mainScreen] bounds].size.width
#define kMainViewHeight        [[UIScreen mainScreen] bounds].size.height

@implementation NotesMenuView {
    CGPoint                    _point;
    BOOL                       _isUp;
    UIButton                   *_orangeButton;
    UIButton                   *_blueButton;
    UIButton                   *_greenButton;
    UIButton                   *_purpleButton;
    UIButton                   *_deleteButton;
    UIImageView                *_triangleImageView;
    UIView                     *_tapView;
    UITapGestureRecognizer     *_tapGestureRecognizer;
    UIView                     *_menuView;
}

+ (NotesMenuView *)shareNotesMenuView:(CGPoint)point isUp:(BOOL)isUp {
    NotesMenuView *notesMenuView = [[NotesMenuView alloc] initWithPoint:point isUp:isUp];
    return notesMenuView;
}
- (instancetype)initWithPoint:(CGPoint)point isUp:(BOOL)isUp {
    self = [super init];
    if (self) {
        _point = point;
        _isUp  = isUp;
        [self initializeView];
    }
    return self;
}
- (void)initializeView {
    self.frame                   = CGRectMake(kNotesMenuViewX, kNotesMenuViewY, kNotesMenuViewWidth, kNotesMenuViewHeight);
    self.backgroundColor         = [UIColor clearColor];
    _tapView                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNotesMenuViewWidth, kNotesMenuViewHeight)];
    _tapView.backgroundColor     = [UIColor clearColor];
    _tapGestureRecognizer        = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick)];
    [_tapView addGestureRecognizer:_tapGestureRecognizer];
    [self addSubview:_tapView];
    _menuView                    = [[UIView alloc] init];
    _menuView.backgroundColor    = [UIColor colorWithRed:34 / 255.0 green:34 / 255.0 blue:34 / 255.0 alpha:0.95f];
    _menuView.layer.cornerRadius = 10.0f;
    if (_triangleImageView) {
        [_triangleImageView removeFromSuperview];
    }
    UIImage *image           = [UIImage imageNamed:@"三角形"];
    _triangleImageView       = [[UIImageView alloc] initWithImage:image];
    [_menuView addSubview:_triangleImageView];
    _triangleImageView.frame = CGRectMake(100, -image.size.height + 0.5,  image.size.width, image.size.height);
    if (_isUp) {
        _menuView.frame              = CGRectMake(kMenuViewX, _point.y + 53 + image.size.height, kMenuViewWidth, kMenuViewHeight);
    } else {
        _triangleImageView.transform = CGAffineTransformRotate(_triangleImageView.transform, M_PI);
        CGRect rect                  = _triangleImageView.frame;
        rect.origin.y                = kMenuViewHeight;
        _triangleImageView.frame     = rect;
        _menuView.frame              = CGRectMake(kMenuViewX, _point.y - kMenuViewHeight - image.size.height, kMenuViewWidth, kMenuViewHeight);
    }
    [self addSubview:_menuView];
    for (NSInteger i = 0; i < 5; i++) {
        [self createFirstRowButton:i];
    }
    for (NSInteger i = 0; i < 2; i ++) {
        [self createSecondRowButton:i];
    }
}
- (void)tapGestureRecognizerClick {
    CGPoint point = [_tapGestureRecognizer locationInView:self];
    CGRect rect   = _menuView.frame;
    if (!CGRectContainsPoint(rect, point)) {
        [self.delegate deleteNotesMenuView:self];
    }
}
- (void)createFirstRowButton:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:0];
    CGRect rect      = CGRectMake(kitemButtonX, kitemButtonY, kItemButtonWidth, kItemButtonHeight);
    switch (index) {
        case 0: {
            button.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:136 / 255.0 blue:68 / 255.0 alpha:1];
            button.frame           = rect;
            _orangeButton          = button;
            break;
        }
        case 1: {
            button.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1];
            rect.origin.x          = kitemButtonX + kItemWidth;
            button.frame           = rect;
            _blueButton            = button;
            break;
        }
        case 2: {
            button.backgroundColor = [UIColor colorWithRed:86 / 255.0 green:187 / 255.0 blue:54 / 255.0 alpha:1];
            rect.origin.x          = kitemButtonX + kItemWidth * 2;
            button.frame           = rect;
            _greenButton           = button;
            break;
        }
        case 3: {
            button.backgroundColor = [UIColor colorWithRed:164 / 255.0 green:95 / 255.0 blue:223 / 255.0 alpha:1];
            rect.origin.x          = kitemButtonX + kItemWidth * 3;
            button.frame           = rect;
            _purpleButton          = button;
            break;
        }
        case 4: {
            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"删除"]];
            rect.origin.x          = kitemButtonX + kItemWidth * 4;
            button.frame           = rect;
            _deleteButton          = button;
            break;
        }
        default:
            break;
    }
    button.layer.cornerRadius = 33 / 2.0f;
    button.tag                = index;
    [button addTarget:self action:@selector(firstRowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:button];
}
- (void)firstRowButtonClick:(UIButton *)button {
    if (button.tag == 4) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(notesMenuViewDelete:)]){
            [self.delegate notesMenuViewDelete:self];
        }
    } else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(drawBottomLineColor:)]){
            [self.delegate drawBottomLineColor:button.tag];
        }
    }
}
- (void)createSecondRowButton:(NSInteger)index {
    UIButton *button               = [UIButton buttonWithType:0];
    CGRect rect                    = CGRectMake(kitemButtonX, kitemButtonY + kItemButtonHeight + 20, kItemButtonWidth, kItemButtonHeight + 21);
    button.backgroundColor         = [UIColor clearColor];
    UIImageView *buttonImageView   = [[UIImageView alloc] init];
    buttonImageView.frame          = CGRectMake(0, 0, kItemButtonWidth, kItemButtonHeight);
    [button addSubview:buttonImageView];

    UILabel *buttonTitleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, kItemButtonWidth, 10)];
    buttonTitleLabel.font          = [UIFont systemFontOfSize:12.0f];
    buttonTitleLabel.textColor     = [UIColor colorWithRed:178 / 255.0 green:178 / 255.0 blue:178 / 255.0 alpha:1];
    buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
    [button addSubview:buttonTitleLabel];
    switch (index) {
        case 0: {
            button.frame = rect;
            buttonImageView.image = [UIImage imageNamed:@"复制"];
            buttonTitleLabel.text = @"复制";
            _orangeButton = button;
            break;
        }
        case 1: {
            rect.origin.x = kitemButtonX + kItemWidth;
            button.frame = rect;
            buttonImageView.image = [UIImage imageNamed:@"笔记"];
            buttonTitleLabel.text = @"笔记";
            _blueButton = button;
            break;
        }
        default:
            break;
    }
    button.layer.cornerRadius = 33 / 2.0f;
    button.tag                = index;
    [button addTarget:self action:@selector(secondRowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:button];
}
- (void)secondRowButtonClick:(UIButton *)button {
    if (button.tag == 0) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(notesMenuViewCopy:)]){
            [self.delegate notesMenuViewCopy:self];
        }
    }
    if (button.tag == 1) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(notesMenuViewNotes:)]){
            [self.delegate notesMenuViewNotes:self];
        }
    }
}

@end
