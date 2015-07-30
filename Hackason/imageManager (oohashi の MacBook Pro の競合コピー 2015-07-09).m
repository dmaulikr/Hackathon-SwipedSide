//
//  imageManager.m
//  Hackason
//
//  Created by oohashi on 2015/07/09.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "imageManager.h"

@implementation imageManager {
    UIImage *postImage;
    
    //imageView.image = [UIImage imageNamed:@"apple.jpg"];
}


-(void)upload
{
    postImage = [UIImage imageNamed:@"apple.jpg"];
    
    NSURL *url = [NSURL URLWithString:@"http://kaicyo.local/RegisterContents.php"];
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(postImage, 1.0)];
    
    NSMutableDictionary* texts  = [NSMutableDictionary dictionary];
    NSMutableDictionary* images = [NSMutableDictionary dictionary];
    
    [texts  setObject:@"tst" forKey:@"tst"];//複数ある場合はこれを追加
    [images setObject:imageData forKey:@"apple"];//複数ある場合はこれを追加
    
    ReqHTTP *reqHTTP = [[ReqHTTP alloc] init];
    [reqHTTP postMultiDataWithTextDictionary:texts
                             imageDictionary:images
                                         url:url
                                        done:^(NSDictionary *responseData) {
                                            //NSError *error;
                                            NSInteger status = [[responseData objectForKey:@"status"] integerValue];
                                            //NSDictionary *respons = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                                            if (status != 1) {
                                                NSLog(@"画像のUploadに失敗");
                                                return;
                                            }
                                            NSLog(@"success %@", responseData);
                                            
                                        } fail:^(NSInteger status) {
                                            NSLog(@"画像のUploadに失敗2");
                                            //NSLog(@"success %@", responseData);
                                        }];
}

- (UIImage *)getImageServer//imageURL
{
    NSString *str = @"http://kaicyo.local/Hackason/images/tst.jpg";
    NSURL    *url = [NSURL URLWithString:str];
    NSData   *dat = [NSData dataWithContentsOfURL:url];
    UIImage  *img = [UIImage imageWithData:dat];
    
    return img;
}

@end
