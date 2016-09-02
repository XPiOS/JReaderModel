//
//  ReaderView.m
//  创新版
//
//  Created by XuPeng on 16/5/21.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "ReaderView.h"
#import <CoreText/CoreText.h>
#import <AVFoundation/AVSpeechSynthesis.h>
#import "MagnifyingGlassView.h"
#import "NotesMenuView.h"
#import "CursorView.h"
#import "NoteContentButton.h"
#import "EnterNotesView.h"

#define kOrangeColor    [UIColor colorWithRed:252 / 255.0 green:136 / 255.0 blue:68 / 255.0 alpha:1]
#define kBlueColor      [UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0  alpha:1]
#define kGreenColor     [UIColor colorWithRed:86 / 255.0 green:187 / 255.0 blue:54 / 255.0  alpha:1]
#define kPurpleColor    [UIColor colorWithRed:164 / 255.0 green:95 / 255.0 blue:223 / 255.0 alpha:1]


@interface ReaderView ()<NotesMenuViewDelegate,EnterNotesViewDelegate>

@property (nonatomic, strong) CursorView          *leftCursor;
@property (nonatomic, strong) CursorView          *rightCursor;
@property (nonatomic, strong) MagnifyingGlassView *magnifierView;
@property (nonatomic, strong) UIImage             *magnifiterImage;
@property (nonatomic, strong)NotesMenuView        *notesMenuView;

@end

@implementation ReaderView {
    BOOL                         _isNight;
    CTFrameRef                   _ctFrame;
    NSMutableString              *_totalString;
    CGFloat                      _fontSize;
    UIColor                      *_fontColor;
    NSRange                      selectedRange;
    NSRange                      _bottomLineRange;
    UIColor                      *_bottomLineColor;
    BOOL                         _dragEnd;
    NSInteger                    _selectCursor;
    NSInteger                    _anchor;
    EnterNotesView               *_enterNotesView;
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    BOOL                         _isShowMenuView;
    UIPanGestureRecognizer       *_panGestureRecognizer;
    NSMutableDictionary          *_tapBottomLineDic;
}
- (void)dealloc
{
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame);
    }
}
- (instancetype)initWithFontSize:(CGFloat)fontSize pageRect:(CGRect)pageRect fontColor:(UIColor *)fontColor txtContent:(NSString *)txtContent backgroundColorImage:(UIImage *)backgroundColorImage isNight:(BOOL)isNight {
    self = [super initWithFrame:pageRect];
    if (self) {
        if (!txtContent) {
            txtContent = @"";
        }
        _totalString                  = [NSMutableString stringWithString:txtContent];
        _fontSize                     = fontSize;
        _fontColor                    = fontColor;
        _isNight                      = isNight;
        self.magnifiterImage          = backgroundColorImage;
        self.userInteractionEnabled   = YES;
        self.backgroundColor          = [UIColor clearColor];
        [self render];
        _longPressGestureRecognizer   = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:_longPressGestureRecognizer];
        _panGestureRecognizer         = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        _panGestureRecognizer.enabled = NO;
        [self addGestureRecognizer:_panGestureRecognizer];
    }
    return self;
}
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    CGPoint point = [longPress locationInView:self];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self removeCursor];
            [self hideMenuUI];
            if ([self isShowMenuView:point]) {
                _isShowMenuView = YES;
                return;
            }
            CFIndex index                 = [self getTouchIndexWithTouchPoint:point];
            _anchor                       = index;
            selectedRange.location        = index;
            selectedRange.length          = 1;
            self.magnifierView.touchPoint = point;
            [self setNeedsDisplay];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (_isShowMenuView) {
                return;
            }
            [self hideMenuUI];
            CFIndex index = [self getTouchIndexWithTouchPoint:point];
            if (index == -1) {
                return;
            }
            if (_anchor == -1) {
                _anchor = index;
            }
            [self removeCursor];
            self.magnifierView.touchPoint = point;
            if (index > _anchor) {
                selectedRange.location = _anchor;
                selectedRange.length   = index - _anchor;
            } else {
                selectedRange.location = index;
                selectedRange.length   = _anchor - index;
            }
            [self setNeedsDisplay];
            break;
        }
        default: {
            if (_isShowMenuView) {
                _isShowMenuView = NO;
                return;
            }
            [self removeMaginfierView];
            if (selectedRange.length <= 1) {
                CFIndex index = [self getTouchIndexWithTouchPoint:point];
                if (index != -1 && index < _totalString.length) {
                    NSRange range = [self characterRangeAtIndex:index];
                    selectedRange = NSMakeRange(range.location, range.length);
                } else {
                    break;
                }
            }
            if (selectedRange.length != 0 && selectedRange.location != NSNotFound ) {
                _dragEnd       = YES;
                _selectCursor  = 0;
                [self startEditMode];
                [self setNeedsDisplay];
            }
            break;
        }
    }
}
#pragma mark 拖动
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (_leftCursor && CGRectContainsPoint(CGRectMake(_leftCursor.frame.origin.x - 22, _leftCursor.frame.origin.y + _leftCursor.frame.size.height - 88, 44, 88), point)) {
            _selectCursor = -1;
            _anchor       = selectedRange.location + selectedRange.length;
        } else if (_rightCursor && CGRectContainsPoint(CGRectMake(_rightCursor.frame.origin.x - 22, _rightCursor.frame.origin.y, 44, 88), point)) {
            _selectCursor = 1;
            _anchor       = selectedRange.location;
        }else{
            [self removeMaginfierView];
        }
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        if (_selectCursor == 0) {
            return;
        }
        CFIndex index = [self getTouchIndexWithTouchPoint:point];
        self.magnifierView.touchPoint = point;
        [self hideMenuUI];
        if (index == -1) {
            return;
        }
        if (index > _anchor) {
            selectedRange.location = _anchor;
            selectedRange.length   = index - _anchor;
        } else {
            selectedRange.location = index;
            selectedRange.length   = _anchor - index;
        }
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded ||
              panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        _selectCursor    = 0;
        _dragEnd         = YES;
        [self removeMaginfierView];
    }
    [self setNeedsDisplay];
}

