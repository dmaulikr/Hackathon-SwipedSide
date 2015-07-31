//
//  ViewController.m
//  Hackason
//
//  Created by oohashi on 2015/07/07.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "MainViewController.h"
#import "ContentsCollectionView.h"
#import "UploadViewController.h"
#import "DownloadViewController.h"

@interface MainViewController()<UIViewControllerTransitioningDelegate>

@end

@implementation MainViewController{
    AppData *_appData;
    
    __weak IBOutlet UIView *_viewContainer;
    __weak IBOutlet UIButton *uploadTabButton;
    __weak IBOutlet UIButton *downloadTabButton;
    UploadViewController   *_uploadViewController;
    DownloadViewController *_downloadViewController;
    
    BOOL _canChange;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    FUNC();
    self = [super initWithCoder:coder];
    if (self){
        _appData = [AppData SharedManager];
        
        // #########################################################################
        _appData.arrUploadContents = [_appData.queryHelper selectUploadContents];
        for (Contents *contents in _appData.arrUploadContents) {
             [ImageManager loadImage:contents];
        }
        _appData.arrDownloadContents = [_appData.queryHelper selectDownloadContents];
        for (Contents *contents in _appData.arrDownloadContents) {
            [ImageManager loadImage:contents];
        }
        
        _uploadViewController = [[UploadViewController alloc] init];
        [self addChildViewController:_uploadViewController];
        [_uploadViewController didMoveToParentViewController:self];
        
        _downloadViewController = [[DownloadViewController alloc] init];
        [self addChildViewController:_downloadViewController];
        [_downloadViewController didMoveToParentViewController:self];
        
        [self setTransitioningDelegate:self];
        
        _canChange = true;
        
    }
    return self;
}

// 二つの画面をメインに追加
- (void)viewDidLoad
{
    FUNC();
    [super viewDidLoad];
    [_viewContainer addSubview:_downloadViewController.view];
    [_viewContainer addSubview:_uploadViewController.view];
    
    [self initTab];
}
- (void)initTab
{
    FUNC();
    UIImage *uploadImage = [[UIImage alloc] init];
    uploadImage = [UIImage imageNamed:@"uploadIcon.png"];
    UIImageView *uploadImageView
    = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, uploadImage.size.width / 5, uploadImage.size.height / 5)];
    uploadImageView.image = uploadImage;
    [downloadTabButton addSubview:uploadImageView];

    UIImage *downloadImage = [[UIImage alloc] init];
    downloadImage = [UIImage imageNamed:@"download.png"];
    UIImageView *downloadImageView
    = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, downloadImage.size.width / 5, downloadImage.size.height / 5)];
    downloadImageView.image = downloadImage;
    [uploadTabButton addSubview:downloadImageView];
}


#pragma mark-<Move Screen>
- (IBAction)onTapUpload:(id)sender
{
    FUNC();
    [self changeMode:_downloadViewController toViewController:_uploadViewController];
}

- (IBAction)onTapDownload:(id)sender
{
    FUNC();
    [self changeMode:_uploadViewController toViewController:_downloadViewController];
}

- (void)changeMode:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController{
    FUNC();
    
    if (!_canChange) return;
    
    _canChange = false;
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:1.0
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{}
                            completion:^(BOOL finished){
                                _canChange = true;
                            }];
}

@end
