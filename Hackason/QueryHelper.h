//
//  QueryHelper.h
//  Hackason
//
//  Created by Yohei Sashikata on 2015/07/22.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contents.h"

@interface QueryHelper : NSObject
- (void)insertUploadContents:(Contents *)contents;
- (void)insertDownLoadContents:(Contents *)contents;

- (NSArray *)selectUploadContents;
- (NSArray *)selectDownloadContents;
@end
