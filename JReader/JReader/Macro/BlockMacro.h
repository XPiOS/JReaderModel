//
//  BlockMacro.h
//  iuReader
//
//  Created by Jerry on 2017/6/17.
//  Copyright © 2017年 com.AiYouHuYu. All rights reserved.
//   Block 相关宏

/**
 无参数Block
 */
typedef void(^ParameterBlock) (void);

/**
 一个参数的Block

 @param parameter 参数
 */
typedef void(^Parameter1Block) (id parameter);

/**
 两个参数的Block

 @param parameter1 参数1
 @param parameter2 参数2
 */
typedef void(^Parameter2Block) (id parameter1, id parameter2);