- (void)render {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:_totalString];
    [attrString setAttributes:self.coreTextAttributes range:NSMakeRange(0, attrString.length)];
    CTFramesetterRef frameSetter          = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path                        = CGPathCreateWithRect(self.bounds, NULL);
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame), _ctFrame = NULL;
    }
    _ctFrame                              = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(frameSetter);
}
- (NSDictionary *)coreTextAttributes
{
    UIFont *font_                           = [UIFont fontWithName:@"HelveticaNeue" size:_fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = font_.pointSize / 3;
    paragraphStyle.paragraphSpacing         = font_.pointSize * 0.5;
    paragraphStyle.alignment                = NSTextAlignmentJustified;
    NSDictionary *dic                       = @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font_,NSForegroundColorAttributeName:_fontColor};
    return dic;
}

- (void)drawRect:(CGRect)rect
{
    if (!_ctFrame) return;
    CGContextRef context        = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGAffineTransform transform = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, transform);
    [self showSelectRect:selectedRange];
    NSArray *subViewArr         = self.subviews;
    for (UIView *button in subViewArr) {
        if ([[NSString stringWithUTF8String:object_getClassName(button)] isEqualToString:@"NoteContentButton"]) {
            [button removeFromSuperview];
        }
    }
    for (NSMutableDictionary *dic in _bottomLineArr) {
        [self showBottomLine:dic];
    }
    CTFrameDraw(_ctFrame, context);
}
- (void)openOrClosedNotesFunction:(BOOL)notesState {
    self.userInteractionEnabled = notesState;
}
- (void)drawTitle:(NSString *)titleStr {
    if (!titleStr || [titleStr isEqualToString:@""]) {
        return;
    }
    CGFloat lineHeight   = [self getHeightByWidth:self.frame.size.width title:@"中文万维" font:[UIFont systemFontOfSize:_fontSize + 2]];
    CGFloat actualHeight = [self getHeightByWidth:self.frame.size.width title:titleStr font:[UIFont systemFontOfSize:_fontSize + 2]];
    UILabel *titleLabel;
    if (actualHeight > lineHeight) {
        titleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, lineHeight * 2)];
        titleLabel.numberOfLines = 2;
    } else {
        titleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, lineHeight)];
    }
    titleLabel.font           = [UIFont fontWithName:@"HelveticaNeue" size:_fontSize + 2];
    titleLabel.text           = titleStr;
    titleLabel.textColor      = _fontColor;
    [self addSubview:titleLabel];
    UIView *titleLine         = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height + 10, self.frame.size.width, 1)];
    titleLine.backgroundColor = _fontColor;
    [self addSubview:titleLine];
}
- (BOOL)isShowMenuView:(CGPoint)point {
    CFIndex index = [self getTouchIndexWithTouchPoint:point];
    if (index == -1) {
        return NO;
    }
    NSString *markStr;
    if (index + 5 < _totalString.length) {
        markStr = [_totalString substringWithRange:NSMakeRange(index, 5)];
    } else {
        markStr = [_totalString substringWithRange:NSMakeRange(_totalString.length - 5, 5)];
    }
    for (NSMutableDictionary *dic in _bottomLineArr) {
        NSString *bottomLineStr = dic[@"selectedContentStr"];
        if ([bottomLineStr rangeOfString:markStr].location != NSNotFound) {
            _tapBottomLineDic = dic;
            double pointY     = [dic[@"noteContentButtonY"] doubleValue];
            point.y           = pointY;
            if (self.frame.size.height - point.y > 138 + 26 + 88) {
                [self showMenuUI:point isUp:YES notesContentDic:dic];
            } else {
                if (point.y < 138 + 26) {
                    [self showMenuUI:CGPointMake(0, self.frame.size.width / 2) isUp:YES notesContentDic:dic];
                } else {
                    [self showMenuUI:point isUp:NO notesContentDic:dic];
                }
            }
            [self startEditMode];
            return YES;
        }
    }
    return NO;
}
- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text          = title;
    label.font          = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height      = label.frame.size.height;
    return height;
}
- (UIColor *)getColor:(NSString *)colorStr {
    NSInteger colorIndex = [colorStr integerValue];
    UIColor *color;
    switch (colorIndex) {
        default:
        case 0: {
            color = kOrangeColor;
            break;
        }
        case 1: {
            color = kBlueColor;
            break;
        }
        case 2: {
            color = kGreenColor;
            break;
        }
        case 3: {
            color = kPurpleColor;
            break;
        }
    }
    return color;
}
- (void)startEditMode {
    _panGestureRecognizer.enabled = YES;
    [self.delegate readerViewStartEditMode:self];
}
- (void)closeEditMode {
    _panGestureRecognizer.enabled = NO;
    [self.delegate readerViewCloseEditMode:self];
}
- (NSMutableArray *)calculateRangeArrayWithKeyWord:(NSString *)searchWord{
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < searchWord.length; i ++) {
        [blankWord appendString:@" "];
    }
    NSMutableArray *feedBackArray = [NSMutableArray array];
    for (int i = 0; i < INT_MAX; i++){
        if ([_totalString rangeOfString:searchWord options:1].location != NSNotFound){
            NSRange newRange = [_totalString rangeOfString:searchWord options:1];
            [feedBackArray addObject:NSStringFromRange(newRange)];
            [_totalString replaceCharactersInRange:newRange withString:blankWord];
            
        }else{
            break;
        }
    }
    return feedBackArray;
}
- (CTFrameRef)getCTFrame {
    return _ctFrame;
}
- (CGFloat)get_LastLinePosition {
    NSArray *lines   = (NSArray*)CTFrameGetLines([self getCTFrame]);
    if (lines.count == 0) {
        return 0;
    }
    CGPoint *origins            = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);
    CGPoint origin              = origins[lines.count - 1];
    CTLineRef line              = (__bridge CTLineRef) [lines objectAtIndex:lines.count - 1];
    CGFloat ascent, descent;
    CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
    CGRect selectionRect        = CGRectMake(0, origin.y - descent,0, 0);
    CGPoint rightCursorPoint    = CGRectFromString(NSStringFromCGRect(selectionRect)).origin;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform                   = CGAffineTransformScale(transform, 1.f, -1.f);
    rightCursorPoint            = CGPointApplyAffineTransform(rightCursorPoint, transform);
    free(origins);
    return rightCursorPoint.y;
}
- (void)showSelectRect:(NSRange)selectRect{
    if (selectRect.length == 0 || selectRect.location == NSNotFound) {
        return;
    }
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    NSArray *lines            = (NSArray*)CTFrameGetLines([self getCTFrame]);
    CGPoint *origins          = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line       = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange    = CTLineGetStringRange(line);
        NSRange range        = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:selectRect];
        if (intersection.length > 0) {
            CGFloat xStart       = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);
            CGFloat xEnd         = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint origin       = origins[i];
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(origin.x + xStart, origin.y - descent, xEnd - xStart, ascent + descent);
            [pathRects addObject:NSStringFromCGRect(selectionRect)];
        }
    }
    free(origins);
    [self drawPathFromRects:pathRects];
}
- (void)showBottomLine:(NSMutableDictionary *)bottomLineDic {
    NSString *bottomLineStr = bottomLineDic[@"selectedContentStr"];
    NSString *headStr, *tailStr;
    NSRange bottomLineRange, headRange, tailRange;
    if (bottomLineStr.length >= 10) {
        headStr = [bottomLineStr substringToIndex:10];
        tailStr = [bottomLineStr substringFromIndex:bottomLineStr.length - 10];
    } else {
        headStr = tailStr = bottomLineStr;
    }
    headRange = [_totalString rangeOfString:headStr];
    tailRange = [_totalString rangeOfString:tailStr];
    if (headRange.location != NSNotFound && tailRange.location == NSNotFound) {
        bottomLineRange.location = headRange.location;
        bottomLineRange.length   = _totalString.length - headRange.location;
    } else if (headRange.location == NSNotFound && tailRange.location != NSNotFound) {
        bottomLineRange.location = 0;
        bottomLineRange.length   = tailRange.location + tailRange.length;
    } else {
        bottomLineRange          = [_totalString rangeOfString:bottomLineStr];
    }
    if (bottomLineRange.length == 0 || bottomLineRange.location == NSNotFound) {
        return;
    }
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    NSArray *lines            = (NSArray*)CTFrameGetLines([self getCTFrame]);
    CGPoint *origins          = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);
    
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line       = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange    = CTLineGetStringRange(line);
        NSRange range        = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:bottomLineRange];
        if (intersection.length > 0) {
            
            CGFloat xStart       = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);
            CGFloat xEnd         = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint origin       = origins[i];
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(origin.x + xStart, origin.y - descent, xEnd - xStart, 2);
            [pathRects addObject:NSStringFromCGRect(selectionRect)];
        }
    }
    free(origins);
    [self drawBottomLineFromRects:pathRects bottomLineDic:bottomLineDic];
}

