//
//  Manager.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/20.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "Manager.h"
#import "MineSCModel.h"
#import "MineDYModel.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>


static Manager *manager = nil;

@interface Manager()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}
@end



@implementation Manager

+ (Manager *)sharedManager {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[Manager alloc] init];
        
    });
    
    return manager;
}











-(void)location
{
    
    self.dddf = NO;
    _locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务没有打开，请设置打开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    if (IPHONE8)
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        {
            
            [_locationManager requestWhenInUseAuthorization];
            
        }
        else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            CLLocationDistance distance = 100;
            _locationManager.distanceFilter = distance;
            [_locationManager startUpdatingLocation];
        }
    }
    
   
    
}

#pragma mark --LocationDeledate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location =  [locations firstObject];
    _geocoder = [[CLGeocoder alloc] init];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placeMark = [placemarks firstObject];
        
        NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *text= [doucments stringByAppendingPathComponent:@"dangqianweizhi.text"];
        NSString *st = placeMark.name;
        [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
       
        
    }];
    
    [manager stopUpdatingLocation];
}











- (NSMutableArray *)cateid {
    if (_cateid == nil) {
        self.cateid = [NSMutableArray array];
    }
    return _cateid;
}


+ (void)setupclicknum:(NSString *)type arid:(NSString *)arid {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //__weak typeof(self) weakSelf = self;
    NSString *string = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/index/onclick?type=%@&id=%@",type,arid];
    [session GET:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        //NSLog(@"------------=======----------%@",[NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



																																															

//时间戳转时间
+ (NSString *)timeWithTimeIntervalString:(NSString *)str {
    NSTimeInterval time =[str doubleValue];
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd H:mm"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
+ (NSString *)othertimeWithTimeIntervalString:(NSString *)str {
    NSTimeInterval time =[str doubleValue];
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];    
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd H:mm"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
+ (NSString *)otheronetimeWithTimeIntervalString:(NSString *)str {
    NSTimeInterval time =[str doubleValue];
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"MM-dd H:mm"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

+ (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[5-6])|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确的*****号码";
        }
    }
    return nil;
}

-(BOOL)checkPassWord:(NSString *)password
{
    //6-20位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        return YES ;
    }else
        return NO;
}





- (NSMutableArray *)dingyueArray {
    if (_dingyueArray == nil) {
        self.dingyueArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dingyueArray;
}


- (NSMutableSet *)mutSet {
    if (_mutSet == nil) {
        self.mutSet = [[NSMutableSet alloc]initWithCapacity:1];
    }
    return _mutSet;
}
- (NSMutableSet *)MovieMutSet {
    if (_MovieMutSet == nil) {
        self.MovieMutSet = [[NSMutableSet alloc]initWithCapacity:1];
    }
    return _MovieMutSet;
}





- (void)panduanjincikugengxin {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self)weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/api/badword/index" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
       NSString *newstring = [NSString stringWithFormat:@"%@",[dic objectForKey:@"version"]];
        
        
        NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *tex= [dom stringByAppendingPathComponent:@"jinciversion.text"];
        NSString *oldstring = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
        
        
        if (![newstring isEqualToString:oldstring]) {
            
            [weakSelf returnjinci];
            NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *text= [doucments stringByAppendingPathComponent:@"jinciversion.text"];
            NSString *st = newstring;
            [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



- (void)returnjinci {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
   
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/api/badword/check" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:@"/arr.text"];
            [arr writeToFile:filewebCaches atomically:YES];
        });
        
        //[MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
}





//直播
- (NSString *)md5:(NSString *)str

{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
}
- (UIImage *)zhuanhuanpic:(NSString *)string{
    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:string]];
    UIImage *image = [[UIImage alloc]initWithData:data];
    return image;
    
}
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image)
        
    {
        
        newimage = nil;
        
    } else {
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height)
            
        {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        } else {
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}







@end
