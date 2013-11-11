//
//  PreferencesViewController.m
//  GalileoThermoMeter
//
//  Created by Shunsuke Taniguchi on 2013/10/15.
//  Copyright (c) 2013年 Shunsuke Taniguchi. All rights reserved.
//

#import "PreferencesViewController.h"
#import "GTViewController.h"
#import "SavedDataHandler.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController
{
    UIButton *backhomeButton;
    UIPickerView *wpPicker;
    UIPickerView *spPicker;
    
    UIButton *sel_wp_button;
    UIButton *sel_sp_button;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    UIScreen *sc = [UIScreen mainScreen];//Obtains screen size
    
    wpArray = [[NSArray alloc] initWithObjects:@"光と窓",
               @"空",@"スペクトル",@"夕焼け",@"森",
               @"水中",@"海",@"夜空",@"桜",@"夏の棚田",@"紅葉",@"氷の大地",@"ハーバー",@"ピラミッド",
               
               
               nil];
    
    spArray = [[NSArray alloc] initWithObjects:@"ガラス球",
               @"ビードロ",@"ハート",@"星",@"ネオン",
               @"LOCKED",@"LOCKED",@"LOCKED",@"LOCKED",@"LOCKED",
               
               
               nil];
    
    // Set basic layer
    preferencesBaseLayer = [CALayer layer];
    preferencesBaseLayer.contentsScale = [[UIScreen mainScreen] scale];
    preferencesBaseLayer.bounds = CGRectMake(0, 0, 320, 568);
    preferencesBaseLayer.position = CGPointMake(160,284);
    preferencesBaseLayer.contents = (id)[UIImage imageNamed:@"gray-line.png"].CGImage;
    preferencesBaseLayer.zPosition = 0;
    
    //　White square layer for wallpaper select
    wpBackLayer = [CALayer layer];
    wpBackLayer.contentsScale = [[UIScreen mainScreen] scale];
    wpBackLayer.bounds = CGRectMake(0, 0, 200, 36);
    wpBackLayer.position = CGPointMake(120,80);
    wpBackLayer.contents = (id)[UIImage imageNamed:@"wp-back.png"].CGImage;
    wpBackLayer.zPosition = 1;
    
    //　White square layer for sphere select
    sphereBackLayer = [CALayer layer];
    sphereBackLayer.contentsScale = [[UIScreen mainScreen] scale];
    sphereBackLayer.bounds = CGRectMake(0, 0, 200, 36);
    sphereBackLayer.position = CGPointMake(120,160);
    sphereBackLayer.contents = (id)[UIImage imageNamed:@"sphere-back.png"].CGImage;
    sphereBackLayer.zPosition = 1;
    
    // Set preferences font
    CALayer *settei = [CALayer layer];
    settei.bounds  = CGRectMake(0, 0, 36, 18);
    settei.position = CGPointMake(160,24);
    settei.contents = (id)[UIImage imageNamed:@"settei.png"].CGImage;
    settei.zPosition = 1;
    
    // Set text layer for wallpaper
    textLayerWP = [CATextLayer layer];
    textLayerWP.contentsScale = [[UIScreen mainScreen] scale];
    textLayerWP.bounds = CGRectMake(0, 0, 200, 36);
    textLayerWP.position = CGPointMake(170, 90);
    textLayerWP.foregroundColor = [UIColor blackColor].CGColor;
    textLayerWP.shadowColor = [UIColor blackColor].CGColor;
    textLayerWP.fontSize = 16.0;
    textLayerWP.alignmentMode = kCAAlignmentLeft;
    textLayerWP.string = [[SavedDataHandler sharedSavedDataHandler] getWpName];
    textLayerWP.zPosition = 5;
    
    // Set text layer for sphere
    textLayerSP = [CATextLayer layer];
    textLayerSP.contentsScale = [[UIScreen mainScreen] scale];
    textLayerSP.bounds = CGRectMake(0, 0, 200, 36);
    textLayerSP.position = CGPointMake(170, 170);
    textLayerSP.foregroundColor = [UIColor blackColor].CGColor;
    textLayerSP.shadowColor = [UIColor blackColor].CGColor;
    textLayerSP.fontSize = 16.0;
    textLayerSP.alignmentMode = kCAAlignmentLeft;
    textLayerSP.string = [[SavedDataHandler sharedSavedDataHandler] getSpName];
    textLayerSP.zPosition = 6
    ;
    
    //　Set home button
    backhomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backhomeButton.frame = CGRectMake(0, sc.bounds.size.height - GAD_SIZE_320x50.height - 40, 40, 40);
    backhomeButton.layer.zPosition = 100;
    [backhomeButton setImage:[UIImage imageNamed:@"button-home.png"] forState:UIControlStateNormal];
    [backhomeButton addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    
    //　Set show wallpaper select picker button
    pickerWpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pickerWpButton.frame = CGRectMake(60, 62, 160, 36);
    pickerWpButton.layer.zPosition = 100;
    [pickerWpButton setImage:[UIImage imageNamed:@"trans-button.png"] forState:UIControlStateNormal];
    [pickerWpButton addTarget:self action:@selector(showWpPicker) forControlEvents:UIControlEventTouchUpInside];
    
    //　Set show sphere select picker button
    pickerSpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pickerSpButton.frame = CGRectMake(60, 142, 160, 36);
    pickerSpButton.layer.zPosition = 100;
    [pickerSpButton setImage:[UIImage imageNamed:@"trans-button.png"] forState:UIControlStateNormal];
    [pickerSpButton addTarget:self action:@selector(showSpPicker) forControlEvents:UIControlEventTouchUpInside];
    
    // Set white layer while showing picker.
    preferencesWhiteLayer = [CALayer layer];
    preferencesWhiteLayer.bounds = CGRectMake(0,0,320,568);
    preferencesWhiteLayer.position = CGPointMake(160,284);
    preferencesWhiteLayer.contents = (id)[UIImage imageNamed:@"white.png"].CGImage;
    preferencesWhiteLayer.opacity = 0;
    preferencesWhiteLayer.zPosition = 101;
    
    
    [preferencesBaseLayer addSublayer:settei];
    [preferencesBaseLayer addSublayer:wpBackLayer];
    [preferencesBaseLayer addSublayer:sphereBackLayer];
    [preferencesBaseLayer addSublayer:textLayerWP];
    [preferencesBaseLayer addSublayer:textLayerSP];
    [preferencesBaseLayer addSublayer:preferencesWhiteLayer];
    
    [self.view.layer addSublayer:preferencesBaseLayer];
    [self.view addSubview:pickerWpButton];
    [self.view addSubview:pickerSpButton];
    [self.view addSubview:backhomeButton];
    
    //　Wallpaper select picker
    wpPicker = [[UIPickerView alloc] init];
    wpPicker.frame = CGRectMake(0,568,320,162);
    wpPicker.showsSelectionIndicator = YES;
    wpPicker.delegate = self;
    wpPicker.dataSource = self;
    wpPicker.tag = 2;
    [self.view addSubview:wpPicker];
    [wpPicker selectRow:[[SavedDataHandler sharedSavedDataHandler] getPickerWallpaperRowNumber] inComponent:0 animated:NO];
    
    //　Sphere select picker
    spPicker = [[UIPickerView alloc] init];
    spPicker.frame = CGRectMake(0,568,320,162);
    spPicker.showsSelectionIndicator = YES;
    spPicker.delegate = self;
    spPicker.dataSource = self;
    spPicker.tag = 3;
    [self.view addSubview:spPicker];
    [spPicker selectRow:[[SavedDataHandler sharedSavedDataHandler] getPickerSphereRowNumber] inComponent:0 animated:NO];
    
    //　Decision button for wallpaper picker
    sel_wp_button = [UIButton buttonWithType:UIButtonTypeCustom];
    sel_wp_button.frame = CGRectMake(120, 770, 80, 40);
    [sel_wp_button setImage:[UIImage imageNamed:@"button-select-j.png"] forState:UIControlStateNormal];
    [sel_wp_button addTarget:self action:@selector(hideWpPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sel_wp_button];
    
    //　Decision button for sphere picker
    sel_sp_button = [UIButton buttonWithType:UIButtonTypeCustom];
    sel_sp_button.frame = CGRectMake(120, 770, 80, 40);
    [sel_sp_button setImage:[UIImage imageNamed:@"button-select-j.png"] forState:UIControlStateNormal];
    [sel_sp_button addTarget:self action:@selector(hideSpPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sel_sp_button];
    
    //　This is ad banner view
    
    CGPoint origin = CGPointMake(0, sc.bounds.size.height - GAD_SIZE_320x50.height);
    NSLog(@"%f",self.view.frame.size.height);
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    bannerView_.adUnitID = @"ca-app-pub-5916462741443088/1398778055";
    bannerView_.rootViewController = self;
    bannerView_.layer.zPosition = 50;
    
    
    [self.view addSubview:bannerView_];
    
    GADRequest *gadrequest = [GADRequest request];
    gadrequest.testing = NO;
    gadrequest.testDevices = [NSArray arrayWithObjects:@"GAD_SIMULATOR_ID", nil];
    
    [bannerView_ loadRequest:gadrequest];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //returns picker components number
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int components_number;
    
    if(pickerView.tag == 2){
        switch(component){
            case 0:
                if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 50400){
                    components_number = 14;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 46800){
                    components_number = 13;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 43200){
                    components_number = 12;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 39600){
                    components_number = 11;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 36000){
                    components_number = 10;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 32400){
                    components_number = 9;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 14400){
                    components_number = 8;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 10800){
                    components_number = 7;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 7200){
                    components_number = 6;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 3600){
                    components_number = 5;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 1800){
                    components_number = 4;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 600){
                    components_number = 3;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 180){
                    components_number = 2;
                    break;
                }else{
                    components_number = 1;
                    break;
                }
            default:
                return 0;
                break;
        }
    }
    
    if(pickerView.tag == 3){
        switch(component){
            case 0:
                if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 28800){
                    components_number = 5;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 25200){
                    components_number = 4;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 21600){
                    components_number = 3;
                    break;
                }else if([[SavedDataHandler sharedSavedDataHandler] getElapsedTime] >= 18000){
                    components_number = 2;
                    break;
                }else{
                    components_number = 1;
                    break;
                }
                
            default:
                components_number = 0;
                break;
        }
    }
    
    // returns components rows number
    return components_number;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    
    if(pickerView.tag == 2){
        // Set wallpaper picker string
        str = [NSString stringWithFormat:@"%@",[wpArray objectAtIndex:row]];
        
    }else if(pickerView.tag == 3){
        
        str = [NSString stringWithFormat:@"%@",[spArray objectAtIndex:row]];
        
    }else{
        str = @"";
    }
    
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // If picker's value determined, following process will do
    
    
    if(pickerView.tag == 2){
        NSInteger val = [wpPicker selectedRowInComponent:0];
        wpName = [wpArray objectAtIndex:val];
        textLayerWP.string = wpName;
        [[SavedDataHandler sharedSavedDataHandler] saveWpName:wpName];
        [[SavedDataHandler sharedSavedDataHandler] savePickerWallpaperRowNumber:row];
    }else if(pickerView.tag == 3){
        NSInteger val = [spPicker selectedRowInComponent:0];
        spName = [spArray objectAtIndex:val];
        textLayerSP.string = spName;
        [[SavedDataHandler sharedSavedDataHandler] saveSpName:spName];
        [[SavedDataHandler sharedSavedDataHandler] savePickerSphereRowNumber:row];
    }else{
        ;
    }
    
    
    
    
    
}


- (void)showWpPicker
{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    pickerWpButton.userInteractionEnabled = NO;
    pickerSpButton.userInteractionEnabled = NO;
    wpPicker.frame = CGRectMake(0,198,320,162);
    sel_wp_button.frame = CGRectMake(120,390,80,40);
    preferencesWhiteLayer.opacity = 0.8;
    [CATransaction commit];
    
    NSLog(@"wppicker");
    
}

- (void)hideWpPicker
{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    pickerWpButton.userInteractionEnabled = YES;
    pickerSpButton.userInteractionEnabled = YES;
    wpPicker.frame = CGRectMake(0,568,320,162);
    sel_wp_button.frame = CGRectMake(120,770,80,40);
    preferencesWhiteLayer.opacity = 0;
    [CATransaction commit];
    
}

- (void)showSpPicker
{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    pickerWpButton.userInteractionEnabled = NO;
    pickerSpButton.userInteractionEnabled = NO;
    spPicker.frame = CGRectMake(0,198,320,162);
    sel_sp_button.frame = CGRectMake(120,390,80,40);
    preferencesWhiteLayer.opacity = 0.8;
    [CATransaction commit];
    NSLog(@"sppicker");
    
}


- (void)hideSpPicker
{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    pickerWpButton.userInteractionEnabled = YES;
    pickerSpButton.userInteractionEnabled = YES;
    spPicker.frame = CGRectMake(0,568,320,162);
    sel_sp_button.frame = CGRectMake(120,770,80,40);
    preferencesWhiteLayer.opacity = 0;
    [CATransaction commit];
    
}

- (void)backHome
{
    GTViewController *gtViewController = [[GTViewController alloc]initWithNibName:@"GTViewController" bundle:nil];
    gtViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:gtViewController animated:YES completion:nil];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