- (void)drawBottomLineFromRects:(NSMutableArray*)array bottomLineDic:(NSMutableDictionary *)bottomLineDic {
    UIColor *color = [self getColor:bottomLineDic[@"color"]];
    if (array==nil || [array count] == 0) {
        return;
    }
    CGMutablePathRef _path = CGPathCreateMutable();
    [_bottomLineColor setFill];
    for (int i = 0; i < [array count]; i++) {
        CGRect firstRect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(_path, NULL, firstRect);
    }
    [self setNoteContentButtonFrame:array bottomLineDic:bottomLineDic];
    CGContextRef ctx          = UIGraphicsGetCurrentContext();
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], components[3]);    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
}
- (void)drawPathFromRects:(NSMutableArray*)array {
    if (array==nil || [array count] == 0) {
        return;
    }
    CGFloat height = 0.0f;
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0  alpha:0.2f] setFill];
    for (int i = 0; i < [array count]; i++) {
        CGRect firstRect = CGRectFromString([array objectAtIndex:i]);
        height           = firstRect.size.height;
        CGPathAddRect(_path, NULL, firstRect);
    }
    [self showCursor:height];
    [self resetCursor:array];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
}

- (void)setNoteContentButtonFrame:(NSMutableArray *)rectArray bottomLineDic:(NSMutableDictionary *)bottomLineDic {
    UIColor *color              = [self getColor:bottomLineDic[@"color"]];
    NSString *noteContentStr    = bottomLineDic[@"noteContentStr"];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform                   = CGAffineTransformScale(transform, 1.f, -1.f);
    CGPoint rightCursorPoint    = CGRectFromString([rectArray lastObject]).origin;
    rightCursorPoint.x          = rightCursorPoint.x + CGRectFromString([rectArray lastObject]).size.width;
    rightCursorPoint            = CGPointApplyAffineTransform(rightCursorPoint, transform);
    bottomLineDic[@"noteContentButtonY"] = [NSString stringWithFormat:@"%f",rightCursorPoint.y];
    if (noteContentStr && ![noteContentStr isEqualToString:@""]) {
        NoteContentButton *noteContentButton = [NoteContentButton shareNoteContentButton:color noteContent:noteContentStr isNight:_isNight];
        noteContentButton.frame              = CGRectMake(rightCursorPoint.x, rightCursorPoint.y - 8, 44, 44);
        [self addSubview:noteContentButton];
        [self sendSubviewToBack:noteContentButton];
    }
}
- (void)resetCursor:(NSMutableArray*)rectArray{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform                   = CGAffineTransformScale(transform, 1.f, -1.f);
    CGPoint leftCursorPoint     = CGRectFromString([rectArray objectAtIndex:0]).origin;
    leftCursorPoint             = CGPointApplyAffineTransform(leftCursorPoint, transform);
    _leftCursor.setupPoint      = leftCursorPoint;
    CGPoint rightCursorPoint    = CGRectFromString([rectArray lastObject]).origin;
    rightCursorPoint.x          = rightCursorPoint.x + CGRectFromString([rectArray lastObject]).size.width;
    rightCursorPoint            = CGPointApplyAffineTransform(rightCursorPoint, transform);
    _rightCursor.setupPoint     = rightCursorPoint;
    if (_dragEnd) {
        NSMutableDictionary *notesContentDic = [NSMutableDictionary dictionary];
        notesContentDic[@"selectedContentStr"] = [_totalString substringWithRange:selectedRange];
        if (self.frame.size.height- rightCursorPoint.y > 138 + 26 + 88) {
            [self showMenuUI:rightCursorPoint isUp:YES notesContentDic:notesContentDic];
        } else {
            if (leftCursorPoint.y < 138 + 26) {
                [self showMenuUI:CGPointMake(0, self.frame.size.width / 2) isUp:YES notesContentDic:notesContentDic];
            } else {
                [self showMenuUI:leftCursorPoint isUp:NO notesContentDic:notesContentDic];
            }
        }
    }
    _dragEnd = NO;
}

