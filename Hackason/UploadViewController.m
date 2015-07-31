//
//  UploadViewController.m
//  Hackason
//
//  Created by Yohei Sashikata on 2015/07/24.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "UploadViewController.h"
#import "ContentsCollectionView.h"
#import "Interactiveview.h"
#import "ImageManager.h"
#import "DCViewController.h"
#import "Contents.h"
#import "JCRBlurView.h"

@interface UploadViewController ()
<
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
  ContentsCollectionViewDelegate,
  InteractiveViewDelegate
>

@end

@implementation UploadViewController
{
    DCViewController *dcViewController;
    AppData          *_appData;
    ImageManager     *_imageManager;
    __weak IBOutlet ContentsCollectionView *_contentsCollectionView;
    __weak IBOutlet UIView                 *_baseView;
    __weak IBOutlet InteractiveView        *_interactiveView;
    __weak IBOutlet UIImageView            *_imgView;
    JCRBlurView                            *blurView;
}

#pragma mark-<初期化>
// @test いつ実行されるか
- (instancetype)init
{
    FUNC();
    self = [super init];
    if (self) {
        _appData      = [AppData SharedManager];
        _imageManager = [ImageManager new];
        
    }
    return self;
}
// @test いつ実行されるか
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
    
    dcViewController = [DCViewController new];
    [_contentsCollectionView setContentsList:_appData.arrUploadContents];
    [_contentsCollectionView setDelegate:self];
    [_contentsCollectionView initCollectionView];// initなのにしたでいいのか
    
    [self initSwipedImageViews];
    [self initBlurView];
    [self titleGen];
}
- (void)titleGen
{
    UILabel *title;
    title = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, 200, 60)];
    title.text = @"UPLOAD";
    title.font = [UIFont boldSystemFontOfSize:32.0f];
    title.textColor = [UIColor grayColor];
    [self.view addSubview:title];
}
/*
 * スワイプされるコンテンツ・ビュー群の初期化
 */
- (void)initSwipedImageViews
{
    [_interactiveView setDelegate:self];
    [_baseView setAlpha:0];
    _imgView.backgroundColor         = [UIColor clearColor];
    _baseView.backgroundColor        = [UIColor clearColor];
    _interactiveView.backgroundColor = [UIColor clearColor];
    _imgView.contentMode             = UIViewContentModeScaleAspectFit;
}
/*
 * スワイプする画像を表示する時，その画像の背景にブラー効果を施す
 * これは，コンテンツの背景がコレクション・ビューでごちゃつくのが好ましくないための処理
 */
- (void)initBlurView
{
    blurView = [JCRBlurView new];
    [blurView setFrame:CGRectMake(0.0f,0.0f,SCREEN_W,SCREEN_H)];
    [self.view addSubview:blurView];
    blurView.alpha = 0.0f;
    [self.view bringSubviewToFront:_baseView];
}
- (void)didReceiveMemoryWarning
{
    FUNC();
    [super didReceiveMemoryWarning];
}

#pragma mark-<コンテンツのアップロード>
- (void)onTapAdd
{
    FUNC();
    [self showCameraroll];
}
- (void)showCameraroll
{
    FUNC();
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    [imagePickerController setDelegate:self];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController: imagePickerController animated:YES completion:nil];
}
/**
 * カメラロールから画像を取得した直後に実行されるDelegateメソッド
 */
- (void)imagePickerController :(UIImagePickerController *)picker
        didFinishPickingImage :(UIImage *)image
                  editingInfo :(NSDictionary *)editingInfo
{
    FUNC();
    [_imgView setImage:image];
    [self dismissViewControllerAnimated:YES completion:^ {
        [_baseView setAlpha:1];
    }];
    blurView.alpha = 1.0f;
}
/**
 * Swipeされたタイミングで実行されるDelegateメソッド
 * 同期的に書き換えれば......いいじゃない!
 */
- (void)didFinishSwipe
{
    FUNC();
    [_imageManager uploadSwipedImage:[_imgView image]
                                text:@"stab"
                                 url:[NSURL URLWithString: @"http://prez.pya.jp/Hackason/RegisterContents.php"]];
    
    // コレクション・ビュー再描画// minor値はサーバーに登録されないと取得できないため遅延させる
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                          target:self
                                        selector:@selector(loadSwipedContent)
                                        userInfo:nil
                                         repeats:NO
    ];
//    NSTimer *tm = [[NSTimer alloc] init];
//    tm = [NSTimer scheduledTimerWithTimeInterval:5.0f
//                                          target:self
//                                        selector:@selector(loadSwipedContent)
//                                        userInfo:nil
//                                         repeats:NO
//          ];
    // スワイプした画像を不可視に
    [_baseView setAlpha:0];
    // ブラー効果
    blurView.alpha = 0.0f;
}
-(void)loadSwipedContent
{
    FUNC();
    [_contentsCollectionView setContentsList:_appData.arrUploadContents];//////////
    [_contentsCollectionView reloadData];
}

// なんだっけ，これ......
//- (NSArray *)getContents:(Contents *)contentsTarget
//{
//    NSMutableArray *arrContent = [_appData.arrUploadContents mutableCopy];
//    for (Contents *contents in arrContent) {
//        if (contentsTarget.minor == contents.minor) {
//            contents.image = contentsTarget.image;
//            return [arrContent copy];
//        }
//    }
//    [arrContent addObject:contentsTarget];
//    return [arrContent copy];
//}

#pragma mark-<画面遷移>
/*
 * コレクション・ビューの画像が選択された時に詳細画面(dcViewController)に遷移
 * AppData経由して，データの受け渡し
 */
- (void)didTapImageViewOfCellectionWithIndex:(int)idx
{
    FUNC();
    LOG(@"idx(=minor): %d", idx);
//    Contents *selectedContents = [Contents new];
//    selectedContents = ((Contents *)[_appData.arrUploadContents objectAtIndex:idx]);
    Contents *selectedContents = ((Contents *)[_appData.arrUploadContents objectAtIndex:idx]);
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
