//
//  ViewController.m
//  FCModelPresentationSample
//
//  Created by Harley.xk on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import "ViewController.h"
#import "ModelViewController.h"
#import "UIViewController+FCModelPresentation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAction:(id)sender
{
    ModelViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ModelViewController"];
    [self fc_modelPresentViewController:controller animated:YES completion:nil];
}

- (IBAction)show2Action:(id)sender
{
    ModelViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ModelViewController"];
    controller.showType = 1;
    [self fc_modelPresentViewController:controller animated:YES completion:nil];
}

@end
