//
//  DbManager.h
//  common
//
//  Created by koji on 13/06/26.
//  Copyright (c) 2013年 Free-quency Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DbManager : NSObject

- (void)backup;
- (void)restore;
- (FMResultSet *)select:(NSString *)sql;
- (void)select:(NSString *)sql instance:(id)callbackInstance selector:(SEL)callbackSelector;
- (void)update:(NSString *)sql;
- (void)begin;
- (void)commit;

+ (NSString *)escape:(NSString *)value;
- (id)initDb:(BOOL)deleteDb;
@end
