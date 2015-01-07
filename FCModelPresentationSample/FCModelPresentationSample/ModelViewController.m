//
//  ModelViewController.m
//  FCModelControlCenterSample
//
//  Created by Harley on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import "UIViewController+FCModelPresentation.h"
#import "ModelViewController.h"

@interface ModelViewController ()

@end

@implementation ModelViewController

@synthesize fc_centerConstraintX;
@synthesize fc_centerConstraintY;


- (IBAction)presentAction:(id)sender
{
    ModelViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ModelViewController"];
    [self fc_modelPresentViewController:controller animated:YES completion:nil];
}

- (IBAction)dismissAction:(id)sender
{
    [self fc_dismissModelViewControllerAnimated:YES completion:nil];
}


// 实现该方法，以返回当前视图大小
- (CGSize)fc_modelPresentationSize
{
    return CGSizeMake(500, 400);
}

/**
 *  实现该方法来阻止点击背景自动关闭
 */
//- (BOOL)fc_canDismissViaTapOutside
//{
//    return NO;
//}

- (BOOL)fc_shouldUseCustomPresentAnimation
{
    return self.showType == 0;
}

- (BOOL)fc_shouldUseCustomDismissAnimation
{
    return self.showType == 0;
}

- (void)fc_runModelPresentAnimation
{
    self.fc_centerConstraintY.constant = 500;
    [self.view layoutIfNeeded]; // constant初始值为0，所以需要update到最新

    [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
        self.fc_centerConstraintY.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fc_runModelDismissAnimation
{
    [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
        self.fc_centerConstraintY.constant = 500;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

@end
