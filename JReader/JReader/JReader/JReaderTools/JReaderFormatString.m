//
//  JReaderFormatString.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderFormatString.h"

#define MAX_TEXT_LENGHT  1024

@implementation JReaderFormatString

+ (NSString *)jReaderFormatString:(NSString *)string {
    return [self processingChapterContent:string];
}

#pragma mark - 处理字符串内容
+ (NSString *)processingChapterContent:(NSString *)chapterStr {
    if (!chapterStr) {
        return @"";
    }
    NSString *chapterContent = [[NSString alloc] init];
    NSInteger stringPointer  = 0;
    while (YES) {
        NSRange range;
        if (stringPointer + MAX_TEXT_LENGHT > chapterStr.length) {
            NSString *str = [chapterStr substringFromIndex:stringPointer];
            str = [self stringProcessing:str];
            chapterContent = [chapterContent stringByAppendingString:str];
            break;
        } else {
            range.location = stringPointer;
            range.length  = MAX_TEXT_LENGHT;
            NSString *str = [chapterStr substringWithRange:range];
            chapterContent = [chapterContent stringByAppendingString:[self stringProcessing:str]];
            stringPointer += MAX_TEXT_LENGHT;
        }
    }
    // 清除字符串开头和结尾的多余字符
    chapterContent = [self stringHeadAndTailProcessing:chapterContent];
    // 文章开头插入两个空格
    chapterContent = [NSString stringWithFormat:@"\n\n　　%@",chapterContent];
    return chapterContent;
}

#pragma mark - 字符串头部和尾部格式化
+ (NSString *)stringHeadAndTailProcessing:(NSString *)str {
    // 清除字符串头部的 @"\n  "
    if ([str hasPrefix:@"\n　　"]) {
        str = [str substringFromIndex:3];
    }
    // 清除字符串尾部的@"\n  "
    if ([str hasSuffix:@"\n　　"]) {
        str = [str substringToIndex:str.length - 3];
    }
    return str;
}

#pragma mark - 格式化章节内容片段
+ (NSString *)stringProcessing:(NSString *)str {
    
    // 去掉 空格
    str = [str stringByReplacingOccurrencesOfString:@"　" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 去掉空行
    while (YES) {
        if ([str rangeOfString:@"\r\n"].location == NSNotFound) {
            break;
        }
        str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    }
    // 去掉\r
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    // 去掉空行
    while (YES) {
        if ([str rangeOfString:@"\n\n"].location == NSNotFound) {
            break;
        }
        str = [str stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    }
    // 首行缩进
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\n　　"];
    return str;
}

@end
