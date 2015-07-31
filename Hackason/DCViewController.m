//
//  DCViewController.m
//  Hackason
//
//  Created by oohashi on 2015/07/27.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "DCViewController.h"
#import "ImageManager.h"
#define MAX_LENGTH 60

@interface DCViewController ()

@end

@implementation DCViewController
{
    AppData     *appData;
    Contents    *content;
    UIView      *commentsView;
    UITextField *_textField;
    NSString    *tmpTxt;
}
- (void)viewDidLoad
{
    FUNC();
    [super viewDidLoad];
    
    appData         = [AppData SharedManager];
    self.apiManager = [[ApiManager alloc]init:@"version" installId:@"oohashi" ];
    content         = [Contents new];
    [self initCommentTextField];
    [self initScrollView];
    self.DetailImageView = [UIImageView new];
    [self.scrollView addSubview:self.DetailImageView];
    [self backButtonGen];
    [self postButtonGen];
    [self commentViewGen];
}
- (void)initScrollView
{
    self.scrollView = [UIScrollView new];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_W, SCREEN_H - 120)];
    self.scrollView.delegate         = self;
    self.scrollView.scrollEnabled    = YES;
    self.scrollView.bounces          = NO;
    self.scrollView.contentSize      = CGSizeMake(SCREEN_W, SCREEN_H * 2);
    self.scrollView.contentOffset    = CGPointMake(0, 0);
    self.scrollView.backgroundColor  = [UIColor whiteColor];
    self.scrollView.scrollsToTop     = YES;
    [self.view addSubview: self.scrollView];
}
- (void)initCommentTextField
{
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, SCREEN_H - 60, SCREEN_W * 0.8, 60)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.delegate    = self;
    [self.view addSubview:_textField];
}

- (void)didReceiveMemoryWarning
{
    FUNC();
    [super didReceiveMemoryWarning];
}

-(void)postButtonGen
{
    FUNC();
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [ UIFont fontWithName:@"Zapfino" size:24];
    btn.frame = CGRectMake(SCREEN_W * 0.8, SCREEN_H - 60, SCREEN_W * 0.2, 60);
    [btn setTitle:@"投稿" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(postComment)
  forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}
-(void)postComment
{
    FUNC();
    
    if ([tmpTxt isEqual:_textField.text] || [_textField isEqual:@""]) {
        
        return;
    }
    tmpTxt = _textField.text;
    // 通信中......

    [self.apiManager connect:@"http://prez.pya.jp/Hackason/RegisterComment.php"
                    postData:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%d", appData.selectedMajor], @"nearest_major",
                              [NSString stringWithFormat:@"%d", appData.selectedMinor], @"nearest_minor",
                              @"stab", @"from_device_token",
                              _textField.text, @"comment",
                              nil]
                    complete:^(NSArray *success) {
                        LOG(@"postComment Success");
                        [self fetchComments];
                        // 通信完了!
                    } error:^(NSDictionary *error) {
                        LOG(@"postComment Error");
                        // 通信に失敗しました......
                    }
     ];
}

-(void)reloadComments
{
    _textField.text = @"";
    [self.commentView reloadData];
}

-(void)fetchComments
{
    FUNC();
    [self.apiManager connect:@"http://prez.pya.jp/Hackason/FetchComment.php"
                    postData:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%d", appData.selectedMajor], @"select_major",
                              [NSString stringWithFormat:@"%d", appData.selectedMinor], @"select_minor",
                              nil]
                    complete:^(NSArray *success) {
                        LOG(@"fetchComment Success");
                        if([success count] == 0) {
                        
                            return ;
                        }
                        LOG(@"%@", [[success objectAtIndex:0] objectForKey:@"comment"]);
                        NSMutableArray *commentsArrayk = [NSMutableArray array];
                        for(int i = 0; i < [success count]; i++) {
                            LOG(@"LOPP: %@", [[success objectAtIndex:i] objectForKey:@"comment"]);
                            [commentsArrayk addObject: [[success objectAtIndex:i] objectForKey:@"comment"]];
                        }
                        self.comments = commentsArrayk;
                        LOG(@"%@", self.comments);
                        [self reloadComments];
                    } error:^(NSDictionary *error) {

                    }
     ];
    
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
-(void)commentViewGen
{
    self.commentView = [[UITableView alloc] initWithFrame:CGRectMake(0,0 , SCREEN_W, SCREEN_H)];
    self.commentView.delegate   = self;
    self.commentView.dataSource = self;
    [self.scrollView addSubview:self.commentView];
}

-(void)viewDidAppear:(BOOL)animated
{
    FUNC();
    [super viewDidAppear:YES];
    
    [self.DetailImageView removeFromSuperview];
    content.major = appData.selectedMajor;
    content.minor = appData.selectedMinor;
    content       = [ImageManager loadImage:content];

    self.DetailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, content.image.size.height * (SCREEN_W / content.image.size.width))];
    self.DetailImageView.backgroundColor = [UIColor redColor];
    self.DetailImageView.image       = content.image;
    [self.scrollView addSubview:self.DetailImageView];
    self.commentView.transform       = CGAffineTransformIdentity;
    self.commentView.transform       = CGAffineTransformMakeTranslation(0, (content.image.size.height * (SCREEN_W / content.image.size.width)));
    [self fetchComments];
}

#pragma mark-<scroll>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
-(UIView *)objectInDetailImageViewAtIndex:(NSUInteger)index
{
    FUNC();
    
    return self.DetailImageView;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    FUNC();
    
    return self.DetailImageView;
}
-(void)viewDidLayoutSubviews
{
    FUNC();
    
    [self.scrollView setContentSize: CGSizeMake(SCREEN_W, SCREEN_H * 2)];
    [self.scrollView flashScrollIndicators];
}
#pragma mark-<textField>
/**
 * キーボードでReturnキー選択時のイベントハンドラ
 * @param textField イベントが発生したテキストフィールド
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    FUNC();
    [self.view endEditing:YES];
    
    return YES;
}

/**
 * テキストが編集されたとき
 * @param textField イベントが発生したテキストフィールド
 * @param range 文字列が置き換わる範囲(入力された範囲)
 * @param string 置き換わる文字列(入力された文字列)
 * @retval YES 入力を許可する場合
 * @retval NO 許可しない場合
 */
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    FUNC();
    NSMutableString *text = [textField.text mutableCopy];
    
    [text replaceCharactersInRange:range withString:string];
    
    return ([text length] <= MAX_LENGTH);
}

#pragma mark-<tableViewForComment>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    FUNC();
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FUNC();
    return [self.comments count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUNC();
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.commentView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *name = self.comments[indexPath.row];
    cell.textLabel.text = name;
    
    return cell;
}
/*
 * コメント・ビューのコメントをタップした時に，表示しきれなかったコメントを表示
 *
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUNC();
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"コメント[全文]" message:self.comments[indexPath.row] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    
    [self.commentView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
