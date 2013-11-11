//
//  GTViewController.m
//  GalileoThermoMeter
//
//  Created by Shunsuke Taniguchi on 2013/10/15.
//  Copyright (c) 2013年 Shunsuke Taniguchi. All rights reserved.
//

#import "GTViewController.h"
#import "SavedDataHandler.h"
#import "InfoViewController.h"
#import "PreferencesViewController.h"

@interface GTViewController ()

@end

@implementation GTViewController
{
    UIPickerView *prefecturePicker;
    
    UIButton *showPickerButton;
    UIButton *goInfoPageButton;
    UIButton *goPreferencesPageButton;
    UIButton *decisionButton;
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
    // Do any additional setup after loading the view from its nib.
    
    elapsedTime = [[SavedDataHandler sharedSavedDataHandler] getElapsedTime];
    
    timeElapsingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeElapsing) userInfo:nil repeats:YES];
    
    
    
    [super viewDidLoad];
    
    // create the banner view at the bottom of the screen
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // admob publisher id
    bannerView_.adUnitID = @"ca-app-pub-5916462741443088/3931186057";
    
    
    // notification
    
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // read ad
    [bannerView_ loadRequest:[GADRequest request]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    UIScreen *sc = [UIScreen mainScreen];//Obtains screen size
    
    prefectureTemperature = 0;
    startTemperature = 20;
    wallPaperName = [[SavedDataHandler sharedSavedDataHandler] getWpName];
    sphereName = [[SavedDataHandler sharedSavedDataHandler] getSpName];
    
    // Set prefecture name array
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* path = [bundle pathForResource:@"prefectureList" ofType:@"plist"];
    prefectureNameArray = [NSArray arrayWithContentsOfFile:path];
    
    
    // Set wallpaper layers
    baseLayer = [CALayer layer];
    baseLayer.contentsScale = [[UIScreen mainScreen] scale];
    baseLayer.bounds = CGRectMake(0,0,320,568);
    baseLayer.position = CGPointMake(160,284);
    baseLayer.contents = [self changeWallPaper];
    baseLayer.zPosition = 1;
    
    // Set ripple white layer
    rippleWhiteLayer = [CALayer layer];
    rippleWhiteLayer.contentsScale = [[UIScreen mainScreen] scale];
    rippleWhiteLayer.bounds = CGRectMake(0, 0, 1, 1);
    rippleWhiteLayer.position = CGPointMake(200,200);
    rippleWhiteLayer.opacity = 1;
    rippleWhiteLayer.contents = (id)[UIImage imageNamed:@"wave-white.png"].CGImage;
    rippleWhiteLayer.zPosition = 2;
    
    // Set ripple yellow layer
    rippleYellowLayer = [CALayer layer];
    rippleYellowLayer.contentsScale = [[UIScreen mainScreen] scale];
    rippleYellowLayer.bounds = CGRectMake(0, 0, 1, 1);
    rippleYellowLayer.position = CGPointMake(200,200);
    rippleYellowLayer.opacity = 1;
    rippleYellowLayer.contents = (id)[UIImage imageNamed:@"wave-yellow.png"].CGImage;
    rippleYellowLayer.zPosition = 2;
    
    // Set tube layer
    tubeLayer = [CALayer layer];
    tubeLayer.contentsScale = [[UIScreen mainScreen] scale];
    tubeLayer.bounds = CGRectMake(0,0,140,568);
    tubeLayer.position = CGPointMake(250,284);
    tubeLayer.contents = (id)[UIImage imageNamed:@"tube.png"].CGImage;
    tubeLayer.zPosition = 4;
    
    // Set circle layer(this circle is temperature text's background)
    circleLayer = [CALayer layer];
    circleLayer.contentsScale = [[UIScreen mainScreen] scale];
    circleLayer.bounds = CGRectMake(0,0,200,200);
    circleLayer.position = CGPointMake(90,205);
    circleLayer.contents = [self changeCircleBackground];
    circleLayer.zPosition = 4;
    
    // Set weather pictgram layer
    weatherPicLayer = [CALayer layer];
    weatherPicLayer.bounds = CGRectMake(0, 0, 50, 50);
    weatherPicLayer.position = CGPointMake(38,258);
    weatherPicLayer.contents = [self changeWeatherPictogram];
    weatherPicLayer.zPosition = 7;
    
    // Set temperature degree text layer
    degreeTextLayer = [CATextLayer layer];
    degreeTextLayer.contentsScale = [[UIScreen mainScreen] scale];
    degreeTextLayer.bounds = CGRectMake(0, 0, 320, 100);
    degreeTextLayer.position = CGPointMake(105, 195);
    degreeTextLayer.font = CGFontCreateWithFontName((CFStringRef)@"Helvetica-Bold");
    degreeTextLayer.foregroundColor = [self changeFontColor];
    degreeTextLayer.shadowColor = [UIColor blackColor].CGColor;
    degreeTextLayer.fontSize = 72.0;
    degreeTextLayer.alignmentMode = kCAAlignmentCenter;
    degreeTextLayer.zPosition = 8;
    
    // Set prefecture position text layer
    positionTextLayer = [CATextLayer layer];
    positionTextLayer.contentsScale = [[UIScreen mainScreen] scale];
    positionTextLayer.bounds = CGRectMake(0, 0, 320, 100);
    positionTextLayer.position = CGPointMake(95, 280);
    positionTextLayer.foregroundColor = [self changeFontColor];
    positionTextLayer.shadowColor = [UIColor blackColor].CGColor;
    positionTextLayer.fontSize = 18.0;
    positionTextLayer.alignmentMode = kCAAlignmentCenter;
    positionTextLayer.zPosition = 9;
    
    // Set white background layer
    whiteLayer = [CALayer layer];
    whiteLayer.bounds = CGRectMake(0,0,320,568);
    whiteLayer.position = CGPointMake(160,284);
    whiteLayer.contents = (id)[UIImage imageNamed:@"white.png"].CGImage;
    whiteLayer.opacity = 0;
    whiteLayer.zPosition = 10;
    
    // Set show picker button
    showPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showPickerButton.frame = CGRectMake(43, 230, 100, 50);
    showPickerButton.layer.zPosition = 100;
    [showPickerButton setImage:[UIImage imageNamed:@"trans-button.png"] forState:UIControlStateNormal];
    [showPickerButton addTarget:self action:@selector(showPrefecturePicker) forControlEvents:UIControlEventTouchUpInside];
    
    
    //　Set transition button to info page button
    goInfoPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goInfoPageButton.frame = CGRectMake(0, sc.bounds.size.height - GAD_SIZE_320x50.height - 80, 40, 40);
    goInfoPageButton.layer.zPosition = 100;
    [goInfoPageButton setImage:[UIImage imageNamed:@"button-info.png"] forState:UIControlStateNormal];
    [goInfoPageButton addTarget:self action:@selector(goInfoPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    //　Set transition button to preferences page button
    goPreferencesPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goPreferencesPageButton.frame = CGRectMake(0, sc.bounds.size.height - GAD_SIZE_320x50.height - 40, 40, 40);
    goPreferencesPageButton.layer.zPosition = 100;
    [goPreferencesPageButton setImage:[UIImage imageNamed:@"button-preferences.png"] forState:UIControlStateNormal];
    [goPreferencesPageButton addTarget:self action:@selector(goPreferencesPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    //　Set prefecture decision button
    decisionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    decisionButton.frame = CGRectMake(120, 770, 80, 40);
    decisionButton.layer.zPosition = 100;
    [decisionButton setImage:[UIImage imageNamed:@"button-select-j.png"] forState:UIControlStateNormal];
    [decisionButton addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Set prefecture picker
    prefecturePicker = [[UIPickerView alloc] init];
    prefecturePicker.frame = CGRectMake(0,568,320,162);
    prefecturePicker.layer.zPosition = 100;
    prefecturePicker.showsSelectionIndicator = YES;
    prefecturePicker.delegate = self;
    prefecturePicker.dataSource = self;
    prefecturePicker.tag = 1;
    [self.view addSubview:prefecturePicker];
    
    [prefecturePicker selectRow:[[SavedDataHandler sharedSavedDataHandler] getPickerRowNumber] inComponent:0 animated:NO];
    
    [self.view.layer addSublayer:baseLayer];
    [baseLayer addSublayer:rippleWhiteLayer];
    [baseLayer addSublayer:rippleYellowLayer];
    [baseLayer addSublayer:tubeLayer];
    [baseLayer addSublayer:circleLayer];
    [baseLayer addSublayer:whiteLayer];
    [baseLayer addSublayer:weatherPicLayer];
    [baseLayer addSublayer:degreeTextLayer];
    [baseLayer addSublayer:positionTextLayer];
    
    [self.view addSubview:showPickerButton];
    [self.view addSubview:goInfoPageButton];
    [self.view addSubview:goPreferencesPageButton];
    [self.view addSubview:decisionButton];
    [self.view addSubview:prefecturePicker];
    
    
    
    prefecture = [[SavedDataHandler sharedSavedDataHandler] getPrefecture];
    prefectureTemperature = [self getTemperature];
    evenTemperature = [self getEvenTemperture:prefectureTemperature];
    
    degreeTextLayer.string = [NSMutableString stringWithFormat:@"%d°",prefectureTemperature];
    positionTextLayer.string = [NSMutableString stringWithFormat:@"%@",prefecture];

    
    
    tempSphereLayer06 = [self makeDegreeSphereLayerAtPos:CGPointMake(230,BASIC_SPHERE_LINE - 100 * (32 - startTemperature) / 2) AndDegree:@"06"];
    tempSphereLayer08 = [self makeDegreeSphereLayerAtPos:CGPointMake(270,BASIC_SPHERE_LINE - 100 - 100 * (32 - startTemperature) / 2) AndDegree:@"08"];
    tempSphereLayer10 = [self makeDegreeSphereLayerAtPos:CGPointMake(230,BASIC_SPHERE_LINE - 200 - 100 * (32 - startTemperature) / 2) AndDegree:@"10"];
    tempSphereLayer12 = [self makeDegreeSphereLayerAtPos:CGPointMake(270,BASIC_SPHERE_LINE - 300 - 100 * (32 - startTemperature) / 2) AndDegree:@"12"];
    tempSphereLayer14 = [self makeDegreeSphereLayerAtPos:CGPointMake(230,BASIC_SPHERE_LINE - 400 - 100 * (32 - startTemperature) / 2) AndDegree:@"14"];
    tempSphereLayer16 = [self makeDegreeSphereLayerAtPos:CGPointMake(270,BASIC_SPHERE_LINE - 500 - 100 * (32 - startTemperature) / 2) AndDegree:@"16"];
    tempSphereLayer18 = [self makeDegreeSphereLayerAtPos:CGPointMake(230,BASIC_SPHERE_LINE - 600 - 100 * (32 - startTemperature) / 2) AndDegree:@"18"];
    tempSphereLayer20 = [self makeDegreeSphereLayerAtPos:CGPointMake(270,BASIC_SPHERE_LINE - 700 - 100 * (32 - startTemperature) / 2) AndDegree:@"20"];
    tempSphereLayer22 = [self makeDegreeSphereLayerAtPos:CGPointMake(230,BASIC_SPHERE_LINE - 800 - 100 * (32 - startTemperature) / 2) AndDegree:@"22"];
    tempSphereLayer24 = [self makeDegreeSphereLayerAtPos:CGPointMake(270,BASIC_SPHERE_LINE - 900 - 100 * (32 - startTemperature) / 2) AndDegree:@"24"];
    tempSphereLayer26 = [self makeDegreeSphereLayerAtPos:CGPointMake(230,BASIC_SPHERE_LINE - 1000 - 100 * (32 - startTemperature) / 2) AndDegree:@"26"];
    tempSphereLayer28 = [self makeDegreeSphereLayerAtPos:CGPointMake(270,BASIC_SPHERE_LINE - 1100 - 100 * (32 - startTemperature) / 2) AndDegree:@"28"];
    tempSphereLayer30 = [self makeDegreeSphereLayerAtPos:CGPointMake(230,BASIC_SPHERE_LINE - 1200 - 100 * (32 - startTemperature) / 2) AndDegree:@"30"];
    tempSphereLayer32 = [self makeDegreeSphereLayerAtPos:CGPointMake(270,BASIC_SPHERE_LINE - 1300 - 100 * (32 - startTemperature) / 2) AndDegree:@"32"];
    
    [baseLayer addSublayer:tempSphereLayer06];
    [baseLayer addSublayer:tempSphereLayer08];
    [baseLayer addSublayer:tempSphereLayer10];
    [baseLayer addSublayer:tempSphereLayer12];
    [baseLayer addSublayer:tempSphereLayer14];
    [baseLayer addSublayer:tempSphereLayer16];
    [baseLayer addSublayer:tempSphereLayer18];
    [baseLayer addSublayer:tempSphereLayer20];
    [baseLayer addSublayer:tempSphereLayer22];
    [baseLayer addSublayer:tempSphereLayer24];
    [baseLayer addSublayer:tempSphereLayer26];
    [baseLayer addSublayer:tempSphereLayer28];
    [baseLayer addSublayer:tempSphereLayer30];
    [baseLayer addSublayer:tempSphereLayer32];
    
    [self adjustSpherePosition:tempSphereLayer06];
    [self adjustSpherePosition:tempSphereLayer08];
    [self adjustSpherePosition:tempSphereLayer10];
    [self adjustSpherePosition:tempSphereLayer12];
    [self adjustSpherePosition:tempSphereLayer14];
    [self adjustSpherePosition:tempSphereLayer16];
    [self adjustSpherePosition:tempSphereLayer18];
    [self adjustSpherePosition:tempSphereLayer20];
    [self adjustSpherePosition:tempSphereLayer22];
    [self adjustSpherePosition:tempSphereLayer24];
    [self adjustSpherePosition:tempSphereLayer26];
    [self adjustSpherePosition:tempSphereLayer28];
    [self adjustSpherePosition:tempSphereLayer30];
    [self adjustSpherePosition:tempSphereLayer32];
    
    
    
    
    /// get temperature
    prefecture = [[SavedDataHandler sharedSavedDataHandler] getPrefecture];
    
    prefectureTemperature = [self getTemperature];
    weatherPicLayer.contents = [self changeWeatherPictogram];
    
    /// weather pictgram changes
    
    
    
    // Those are timers.
    
    spherePositionAdjustTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(shiftSpherePositionByTemperature) userInfo:nil repeats:YES];
    
    rippleWhiteTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stayRippleWhite) userInfo:nil repeats:YES];
    
    rippleYellowTimer = [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(stayRippleYellow) userInfo:nil repeats:YES];
    
    //　This is ad banner view
    
    CGPoint origin = CGPointMake(0, sc.bounds.size.height - GAD_SIZE_320x50.height);
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];// originで場所決め
    bannerView_.adUnitID = @"ca-app-pub-5916462741443088/1398778055";
    bannerView_.rootViewController = self;
    bannerView_.layer.zPosition = 50;
    
    
    [self.view addSubview:bannerView_];
    
    GADRequest *gadrequest = [GADRequest request];
    gadrequest.testing = NO;
    gadrequest.testDevices = [NSArray arrayWithObjects:@"GAD_SIMULATOR_ID", nil];
    
    [bannerView_ loadRequest:gadrequest];
    
    // End of viewWillAppear
}

- (NSInteger)getTemperature
{
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* path = [bundle pathForResource:@"prefectureInformation" ofType:@"plist"];
    prefectureInformationDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    int temperature;
    NSString *url = [prefectureInformationDictionary objectForKey:prefecture];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_raw_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(json_raw_data != nil){
        // add crickets to json data for parsing easily
        NSString *jstr = [[NSString alloc] initWithData:json_raw_data encoding:NSUTF8StringEncoding];
        NSString *cricket_left = @"[";
        NSString *cricket_right = @"]";
        
        jstr = [[cricket_left stringByAppendingString:jstr] stringByAppendingString:cricket_right];
        
        NSData *json_data = [jstr dataUsingEncoding:NSUnicodeStringEncoding];
        
        NSError *error=nil;
        NSArray *jarray = [NSJSONSerialization JSONObjectWithData:json_data
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
        
        NSDictionary *dic;
        
        for (NSDictionary *obj in jarray)
        {
            dic = obj;
        }
        
        /* 　obtain temperature　　*/
        temperature = [[[[[dic objectForKey:@"list"] objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp"] intValue] - 273;
        
        
    }else{
        temperature = -273;
    }
    
    return temperature;
    
}

- (NSInteger)getEvenTemperture:(NSInteger) temper
{
    int eventemper;
    
    if(temper > 32){
        eventemper = 32;
    }else if(temper < 6){
        eventemper = 6;
    }else{
        if(temper % 2 == 0) eventemper = temper;
        else eventemper = temper + 1;
    }
    
    return eventemper;
    
}

- (id)changeWallPaper
{
    NSObject *contents;
    if([wallPaperName isEqualToString:@"光と窓"]) contents = (id)[UIImage imageNamed:@"wallpaper-01.png"].CGImage;
    else if([wallPaperName isEqualToString:@"空"]) contents = (id)[UIImage imageNamed:@"wallpaper-02.png"].CGImage;
    else if([wallPaperName isEqualToString:@"スペクトル"]) contents = (id)[UIImage imageNamed:@"wallpaper-03.png"].CGImage;
    else if([wallPaperName isEqualToString:@"夕焼け"]) contents = (id)[UIImage imageNamed:@"wallpaper-04.png"].CGImage;
    else if([wallPaperName isEqualToString:@"森"]) contents = (id)[UIImage imageNamed:@"wallpaper-05.png"].CGImage;
    else if([wallPaperName isEqualToString:@"水中"]) contents = (id)[UIImage imageNamed:@"wallpaper-06.png"].CGImage;
    else if([wallPaperName isEqualToString:@"海"]) contents = (id)[UIImage imageNamed:@"wallpaper-07.png"].CGImage;
    else if([wallPaperName isEqualToString:@"夜空"]) contents = (id)[UIImage imageNamed:@"wallpaper-08.png"].CGImage;
    else if([wallPaperName isEqualToString:@"桜"]) contents = (id)[UIImage imageNamed:@"wallpaper-09.png"].CGImage;
    else if([wallPaperName isEqualToString:@"夏の棚田"]) contents = (id)[UIImage imageNamed:@"wallpaper-10.png"].CGImage;
    else if([wallPaperName isEqualToString:@"紅葉"]) contents = (id)[UIImage imageNamed:@"wallpaper-11.png"].CGImage;
    else if([wallPaperName isEqualToString:@"氷の大地"]) contents = (id)[UIImage imageNamed:@"wallpaper-12.png"].CGImage;
    else if([wallPaperName isEqualToString:@"ハーバー"]) contents = (id)[UIImage imageNamed:@"wallpaper-13.png"].CGImage;
    else if([wallPaperName isEqualToString:@"ピラミッド"]) contents = (id)[UIImage imageNamed:@"wallpaper-14.png"].CGImage;
    else contents = (id)[UIImage imageNamed:@"wallpaper-01.png"].CGImage;
    
    return contents;
}


- (id)changeCircleBackground
{
    NSObject *contents;
    if([wallPaperName isEqualToString:@"光と窓"]) contents = (id)[UIImage imageNamed:@"circle01.png"].CGImage;
    else if([wallPaperName isEqualToString:@"空"]) contents = (id)[UIImage imageNamed:@"circle01.png"].CGImage;
    else if([wallPaperName isEqualToString:@"スペクトル"]) contents = (id)[UIImage imageNamed:@"circle02.png"].CGImage;
    else if([wallPaperName isEqualToString:@"夕焼け"]) contents = (id)[UIImage imageNamed:@"circle02.png"].CGImage;
    else if([wallPaperName isEqualToString:@"森"]) contents = (id)[UIImage imageNamed:@"circle03.png"].CGImage;
    else if([wallPaperName isEqualToString:@"水中"]) contents = (id)[UIImage imageNamed:@"circle04.png"].CGImage;
    else if([wallPaperName isEqualToString:@"海"]) contents = (id)[UIImage imageNamed:@"circle05.png"].CGImage;
    else if([wallPaperName isEqualToString:@"夜空"]) contents = (id)[UIImage imageNamed:@"circle06.png"].CGImage;
    else if([wallPaperName isEqualToString:@"桜"]) contents = (id)[UIImage imageNamed:@"circle07.png"].CGImage;
    else if([wallPaperName isEqualToString:@"夏の棚田"]) contents = (id)[UIImage imageNamed:@"circle08.png"].CGImage;
    else if([wallPaperName isEqualToString:@"紅葉"]) contents = (id)[UIImage imageNamed:@"circle09.png"].CGImage;
    else if([wallPaperName isEqualToString:@"氷の大地"]) contents = (id)[UIImage imageNamed:@"circle10.png"].CGImage;
    else if([wallPaperName isEqualToString:@"ハーバー"]) contents = (id)[UIImage imageNamed:@"circle05.png"].CGImage;
    else if([wallPaperName isEqualToString:@"ピラミッド"]) contents = (id)[UIImage imageNamed:@"circle05.png"].CGImage;
    else contents = (id)[UIImage imageNamed:@"circle01.png"].CGImage;
    
    return contents;
}


- (id)changeWeatherPictogram
{
    
    NSObject *contents;
    NSString *weather;
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* path = [bundle pathForResource:@"prefectureInformation" ofType:@"plist"];
    prefectureInformationDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *url = [prefectureInformationDictionary objectForKey:prefecture];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_raw_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(json_raw_data != nil){
        // add crickets to json data for parsing easily
        NSString *jstr = [[NSString alloc] initWithData:json_raw_data encoding:NSUTF8StringEncoding];
        NSString *cricket_left = @"[";
        NSString *cricket_right = @"]";
        
        jstr = [[cricket_left stringByAppendingString:jstr] stringByAppendingString:cricket_right];
        
        NSData *json_data = [jstr dataUsingEncoding:NSUnicodeStringEncoding];
        
        NSError *error=nil;
        NSArray *jarray = [NSJSONSerialization JSONObjectWithData:json_data
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
        
        NSDictionary *dic;
        
        for (NSDictionary *obj in jarray)
        {
            dic = obj;
        }
        
        weather = [[[[[dic objectForKey:@"list"] objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
        
        if([weather isEqualToString:@"Sky is Clear"]){
            contents = (id)[UIImage imageNamed:@"01_sky_is_clear.png"].CGImage;
            
        }else if([weather isEqualToString:@"few clouds"]){
            contents = (id)[UIImage imageNamed:@"02_few_clouds.png"].CGImage;
            
        }else if([weather isEqualToString:@"scattered clouds"]){
            contents = (id)[UIImage imageNamed:@"03_scattered_clouds.png"].CGImage;
            
        }else if([weather isEqualToString:@"broken clouds"] ||
                 [weather isEqualToString:@"overcast clouds"]){
            contents = (id)[UIImage imageNamed:@"04_overcast_clouds.png"].CGImage;
            
        }else if([weather isEqualToString:@"light rain"] || [weather isEqualToString:@"light intensity drizzle"]){
            contents = (id)[UIImage imageNamed:@"05_light_rain.png"].CGImage;
            
        }else if([weather isEqualToString:@"moderate rain"]){
            contents = (id)[UIImage imageNamed:@"06_rain.png"].CGImage;
            
        }else if([weather isEqualToString:@"heavy intensity rain"] ||
                 [weather isEqualToString:@"very heavy rain"] ||
                 [weather isEqualToString:@"extreme rain"] ||
                 [weather isEqualToString:@"light intensity shower rain"] ||
                 [weather isEqualToString:@"shower rain"] ||
                 [weather isEqualToString:@"heavy intensity shower rain"]){
            contents = (id)[UIImage imageNamed:@"07_shower_rain.png"].CGImage;
            
        }else if([weather isEqualToString:@"light snow"] ||
                 [weather isEqualToString:@"snow"] ||
                 [weather isEqualToString:@"sleet snow"] ||
                 [weather isEqualToString:@"shower snow"]){
            contents = (id)[UIImage imageNamed:@"08_snow.png"].CGImage;
            
        }else if([weather isEqualToString:@"heavy snow"]){
            contents = (id)[UIImage imageNamed:@"09_heavy_snow.png"].CGImage;
            
        }else if([weather isEqualToString:@"freezing rain"]){
            contents = (id)[UIImage imageNamed:@"10_freezing_rain.png"].CGImage;
            
        }else if([weather isEqualToString:@"light thunderstorm"] ||
                 [weather isEqualToString:@"thunderstorm"] ||
                 [weather isEqualToString:@"heavy thunderstorm"] ||
                 [weather isEqualToString:@"ragged thunderstorm"]){
            contents = (id)[UIImage imageNamed:@"11_thunder_with_clouds.png"].CGImage;
            
        }else if([weather isEqualToString:@"thunderstorm with light rain"] ||
                 [weather isEqualToString:@"thunderstorm with rain"] ||
                 [weather isEqualToString:@"thunderstorm with heavy rain"] ||
                 [weather isEqualToString:@"thunderstorm with light drizzle"] ||
                 [weather isEqualToString:@"thunderstorm with drizzle"] ||
                 [weather isEqualToString:@"thunderstorm with heavy drizzle"]){
            contents = (id)[UIImage imageNamed:@"12_thunder_with_drizzle.png"].CGImage;
            
        }else if([weather isEqualToString:@"mist"] ||
                 [weather isEqualToString:@"smoke"] ||
                 [weather isEqualToString:@"haze"] ||
                 [weather isEqualToString:@"Sand/Dust Whirls"] ||
                 [weather isEqualToString:@"Fog"]){
            contents = (id)[UIImage imageNamed:@"13_mist.png"].CGImage;
            
        }else{
            contents = (id)[UIImage imageNamed:@"14_unknown.png"].CGImage;
            
        }
        
        
    }else{
        contents = (id)[UIImage imageNamed:@"14_unknown.png"].CGImage;
    }
    
    return contents;
}

- (struct CGColor *)changeFontColor
{
    struct CGColor *color;
    if([wallPaperName isEqualToString:@"光と窓"]) color = [UIColor grayColor].CGColor;
    else if([wallPaperName isEqualToString:@"空"]) color = [UIColor grayColor].CGColor;
    else if([wallPaperName isEqualToString:@"スペクトル"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"夕焼け"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"森"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"水中"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"海"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"夜空"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"桜"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"夏の棚田"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"紅葉"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"氷の大地"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"ハーバー"]) color = [UIColor whiteColor].CGColor;
    else if([wallPaperName isEqualToString:@"ピラミッド"]) color = [UIColor whiteColor].CGColor;
    else color = color = [UIColor whiteColor].CGColor;
    
    return color;
}

- (void)showPrefecturePicker
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    prefecturePicker.frame = CGRectMake(0,0,320,162);
    decisionButton.frame = CGRectMake(120,202,80,40);
    whiteLayer.opacity = 0.8;
    [CATransaction commit];
}

- (void)goInfoPage
{
    InfoViewController *infoViewController = [[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
    infoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:infoViewController animated:YES completion:nil];
   
}

- (void)goPreferencesPage
{
    PreferencesViewController *preferencesViewController = [[PreferencesViewController alloc]initWithNibName:@"PreferencesViewController" bundle:nil];
    preferencesViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:preferencesViewController animated:YES completion:nil];
}

- (void)hidePicker
{
    
    positionTextLayer.string = [NSMutableString stringWithFormat:@"%@",prefecture];
    prefectureTemperature = [self getTemperature];
    degreeTextLayer.string = [NSMutableString stringWithFormat:@"%d°",prefectureTemperature];
    evenTemperature = [self getEvenTemperture:prefectureTemperature];
    
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    prefecturePicker.frame = CGRectMake(0,568,320,162);
    decisionButton.frame = CGRectMake(120,770,80,40);
    whiteLayer.opacity = 0;
    [CATransaction commit];
}

- (CALayer *)makeDegreeSphereLayerAtPos:(CGPoint)pos AndDegree:(NSString *)deg
{
    CALayer *hogeLayer = [CALayer layer];
    hogeLayer.bounds = CGRectMake(0,0,100,148);
    hogeLayer.position = pos;
    if([sphereName isEqualToString:@"ガラス球"]){
        hogeLayer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"degree-%@.png",deg]].CGImage;
    }else if([sphereName isEqualToString:@"ビードロ"]){
        hogeLayer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"bidoro-%@.png",deg]].CGImage;
    }else if([sphereName isEqualToString:@"ハート"]){
        hogeLayer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"heart-degree-%@.png",deg]].CGImage;
    }else if([sphereName isEqualToString:@"星"]){
        hogeLayer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"star-degree-%@.png",deg]].CGImage;
    }else if([sphereName isEqualToString:@"ネオン"]){
        hogeLayer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"neon-degree-%@.png",deg]].CGImage;
    }else{
        hogeLayer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"degree-%@.png",deg]].CGImage;
    }
    
    hogeLayer.zPosition = 5;
    
    return hogeLayer;
}

