# CJLinkLabel
>自定义Label，可加载超链接和HTML
>>效果图:![](https://github.com/CoderJee/CJLinkLabel/blob/master/2015-04-14%2017_46_57.gif)

#使用方法:
```Objective-c
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

/**
 *  加载html文字
 */
@property (nonatomic, copy)NSString *HTMLAttributeString;
```
#使用案例
```Objective-c
// 加载超链接
    CJLinkLabel *linkLabel = [[CJLinkLabel alloc] initWithFrame:CGRectMake(10, 70, 300, 50)];
    [self.view addSubview:linkLabel];
    self.linkLabel = linkLabel;
    linkLabel.delegate = self;
    NSString *LinkStr = @"I'm CoderJee,正在帝都修行中!(加载超链接):\nhttp://www.baidu.com,http://www.jianshu.com/p/3511ec38ca20";
    [linkLabel setLinkString:LinkStr withTextColor:[UIColor blackColor] withLinkColor:[UIColor CJ_16_Color:@"00e7b9"] AndClickLinkColor:[UIColor blueColor] WithLinkFont:[UIFont systemFontOfSize:14]];
    linkLabel.backgroundColor = [UIColor lightGrayColor];
    
    // 加载HTML
    NSString *htmlString =  @"<html><body><font size=\"10\" color=\"red\"> 加载HTML: </font>I'm CoderJee,正在帝都修行中! </body></html>";
    CJLinkLabel *htmlLabel = [[CJLinkLabel alloc] initWithFrame:CGRectMake(10, 126, 300, 60)];
    htmlLabel.HTMLAttributeString = htmlString;
    htmlLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:htmlLabel];
```
#加载超链接时需实现代理<CJLinkLabelDelegate>
##实现方法:
```Objective-c
- (void)linkLabel:(CJLinkLabel *)label linkClick:(NSString *)URL
{
    根据需求实现...
}
```
