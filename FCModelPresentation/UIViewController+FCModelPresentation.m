//
//  UIViewController+FCModelPresentation.m
//  FCModelPresentationSample
//
//  Created by Harley.xk on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import "UIViewController+FCModelPresentation.h"
#import "FCModelPresentationCenter.h"

@implementation UIViewController (FCModelPresentation)

- (void)fc_modelPresentViewController:(UIViewController*)controller animated:(BOOL)animated completion:(void (^)(void))completion
{
    [[FCModelPresentationCenter sharedCenter] presentViewController:controller animated:animated completion:completion];
}

- (void)fc_dismissModelViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [[FCModelPresentationCenter sharedCenter] dismissViewControllerAnimated:animated completion:completion];
}

@end


/**
 *  自定义连线，实现在StoryBoard中使用segue操作
 */
@implementation FCModelPresentationSegue : UIStoryboardSegue

- (void)perform
{
    UIViewController *destinationViewController = self.destinationViewController;
    [[FCModelPresentationCenter sharedCenter] presentViewController:destinationViewController animated:YES completion:nil];
}

@end