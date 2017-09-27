//
//  MarkModel.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/27.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkModel : NSObject

@property (nonatomic, strong) NSString *chapterName;
@property (nonatomic, assign) NSInteger chapterIndex;
@property (nonatomic, strong) NSString *markContent;
@property (nonatomic, strong) NSString *markTime;

@end
