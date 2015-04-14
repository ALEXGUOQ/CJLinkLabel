//
//  CJLinkLabel.h
//  LinkLabelDemo
//
//  Created by CoderJee on 15/4/14.
//  Copyright (c) 2015年 com.huazhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJLinkLabel;
@protocol CJLinkLabelDelegate <NSObject>

- (void)linkLabel:(CJLinkLabel *)label linkClick:(NSString *)URL;

@end

@interface CJLinkLabel : UIView
@property (nonatomic, weak)id<CJLinkLabelDelegate> delegate;
/**
 *  加载html文字
 */
@property (nonatomic, copy)NSString *HTMLAttributeString;
/**
 *  加载超链接文本
 *
 *  @param textColor      非链接文字颜色
 *  @param LinkString     超链接文本
 *  @param LinkTextColor  链接文字颜色
 *  @param LinkClickColor 点击链接时的背景色
 *  @param LinkFont       超链接文本字体大小
 */
- (void)setLinkString:(NSString *)LinkString withTextColor:(UIColor *)textColor withLinkColor:(UIColor *)LinkTextColor AndClickLinkColor:(UIColor *)LinkClickColor WithLinkFont:(UIFont *)LinkFont;
@end
