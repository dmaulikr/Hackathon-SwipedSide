//
//  ApiManager.m
//  common
//
//  Created by Yohei Sashikata on 2015/06/23.
//  Copyright (c) 2015年 Yohei Sashikata. All rights reserved.
//

#import "ApiManager.h"
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

@interface ApiManager () <UIAlertViewDelegate>

@end

@implementation ApiManager{

    void (^_callbackComplete)(NSArray *result);
    void (^_callbackError)(NSDictionary *result);

    NSMutableData *_receivedData;

    NSString *_url;
    
    int _apiErrorCode;

    NSString *_deviceInfo;
    NSString *_version;
    NSString *_installId;
    NSString *_token;
}

- (id)init:(NSString *)version installId:(NSString *)installId{
	self = [super init];
	if(self != nil){
		NSLog(@"================ ApiManager.init ================");
        //機種情報作成
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *tmpMachine = malloc(size);
        sysctlbyname("hw.machine", tmpMachine, &size, NULL, 0);
        NSString *machine = [NSString stringWithCString:tmpMachine encoding: NSUTF8StringEncoding];
        free(tmpMachine);
        _deviceInfo = [NSString stringWithFormat:@"%@ %@ %@", machine, [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];

        _version = version;
        _installId = installId;
        NSLog(@"       _version:%@", _version);
        NSLog(@"     _installId:%@", _installId);
        /*
        //token = md5(インストールID + 秘密鍵);
        _token = [[CONCAT(_installId, SECRET_KEY) dataUsingEncoding:NSUTF8StringEncoding] MD5];
        LOG(@"     CONCAT(_installId, SECRET_KEY):%@", CONCAT(_installId, SECRET_KEY));
        LOG(@"     _token:%@", _token);
        */
    }
	return self;
}

- (void)connect:(NSString *)url postData:(NSDictionary *)postData complete:(void (^)(NSArray *result))callbackComplete error:(void (^)(NSDictionary *result))callbackError{
    FUNC();
    NSLog(@"【%@】", url);
    _url = url;
    _callbackComplete = callbackComplete;
    _callbackError = callbackError;
    
    //POSTパラメーターを設定
    NSString *param = @"";
    param = [param stringByAppendingString:[NSString stringWithFormat:@"%@=%@", @"install_id", _installId]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", @"device_info", _deviceInfo]];
    if(!postData[@"token"]){
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", @"token", _token]];
    }
    
    for(id key in [postData keyEnumerator]){
        NSString *value = [postData valueForKey:key];
        NSLog(@"        Key:%@ Value:%@", key, value);
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
    NSLog(@"        param:%@", param);
    
    //リクエスト設定
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setTimeoutInterval:300];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    //送信
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(self.connection){
        _receivedData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receivedData appendData:data];
}


//ERROR!
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"ApiManager Connection failed! Error - %@ %@",
    [error localizedDescription],
    [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    NSLog(@"%@", error);

    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    _callbackError(result);
}


//API RESPONS OK!
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *error;
    NSArray *respons = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingAllowFragments error:&error];
    LOG(@"Fetch Comment Response: %@", [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding]);
    LOG(@"Fetch Comment Response Raw: %@", respons);
    // if(error) NSLog(@" api error:%@", error);
    // ############
//    LOG(@"%@", [[respons objectAtIndex:0] objectForKey:@"comment"]);
//    NSMutableArray *commentsArrayk = [NSMutableArray array];//@[@"jjjjj"];//[NSArray array];
//    for(int i = 0; i < [respons count]; i++) {
//        LOG(@"LOPP: %@", [[respons objectAtIndex:i] objectForKey:@"comment"]);
//        [commentsArrayk addObject: [[respons objectAtIndex:i] objectForKey:@"comment"]];
//    }
//    LOG(@"LOPPPPPPPPPPPPPPPPPPPP: %@", commentsArrayk);
    
    int status = 0;
    if(error) {
        //status = 1;
    }else{
       // status = [[respons objectForKey:@"status"] intValue];
    }
    NSLog(@"status:%@", respons);

    // 強制的にsuccess
    
    
    //ステータスチェック
    if(status == 0) {

        //API OK
        //NSDictionary *data = [respons objectForKey:@"data"];
        //NSLog(@"major=%@", [data objectForKey:@"major"]);
        _callbackComplete(respons);//?

    }else{
        //self.lastErrorStatus = ITOSTR(status);
        //NSMutableDictionary *result = [NSMutableDictionary dictionary];
        //result[@"status"] = ITOSTR(status);
        //_callbackError(result);
    }

    _receivedData = [NSMutableData data];
}




@end
