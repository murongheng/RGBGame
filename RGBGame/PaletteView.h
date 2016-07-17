//
//  PaletteView.h
//  RGBGame
//
//  Created by 千锋 on 16/3/2.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaletteView : UIView {
    UISlider *_redSlider; //红色滑条
    UISlider *_greenSlider; //绿
    UISlider *_blueSlider; //蓝
    UISlider *_widthSlider; //线宽
    
    UIView *_colorView;
    UILabel *_widthLabel;
}
@property (nonatomic, strong) UIColor *seletedColor;

@property (nonatomic, assign) float selectedWidth;
//
- (void) changeWidth:(id) sender;



@end
