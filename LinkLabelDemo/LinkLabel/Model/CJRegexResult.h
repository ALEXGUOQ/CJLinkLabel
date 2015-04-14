//
//  CJRegexResult.h
//  LinkLabelDemo
//
//  Created by CoderJee on 15/4/14.
//  Copyright (c) 2015年 com.huazhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJRegexResult : NSObject
/**
 *  匹配到的字符串
 */
@property (nonatomic, copy) NSString *string;
/**
 *  匹配到的范围
 */
@property (nonatomic, assign) NSRange range;
@end
