//
//  CJLinkLabel.m
//  LinkLabelDemo
//
//  Created by CoderJee on 15/4/14.
//  Copyright (c) 2015年 com.huazhi. All rights reserved.
//
#import "CJRegexResult.h"
#import "CJLink.h"
#import "RegexKitLite.h"
#import "CJLinkLabel.h"
#define LINKTEXT @"LINKTEXT"
#define URL_EXPRESSION @"([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])"
#define CJLinkBackgroundTag 1993
@interface CJLinkLabel()
/**
 *  加载超链文字
 */
@property (nonatomic, strong)NSString *LinkAttributeString;
@property (nonatomic, weak)UITextView *textView;
@property (nonatomic, strong)NSMutableArray *links;
@property (nonatomic, strong)NSMutableAttributedString *LinkAttributedString;
@property (nonatomic, strong)UIColor *LinkClickColor;
@property (nonatomic, strong)UIColor *LinkTextColor;
@property (nonatomic, strong)UIFont *LinkFont;
@end
@implementation CJLinkLabel

- (NSMutableArray *)links
{
    if (!_links) {
         NSMutableArray *links = [NSMutableArray array];
        // 搜索所有的链接
        [self.LinkAttributedString enumerateAttributesInRange:NSMakeRange(0, self.LinkAttributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            NSString *linkText = attrs[LINKTEXT];
            if (linkText == nil) return;
            
            // 创建一个链接
            CJLink *link = [[CJLink alloc] init];
            link.text = linkText;
            link.range = range;
            
            // 处理矩形框
            NSMutableArray *rects = [NSMutableArray array];
            // 设置选中的字符范围
            self.textView.selectedRange = range;
            // 算出选中的字符范围的边框
            NSArray *selectionRects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
            for (UITextSelectionRect *selectionRect in selectionRects) {
                if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) continue;
                [rects addObject:selectionRect];
            }
            link.rects = rects;
            
            [links addObject:link];
        }];
        
        self.links = links;
    }
    return _links;
}

- (void)setLinkString:(NSString *)LinkString withTextColor:(UIColor *)textColor withLinkColor:(UIColor *)LinkTextColor AndClickLinkColor:(UIColor *)LinkClickColor WithLinkFont:(UIFont *)LinkFont
{
    _LinkAttributeString = LinkString;
    _LinkClickColor = LinkClickColor;
    self.LinkAttributedString = [[self attributedStringWithText:LinkString withColor:LinkTextColor withFont:LinkFont withTextColor:textColor] mutableCopy];
    self.textView.attributedText = [self.LinkAttributedString copy];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        // 不能滚动
        textView.scrollEnabled = NO;
        // 不能编辑
        textView.editable = NO;
        // 设置TextView不能跟用户交互
        textView.userInteractionEnabled = NO;
        // 设置文字的内边距
        textView.textContainerInset = UIEdgeInsetsZero;
        [self addSubview:textView];
        self.textView = textView;
        
    }
    return self;
}

- (void)setHTMLAttributeString:(NSString *)HTMLAttributeString
{
    _HTMLAttributeString = HTMLAttributeString;
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[HTMLAttributeString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.textView.attributedText = attStr;
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text withColor:(UIColor *)LinkColor withFont:(UIFont *)LinkFont withTextColor:(UIColor *)textColor
{
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:text];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(CJRegexResult *result, NSUInteger idx, BOOL *stop) {
        NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
        [substr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, substr.string.length)];
        // 匹配超链接
        NSString *httpRegex = URL_EXPRESSION;
        [result.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
            // 设置匹配到的超链接的文字颜色
            [substr addAttribute:NSForegroundColorAttributeName value:LinkColor range:*capturedRanges];
            [substr addAttribute:LINKTEXT value:*capturedStrings range:*capturedRanges];
        }];
        [attributedString appendAttributedString:substr];
    }];
    
    // 设置字体
    [attributedString addAttribute:NSFontAttributeName value:LinkFont range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

/**
 *  根据字符串计算出所有的匹配结果（已经排好序）
 *
 *  @param text 字符串内容
 */
- (NSArray *)regexResultsWithText:(NSString *)text
{
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    NSString *Regex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    
    [text enumerateStringsSeparatedByRegex:Regex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        CJRegexResult *rr = [[CJRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        [regexResults addObject:rr];
    }];
    
    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(CJRegexResult *rr1, CJRegexResult *rr2) {
        int loc1 = rr1.range.location;
        int loc2 = rr2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];
    return regexResults;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
    
    self.textView.contentOffset = CGPointZero;
}

#pragma mark - 事件处理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    // 得出被点击的那个链接
    CJLink *touchingLink = [self touchingLinkWithPoint:point];
    
    // 设置链接选中的背景
    [self showLinkBackground:touchingLink];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    // 被点击的链接
    CJLink *touchingLink = [self touchingLinkWithPoint:point];
    if (touchingLink) {
        if ([self.delegate respondsToSelector:@selector(linkLabel:linkClick:)]) {
            [self.delegate linkLabel:self linkClick:touchingLink.text];
        }
    }
    
    // 触摸被取消
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAllLinkBackground];
    });
}


#pragma mark - 链接背景处理
/**
 *  根据触摸点找出被触摸的链接
 *
 *  @param point 触摸点
 */
- (CJLink *)touchingLinkWithPoint:(CGPoint)point
{
    __block CJLink *touchingLink = nil;
    [self.links enumerateObjectsUsingBlock:^(CJLink *link, NSUInteger idx, BOOL *stop) {
        for (UITextSelectionRect *selectionRect in link.rects) {
            if (CGRectContainsPoint(selectionRect.rect, point)) {
                touchingLink = link;
                break;
            }
        }
    }];
    return touchingLink;
}

/**
 *  显示链接的背景
 *
 *  @param link 需要显示背景的link
 */
- (void)showLinkBackground:(CJLink *)link
{
    for (UITextSelectionRect *selectionRect in link.rects) {
        UIView *bg = [[UIView alloc] init];
        bg.tag = CJLinkBackgroundTag;
        bg.layer.cornerRadius = 3;
        bg.frame = selectionRect.rect;
        bg.backgroundColor = self.LinkClickColor;
        [self insertSubview:bg atIndex:0];
    }
}

- (void)removeAllLinkBackground
{
    for (UIView *child in self.subviews) {
        if (child.tag == CJLinkBackgroundTag) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  这个方法会返回能够处理事件的控件
 *  这个方法可以用来拦截所有触摸事件
 *  @param point 触摸点
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self touchingLinkWithPoint:point]) {
        return self;
    }
    return nil;
}

@end
