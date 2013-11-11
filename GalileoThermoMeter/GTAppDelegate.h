//
//  GTAppDelegate.h
//  GalileoThermoMeter
//
//  Created by Shunsuke Taniguchi on 2013/10/15.
//  Copyright (c) 2013年 Shunsuke Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTViewController.h"

@interface GTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GTViewController *viewController;

@end
