//
//  ViewController.m
//  RGBGame
//
//  Created by 千锋 on 16/2/25.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "DrawViewController.h"
#import "WGArchiverManager.h"
#import "AppDelegate.h"
#import "UIImage+GIF.h"
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define centerX WIDTH / 2
#define centerY HEIGHT / 2 - 50
#define MKCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define TASK_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RGRGame.data"]

static const CGFloat closeX = 80 / 1.414;

@interface ViewController ()

@end

@implementation ViewController {
    NSString *_taskStr;
    UIButton *_button;
    UILabel *_scoreLabel;
    UIButton *_drawButton;
    UIImageView *_imageView;
    UIView *_gifView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_myTask.checkPoint == 0) {
        [self createActionView];
    }
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:_imageView];
    [self.view sendSubviewToBack:_imageView];

    if (!_myTask) {
        _myTask = [[Task alloc] init];
        _myTask.speed = 2;
        _myTask.number = 10;
        _myTask.checkPoint = 1;
        _myTask.taskColor = [UIColor redColor];
        _myTask.colorStr = @"红";
//        _myTask.animation = 1;
        _myTask.myLayer = nil;
    }
    [self drawMonkey];
    //gameButton
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 120, 18, 100, 40)];
        [_button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        [_button setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [self.view addSubview:_button];
    }
    //显示最高分
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, WIDTH - 140, 40)];
    [self.view addSubview:_scoreLabel];
    _scoreLabel.text = [NSString stringWithFormat:@"最高分:%ld", (long)_myTask.hightScore];
    _scoreLabel.font = [UIFont boldSystemFontOfSize:20];
    _scoreLabel.textColor = [UIColor blackColor];
    
    //让界面显示label
    if (_myTask.checkPoint > 9) {
        [self createLabel];
        [self createButton];
    }
    [self.view addSubview:_gifView];

}
- (void) onClick {
    
    if (_myTask.checkPoint > 9) {
       [self createPromptAlertController];
        
    } else {
        [self createAlertController];
    }
}
//游戏通关后自由选择游戏难度
- (void) createPromptAlertController {
    _myTask.taskColor = [UIColor blueColor];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"选择游戏难度" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *easyAction = [UIAlertAction actionWithTitle:@"简单" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        GameViewController *vc = [[GameViewController alloc] init];
        _myTask.speed = 2;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.myTask = _myTask;
        [_scoreLabel removeFromSuperview];
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    UIAlertAction *normalAction = [UIAlertAction actionWithTitle:@"普通" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        GameViewController *vc = [[GameViewController alloc] init];
        _myTask.speed = 4;
        vc.myTask = _myTask;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [_scoreLabel removeFromSuperview];
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    UIAlertAction *difficultAction = [UIAlertAction actionWithTitle:@"困难" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        GameViewController *vc = [[GameViewController alloc] init];
        _myTask.speed = 6;
        vc.myTask = _myTask;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [_scoreLabel removeFromSuperview];
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [ac addAction:easyAction];
    [ac addAction:normalAction];
    [ac addAction:difficultAction];
    [ac addAction:cancleAction];
    [self presentViewController:ac animated:YES completion:nil];

}
//任务提示框
- (void) createAlertController {
    
    _taskStr = [NSString stringWithFormat:@"任务%ld: 点击%@色方块%ld次", (long)_myTask.checkPoint, _myTask.colorStr, (long)_myTask.number];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确定进入游戏?" message:_taskStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        GameViewController *vc = [[GameViewController alloc] init];
        vc.myTask = _myTask;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [_scoreLabel removeFromSuperview];
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [ac addAction:cancleAction];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 猴子

- (void) drawMonkey {
   
    //头轮廓  hight / 2 - 50
    CAShapeLayer *headLayer = [CAShapeLayer layer];
    UIBezierPath *headPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WIDTH / 2, HEIGHT / 2 - 50) radius:80 startAngle:M_PI / 4  endAngle:M_PI / 4 * 3 clockwise:NO];

    CAShapeLayer *headLayer2 = [CAShapeLayer layer];
    UIBezierPath *headPath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WIDTH / 2, HEIGHT / 2 - 46) radius:75 startAngle:M_PI / 4  endAngle:M_PI / 4 * 3 clockwise:NO];

    //头冠
    CAShapeLayer *hatLayer = [CAShapeLayer layer];
    UIBezierPath *hatPath = [UIBezierPath bezierPath];
    
    [hatPath moveToPoint:CGPointMake(WIDTH / 2 - 25, HEIGHT / 2 - 125)];
    [hatPath addQuadCurveToPoint:CGPointMake(WIDTH / 2, HEIGHT / 2 - 140) controlPoint:CGPointMake(WIDTH / 2 - 60, HEIGHT / 2 - 140)];
    [hatPath addQuadCurveToPoint:CGPointMake(WIDTH / 2 + 25, HEIGHT / 2 - 125) controlPoint:CGPointMake(WIDTH / 2 + 60, HEIGHT / 2 - 140)];

    //左耳
    CAShapeLayer *leftEarLayer = [CAShapeLayer layer];
    UIBezierPath *leftEarPath = [UIBezierPath bezierPath];
    
    [leftEarPath moveToPoint:CGPointMake(centerX - 78 , centerY - 20)];
    [leftEarPath addQuadCurveToPoint:CGPointMake(centerX - 78, centerY + 20) controlPoint:CGPointMake(centerX - 120, centerY - 40)];

    //右耳
    CAShapeLayer *rightEarLayer = [CAShapeLayer layer];
    UIBezierPath *rightEarPath = [UIBezierPath bezierPath];
    
    [rightEarPath moveToPoint:CGPointMake(centerX + 78 , centerY - 20)];
    [rightEarPath addQuadCurveToPoint:CGPointMake(centerX + 78, centerY + 20) controlPoint:CGPointMake(centerX + 120, centerY - 40)];
    
    //脸
    CAShapeLayer *faceLayer = [CAShapeLayer layer];
    UIBezierPath *fachPath = [UIBezierPath bezierPath];
    
    [fachPath moveToPoint:CGPointMake(centerX, centerY + 20)];
    [fachPath addQuadCurveToPoint:CGPointMake(centerX - 52, centerY - 50) controlPoint:CGPointMake(centerX - 70, centerY)];
    [fachPath addQuadCurveToPoint:CGPointMake(centerX, centerY - 45) controlPoint:CGPointMake(centerX - 30, centerY - 70)];
    [fachPath addQuadCurveToPoint:CGPointMake(centerX + 52, centerY - 50) controlPoint:CGPointMake(centerX + 30, centerY - 70)];
    [fachPath addQuadCurveToPoint:CGPointMake(centerX, centerY + 20) controlPoint:CGPointMake(centerX + 70, centerY)];
    
    //左眼
    CAShapeLayer *leftEyeLayer = [CAShapeLayer layer];
    UIBezierPath *leftEyePath = [UIBezierPath bezierPath];
    
    [leftEyePath moveToPoint:CGPointMake(centerX - 10, centerY - 10)];
    [leftEyePath addQuadCurveToPoint:CGPointMake(centerX - 50, centerY - 45) controlPoint:CGPointMake(centerX - 60, centerY - 10)];

    [leftEyePath addQuadCurveToPoint:CGPointMake(centerX - 10, centerY - 10) controlPoint:CGPointMake(centerX - 10, centerY - 45)];

    //左瞳孔
    CAShapeLayer *leftPupilLayer = [CAShapeLayer layer];
    UIBezierPath *leftPupilPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(centerX - 40, centerY - 35, 20, 20) cornerRadius:10];

    //右眼
    CAShapeLayer *rightEyeLayer = [CAShapeLayer layer];
    UIBezierPath *rightEyePath = [UIBezierPath bezierPath];
    
    [rightEyePath moveToPoint:CGPointMake(centerX + 10, centerY - 10)];
    [rightEyePath addQuadCurveToPoint:CGPointMake(centerX + 50, centerY - 45) controlPoint:CGPointMake(centerX + 60, centerY - 10)];

    [rightEyePath addQuadCurveToPoint:CGPointMake(centerX + 10, centerY - 10) controlPoint:CGPointMake(centerX + 10, centerY - 45)];

    //瞳孔
    CAShapeLayer *rightPupilLayer = [CAShapeLayer layer];
    UIBezierPath *rightPupilPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(centerX + 20, centerY - 35, 20, 20) cornerRadius:10];

    //竖线
    CAShapeLayer *layer3 = [CAShapeLayer layer];
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(centerX, centerY + 20)];
    [path3 addLineToPoint:CGPointMake(centerX, centerY + 40)];
    
    //身体
    CAShapeLayer *bodyLayer = [CAShapeLayer layer];
    UIBezierPath *bodyPath = [UIBezierPath bezierPath];
    
    [bodyPath moveToPoint:CGPointMake(centerX - closeX, centerY + closeX)];
    [bodyPath addLineToPoint:CGPointMake(centerX - closeX, centerY + closeX + 70)];
    [bodyPath addQuadCurveToPoint:CGPointMake(centerX + closeX, centerY + closeX + 70) controlPoint:CGPointMake(centerX, centerY + closeX + 130)];

    [bodyPath addLineToPoint:CGPointMake(centerX + closeX, centerY + closeX)];
    [bodyPath addLineToPoint:CGPointMake(centerX - closeX, centerY + closeX)];

    //左腿
    CAShapeLayer *leftLagLayer = [CAShapeLayer layer];
    UIBezierPath *leftLagPath = [UIBezierPath bezierPath];
    
    [leftLagPath moveToPoint:CGPointMake(centerX - closeX, centerY + closeX + 70)];
    [leftLagPath addLineToPoint:CGPointMake(centerX - closeX, centerY + closeX + 160)];

    [leftLagPath addLineToPoint:CGPointMake(centerX - closeX + 30, centerY + closeX + 160)];
    [leftLagPath addLineToPoint:CGPointMake(centerX - closeX + 30, centerY + closeX + 92)];
    [leftLagPath addQuadCurveToPoint:CGPointMake(centerX - closeX, centerY + closeX + 70) controlPoint:CGPointMake(centerX - closeX + 13 , centerY + closeX + 84)];
    
    //脚
    CAShapeLayer *leftFootLayer = [CAShapeLayer layer];
    UIBezierPath *leftFootPath = [UIBezierPath bezierPath];
    
    [leftFootPath moveToPoint:CGPointMake(centerX - closeX, centerY + closeX + 160)];
    [leftFootPath addQuadCurveToPoint:CGPointMake(centerX - closeX + 15, centerY + closeX + 190) controlPoint:CGPointMake(centerX - closeX , centerY + closeX + 195)];
    [leftFootPath addQuadCurveToPoint:CGPointMake(centerX - closeX + 30, centerY + closeX + 160) controlPoint:CGPointMake(centerX - closeX + 30, centerY + closeX + 195)];
    
    //右腿
    CAShapeLayer *rightLagLayer = [CAShapeLayer layer];
    UIBezierPath *rightLagPath = [UIBezierPath bezierPath];
    
    [rightLagPath moveToPoint:CGPointMake(centerX + closeX, centerY + closeX + 70)];
    [rightLagPath addLineToPoint:CGPointMake(centerX + closeX, centerY + closeX + 160)];

    [rightLagPath addLineToPoint:CGPointMake(centerX + closeX - 30, centerY + closeX + 160)];

    [rightLagPath addLineToPoint:CGPointMake(centerX + closeX - 30, centerY + closeX + 92)];
    [rightLagPath addQuadCurveToPoint:CGPointMake(centerX + closeX, centerY + closeX + 70) controlPoint:CGPointMake(centerX + closeX - 10 , centerY + closeX + 80)];
    
    //右脚
    CAShapeLayer *rightFootLayer = [CAShapeLayer layer];
    UIBezierPath *rightFootPath = [UIBezierPath bezierPath];
    
    [rightFootPath moveToPoint:CGPointMake(centerX + closeX, centerY + closeX + 160)];
    [rightFootPath addQuadCurveToPoint:CGPointMake(centerX + closeX - 15, centerY + closeX + 190) controlPoint:CGPointMake(centerX + closeX , centerY + closeX + 195)];
    [rightFootPath addQuadCurveToPoint:CGPointMake(centerX + closeX - 30, centerY + closeX + 160) controlPoint:CGPointMake(centerX + closeX - 30, centerY + closeX + 195)];
    
    //胳膊
    CAShapeLayer *armLayer = [CAShapeLayer layer];
    UIBezierPath *armPath = [UIBezierPath bezierPath];
    [armPath moveToPoint:CGPointMake(centerX - closeX, centerY + closeX)];
    [armPath addLineToPoint:CGPointMake(centerX - closeX - 40, centerY + closeX + 40)];
    [armPath addQuadCurveToPoint:CGPointMake(centerX - closeX - 30, centerY + closeX + 60) controlPoint:CGPointMake(centerX - closeX - 30, centerY + closeX + 40)];
    [armPath addLineToPoint:CGPointMake(centerX - closeX, centerY + closeX + 30)];
    
    [armPath moveToPoint:CGPointMake(centerX + closeX, centerY + closeX)];
    [armPath addLineToPoint:CGPointMake(centerX + closeX + 40, centerY + closeX + 40)];
    [armPath addQuadCurveToPoint:CGPointMake(centerX + closeX + 30, centerY + closeX + 60) controlPoint:CGPointMake(centerX + closeX + 30, centerY + closeX + 40)];
    [armPath addLineToPoint:CGPointMake(centerX + closeX, centerY + closeX + 30)];
    //手   *** 在说
    CAShapeLayer *handLayer = [CAShapeLayer layer];
    UIBezierPath *handPath = [UIBezierPath bezierPath];
    
    [handPath moveToPoint:CGPointMake(centerX - closeX - 40, centerY + closeX + 40)];
    [handPath addQuadCurveToPoint:CGPointMake(centerX - closeX - 30, centerY + closeX + 60) controlPoint:CGPointMake(centerX - closeX - 30, centerY + closeX + 40)];
    [handPath addQuadCurveToPoint:CGPointMake(centerX - closeX - 50, centerY + closeX + 60) controlPoint:CGPointMake(centerX - closeX - 50, centerY + closeX + 70)];
    [handPath addQuadCurveToPoint:CGPointMake(centerX - closeX - 40, centerY + closeX + 40) controlPoint:CGPointMake(centerX - closeX - 50, centerY + closeX + 50)];
    
    [handPath moveToPoint:CGPointMake(centerX + closeX + 40, centerY + closeX + 40)];
    [handPath addQuadCurveToPoint:CGPointMake(centerX + closeX + 30, centerY + closeX + 60) controlPoint:CGPointMake(centerX + closeX + 30, centerY + closeX + 40)];
    [handPath addQuadCurveToPoint:CGPointMake(centerX + closeX + 50, centerY + closeX + 60) controlPoint:CGPointMake(centerX + closeX + 50, centerY + closeX + 70)];
    [handPath addQuadCurveToPoint:CGPointMake(centerX + closeX + 40, centerY + closeX + 40) controlPoint:CGPointMake(centerX + closeX + 50, centerY + closeX + 50)];
    
    //腰带
    CAShapeLayer *beltLayer = [CAShapeLayer layer];
    UIBezierPath *beltPath = [UIBezierPath bezierPath];
    [beltPath moveToPoint:CGPointMake(centerX - closeX , centerY + closeX + 40)];
    [beltPath addLineToPoint:CGPointMake(centerX - closeX, centerY + closeX + 60)];
    [beltPath addQuadCurveToPoint:CGPointMake(centerX + closeX, centerY + closeX + 60) controlPoint:CGPointMake(centerX, centerY + closeX + 80)];
    [beltPath addLineToPoint:CGPointMake(centerX + closeX, centerY + closeX + 40)];
    [beltPath addQuadCurveToPoint:CGPointMake(centerX - closeX, centerY + closeX + 40) controlPoint:CGPointMake(centerX, centerY + closeX + 60)];
    
    //tie
    CAShapeLayer *tieLayer = [CAShapeLayer layer];
    UIBezierPath *tiePath = [UIBezierPath bezierPath];
    //领结
    [tiePath moveToPoint:CGPointMake(centerX , centerY + closeX + 16)];
    [tiePath addQuadCurveToPoint:CGPointMake(centerX - 20, centerY + closeX + 30) controlPoint:CGPointMake(centerX - 20, centerY + closeX + 20)];
    [tiePath addQuadCurveToPoint:CGPointMake(centerX, centerY + closeX + 16) controlPoint:CGPointMake(centerX - 20, centerY + closeX + 40)];
    [tiePath addQuadCurveToPoint:CGPointMake(centerX + 20, centerY + closeX + 30) controlPoint:CGPointMake(centerX + 20, centerY + closeX + 20)];
    [tiePath addQuadCurveToPoint:CGPointMake(centerX, centerY + closeX + 16) controlPoint:CGPointMake(centerX + 20, centerY + closeX + 40)];
    
    [tiePath moveToPoint:CGPointMake(centerX - closeX, centerY + closeX + 15)];
    [tiePath addQuadCurveToPoint:CGPointMake(centerX + closeX, centerY + closeX + 15) controlPoint:CGPointMake(centerX, centerY + closeX + 20)];
    [tiePath addLineToPoint:CGPointMake(centerX + closeX, centerY + closeX)];
    [tiePath addLineToPoint:CGPointMake(centerX - closeX, centerY + closeX)];
    [tiePath addLineToPoint:CGPointMake(centerX - closeX, centerY + closeX + 15)];
   
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(centerX - 8, centerY + closeX, 16, 16) cornerRadius:8];

    //嘴
    CAShapeLayer *mouthLayer = [CAShapeLayer layer];
    UIBezierPath *mouthPath = [UIBezierPath bezierPath];
    [mouthPath moveToPoint:CGPointMake(centerX - 30, centerY + 30)];
    [mouthPath addQuadCurveToPoint:CGPointMake(centerX + 30, centerY + 30) controlPoint:CGPointMake(centerX, centerY + 50)];
    mouthLayer.lineWidth = 3;
    //花翎
    CAShapeLayer *peacockLayer = [CAShapeLayer layer];
    UIBezierPath *peacockPath = [UIBezierPath bezierPath];
    [peacockPath moveToPoint:CGPointMake(centerX - 15, centerY - 90)];
    [peacockPath addQuadCurveToPoint:CGPointMake(centerX - 20, centerY - 130) controlPoint:CGPointMake(centerX - 20, centerY - 100)];
    [peacockPath addQuadCurveToPoint:CGPointMake(centerX - 10, centerY - 90) controlPoint:CGPointMake(centerX - 10, centerY - 100)];
    [peacockPath moveToPoint:CGPointMake(centerX + 15, centerY - 90)];
    [peacockPath addQuadCurveToPoint:CGPointMake(centerX + 20, centerY - 130) controlPoint:CGPointMake(centerX + 20, centerY - 100)];
    [peacockPath addQuadCurveToPoint:CGPointMake(centerX + 10, centerY - 90) controlPoint:CGPointMake(centerX + 10, centerY - 100)];
    
    //绘图
    [self.view.layer addSublayer:_myTask.myLayer];
    if (_myTask.animation == 0) {
        _myTask.animation = 1;
    } else {
    
        switch (_myTask.checkPoint - 1) {
            case 1: {
                [self setLayer:headLayer path:headPath delay:1];
            
                [self setLayer:headLayer2 path:headPath2 delay:2];
            
                [self setLayerColor:headLayer color:MKCOLOR(181, 158, 107) delay:3];
            
                [self setLayerColor:headLayer2 color:[UIColor whiteColor] delay:3];
            }
                break;
            case 2: {
                [self setLayer:hatLayer path:hatPath delay:1];
                [self setLayer:peacockLayer path:peacockPath delay:2];
                [self setLayerColor:hatLayer color:MKCOLOR(252, 255, 62) delay:3];
                [self setLayerColor:peacockLayer color:MKCOLOR(255, 255, 65) delay:3];
            }
                break;
            case 3:{
                [self setLayer:faceLayer path:fachPath delay:1];
                [self setLayer:leftEyeLayer path:leftEyePath delay:2];
                [self setLayer:rightEyeLayer path:rightEyePath delay:2];
                [self setLayerColor:faceLayer color:MKCOLOR(249, 64, 78) delay:3];
                [self setLayerColor:leftEyeLayer color:[UIColor whiteColor] delay:3];
                [self setLayerColor:rightEyeLayer color:[UIColor whiteColor] delay:3];
            }
                break;
            case 4:{
                [self setLayer:leftPupilLayer path:leftPupilPath delay:1];
                [self setLayer:rightPupilLayer path:rightPupilPath delay:1];
                [self setLayer:leftEarLayer path:leftEarPath delay:2];
                [self setLayer:rightEarLayer path:rightEarPath delay:2];
                [self setLayerColor:leftEarLayer color:MKCOLOR(179, 154, 103) delay:3];
                [self setLayerColor:rightEarLayer color:MKCOLOR(179, 154, 103) delay:3];
                [self setLayerColor:leftPupilLayer color:MKCOLOR(74, 33, 22) delay:3];
                [self setLayerColor:rightPupilLayer color:MKCOLOR(74, 33, 22) delay:3];
            }
                break;
            case 5:{
                [self setLayer:bodyLayer path:bodyPath delay:1];
                [self setLayer:layer3 path:path3 delay:2];
                [self setLayer:mouthLayer path:mouthPath delay:2];
                [self setLayerColor:bodyLayer color:MKCOLOR(252, 255, 62) delay:3];
                }
                break;
            case 6:{
                [self setLayer:armLayer path:armPath delay:1];
                [self setLayer:handLayer path:handPath delay:2];
                [self setLayerColor:handLayer color:MKCOLOR(182, 157, 102) delay:3];
                [self setLayerColor:armLayer color:MKCOLOR(252, 255, 62) delay:3];
            }
                break;
            case 7:{
                [self setLayer:tieLayer path:tiePath delay:1];
                [self setLayer:circleLayer path:circlePath delay:2];
                [self setLayer:beltLayer path:beltPath delay:2];
                [self setLayerColor:beltLayer color:MKCOLOR(251, 68, 78) delay:3];
                [self setLayerColor:tieLayer color:MKCOLOR(114, 120, 255) delay:3];
                [self setLayerColor:circleLayer color:MKCOLOR(114, 120, 255) delay:3];
            }
                break;
            case 8:{
                [self setLayer:leftLagLayer path:leftLagPath delay:1];
                [self setLayer:rightLagLayer path:rightLagPath delay:1];
                [self setLayer:leftFootLayer path:leftFootPath delay:2];
                [self setLayer:rightFootLayer path:rightFootPath delay:2];
                [self setLayerColor:leftLagLayer color:MKCOLOR(249, 67, 78) delay:3];
                [self setLayerColor:rightLagLayer color:MKCOLOR(249, 67, 78) delay:3];
                [self setLayerColor:leftFootLayer color:MKCOLOR(177, 153, 102) delay:4];
                [self setLayerColor:rightFootLayer color:MKCOLOR(177, 153, 102) delay:4];
            }
                break;
            case 9:{
                //label
                [self createLabel];
                [self createButton];
           }
                break;
            default:
                break;
        }
    }
    _myTask.myLayer = self.view.layer;
    
}

