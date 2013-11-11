//
//  InfoViewController.m
//  GalileoThermometer
//
//  Created by Shunsuke Taniguchi on 2013/10/15.
//  Copyright (c) 2013年 Shunsuke Taniguchi. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
{
    UIButton *backhomeButton;
    
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
    
    // Basic layer
    infoBaseLayer = [CALayer layer];
    infoBaseLayer.contentsScale = [[UIScreen mainScreen] scale];
    infoBaseLayer.bounds = CGRectMake(0, 0, 320, 568);
    infoBaseLayer.position = CGPointMake(160,284);
    infoBaseLayer.contents = (id)[UIImage imageNamed:@"wallpaper-01.png"].CGImage;
    infoBaseLayer.zPosition = 10;
    
    // Black layer
    infoBlackLayer = [CALayer layer];
    infoBlackLayer.contentsScale = [[UIScreen mainScreen] scale];
    infoBlackLayer.bounds = CGRectMake(0,0,320,568);
    infoBlackLayer.position = CGPointMake(160,284);
    infoBlackLayer.contents = (id)[UIImage imageNamed:@"black.png"].CGImage;
    infoBlackLayer.opacity = 0.5;
    infoBlackLayer.zPosition = 11;
    
    //　Description for this app
    textLayerInfo = [CATextLayer layer];
    textLayerInfo.contentsScale = [[UIScreen mainScreen] scale];
    textLayerInfo.bounds = CGRectMake(0, 0, 300, 480);
    textLayerInfo.position = CGPointMake(160, 260);
    textLayerInfo.foregroundColor = [UIColor whiteColor].CGColor;
    textLayerInfo.shadowColor = [UIColor blackColor].CGColor;
    textLayerInfo.fontSize = 12.0;
    textLayerInfo.alignmentMode = kCAAlignmentLeft;
    textLayerInfo.string = @"　　　　　　　　　　アプリ説明\n\nガリレオ温度計は水柱にある色球体の浮き沈みによって\n温度を知ることができる温度計です。\n浮く温度球と沈む温度球があり、浮いている温度球で\n最も低い位置にある温度球が現在の温度になります。\n\n本アプリはガリレオ温度計を再現したものです。\nインテリアとしても使用できるようにデザイン\nしたアプリです。\n\n地名をタッチしていただけるとピッカーが\n出現しお好きな地名を選ぶことができます。\n\nまた、お好みにより壁紙を変更したり、気温球を\n変更することも可能です。\n\nより長い時間ご使用していただくと、壁紙や気温球の\nプレゼントもありますので、ご愛顧いただけたら\n幸いです。\n";
    textLayerInfo.zPosition = 12;
    
    
    //　Home button
    backhomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backhomeButton.frame = CGRectMake(0, sc.bounds.size.height - GAD_SIZE_320x50.height - 40, 40, 40);
    backhomeButton.layer.zPosition = 100;
    [backhomeButton setImage:[UIImage imageNamed:@"button-home.png"] forState:UIControlStateNormal];
    [backhomeButton addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view.layer addSublayer:infoBaseLayer];
    [infoBaseLayer addSublayer:infoBlackLayer];
    [infoBaseLayer addSublayer:textLayerInfo];
    
    
    [self.view addSubview:backhomeButton];
    
    //　This is ad banner view
    
    CGPoint origin = CGPointMake(0, sc.bounds.size.height - GAD_SIZE_320x50.height);
    NSLog(@"%f",self.view.frame.size.height);
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];// originで場所決め
    bannerView_.adUnitID = @"ca-app-pub-5916462741443088/1398778055";
    bannerView_.rootViewController = self;
    bannerView_.layer.zPosition = 50;
    
    
    [self.view addSubview:bannerView_];
    
    GADRequest *gadrequest = [GADRequest request];
    gadrequest.testing = NO;
    gadrequest.testDevices = [NSArray arrayWithObjects:@"GAD_SIMULATOR_ID", nil];
    
    [bannerView_ loadRequest:gadrequest];
    
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
