//
//  imageManager.h
//  Hackason
//
//  Created by oohashi on 2015/07/09.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "ReqHTTP.h"
#import "Contents.h"

@interface ImageManager : NSObject

- (void)uploadSwipedImage: (UIImage *)image text: (NSString *)text url:(NSURL *)url;
- (UIImage *)getImageServer;
+ (void)saveImage:(Contents *)contents;
+ (Contents *)loadImage:(Contents *)contents;
+ (BOOL)makeDirForAppContents;
+ (UIImage *)getImageServerWithURL: (NSURL *)url;

@end