- (void)adjustSpherePosition:(CALayer *)layer
{
    //this method can split spheres, floating group n sinking grounp
    CALayer *piyoLayer = [CALayer layer];
    piyoLayer = layer;
    if(piyoLayer.position.y <= 274){
        layer.position = CGPointMake(piyoLayer.position.x,piyoLayer.position.y - 200);
    }
    
}

- (void)shiftSpherePositionByTemperature
{
    prefectureTemperature = [self getTemperature];
    degreeTextLayer.string = [NSMutableString stringWithFormat:@"%d°",prefectureTemperature];
    evenTemperature = [self getEvenTemperture:prefectureTemperature];
    weatherPicLayer.contents = [self changeWeatherPictogram];
    
    if(prefectureTemperature <= -272){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"電波の良い場所で使用して下さい。"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:10.00];
    tempSphereLayer06.position = CGPointMake(230,BASIC_SPHERE_LINE -   0 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer08.position = CGPointMake(270,BASIC_SPHERE_LINE - 100 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer10.position = CGPointMake(230,BASIC_SPHERE_LINE - 200 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer12.position = CGPointMake(270,BASIC_SPHERE_LINE - 300 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer14.position = CGPointMake(230,BASIC_SPHERE_LINE - 400 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer16.position = CGPointMake(270,BASIC_SPHERE_LINE - 500 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer18.position = CGPointMake(230,BASIC_SPHERE_LINE - 600 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer20.position = CGPointMake(270,BASIC_SPHERE_LINE - 700 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer22.position = CGPointMake(230,BASIC_SPHERE_LINE - 800 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer24.position = CGPointMake(270,BASIC_SPHERE_LINE - 900 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer26.position = CGPointMake(230,BASIC_SPHERE_LINE - 1000 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer28.position = CGPointMake(270,BASIC_SPHERE_LINE - 1100 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer30.position = CGPointMake(230,BASIC_SPHERE_LINE - 1200 - 100 * (32 - evenTemperature) / 2);
    tempSphereLayer32.position = CGPointMake(270,BASIC_SPHERE_LINE - 1300 - 100 * (32 - evenTemperature) / 2);
    
    [self adjustSpherePosition:tempSphereLayer06];
    [self adjustSpherePosition:tempSphereLayer08];
    [self adjustSpherePosition:tempSphereLayer10];
    [self adjustSpherePosition:tempSphereLayer12];
    [self adjustSpherePosition:tempSphereLayer14];
    [self adjustSpherePosition:tempSphereLayer16];
    [self adjustSpherePosition:tempSphereLayer18];
    [self adjustSpherePosition:tempSphereLayer20];
    [self adjustSpherePosition:tempSphereLayer22];
    [self adjustSpherePosition:tempSphereLayer24];
    [self adjustSpherePosition:tempSphereLayer26];
    [self adjustSpherePosition:tempSphereLayer28];
    [self adjustSpherePosition:tempSphereLayer30];
    [self adjustSpherePosition:tempSphereLayer32];
    
    [CATransaction commit];
    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //returns picker's components number
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // returns picker's contents number
    switch(component){
        case 0:
            return 113;
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pickerString;
    
    
    // write contents to the picker
    if(pickerView.tag == 1){
        pickerString = [NSString stringWithFormat:@"%@",[prefectureNameArray objectAtIndex:row]];
    }else{
        pickerString = @"";
    }
    
    return pickerString;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // After picker row is determined, this method will do following process
    
    if(pickerView.tag == 1){
        NSInteger val = [prefecturePicker selectedRowInComponent:0];
        prefecture = [prefectureNameArray objectAtIndex:val];
        [[SavedDataHandler sharedSavedDataHandler] savePrefecture:prefecture];
        [[SavedDataHandler sharedSavedDataHandler] savePickerRowNumber:row];
        
        weatherPicLayer.contents = [self changeWeatherPictogram];
        
        
    }else{
        ;
    }
    
    
    
    
    
}

- (void)timeElapsing
{
    elapsedTime++;
    [[SavedDataHandler sharedSavedDataHandler] saveElapsedTime:elapsedTime];
    
    [self presentNotification:180 AndMessage:@"壁紙「空」"];
    [self presentNotification:600 AndMessage:@"壁紙「スペクトル」"];
    [self presentNotification:1800 AndMessage:@"壁紙「夕焼け」"];
    [self presentNotification:3600 AndMessage:@"壁紙「森」"];
    [self presentNotification:7200 AndMessage:@"壁紙「水中」"];
    [self presentNotification:10800 AndMessage:@"壁紙「海」"];
    [self presentNotification:14400 AndMessage:@"壁紙「夜空」"];
    [self presentNotification:18000 AndMessage:@"温度球「ビードロ」"];
    [self presentNotification:21600 AndMessage:@"温度球「ハート」"];
    [self presentNotification:25200 AndMessage:@"温度球「星」"];
    [self presentNotification:28800 AndMessage:@"温度球「ネオン」"];
    [self presentNotification:32400 AndMessage:@"壁紙「桜」"];
    [self presentNotification:36000 AndMessage:@"壁紙「棚田」"];
    [self presentNotification:39600 AndMessage:@"壁紙「紅葉」"];
    [self presentNotification:43200 AndMessage:@"壁紙「氷の大地」"];
    [self presentNotification:46800 AndMessage:@"壁紙「ハーバー」"];
    [self presentNotification:50400 AndMessage:@"壁紙「ピラミッド」"];
    
}

- (void)presentNotification:(float) presentTime AndMessage:(NSString *)message
{
    if(elapsedTime > presentTime - 0.01 && elapsedTime < presentTime + 0.01){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:[NSString stringWithFormat:@"%@のプレゼントを受け取りました。",message]
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)stayRippleWhite
{
    rippleWhitePosX = rand()%300 + 10;
    rippleWhitePosY = rand()%460 + 10;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    rippleWhiteLayer.opacity = 1;
    rippleWhiteLayer.bounds = CGRectMake(0,0,1,1);
    rippleWhiteLayer.position = CGPointMake(rippleWhitePosX,rippleWhitePosY);
    [CATransaction commit];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(spreadRippleWhite) userInfo:nil repeats:NO];
    
}

- (void)spreadRippleWhite
{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:3.5];
    rippleWhiteLayer.opacity = 0;
    rippleWhiteLayer.bounds = CGRectMake(0,0,568,568);
    rippleWhiteLayer.position = CGPointMake(rippleWhitePosX,rippleWhitePosY);
    [CATransaction commit];
    
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(resetRippleWhite) userInfo:nil repeats:NO];
    
}

- (void)resetRippleWhite
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:3.5];
    rippleWhiteLayer.opacity = 0;
    rippleWhiteLayer.bounds = CGRectMake(0,0,1,1);
    rippleWhiteLayer.position = CGPointMake(rippleWhitePosX,rippleWhitePosY);
    
    [CATransaction commit];
}

- (void)stayRippleYellow
{
    rippleYellowPosX = rand()%300 + 10;
    rippleYellowPosY = rand()%460 + 10;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    rippleYellowLayer.opacity = 1;
    rippleYellowLayer.bounds = CGRectMake(0,0,1,1);
    rippleYellowLayer.position = CGPointMake(rippleYellowPosX,rippleYellowPosY);
    [CATransaction commit];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(spreadRippleYellow) userInfo:nil repeats:NO];
    
}

- (void)spreadRippleYellow
{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:3.5];
    rippleYellowLayer.opacity = 0;
    rippleYellowLayer.bounds = CGRectMake(0,0,568,568);
    rippleYellowLayer.position = CGPointMake(rippleYellowPosX,rippleYellowPosY);
    [CATransaction commit];
    
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(resetRippleYellow) userInfo:nil repeats:NO];
    
}

- (void)resetRippleYellow
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:3.5];
    rippleYellowLayer.opacity = 0;
    rippleYellowLayer.bounds = CGRectMake(0,0,1,1);
    rippleYellowLayer.position = CGPointMake(rippleYellowPosX,rippleYellowPosY);
    
    [CATransaction commit];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [timeElapsingTimer invalidate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//hide status bar
}

@end
