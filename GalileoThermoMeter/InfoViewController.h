//
//  InfoViewController.h
//  GalileoThermoMeter
//
//  Created by Shunsuke Taniguchi on 2013/10/15.
//  Copyright (c) 2013年 Shunsuke Taniguchi. All rights reserved.
//

#import "GTViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface InfoViewController : GTViewController
{
    CALayer *infoBaseLayer;//Base layer
    CALayer *infoBlackLayer;//Black layer
    
    CATextLayer *textLayerInfo;// description for this application
    
    
}


@end
