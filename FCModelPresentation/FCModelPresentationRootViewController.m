//
//  FCModelPresentationRootViewController.m
//  FCModelPresentation
//
//  Created by Harley.xk on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import "FCModelPresentationRootViewController.h"
#import "FCModelPresentationCenter.h"
#import "UIView+AutoLayout.h"

@interface FCModelPresentationRootViewController ()
<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIViewController<FCModelPresentationProtocol> *builtinViewController;
@property (strong, nonatomic) UIView *backgroundView;

/**
 *  键盘事件需要的参数
 */
@property (strong, nonatomic) NSLayoutConstraint *builtinCenterX;
@property (strong, nonatomic) NSLayoutConstraint *builtinCenterY;
@property (assign, nonatomic) CGSize builtinSize;
@property (assign, nonatomic) BOOL keyboardIsShow;
@end

@implementation FCModelPresentationRootViewController

- (instancetype)initWithBuiltinViewController:(UIViewController<FCModelPresentationProtocol> *)controller
{
    self = [super init];
    
    self.builtinViewController = controller;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // background
    self.backgroundView = [[UIView alloc] init];
    [self.view addSubview:self.backgroundView];
    [self.backgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViaTapOutSide)];
    [self.backgroundView addGestureRecognizer:ges];
    
    
    // built in
    [self addChildViewController:self.builtinViewController];
    [self.view addSubview:self.builtinViewController.view];
    self.builtinViewController.view.layer.cornerRadius = 8;
    
    NSArray *constraints = [self.builtinViewController.view autoCenterInSuperview];
    
    self.builtinCenterX = constraints[1];
    self.builtinCenterY = constraints[0];
    if ([self.builtinViewController respondsToSelector:@selector(fc_centerConstraintY)]) {
        self.builtinViewController.fc_centerConstraintY = constraints[0];
    }
    if ([self.builtinViewController respondsToSelector:@selector(fc_centerConstraintX)]) {
        self.builtinViewController.fc_centerConstraintX = constraints[1];
    }
    
    // 监测键盘弹出和隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.builtinSize = CGSizeMake(540, 620);
    if ([self.builtinViewController respondsToSelector:@selector(fc_modelPresentationSize)]) {
        self.builtinSize = [self.builtinViewController fc_modelPresentationSize];
    }
    [self.builtinViewController.view autoSetDimensionsToSize:self.builtinSize];

    [self presentAnimated:YES completion:self.presentationCompletionCallback];
}


- (void)dismissViaTapOutSide
{
    // 当键盘已显示时，隐藏键盘
    if (self.keyboardIsShow) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        return;
    }
    
    if ([self.builtinViewController respondsToSelector:@selector(fc_canDismissViaTapOutside)]) {
        // 只有当实现协议方法并禁止点击隐藏时，才禁用该功能
        if (![self.builtinViewController fc_canDismissViaTapOutside])
        {
            return;
        }
    }
    [[FCModelPresentationCenter sharedCenter] dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    // 需要显示动画
    if (animated)
    {
        // 背景渐黑为固定的默认动画，不可修改
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        self.backgroundView.alpha =  0 ;
        self.builtinViewController.view.alpha = 0.5;
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundView.alpha = 1.0;
            self.builtinViewController.view.alpha = 1.0;
        } completion:nil];

        BOOL shouldUseCustomPresentAnimation = NO;
        // 实现自定动画时执行自定义动画
        if ([self.builtinViewController respondsToSelector:@selector(fc_runModelPresentAnimation)])
        {
            if ([self.builtinViewController respondsToSelector:@selector(fc_shouldUseCustomPresentAnimation)]) {
                shouldUseCustomPresentAnimation = [self.builtinViewController fc_shouldUseCustomPresentAnimation];
            }else{
                shouldUseCustomPresentAnimation = YES;
            }
        }
        
        if (shouldUseCustomPresentAnimation) {
            [self.builtinViewController fc_runModelPresentAnimation];
            if (completion) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }else{
            [self runDefaultAnimationForPresentCompleted:^{
                if (completion) {
                    completion();
                }
            }];
        }
    }
    else
    {
        self.backgroundView.alpha = 1.0;
    }
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (animated)
    {
        // 背景渐白为固定的默认动画，不可修改
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundView.alpha = 0.0;
            self.builtinViewController.view.alpha = 0.0;
        } completion:nil];
        
        BOOL shouldUseCustomAnimation = NO;
        // 实现自定动画时执行自定义动画
        if ([self.builtinViewController respondsToSelector:@selector(fc_runModelDismissAnimation)])
        {
            if ([self.builtinViewController respondsToSelector:@selector(fc_shouldUseCustomDismissAnimation)]) {
                shouldUseCustomAnimation = [self.builtinViewController fc_shouldUseCustomDismissAnimation];
            }else{
                shouldUseCustomAnimation = YES;
            }
        }
        
        if (shouldUseCustomAnimation)
        {
            [self.builtinViewController fc_runModelDismissAnimation];
            if (completion) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }
        else
        {
            [self runDefaultAnimationForDismissCompleted:^{
                if (completion) {
                    completion();
                }
            }];
        }
    }
    else if (completion)
    {
        completion();
    }
}

