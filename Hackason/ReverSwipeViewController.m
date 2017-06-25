//
//  ReverSwipeViewController.m
//  Hackason
//
//  Created by oohashi on 2015/07/28.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "ReverSwipeViewController.h"
#import "ImageManager.h"

@interface ReverSwipeViewController ()

@end

@implementation ReverSwipeViewController
{
    AppData                  *appdata;
    UIImageView              *downnerSwipedImageView;
    UISwipeGestureRecognizer *swipeDownGesture;
    UILabel *assistComment;
}

- (void)viewDidLoad
{
    FUNC();
    [super viewDidLoad];
    
    appdata = [AppData SharedManager];
    [self backButtonGen];
    [self initSwipeDownGesture];
    [self initBackGroundImage];
    [self initDownnerSwipedImageView];
}

- (void)initBackGroundImage
{
    FUNC();
    UIImage     *backGroundImage     = [UIImage imageNamed:@"downSwiped.png"];
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W / 2 -150 , SCREEN_H / 2 - 150, 300, 300)];
    backGroundImageView.image = backGroundImage;
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backGroundImageView];
    
    assistComment = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W / 2 -150 , 70, 300, 50)];
    assistComment.text = @"下にスワイプしてダウンロード";
    assistComment.textColor = [UIColor blackColor];
    assistComment.textAlignment = UITextAlignmentCenter;
    assistComment.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.view addSubview:assistComment];
}

- (void)initDownnerSwipedImageView
{
    FUNC();
    downnerSwipedImageView
    = [[UIImageView alloc] initWithFrame:CGRectMake(35, 60, SCREEN_W * 0.8, SCREEN_H * 0.8)];
    [self.view addSubview:downnerSwipedImageView];
    downnerSwipedImageView.alpha           = 0.0f;
    downnerSwipedImageView.backgroundColor = [UIColor clearColor];
    downnerSwipedImageView.contentMode     =  UIViewContentModeScaleAspectFit;
}

- (void)initSwipeDownGesture
{
    FUNC();
    swipeDownGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeDownner:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGesture];
}

- (void)didReceiveMemoryWarning
{
    FUNC();
    [super didReceiveMemoryWarning];
}

-(void)backButtonGen
{
    FUNC();
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(SCREEN_W - 100, 10, 100, 30);
    UIImage *closeImage = [[UIImage alloc] init];
    closeImage = [UIImage imageNamed:@"close.png"];
    UIImageView *closeImageView
    = [[UIImageView alloc] initWithFrame:CGRectMake(10, -32, closeImage.size.width / 7, closeImage.size.height / 7)];
    closeImageView.image = closeImage;
    [btn addSubview:closeImageView];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backColleView)
        forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}

-(void)backColleView
{
    FUNC();
    [self dismissViewControllerAnimated:YES completion:^(){LOG(@"帰ってきたぞ!");}];
}

- (void)view_SwipeDownner:(UISwipeGestureRecognizer *)sender
{
    FUNC();
    LOG(@"逆スワイプがされました．nearestMajor=%dnearestMinor=%d", appdata.nearestBeacon.major, appdata.nearestBeacon.minor);
    Contents *content = [Contents new];
    content.major = appdata.nearestBeacon.major;
    content.minor = appdata.nearestBeacon.minor;
    NSString *rawURL
    = [NSString stringWithFormat:@"http://prez.pya.jp/Hackason/images/major%d/minor%d.jpg", content.major, content.minor];
    NSURL *urlForDownloadContents = [NSURL URLWithString:rawURL];
    LOG(@"urlForDownloadContents: %@", urlForDownloadContents);
    content.image = [ImageManager getImageServerWithURL:urlForDownloadContents];
    downnerSwipedImageView.image = content.image;
    downnerSwipedImageView.alpha = 1.0f;
    [appdata.queryHelper insertDownLoadContents:content];
    [ImageManager saveImage:content];
    appdata.arrDownloadContents = [self getContents:content];
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^ {
                         downnerSwipedImageView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL result) {
                         assistComment.text = @"ダウンロード完了";
                     }
     ];
}

 - (NSArray *)getContents:(Contents *)contentsTarget
{
    FUNC();
    NSMutableArray *arrContent = [appdata.arrDownloadContents mutableCopy];
    for (Contents *contents in arrContent) {
        if (contentsTarget.minor == contents.minor) {
            contents.image = contentsTarget.image;
            return [arrContent copy];
        }
    }
    [arrContent addObject:contentsTarget];
    
    return [arrContent copy];
}

-(void)viewWillAppear:(BOOL)animated
{
    FUNC();
    [super viewWillAppear:YES];
    assistComment.text = @"下にスワイプしてダウンロード";
    downnerSwipedImageView.transform
    = CGAffineTransformMakeTranslation(0, -downnerSwipedImageView.height);
}

-(void)viewWillDisappear:(BOOL)animated
{
    FUNC();
    [super viewWillDisappear:YES];
    downnerSwipedImageView.alpha = 0.0f;
}
@end
