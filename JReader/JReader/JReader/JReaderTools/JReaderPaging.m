//
//  JReaderPaging.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderPaging.h"
#import <CoreText/CoreText.h>

#define MAX_TEXT_LENGHT 50000

@interface JReaderPaging ()

@property (nonatomic, strong) NSMutableArray *pageOffsetsArr;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, copy) NSString *contentText;

@end

@implementation JReaderPaging

#pragma mark 分页
- (void)paging:(NSString *)contentText attributes:(NSDictionary *)attributes rect:(CGRect)rect nameRange:(NSRange)nameRange nameAttributes:(NSDictionary *)nameAttributes {
    self.contentText = contentText;
    self.rect = rect;
    if (!self.pageOffsetsArr) {
        self.pageOffsetsArr = [NSMutableArray array];
    }
    // 页偏移量清空
    [self.pageOffsetsArr removeAllObjects];
    
    NSString *buffer = [self subStringWithRange:NSMakeRange(0, MAX_TEXT_LENGHT) contenText:_contentText];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:buffer];
    // 设置富文本属性
    if (nameRange.length != NSNotFound) {
        [attrString setAttributes:nameAttributes range:nameRange];
    }
    [attrString setAttributes:attributes range:NSMakeRange(nameRange.length, attrString.length - nameRange.length)];
    nameRange.length = NSNotFound;
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(self.rect, NULL);
    
    // 当前页面在全文中的起始位置
    int currentOffset = 0;
    // 内部偏移量
    int currentInnerOffset = 0;
    // 是否有更多的页面
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    // 同一个地方的重复引用计数
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            ++samePlaceRepeatCount;
        } else {
            samePlaceRepeatCount = 0;
        }
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (self.pageOffsetsArr.count == 0) {
                [self.pageOffsetsArr addObject:@(currentOffset)];
            } else {
                NSInteger lastOffset = [[self.pageOffsetsArr lastObject] integerValue];
                if (lastOffset != currentOffset) {
                    [self.pageOffsetsArr addObject:@(currentOffset)];
                }
            }
            break;
        }
        // 在向量数组尾部加入一个偏移量
        [self.pageOffsetsArr addObject:@(currentOffset)];
        // 核心代码 CTFrameGetVisibleStringRange 会返回  画布上的文字Range
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            currentOffset += range.length;
            currentInnerOffset += range.length;
        } else if ((range.location + range.length) == attrString.length && (currentOffset + range.length) != [self.contentText length]) {
            // 加载后面的
            CFRelease(frame);
            CFRelease(frameSetter);
            [self.pageOffsetsArr removeLastObject];
            buffer = [self subStringWithRange:NSMakeRange(currentOffset, MAX_TEXT_LENGHT) contenText:self.contentText];
            attrString = [[NSMutableAttributedString alloc] initWithString:buffer];
            [attrString setAttributes:attributes range:NSMakeRange(0, attrString.length)];
            frameSetter  = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) {
            CFRelease(frame);
        }
    }
    CGPathRelease(path);
    CFRelease(frameSetter);
}

#pragma mark 指定页内容
- (NSString *)stringOfPage:(NSUInteger)page {
    if (page >= self.pageCount) return @"";
    NSUInteger head = [self.pageOffsetsArr[page] integerValue];//_pageOffsets[page];
    NSUInteger tail = self.contentText.length;
    if (page + 1 < self.pageCount) {
        tail = [self.pageOffsetsArr[page + 1] integerValue];
    }
    return [self subStringWithRange:NSMakeRange(head, tail-head) contenText:self.contentText];
}

#pragma mark 根据页面内容，获取页码
- (NSInteger)getPageIndex: (NSString *)pageStr {
    NSRange range = [self.contentText rangeOfString:pageStr];
    if (range.location != NSNotFound) {
        for (int i = 0; i < self.pageCount; i++) {
            NSUInteger head = [self.pageOffsetsArr[i] integerValue];
            NSUInteger tail = self.contentText.length;
            if (i + 1 < self.pageCount) {
                tail = [self.pageOffsetsArr[i + 1] integerValue];
            }
            if (range.location >= head && range.location <= tail) {
                return i + 1;
            }
        }
    }
    return 0;
}

#pragma mark 在全文中截取字符串
- (NSString *)subStringWithRange:(NSRange)range contenText:(NSString *)contenText {
    if (range.location == NSNotFound) {
        return @"";
    }
    NSUInteger head = range.location;
    if (head >= contenText.length) {
        return @"";
    }
    NSUInteger tail = (range.location + range.length);
    tail = tail > contenText.length ? contenText.length : tail;
    return [contenText substringWithRange:NSMakeRange(head, tail - head)];
}

#pragma mark 总页数
- (NSUInteger)pageCount {
    return self.pageOffsetsArr.count;
}

@end
