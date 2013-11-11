
#import "SavedDataHandler.h"

@implementation SavedDataHandler

static SavedDataHandler *sharedSavedDataHandlerInstance;

// SavedDataHandlerのインスタンスを返す
+(SavedDataHandler *)sharedSavedDataHandler
{
    @synchronized(self)
    {
        if(sharedSavedDataHandlerInstance == nil)
        {
            sharedSavedDataHandlerInstance = [[self alloc] init];
        }
    }
    return sharedSavedDataHandlerInstance;
}

- (id)init
{
    //　デフォルト値
    defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"光と窓",@"wp_name",@"ガラス球",@"sp_name",@"東京",@"prefecture",@"80000",@"elapsed_time",@"0",@"pickerRowNumber",@"0",@"pickerWallpaperRowNumber",@"0",@"pickerSphereRowNumber",nil];
    [defaults registerDefaults:dic];
    
    return self;
}

- (NSString *)getPrefecture
{
    return [defaults objectForKey:@"prefecture"];
}

- (void)savePrefecture:(NSString *)str
{
    [defaults setObject:str forKey:@"prefecture"];
    [defaults synchronize];
}

- (NSString *)getWpName
{
    return [defaults objectForKey:@"wp_name"];
}

- (void)saveWpName:(NSString *)str
{
    [defaults setObject:str forKey:@"wp_name"];
    [defaults synchronize];
}

- (NSString *)getSpName
{
    return [defaults objectForKey:@"sp_name"];
}

- (void)saveSpName:(NSString *)str
{
    [defaults setObject:str forKey:@"sp_name"];
    [defaults synchronize];
}

- (double)getElapsedTime
{
    return [defaults doubleForKey:@"elapsed_time"];
}

- (void)saveElapsedTime:(double)etime
{
    [defaults setDouble:etime forKey:@"elapsed_time"];
    [defaults synchronize];
}

//　選んだリストを保存
- (void)savePickerRowNumber:(int)pn
{
    [defaults setInteger:pn forKey:@"pickerRowNumber"];
    [defaults synchronize];
}

//　選んだリストを取得
- (int)getPickerRowNumber
{
    return [defaults integerForKey:@"pickerRowNumber"];
}

//　選んだ壁紙リストを保存
- (void)savePickerWallpaperRowNumber:(int)pwn
{
    [defaults setInteger:pwn forKey:@"pickerWallpaperRowNumber"];
    [defaults synchronize];
}

//　選んだ壁紙リストを取得
- (int)getPickerWallpaperRowNumber
{
    return [defaults integerForKey:@"pickerWallpaperRowNumber"];
}

//　選んだ温度球リストを保存
- (void)savePickerSphereRowNumber:(int)psn
{
    [defaults setInteger:psn forKey:@"pickerSphereRowNumber"];
    [defaults synchronize];
}

//　選んだ温度球リストを取得
- (int)getPickerSphereRowNumber
{
    return [defaults integerForKey:@"pickerSphereRowNumber"];
}

@end
