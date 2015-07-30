//
//  AppData.m
//  swift
//
//  Created by yohei sashikata on 2014/02/19.
//  Copyright (c) 2014年 Yohei Sashikata. All rights reserved.
//

#import "AppData.h"

@implementation AppData
{
}

static AppData* sharedAppData = nil;

+ (AppData *)SharedManager
{
    @synchronized(self) {
		if(sharedAppData == nil) {
			sharedAppData = [[self alloc] init];
		}
	}
	return sharedAppData;
}

- (AppData *)init
{
    FUNC();
    self.apiManager          = [[ApiManager alloc] init];
    self.queryHelper         = [[QueryHelper alloc] init];
    self.arrUploadContents   = [NSArray array];
    self.arrDownloadContents = [NSArray array];
    self.nearestBeacon       = [NearestBeacon new];
    self.selectedImage       = [UIImage new];
    
    return self;
}

@end
