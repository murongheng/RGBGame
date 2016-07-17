//
//  PaletteView.m
//  RGBGame
//
//  Created by 千锋 on 16/3/2.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "PaletteView.h"

@implementation PaletteView

- (instancetype) initWithFrame:(CGRect) frame {
    if (self = [super initWithFrame:frame]) {
        //红色
        _redSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(self.frame) - 160, 30)];
        [_redSlider addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
        _redSlider.thumbTintColor = [UIColor redColor];
        _redSlider.minimumTrackTintColor = [UIColor redColor];
        [self addSubview:_redSlider];
        
        CGFloat standardWidth = CGRectGetWidth(_redSlider.frame);
        CGFloat standardHeight = CGRectGetHeight(_redSlider.frame);
        //绿色
        _greenSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_redSlider.frame), standardWidth, standardHeight)];
        [_greenSlider addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
        _greenSlider.thumbTintColor = [UIColor greenColor];
        _greenSlider.minimumTrackTintColor = [UIColor greenColor];
        [self addSubview:_greenSlider];
        //蓝色
        _blueSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_greenSlider.frame), standardWidth, standardHeight)];
        [_blueSlider addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
        _blueSlider.thumbTintColor = [UIColor blueColor];
        _blueSlider.minimumTrackTintColor = [UIColor blueColor];
        [self addSubview:_blueSlider];
        //宽度
        _widthSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_blueSlider.frame), standardWidth, standardHeight)];
        _widthSlider.minimumValue = 1.0;
        _widthSlider.maximumValue = 20.0;
        [_widthSlider addTarget:self action:@selector(changeWidth:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_widthSlider];
        
        //color
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 120, 20, 100, 50)];
        _colorView.layer.cornerRadius = 15;
        _colorView.layer.masksToBounds = YES;
        [self addSubview:_colorView];
        
        //widthlabel
        _widthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_colorView.frame) + 10, CGRectGetMaxY(_colorView.frame) + 15, 100, 30)];
        [self addSubview:_widthLabel];
        _widthLabel.text = @"线宽 1.0";
        
        _colorView.backgroundColor = [UIColor blackColor];
        _seletedColor = [UIColor blackColor];
        _selectedWidth = 1;
    }
    return self;
}

- (void) changeColor:(id) sender {
    UIColor *color = [UIColor colorWithRed:_redSlider.value green:_greenSlider.value blue:_blueSlider.value alpha:1.0];
    _colorView.backgroundColor = color;
    if (_seletedColor != color) {
        _seletedColor = color;
    }
}

- (void) changeWidth:(UISlider *) sender {
    _widthLabel.text = [NSString stringWithFormat:@"线宽%.1f", sender.value];
    _selectedWidth = sender.value;
}

@end
