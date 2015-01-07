//
//  ModelViewController.h
//  FCModelControlCenterSample
//
//  Created by Harley on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+FCModelPresentation.h"

@interface ModelViewController : UIViewController
<FCModelPresentationProtocol>

@property (assign, nonatomic) int showType;

@end
