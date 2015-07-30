#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>//こあいめーじ?

@interface ReqHTTP : NSObject

- (void)postMultiDataWithTextDictionary:(NSDictionary*)textDictionary
                        imageDictionary:(NSDictionary*)imageDictionary
                                    url:(NSURL*)url
                                   done:(void(^)(NSDictionary *responseData))doneHandler
                                   fail:(void(^)(NSInteger status))failHandler;

@end