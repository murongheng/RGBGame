//
//  DrawView.m
//  RGBGame
//
//  Created by 千锋 on 16/3/2.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "DrawView.h"
#import "PaletteView.h"
#import "LinePencil.h"
@implementation DrawView

- (instancetype) initWithFrame:(CGRect) frame {
    if (self = [super initWithFrame:frame]) {
        _drawLines = [[NSMutableArray alloc] init];
        [self UILayout];
    }
    return self;
}

- (void) UILayout {
    _paletteView = [[PaletteView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 140, self.frame.size.width, 140)];
    _paletteView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_paletteView];
}

- (void) drawRect:(CGRect) rect {
    //绘制 (遍历绘制数组中的路径)
    for (LinePencil *line in self.drawLines) {
        //设置线头样式
        line.lineCapStyle = kCGLineCapRound;
        //设置连接处样式
        line.lineJoinStyle = kCGLineJoinRound;
        //设置颜色
        [line.lineColor set];
        [line stroke];
    }
}


- (void) touchesBegan:(NSSet<UITouch *> *) touches withEvent:(UIEvent *) event{
    //获取触摸对象
    UITouch *touch = [touches anyObject];
    //根据触摸对象获取触摸的点
    CGPoint locationPoint = [touch locationInView:touch.view];
    //创建路径
    LinePencil *line = [LinePencil bezierPath];
    //设置线宽
    line.lineWidth = _paletteView.selectedWidth;
    //设置线的颜色
    line.lineColor = _paletteView.seletedColor;
    //设置起点
    [line moveToPoint:locationPoint];
    [self.drawLines addObject:line];
}
//手指移动
- (void) touchesMoved:(NSSet<UITouch *> *) touches withEvent:(UIEvent *) event {
    //获取触摸对象
    UITouch *touch = [touches anyObject];
    //根据触摸对象获取触摸的点
    CGPoint locationPoint = [touch locationInView:touch.view];
    //添加一根线
    [[self.drawLines lastObject] addLineToPoint:locationPoint];
    //执行重绘
    [self setNeedsDisplay];
}
//手指抬起
- (void) touchesEnded:(NSSet<UITouch *> *) touches withEvent:(UIEvent *) event {
    
}
//清屏
- (void) clear {
    //把数组中的路径清空
    [self.drawLines removeAllObjects];
    //执行重绘
    [self setNeedsDisplay];
}
//回退
- (void) back {
    [self.drawLines removeLastObject];
    [self setNeedsDisplay];
}
- (void) eraser {
    _paletteView.seletedColor = self.backgroundColor;
}
@end
