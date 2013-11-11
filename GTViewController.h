//
//  GTViewController.h
//  GalileoThermoMeter
//
//  Created by Shunsuke Taniguchi on 2013/10/15.
//  Copyright (c) 2013年 Shunsuke Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GADBannerView.h"

@interface GTViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    int prefectureTemperature;//Prefecture's temperature
    int evenTemperature;//Modified temperature by 2 degree for prefectureTemperature
    int startTemperature;//Temperature when app launches
    int rippleWhitePosX;// White ripple epi-center position
    int rippleWhitePosY;// White ripple epi-center position
    int rippleYellowPosX;// Yellow ripple epi-center position
    int rippleYellowPosY;// Yellow ripple epi-center position
    
    double elapsedTime;// Elapsed time since users use this app
    
    NSArray *prefectureNameArray;// Array of prefecture name
    
    NSDictionary *prefectureInformationDictionary;// Dictionary of prefecture info
    
    NSString *prefecture;// String of prefecture name
    NSString *wallPaperName;// String of wallpaper name
    NSString *tempSphereName;//Temp sphere name
    NSString *sphereName;//Sphere name
    
    NSTimer *timeElapsingTimer;// This timer can have time of using thie application
    NSTimer *spherePositionAdjustTimer;// This timer needs to adjust degree sphere position
    NSTimer *rippleWhiteTimer;// This timer needs to create white ripple animation
    NSTimer *rippleYellowTimer;// This timer needs to create yellow ripple animation
    
    
    CALayer *baseLayer;// Wallpaper
    CALayer *whiteLayer;// When Pickers appeared, the other parts are covered with dark
    CALayer *circleLayer;// Temperature text background circle object
    CALayer *weatherPicLayer;// Weather pictgram
    CALayer *tubeLayer;//Temp Spheres move in this tube
    CALayer *rippleWhiteLayer;//White circle ripple
    CALayer *rippleYellowLayer;//Yellow circle ripple
    CALayer *tempSphereLayer06;//Temp sphere 6 degree
    CALayer *tempSphereLayer08;//Tempsphere 8 degree
    CALayer *tempSphereLayer10;//Tempsphere 10 degree
    CALayer *tempSphereLayer12;//Tempsphere 12 degree
    CALayer *tempSphereLayer14;//Tempsphere 14 degree
    CALayer *tempSphereLayer16;//Tempsphere 16 degree
    CALayer *tempSphereLayer18;//Tempsphere 18 degree
    CALayer *tempSphereLayer20;//Tempsphere 20 degree
    CALayer *tempSphereLayer22;//Tempsphere 22 degree
    CALayer *tempSphereLayer24;//Tempsphere 24 degree
    CALayer *tempSphereLayer26;//Tempsphere 26 degree
    CALayer *tempSphereLayer28;//Tempsphere 28 degree
    CALayer *tempSphereLayer30;//Tempsphere 30 degree
    CALayer *tempSphereLayer32;//Tempsphere 32 degree
    
    CATextLayer *degreeTextLayer;//temperature degree text
    CATextLayer *positionTextLayer;//position text
    
    GADBannerView *bannerView_;//　Ad banner view
    
#define BASIC_SPHERE_LINE 1574


    
}

@end
