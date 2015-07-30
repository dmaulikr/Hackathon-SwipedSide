//
//  ViewController.h
//  Hackason
//
//  Created by oohashi on 2015/07/07.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "ApiManager.h"
#import "BroadCaster.h"
#import "Observer.h"
#import "ImageManager.h"
#import "InteractiveView.h"

@interface MainViewController : UIViewController

@property(nonatomic) ApiManager      *apiManager;
@property(nonatomic) Observer        *observer;
@property(nonatomic) ImageManager    *image;
@property(nonatomic) CGRect           imageViewSize;
@property(nonatomic) UIImageView     *imageView;
@property(nonatomic) InteractiveView *interactiveView;

@end

