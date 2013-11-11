
#import <Foundation/Foundation.h>

@interface SavedDataHandler : NSObject{
    NSUserDefaults *defaults;
    NSString *prefecture;
    NSString *wp_name;
    NSString *sp_name;
    double elapsed_time;
    int pickerRowNumber;
    int pickerWallpaperRowNumber;
    int pickerSphereRowNumber;
}

+(SavedDataHandler *)sharedSavedDataHandler;
-(id)init;

//　都道府県名を取得
- (NSString *)getPrefecture;

//　都道府県名を保存
- (void)savePrefecture:(NSString *)str;

//　壁紙名を取得
- (NSString *)getWpName;

//　壁紙名を保存
- (void)saveWpName:(NSString *)str;

//　温度球名を取得
- (NSString *)getSpName;

//　温度球名を保存
- (void)saveSpName:(NSString *)str;

//　使用時間を取得
- (double)getElapsedTime;

//　使用時間を保存
- (void)saveElapsedTime:(double)etime;

//　選んだリストを保存
- (void)savePickerRowNumber:(int)pn;

//　選んだリストを取得
- (int)getPickerRowNumber;

//　選んだ壁紙リストを保存
- (void)savePickerWallpaperRowNumber:(int)pn;

//　選んだ壁紙リストを取得
- (int)getPickerWallpaperRowNumber;

//　選んだ温度球リストを保存
- (void)savePickerSphereRowNumber:(int)pn;

//　選んだ温度球リストを取得
- (int)getPickerSphereRowNumber;

@end
