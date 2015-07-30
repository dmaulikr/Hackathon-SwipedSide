//
//  AppDelegate.h
//  Hackason
//
//  Created by oohashi on 2015/07/07.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "Observer.h"
#import "ImageManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(nonatomic) UIImage *imageView;
@property(nonatomic) Observer *observer;

@end