- (void) createButton {
    _drawButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX - closeX - 65, centerY + closeX + 65, 30, 120)];
    [_drawButton setImage:[UIImage imageNamed:@"draw"] forState:UIControlStateNormal];
    [_drawButton addTarget:self action:@selector(clickedDraw:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_drawButton];
}
- (void) createLabel {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(centerX + closeX + 35, centerY + closeX + 65, 30, 120)];
    [button setImage:[UIImage imageNamed:@"label"] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    button.userInteractionEnabled = NO;
    
}
- (void) clickedDraw:(UIButton *) button {
    DrawViewController *drawVC = [[DrawViewController alloc] init];
    drawVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//翻转
    [self presentViewController:drawVC animated:YES completion:nil];
}

//绘图显示在view图层
- (void) setLayer:(CAShapeLayer *) layer path:(UIBezierPath *)path delay:(CFTimeInterval) delay {
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.lineWidth = 2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view.layer addSublayer:layer];
        [self addAnimationOnLayer:layer duration:0.5];
    });
}
//动画
- (void) addAnimationOnLayer:(CAShapeLayer *) layer duration:(CFTimeInterval) duration {
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.fromValue = @(0);
    animation1.toValue = @(1);
    animation1.duration = duration;
    
    [layer addAnimation:animation1 forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation2.fromValue = @(1);
    animation2.toValue = @(8);
    animation2.duration = duration;
    
    [layer addAnimation:animation1 forKey:nil];
    [layer addAnimation:animation2 forKey:nil];
    
}

//上色
- (void) setLayerColor:(CAShapeLayer *) layer color:(UIColor *) color delay:(CFTimeInterval) delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.fillColor = color.CGColor;
    });
}

- (void) createActionView {
    _gifView = [[UIView alloc] initWithFrame:self.view.frame];
    _gifView.backgroundColor = [UIColor blackColor];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    CGFloat imageH = w * 100 / 250;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ( h - imageH ) / 2, w, imageH)];
    imageView.image = [UIImage sd_animatedGIFNamed:@"RGB2"];
    [_gifView addSubview:imageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((w - 150) / 2, CGRectGetMaxY(imageView.frame), 150, 50)];
    [button setTitle:@"进入游戏" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goIntoGame) forControlEvents:UIControlEventTouchUpInside];
    [_gifView addSubview:button];
}
#pragma mark - ActionViewButton
- (void) goIntoGame {
    [UIView animateWithDuration:1 animations:^{
        _gifView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        _gifView.alpha = 0;
    } completion:^(BOOL finished) {
        [_gifView removeFromSuperview];
    }];
}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [_imageView removeFromSuperview];
    
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
