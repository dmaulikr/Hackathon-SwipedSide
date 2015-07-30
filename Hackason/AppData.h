//
//  AppData.h
//  swift
//
//  Created by yohei sashikata on 2014/02/19.
//  Copyright (c) 2014年 Yohei Sashikata. All rights reserved.
//

#import "ApiManager.h"
#import "QueryHelper.h"
#import "NearestBeacon.h"

@interface AppData : NSObject

@property ApiManager               *apiManager;
@property QueryHelper              *queryHelper;
@property(nonatomic) NSString      *url;
@property(nonatomic) NSArray       *arrUploadContents;
@property(nonatomic) NSArray       *arrDownloadContents;
@property(nonatomic) NearestBeacon *nearestBeacon;
@property(nonatomic) int            swipedMajor;
@property(nonatomic) int            swipedMinor;
@property(nonatomic) int            selectedMajor;
@property(nonatomic) int            selectedMinor;
@property(nonatomic) UIImage       *selectedImage;

+ (AppData *)SharedManager;
@end
