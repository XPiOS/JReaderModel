//
//  JReaderFormatString.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JReaderFormatString : NSObject

/**
 *  格式化字符串
 *
 *  @param string 需要格式化的字符串
 *
 *  @return 格式化之后的字符串
 */
+ (NSString *)jReaderFormatString:(NSString *)string;

@end
