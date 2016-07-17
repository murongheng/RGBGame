//
//  GameViewController.m
//  RGBGame
//
//  Created by 千锋 on 16/2/25.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "GameViewController.h"
#import "ViewController.h"
#import "UIColor+Util.h"
//#import "Task.h"
#define WIDTH self.view.frame.size.width / 3
#define HEIGHT self.view.frame.size.height

#define RED [UIColor redColor]
#define BLUE [UIColor blueColor]
#define GREEN [UIColor greenColor]
@implementation GameViewController {
    NSMutableArray *_btnArray;
    NSTimer *_timer; // 定时器
    
    NSMutableArray *_stratArr; // 产生不重复随机数的初始数组
    NSMutableArray *_resultArr; // 产生不重复随机数的结构数组
   
    NSInteger _count; //总的时间 (整)
    NSInteger _speed; //速度
    NSInteger _step; //创建btn的间隔时间(整数）
    NSInteger _red;  //随机颜色
    NSInteger _blue; //随机颜色
    NSInteger _green; //随机颜色
    
    NSInteger _score; //分数
    UILabel *_scoreLabel; //显示分数标签
    NSString *_prompt; // 提示
}

- (void) viewDidLoad {
  
   
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gameBack1.jpg"]];
    _score = 0;
    _speed = _myTask.speed;
   
    _stratArr = [[NSMutableArray alloc] initWithObjects:@1, @2, @3, nil];
    _resultArr = [[NSMutableArray alloc] init];
    _btnArray = [[NSMutableArray alloc]init];
    [self createScoreLabel];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(action) userInfo:nil repeats:YES];
}

- (void) createScoreLabel {
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 3, 60)];
    _scoreLabel.textColor = [UIColor blackColor];
    _scoreLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"label.jpg"]];
//    _scoreLabel.backgroundColor = [UIColor whiteColor];
    if (_myTask.checkPoint < 9) {
        _prompt = [NSString stringWithFormat:@"任务%ld: 点击%@色方块%ld次   得分:", (long)_myTask.checkPoint, _myTask.colorStr, (long)_myTask.number];
    } else {
        _prompt = [NSString stringWithFormat:@"点击蓝色方块  得分:"];
    }
    
    _scoreLabel.text = [NSString stringWithFormat:@"%@0", _prompt];
    _scoreLabel.textColor = [UIColor blackColor];
    _scoreLabel.font = [UIFont boldSystemFontOfSize:18];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_scoreLabel];
}

- (void) action {
    [self createButton];
    [self moveButton];
}

