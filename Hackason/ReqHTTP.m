//
//  ReqHTTP.m
//  Hackason
//
//  Created by oohashi on 2015/07/09.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "ReqHTTP.h"

@implementation ReqHTTP
{
    void (^requestDoneHandler)(NSDictionary *data);
    void (^requestFailHandler)(NSInteger status);
}

- (void)postMultiDataWithTextDictionary:(NSDictionary*)textDictionary
                        imageDictionary:(NSDictionary*)imageDictionary
                                    url:(NSURL*)url
                                   done:(void(^)(NSDictionary *responseData))doneHandler
                                   fail:(void(^)(NSInteger status)) failHandler
{
    FUNC();
    requestDoneHandler = doneHandler;
    requestFailHandler = failHandler;
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString* boundary = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    config.HTTPAdditionalHeaders =
    @{
      @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
      };
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableData* data = [NSMutableData data];
    for (id key in [textDictionary keyEnumerator]) {
        NSString* value = [textDictionary valueForKey:key];
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    for (int i = 0; i < [imageDictionary count]; i++) {
        NSString* key = [[imageDictionary allKeys] objectAtIndex:i];
        NSData* value = [imageDictionary valueForKey:key];
        NSString* name = [NSString stringWithFormat:@"upload_file%d", i];
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"name=\"%@\";", name] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"filename=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:value];
        [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [session invalidateAndCancel];
        if(error) {
            requestFailHandler(-1);
        } else {
            NSError *err = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            if (err) {
                requestFailHandler(-1);
                return;
            }
            requestDoneHandler(json);
        }
    }];
    [task resume];
}
@end
