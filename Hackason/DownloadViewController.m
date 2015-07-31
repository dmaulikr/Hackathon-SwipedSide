//
//  DownloadViewController.m
//  Hackason
//
//  Created by Yohei Sashikata on 2015/07/24.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "DownloadViewController.h"
#import "ContentsCollectionView.h"
#import "ImageManager.h"
#import "DCViewController.h"
#import "ReverSwipeViewController.h"

@interface DownloadViewController ()
<
 UINavigationControllerDelegate,
 ContentsCollectionViewDelegate
>

@end

@implementation DownloadViewController
{
    AppData                  *_appData;
    DCViewController         *dcViewController;
    ReverSwipeViewController *reverSwipeViewController;
    ImageManager             *_imageManager;
    __weak IBOutlet ContentsCollectionView *_contentsCollectionView;
    NSTimer *tm;
}

- (instancetype)init
{
    FUNC();
    self = [super init];
    if (self) {
        _appData      = [AppData SharedManager];
        _imageManager = [ImageManager new];
        tm = [[NSTimer alloc] init];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    FUNC();
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    FUNC();
    [super viewDidLoad];
    
    dcViewController         = [DCViewController new];
    reverSwipeViewController = [ReverSwipeViewController new];
    [_contentsCollectionView setContentsList:_appData.arrDownloadContents];////////////
    [_contentsCollectionView setDelegate:self];
    [_contentsCollectionView initCollectionView];
    [self titleGen];
}
- (void)titleGen
{
    UILabel *title;
    title = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 60)];
    title.text = @"DOWNLOAD";
    title.font = [UIFont boldSystemFontOfSize:32.0f];
    title.textColor = [UIColor grayColor];
    [self.view addSubview:title];
}
/*
 * ここのコンテンツ・ビューの処理が微妙......
 */
- (void)viewDidAppear:(BOOL)animated
{
    FUNC();
    [super viewDidAppear:animated];
    // タイミングの問題
    tm = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                          target:self
                                        selector:@selector(loadSwipedContent)
                                        userInfo:nil
                                         repeats:NO
          ];
    [self loadSwipedContent];
}

- (void)didReceiveMemoryWarning
{
    FUNC();
    [super didReceiveMemoryWarning];
}
// ダウンロード画面に移行
- (void)onTapAdd
{
    FUNC();
    [self presentViewController:reverSwipeViewController
                       animated:YES
                     completion:^() {

                     }];
}

-(void)loadSwipedContent
{
    [_contentsCollectionView setContentsList:_appData.arrDownloadContents];
    [_contentsCollectionView reloadData];
}

#pragma mark-<画面遷移>
- (void)didTapImageViewOfCellectionWithIndex:(int)idx
{
    FUNC();
    LOG(@"idx(=minor): %d", idx);
    Contents *selectedContents = ((Contents *)[_appData.arrDownloadContents objectAtIndex:idx]);
//    Contents *selectedContents= [[Contents alloc] init];
//    selectedContents = ((Contents *)[_appData.arrDownloadContents objectAtIndex:idx]);
    _appData.selectedMinor = selectedContents.minor;
    _appData.selectedMajor = selectedContents.major;
    _appData.selectedImage = selectedContents.image;
    LOG(@"selectedMajor: %d", _appData.selectedMajor);
    LOG(@"selectedMinor: %d", _appData.selectedMinor);
    
    [self presentViewController:dcViewController
                       animated:YES
                     completion:^() {
                         LOG(@"==================詳細画面へ遷移==================");
                     }];
}

@end