#pragma mark - Animation
- (void)runDefaultAnimationForPresentCompleted:(void (^)(void))completion
{
    UIView *builtinView = self.builtinViewController.view;
    CATransform3D transform = CATransform3DScale(CATransform3DIdentity, 0.1, 0.1, 1);
    
    builtinView.layer.transform = transform;
    [UIView animateWithDuration:0.09 animations:^{
        CATransform3D transformLarge = CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1);
        builtinView.layer.transform = transformLarge;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08 animations:^{
            CATransform3D transformSmall = CATransform3DScale(CATransform3DIdentity, 0.9, 0.9, 1);
            builtinView.layer.transform = transformSmall;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.08 animations:^{
                CATransform3D transformReverse = CATransform3DScale(CATransform3DIdentity, 1, 1, 1);
                builtinView.layer.transform = transformReverse;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }];
    }];
}

- (void)runDefaultAnimationForDismissCompleted:(void (^)(void))completion
{
    UIView *builtinView = self.builtinViewController.view;
    
    [UIView animateWithDuration:0.05 animations:^{
        CATransform3D transformLarge = CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1);
        builtinView.layer.transform = transformLarge;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            CATransform3D transformSmall = CATransform3DScale(CATransform3DIdentity, 0.1, 0.1, 1);
            builtinView.layer.transform = transformSmall;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }];
}


#pragma mark - KeyBoard
- (void)keyBoardWillShow:(NSNotification*)notif
{
    self.keyboardIsShow = YES;
    
    NSDictionary *userInfo = notif.userInfo;
    
    // 结束时的Frame
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 动画时间和选项
    NSTimeInterval animateDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int animateOption = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    // 计算剩余高度
    CGFloat restHeight = self.view.bounds.size.height - endFrame.size.height - 20;
    CGFloat oldCenter = self.view.bounds.size.height / 2;
    CGFloat newCenter;

    // 如果剩余高度除去状态栏小于视图的高度，则上移至statusbar下面
    if (restHeight <= self.builtinSize.height)  {
        newCenter = self.builtinSize.height / 2 + 20;
    }
    else {
        newCenter = restHeight / 2 + 20;
    }
    [UIView animateWithDuration:animateDuration delay:0 options:animateOption animations:^{
        self.builtinCenterY.constant = newCenter - oldCenter;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyBoardWillHide:(NSNotification*)notif
{
    self.keyboardIsShow = NO;
    
    NSDictionary *userInfo = notif.userInfo;
    
    // 动画时间和选项
    NSTimeInterval animateDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int animateOption = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];

    [UIView animateWithDuration:animateDuration delay:0 options:animateOption animations:^{
        self.builtinCenterY.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

@end
