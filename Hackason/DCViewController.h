//
//  DCViewController.h
//  Hackason
//
//  Created by oohashi on 2015/07/27.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//
#import "ApiManager.h"

@interface DCViewController : UIViewController
<
 UIScrollViewDelegate,
 UIScrollViewAccessibilityDelegate,
 UITextFieldDelegate,
 UITableViewDelegate,
 UITableViewDataSource
>

@property (nonatomic) UIImageView  *DetailImageView;
@property (nonatomic) UIImage      *DetailView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) ApiManager   *apiManager;
@property (nonatomic) UITableView  *commentView;
@property (nonatomic) NSArray      *comments;

-(void)fetchComments;

@end