- (void)showCursor:(CGFloat)height {
    if (selectedRange.length == 0 || selectedRange.location == NSNotFound ) {
        return;
    }
    [self removeCursor];
    _leftCursor  = [[CursorView alloc] initWithType:CursorLeft andHeight:height byDrawColor:[UIColor blueColor]];
    _rightCursor = [[CursorView alloc] initWithType:CursorRight andHeight:height byDrawColor:[UIColor blueColor]];
    [self addSubview:_leftCursor];
    [self addSubview:_rightCursor];
    [self setNeedsDisplay];
}
- (void)hideMenuUI {
    [self.notesMenuView removeFromSuperview];
}
- (void)showMenuUI:(CGPoint)point isUp:(BOOL)isUp notesContentDic:(NSMutableDictionary *)notesContentDic {
    if (self.notesMenuView) {
        [self.notesMenuView removeFromSuperview];
    }
    self.notesMenuView                 = [NotesMenuView shareNotesMenuView:point isUp:isUp];
    self.notesMenuView.delegate        = self;
    self.notesMenuView.notesContentDic = notesContentDic;
    [self addSubview:self.notesMenuView];
    self.notesMenuView.alpha           = 0.0f;
    CGAffineTransform newTransform =
    CGAffineTransformScale(self.notesMenuView.transform, 0.9, 0.9);
    [self.notesMenuView setTransform:newTransform];
    [UIView animateWithDuration:0.3 animations:^{
        self.notesMenuView.alpha     = 1.0f;
        CGAffineTransform newTransform =
        CGAffineTransformScale(self.notesMenuView.transform, 1.1, 1.1);
        [self.notesMenuView setTransform:newTransform];
    } completion:^(BOOL finished) {
        self.notesMenuView.transform = CGAffineTransformIdentity;
    }];
}
- (void)removeMaginfierView {
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}
- (void)removeCursor{
    if (_leftCursor) {
        [_leftCursor removeFromSuperview];
        _leftCursor  = nil;
    }
    if (_rightCursor) {
        [_rightCursor removeFromSuperview];
        _rightCursor = nil;
    }
}
- (CFIndex)getTouchIndexWithTouchPoint:(CGPoint)touchPoint{
    CTFrameRef textFrame = [self getCTFrame];
    NSArray *lines       = (NSArray*)CTFrameGetLines(textFrame);
    if (!lines) {
        return -1;
    }
    CFIndex index       = -1;
    NSInteger lineCount = [lines count];
    CGPoint *origins    = (CGPoint*)malloc(lineCount * sizeof(CGPoint));
    if (lineCount != 0) {
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), origins);
        for (int i = 0; i < lineCount; i++){
            CGPoint baselineOrigin = origins[i];
            baselineOrigin.y       = CGRectGetHeight(self.frame) - baselineOrigin.y;
            CTLineRef line         = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent, descent, leading;
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineFrame       = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, self.frame.size.width, ascent + descent * 2);
            if (CGRectContainsPoint(lineFrame, touchPoint)){
                index = CTLineGetStringIndexForPosition(line, touchPoint);
                if (index >= _totalString.length) {
                    index = _totalString.length - 1;
                }
                NSString *string = [_totalString substringWithRange:NSMakeRange(index, 1)];
                if ([string isEqualToString:@"　"]) {
                    index --;
                }
                break;
            }
        }
    }
    free(origins);
    return index;
}
- (NSRange)characterRangeAtIndex:(NSInteger)index {
    NSRange range         = NSMakeRange(index, 1);
    NSInteger beforeIndex = 0, afterInxed = _totalString.length;
    for (NSInteger i = index; i >= 0; i--) {
        range.location = i - 1;
        range.length   = 2;
        NSString *str  = [_totalString substringWithRange:range];
        if ([str isEqualToString:@"　　"]) {
            beforeIndex = i + 1;
            break;
        }
    }
    for (NSInteger i = index; i < _totalString.length; i ++) {
        range.location = i;
        range.length   = 1;
        NSString *str  = [_totalString substringWithRange:range];
        if ([str isEqualToString:@"\n"]) {
            afterInxed = i;
            break;
        }
    }
    range = NSMakeRange(beforeIndex, afterInxed - beforeIndex );
    return range;
}
- (NSString *)stringReverse:(NSString *)string {
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i = [string length]; i > 0; i--) {
        [s appendString:[string substringWithRange:NSMakeRange(i-1,1)]];
    }
    return s;
}
- (NSRange)rangeIntersection:(NSRange)first withSecond:(NSRange)second {
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (first.location > second.location) {
        NSRange tmp     = first;
        first           = second;
        second          = tmp;
    }
    if (second.location < first.location + first.length) {
        result.location = second.location;
        NSUInteger end  = MIN(first.location + first.length, second.location + second.length);
        result.length   = end - result.location;
    }
    return result;
}
- (void)resetting {
    selectedRange.location = 0;
    selectedRange.length   = 0;
    [self removeCursor];
    [self setNeedsDisplay];
}
- (void)saveNotes {
    NSString *enterSelectedContentStr = _enterNotesView.selectedContentStr;
    for (NSMutableDictionary *dic in _bottomLineArr) {
        NSString *selectedContentStr = dic[@"selectedContentStr"];
        if ([selectedContentStr isEqualToString:enterSelectedContentStr]) {
            if (![_enterNotesView.noteContentStr isEqualToString:@"请输入您想说的话"]) {
                dic[@"noteContentStr"]     = _enterNotesView.noteContentStr;
            } else {
                dic[@"noteContentStr"] = @"";
            }
            [self resetting];
            [self hideMenuUI];
            [self.delegate readerViewAddNotes:self notesContentDic:dic];
            return;
        }
    }
    NSMutableDictionary *bottomLineDic   = [NSMutableDictionary dictionary];
    bottomLineDic[@"color"]              = _enterNotesView.color;
    if (![_enterNotesView.noteContentStr isEqualToString:@"请输入您想说的话"]) {
        bottomLineDic[@"noteContentStr"]     = _enterNotesView.noteContentStr;
    }
    bottomLineDic[@"selectedContentStr"] = _enterNotesView.selectedContentStr;
    if (!_bottomLineArr) {
        _bottomLineArr = [NSMutableArray array];
    }
    [_bottomLineArr addObject:bottomLineDic];
    [self resetting];
    [self hideMenuUI];
    [self.delegate readerViewAddNotes:self notesContentDic:bottomLineDic];
}
- (void)enterNotesViewGoBack:(EnterNotesView *)enterNotesView isSave:(BOOL)isSave {
    [self closeEditMode];
    if (isSave) {
        [self saveNotes];
    }
    CGRect rect   = _enterNotesView.frame;
    rect.origin.y = [[UIScreen mainScreen] bounds].size.height;
    [UIView animateWithDuration:0.3f animations:^{
        _enterNotesView.frame = rect;
    } completion:^(BOOL finished) {
        [_enterNotesView removeFromSuperview];
        _enterNotesView = nil;
    }];
}
#pragma mark - NotesMenuViewDelegate
- (void)drawBottomLineColor:(NSInteger)colorIndex {
    NSString *enterSelectedContentStr = self.notesMenuView.notesContentDic[@"selectedContentStr"];
    for (NSMutableDictionary *dic in _bottomLineArr) {
        NSString *selectedContentStr = dic[@"selectedContentStr"];
        if ([selectedContentStr isEqualToString:enterSelectedContentStr]) {
            dic[@"color"] = [NSString stringWithFormat:@"%ld",colorIndex];
            [self resetting];
            [self.delegate readerViewAddNotes:self notesContentDic:dic];
            return;
        }
    }
    self.notesMenuView.notesContentDic[@"color"] = [NSString stringWithFormat:@"%ld",colorIndex];
    [self notesMenuViewNotes:_notesMenuView];
}
- (void)notesMenuViewDelete:(NotesMenuView *)notesMenuView {
    [self closeEditMode];
    [self.delegate readerViewDeleteNotes:self notesContentDic:notesMenuView.notesContentDic];
    [_bottomLineArr removeObject:self.notesMenuView.notesContentDic];
    [self resetting];
    [self hideMenuUI];
}
- (void)notesMenuViewCopy:(NotesMenuView *)notesMenuView {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:notesMenuView.notesContentDic[@"selectedContentStr"]];
    [self closeEditMode];
    [self resetting];
    [self hideMenuUI];
}
- (void)notesMenuViewNotes:(NotesMenuView *)notesMenuView {
    if (!self.notesMenuView.notesContentDic[@"color"]) {
        self.notesMenuView.notesContentDic[@"color"] = @"0";
    }
    _enterNotesView                    = [[EnterNotesView alloc] init];
    _enterNotesView.noteContentStr     = self.notesMenuView.notesContentDic[@"noteContentStr"];
    _enterNotesView.selectedContentStr = self.notesMenuView.notesContentDic[@"selectedContentStr"];
    _enterNotesView.color              = self.notesMenuView.notesContentDic[@"color"];
    _enterNotesView.delegate           = self;
    _enterNotesView.frame              = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [[[UIApplication sharedApplication] keyWindow] addSubview:_enterNotesView];
    [UIView animateWithDuration:0.3f animations:^{
        _enterNotesView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }];
    [self resetting];
    [self hideMenuUI];
}
- (void)deleteNotesMenuView:(NotesMenuView *)notesMenuView {
    [self closeEditMode];
    [self resetting];
    [self hideMenuUI];
}
#pragma mark - get/set
- (MagnifyingGlassView *)magnifierView {
    if (_magnifierView == nil) {
        _magnifierView = [[MagnifyingGlassView alloc] init];
        if (_magnifiterImage == nil) {
            _magnifierView.backgroundColor = [UIColor clearColor];
        }else{
            _magnifierView.backgroundColor = [UIColor colorWithPatternImage:_magnifiterImage];
        }
        _magnifierView.viewToMagnify = self;
        [self addSubview:_magnifierView];
    }
    return _magnifierView;
}
- (void)setBottomLineArr:(NSMutableArray *)bottomLineArr {
    _bottomLineArr = bottomLineArr;
    [self resetting];
    [self hideMenuUI];
}
- (CGFloat)lastLinePosition {
    if (_lastLinePosition != 0.0f) {
        return _lastLinePosition;
    } else {
        _lastLinePosition = [self get_LastLinePosition];
        return _lastLinePosition;
    }
}
@end