- (void) createButton {
    _step = 120 / _speed;
    if (_count % _step == 0) {

        [self createUncertainNumber];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(i * WIDTH, -120, WIDTH, 120);
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = [[UIColor whiteColor] CGColor];

            button.alpha = 0.6;
            if (i == _red) {
                button.backgroundColor = RED;
                [button addTarget:self action:@selector(redButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (i == _blue) {
                button.backgroundColor = BLUE;
                [button addTarget:self action:@selector(blueButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                button.backgroundColor = GREEN;
                [button addTarget:self action:@selector(greenButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:button];
            [self.view bringSubviewToFront:_scoreLabel];
            [_btnArray addObject:button];
        }
    }
    _count++;
}

- (void) moveButton {
    for (int i = 0; i < _btnArray.count; i++) {
        UIButton *btn = (UIButton *)[_btnArray objectAtIndex:i];
        NSInteger newY = 0;
        newY = btn.frame.origin.y + _speed;
        btn.frame = CGRectMake(btn.frame.origin.x, newY, WIDTH, 120);
        
        if (btn.frame.origin.y > HEIGHT) {
            if (btn.backgroundColor == _myTask.taskColor) {
                [_timer setFireDate:[NSDate distantFuture]];
                [self createWarningAlertView];
            }
            [_btnArray removeObject:btn];
            [btn removeFromSuperview];
        }
    }
}

- (void) createUncertainNumber {
    for (int i = 0; i < 3; i++) {
        int t = arc4random() % _stratArr.count + 1;
        _resultArr[i] = _stratArr[t - 1];
        [_stratArr removeObject:_stratArr[t - 1]];
    }
    _red = [_resultArr[0] integerValue] - 1;
    _blue = [_resultArr[1] integerValue] - 1;
    _green = [_resultArr[2] integerValue] - 1;
    [_stratArr setArray:_resultArr];
     
    
}

- (void) redButtonPress:(UIButton *) button {
    if (_myTask.checkPoint >= 1 && _myTask.checkPoint <= 3) {
        [self clickTrueWithButton:button];
    } else {
        [self clickWrongWithButton:button];
    }
}

- (void) blueButtonPress:(UIButton *) button {
    //&& _myTask.checkPoint <= 9
    if (_myTask.checkPoint >= 7 ) {
        [self clickTrueWithButton:button];
    } else {
        [self clickWrongWithButton:button];
    }
}

- (void) greenButtonPress:(UIButton *) button {
    if (_myTask.checkPoint >= 4 && _myTask.checkPoint <= 6) {
        [self clickTrueWithButton:button];
    } else {
        [self clickWrongWithButton:button];
    }
}

//错误点击
- (void) clickWrongWithButton:(UIButton *) button {
    
    [_timer setFireDate:[NSDate distantFuture]];
    [self createAlertView];
}
//正确点击
- (void) clickTrueWithButton:(UIButton *) button {
    _score += 1;
    _scoreLabel.text = [NSString stringWithFormat:@"%@%ld",  _prompt, (long)_score];
    [button setBackgroundColor:[UIColor clearColor]];
    
    button.userInteractionEnabled = NO;
    if (_myTask.checkPoint > 9) {
        
    } else if (_score >= _myTask.number) {
        
        [_timer setFireDate:[NSDate distantFuture]];
        [self createSuccessAlertView];
        
    }
}
//成功提示
- (void) createSuccessAlertView {
    if (_score > _myTask.hightScore) {
        _myTask.hightScore = _score;
    }
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"任务达成" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ViewController *vc = [[ViewController alloc] init];
        [self taskSucceed];
        vc.myTask = _myTask;
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}
//游戏失败提示点击错误的方块
- (void) createAlertView {
    if (_score > _myTask.hightScore) {
        _myTask.hightScore = _score;
    }
    //
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"游戏失败" message:@"点击到了错误的方块" preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertControllerStyleAlert -- 从中间出现
    //  -- 从底部冒出来   或有目标方块逃逸
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ViewController *vc = [[ViewController alloc] init];
        _myTask.animation = 0;
        vc.myTask = _myTask;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self removeButton];
        [self viewDidLoad];
    }];
    [ac addAction:okAction];
    [ac addAction:cancelAction];
    [self presentViewController:ac animated:YES completion:nil];
}
//游戏错误提示目标方块逃逸
- (void) createWarningAlertView {
    if (_score > _myTask.hightScore) {
        _myTask.hightScore = _score;
    }
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"游戏失败" message:@"有目标方块逃逸" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ViewController *vc = [[ViewController alloc] init];
        vc.myTask = _myTask;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self removeButton];
        [self viewDidLoad];
    }];
    [ac addAction:okAction];
    [ac addAction:cancelAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void) taskSucceed {
    _myTask.checkPoint += 1;
    if (_myTask.checkPoint >= 1 && _myTask.checkPoint <=3) {
        _myTask.taskColor = RED;
        _myTask.speed = 2;
        _myTask.number = 10 * (_myTask.checkPoint);
        _myTask.colorStr = @"红";
        
    } else if (_myTask.checkPoint >= 4 && _myTask.checkPoint <=6) {
        _myTask.taskColor = GREEN;
        _myTask.speed = 3;
        _myTask.number = 10 * (_myTask.checkPoint - 3);
        _myTask.colorStr = @"绿";
    } else if (_myTask.checkPoint >= 7 && _myTask.checkPoint <= 9) {
        _myTask.taskColor = BLUE;
        _myTask.speed = 4;
        _myTask.number = 10 * (_myTask.checkPoint - 6);
        _myTask.colorStr = @"蓝";
    }
}

- (void) removeButton {
    for (int i = 0; i < _btnArray.count; i++) {
        UIButton *btn = (UIButton *)[_btnArray objectAtIndex:i];
        [btn removeFromSuperview];
    }
}



@end
