//
//  PreferencesViewController.h
//  GalileoThermoMeter
//
//  Created by Shunsuke Taniguchi on 2013/10/15.
//  Copyright (c) 2013年 Shunsuke Taniguchi. All rights reserved.
//

#import "GTViewController.h"

@interface PreferencesViewController : GTViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    CALayer *preferencesBaseLayer;//base layer
    CALayer *wpBackLayer;// white square
    CALayer *sphereBackLayer;// white square
    CALayer *preferencesWhiteLayer;//this layer can make picker stand out
    
    
    CATextLayer *textLayerWP;//displays present wallpaper
    CATextLayer *textLayerSP;//displays present sphere
    
    UIButton *pickerWpButton;//show wallpaper select picker
    UIButton *pickerSpButton;//show sphere select picker
    
    NSArray *wpArray;//wallpaper name
    NSArray *spArray;//sphere name
    
    NSString *wpName;//wallpaper name array
    NSString *spName;//sphere name array
    
    
    
}

@end
