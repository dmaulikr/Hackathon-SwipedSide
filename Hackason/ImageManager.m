//
//  imageManager.m
//  Hackason
//
//  Created by oohashi on 2015/07/09.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "ImageManager.h"


@implementation ImageManager
{
    AppData *appData;
}

-(id)init
{
    if (self = [super init]) {
        appData = [AppData SharedManager];
    }
    
    return self;
}
-(void)uploadSwipedImage: (UIImage *)image
                    text: (NSString *)text
                     url:(NSURL *)url
{
    FUNC();
    Contents *contents = [[Contents alloc] init];
    contents.major = appData.nearestBeacon.major;
    contents.image = image;
    
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.1)];
    NSMutableDictionary* texts  = [NSMutableDictionary dictionary];
    NSMutableDictionary* images = [NSMutableDictionary dictionary];
    
    [texts  setObject:text forKey:@"tst"];
    [texts  setObject:[NSString stringWithFormat:@"%d", appData.nearestBeacon.major] forKey:@"nearest_major"];
    [texts  setObject:[NSString stringWithFormat:@"%d", appData.nearestBeacon.minor] forKey:@"nearest_minor"];
    [images setObject:imageData forKey:@"apple"];// apple => swiped_image
    
    ReqHTTP *reqHTTP = [[ReqHTTP alloc] init];
    [reqHTTP postMultiDataWithTextDictionary:texts
                             imageDictionary:images
                                         url:url
                                        done:^(NSDictionary *responseData) {
        NSLog(@"postMultiDataWithTextDictionary: %@", responseData);
        NSInteger status = [[responseData objectForKey:@"status"] integerValue];
        if (status == -1) {
            NSLog(@"画像のUploadに失敗");
            
            return;
        }
        contents.minor = [[[responseData objectForKey:@"data"] objectForKey:@"minor"] intValue];
        [appData.queryHelper insertUploadContents:contents];
        [self saveImage:contents];
        appData.arrUploadContents = [self getContents:contents];
        NSLog(@"success %@", responseData);
    } fail:^(NSInteger status) {
        LOG(@"画像のUploadに失敗: %ld", (long)status);
    }
    ];
}

- (UIImage *)getImageServer//imageURL//?向こう側でも実装
{
    FUNC();
    NSURL *url = [NSURL URLWithString:@"http://133.2.37.224/Hackason/images/apple.jpg"];
    NSData *dat = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:dat];
    
    return img;
}
+ (UIImage *)getImageServerWithURL: (NSURL *)url
{
    FUNC();
    NSData   *dat   = [NSData dataWithContentsOfURL:url];
    UIImage  *image = [UIImage imageWithData:dat];
    
    return image;
}

+ (void)saveImage:(Contents *)contents
{
    FUNC();
    //major, minorからファイル名を作成
    NSString *fileName = [NSString stringWithFormat:@"%d-%d", contents.major, contents.minor];
    
    //pathの作成
    NSString *filePath = [NSString stringWithFormat:@"%@/images/%@.jpg" , [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], fileName];
    
    //NSDataを作成
    NSData *dataImg = [[NSData alloc] initWithData:UIImageJPEGRepresentation(contents.image, 0.1)];//品質最低
    
    NSLog(@"%@", filePath);
    if([dataImg writeToFile:filePath atomically:YES]) {
        NSLog(@"OK");
    } else {
        NSLog(@"Error");
    };
}
- (void)saveImage:(Contents *)contents
{
    FUNC();
    //major, minorからファイル名を作成
    NSString *fileName = [NSString stringWithFormat:@"%d-%d", contents.major, contents.minor];
    
    //pathの作成
    NSString *filePath = [NSString stringWithFormat:@"%@/images/%@.jpg" , [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], fileName];
    
    //NSDataを作成
    NSData *dataImg = [[NSData alloc] initWithData:UIImageJPEGRepresentation(contents.image, 0.1)];//品質最低
    
    NSLog(@"%@", filePath);
    if([dataImg writeToFile:filePath atomically:YES]) {
        NSLog(@"OK");
    } else {
        NSLog(@"Error");
    };
}
+ (Contents *)loadImage:(Contents *)contents
{
    FUNC();
    //major, minorからファイル名を作成
    NSString *fileName = [NSString stringWithFormat:@"%d-%d", contents.major, contents.minor];
    //pathの作成
    NSString *filePath = [NSString stringWithFormat:@"%@/images/%@.jpg" , [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:data];
    contents.image = image;
    return contents;
}

+ (BOOL)makeDirForAppContents
{
    FUNC();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    
    BOOL exists = [fileManager fileExistsAtPath:filePath];
    if (!exists) {
        NSError *error;
        BOOL created = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            NSLog(@"ディレクトリ作成失敗");
            return NO;
        }
    } else {
        return NO; // 作成済みの場合はNO
    }
    return YES;
}
//####################################################
- (NSArray *)getContents:(Contents *)contentsTarget
{
    FUNC();
    NSMutableArray *arrContent = [appData.arrUploadContents mutableCopy];
    for (Contents *contents in arrContent) {
        if (contentsTarget.minor == contents.minor) {
            contents.image = contentsTarget.image;
            return [arrContent copy];
        }
    }
    [arrContent addObject:contentsTarget];
    return [arrContent copy];
}

@end
