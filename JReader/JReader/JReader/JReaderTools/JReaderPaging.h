//
//  JReaderPaging.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JReaderPaging : NSObject

/**
 总页数
 */
@property (nonatomic, readonly) NSUInteger pageCount;

/**
 *  分页
 */
- (void)paging:(NSString *)contentText attributes: (NSDictionary *)attributes rect: (CGRect)rect nameRange: (NSRange)nameRange nameAttributes: (NSDictionary *)nameAttributes;

/**
 *  获得page页的文字内容
 *
 *  @param page 页
 *
 *  @return 内容
 */
- (NSString *)stringOfPage:(NSUInteger)page;

/**
 根据页面内容，获取所在页码

 @param pageStr 页面内容
 @return 页码数
 */
- (NSInteger)getPageIndex: (NSString *)pageStr;

@end
