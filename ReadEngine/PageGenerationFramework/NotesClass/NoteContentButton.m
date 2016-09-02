//
//  NoteContentButton.m
//  创新版
//
//  Created by XuPeng on 16/5/27.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "NoteContentButton.h"

#define kMainViewWidth      [[UIScreen mainScreen] bounds].size.width
#define kMainViewHeight     [[UIScreen mainScreen] bounds].size.height

#define kShowViewX          self.superview.frame.origin.x
#define kShowViewY1         (self.frame.origin.y + 100)
#define kShowViewY2         (self.frame.origin.y - kShowViewHeight)
#define kShowViewY3         (kMainViewHeight / 2.0f - kShowViewHeight / 2.0f)
#define kShowViewWidth      self.superview.frame.size.width
#define kShowViewHeight     150

@implementation NoteContentButton {\
    BOOL         _isNight;
    UIColor      *_color;
    NSString     *_noteContent;
    UIButton     *_button;
    UIView       *_tapView;
    UIView       *_showView;
}

+ (NoteContentButton *)shareNoteContentButton:(UIColor *)color noteContent:(NSString *)noteContent  isNight:(BOOL)isNight {
    NoteContentButton *noteContentButton = [[NoteContentButton alloc] initWithColor:color noteContent:noteContent isNight:isNight];
    return noteContentButton;
}
- (instancetype)initWithColor:(UIColor *)color noteContent:(NSString *)noteContent isNight:(BOOL)isNight {
    self = [super init];
    if (self) {
        _isNight     = isNight;
        _color       = color;
        _noteContent = noteContent;
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick)];
    [self addGestureRecognizer:tap];
}

- (void)tapGestureRecognizerClick {
    _tapView                                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainViewWidth, kMainViewHeight)];
    _tapView.backgroundColor                     = [UIColor clearColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
    tapGestureRecognizer.delegate                = self;
    [_tapView addGestureRecognizer:tapGestureRecognizer];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_tapView];
    _showView                                    = [[UIView alloc] init];
    UIImage *image;
    UIImageView *imageView;
    if (_isNight) {
        _showView.backgroundColor = [UIColor colorWithRed:34 / 255.0 green:34 / 255.0 blue:34 / 255.0 alpha:1.0f];
        image                     = [UIImage imageNamed:@"阅读器-笔记框夜间三角形"];
    } else {
        _showView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:236 / 255.0 blue:185 / 255.0 alpha:1.0f];
        image                     = [UIImage imageNamed:@"阅读器-笔记框三角形"];
    }
    imageView                       = [[UIImageView alloc] initWithImage:image];
    [_showView addSubview:imageView];
    UITextView *showTextView        = [[UITextView alloc] init];
    showTextView.frame              = CGRectMake(0, 10, kShowViewWidth, 0);
    showTextView.layer.cornerRadius = 10;
    UIColor *textColor;
    if (_isNight) {
        showTextView.backgroundColor = [UIColor colorWithRed:34 / 255.0 green:34 / 255.0 blue:34 / 255.0 alpha:1.0f];
        textColor                    = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1.0f];
    } else {
        showTextView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:236 / 255.0 blue:185 / 255.0 alpha:1.0f];
        textColor                    = [UIColor blackColor];
    }
    showTextView.delegate                   = self;
    showTextView.textColor                  = [UIColor redColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = 10;
    NSDictionary *attributes                = @{
                                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                     NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName :textColor
                                                     };
    showTextView.attributedText             = [[NSAttributedString alloc] initWithString:_noteContent attributes:attributes];
    showTextView.textContainerInset         = UIEdgeInsetsMake(0, 10, 0, 0);
    [_showView addSubview:showTextView];
    _showView.layer.shadowColor             = [UIColor blackColor].CGColor;
    _showView.layer.shadowOffset            = CGSizeMake(4,4);
    _showView.layer.shadowOpacity           = 0.6;
    _showView.layer.shadowRadius            = 4;
    _showView.layer.cornerRadius            = 10;
    CGRect textFrame                        = [[showTextView layoutManager]usedRectForTextContainer:[showTextView textContainer]];
    CGFloat showTextViewHeight              = textFrame.size.height + 20;
    if (showTextViewHeight >= kShowViewHeight) {
        showTextViewHeight = kShowViewHeight;
    }
    showTextView.frame = CGRectMake(0, 10, kShowViewWidth, showTextViewHeight - 20);
    if (kShowViewY1 + showTextViewHeight + 44 <= kMainViewHeight) {
        _showView.frame     = CGRectMake(kShowViewX, kShowViewY1, kShowViewWidth, showTextViewHeight);
        imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI);
        imageView.frame     = CGRectMake(kShowViewWidth / 2 - image.size.width / 2, 1 - image.size.height, image.size.width, image.size.height);
    } else if (kShowViewY2 > 0) {
        _showView.frame     = CGRectMake(kShowViewX, kShowViewY2, kShowViewWidth, showTextViewHeight);
        imageView.frame     = CGRectMake(kShowViewWidth / 2 - image.size.width / 2, showTextViewHeight, image.size.width, image.size.height);
    } else {
        _showView.frame     = CGRectMake(kShowViewX, kShowViewY3, kShowViewWidth, showTextViewHeight);
        imageView.frame     = CGRectMake(kShowViewWidth / 2 - image.size.width / 2, showTextViewHeight, image.size.width, image.size.height);
    }
    [_tapView addSubview:_showView];
}
- (void)tapGestureRecognizerClick:(UITapGestureRecognizer *)tapGesture {
    [UIView animateWithDuration:0.5f animations:^{
        _showView.alpha = 0;
    } completion:^(BOOL finished) {
        [_showView removeFromSuperview];
        _showView       = nil;
        [_tapView removeFromSuperview];
        _tapView        = nil;
    }];
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    UIImage *image                = [UIImage imageNamed:@"笔记标志三点"];
    UIImageView *imageView        = [[UIImageView alloc] initWithImage:image];
    imageView.frame               = CGRectMake(0, 0, 14, 14);
    UIView *buttonView            = [[UIView alloc] init];
    buttonView.backgroundColor    = _color;
    buttonView.frame              = imageView.frame;
    buttonView.layer.cornerRadius = 7;
    [buttonView addSubview:imageView];
    [self addSubview:buttonView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:_tapView];
    CGRect rect   = _showView.frame;
    if (CGRectContainsPoint(rect, point)) {
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}
@end
