//
//  DbManager.m
//  common
//
//  Created by koji on 13/06/26.
//  Copyright (c) 2013年 Free-quency Co.,Ltd. All rights reserved.
//

#define SQLITE_FILE_NAME @"fpad_db.sqlite"
#define SQLITE_TEMP_FILE_NAME @"temp.fpad_db.sqlite"

#import "DbManager.h"
#import <sqlite3.h>
#import "FMDatabase.h"

@implementation DbManager{
    id _callbackInstance;
    SEL _callbackSelector;

    NSString *_originalDbPath;
    NSString *_writableDbPath;
    NSString *_tempDbPath;

    FMDatabase *_fmdb;
}

- (id)initDb:(BOOL)deleteDb{
    LOG(@"================ DbManager.initDb ================");
	self = [super init];
    
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];

    //元ファイル
    _originalDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLITE_FILE_NAME];

    //デバイスにコピーされたファイル
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _writableDbPath = [documentsDirectory stringByAppendingPathComponent:SQLITE_FILE_NAME];

    //一時退避用ファイルへのパス
    _tempDbPath = [documentsDirectory stringByAppendingPathComponent:SQLITE_TEMP_FILE_NAME];
    
    BOOL existsWritableDb = [fm fileExistsAtPath:_writableDbPath];

    /*
    if(existsWritableDb){
        LOG(@"_writableDbPath：存在する");
    }else{
        LOG(@"_writableDbPath：存在しない");
    }
    if(deleteDb){
        LOG(@"deleteDb：YES");
    }else{
        LOG(@"deleteDb：NO");
    }
     */

    //devide側のDBが存在している & deleteDb:YES
    // -> DBを一旦削除
    if(existsWritableDb == YES && deleteDb == YES){
        LOG(@"DB削除(devide側のDBが存在 & deleteDb:YES)");
        //DB削除
        [self removeFileByPath:_writableDbPath];
    }else{
        LOG(@"DB削除なし");
    }

    //devide側のDBが存在しない OR deleteDb:YES
    // -> DB初期化(_originalDbPath -> _writableDbPath)
    if(existsWritableDb == NO || deleteDb == YES){
        LOG(@"DBコピー(devide側のDBが存在しない OR deleteDb:YES)");
        //DBコピー
        BOOL successCopy = [fm copyItemAtPath:_originalDbPath toPath:_writableDbPath error:&error];
        if(!successCopy) LOG(@"%@", error);
    }else{
        LOG(@"DBコピーなし");
    }

    //DBに接続
    _fmdb = [FMDatabase databaseWithPath:_writableDbPath];
    if([_fmdb open]){
        [_fmdb setShouldCacheStatements:YES];
        LOG(@"データベースConnect成功");
    }
    
	return self;
}


- (void)removeFileByPath:(NSString*)path{
    LOG(@"removeFileByPath:%@", path);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    [fm removeItemAtPath:path error:&error];
    if(error) LOG(@"[remove失敗]%@", error);
}

/*
 * 現DBの退避を行う(_writableDbPath->_tempDbPath)
 */
- (void)backup{
    LOG(@"===== DbManager.backup =====");
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existsTempDb = [fm fileExistsAtPath:_tempDbPath];
    if(existsTempDb == YES){
        LOG(@"tempDbが存在するので削除");
        [self removeFileByPath:_tempDbPath];
    }

    NSError *error = nil;
    [fm copyItemAtPath:_writableDbPath toPath:_tempDbPath error:&error];
    if(error) LOG(@"_writableDbPath[copy失敗]%@", error);

    [_fmdb close];
    
    [self removeFileByPath:_writableDbPath];

    [fm copyItemAtPath:_originalDbPath toPath:_writableDbPath error:&error];
    if(error) LOG(@"_originalDbPath[copy失敗]%@", error);

    [_fmdb open];
}
/*
 * 退避したファイルを戻す(_tempDbPath->_writableDbPath)
 */
- (void)restore{
    LOG(@"===== DbManager.restore =====");
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existsTempDb = [fm fileExistsAtPath:_tempDbPath];
    if(existsTempDb == NO){
        LOG(@"tempDbが存在しない");
        return;
    }
    BOOL existsWritableDb = [fm fileExistsAtPath:_writableDbPath];
    if(existsWritableDb == YES){
        LOG(@"writableDbが存在するので削除");
        [self removeFileByPath:_writableDbPath];
    }

    NSError *error = nil;
    [fm copyItemAtPath:_tempDbPath toPath:_writableDbPath error:&error];
    if(error) LOG(@"[copy失敗]%@", error);
}

- (void)select:(NSString *)sql instance:(id)callbackInstance selector:(SEL)callbackSelector{
    _callbackInstance = callbackInstance;
    _callbackSelector = callbackSelector;

    FMResultSet *resultSet = [_fmdb executeQuery:sql];

    NSMethodSignature *sig = [_callbackInstance methodSignatureForSelector:_callbackSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:_callbackSelector];
    [invocation setTarget:_callbackInstance];
    
    [invocation setArgument:&resultSet atIndex:2];
    [invocation invoke];
}

- (FMResultSet *)select:(NSString *)sql{
    FMResultSet *resultSet = [_fmdb executeQuery:sql];
    return resultSet;
}


- (void)update:(NSString *)sql{
    [_fmdb executeUpdate:sql];
    if([_fmdb hadError]){
        LOG(@"Err %d: %@", [_fmdb lastErrorCode], [_fmdb lastErrorMessage]);
    }
}
- (void)begin{
    [_fmdb beginTransaction];
}

- (void)commit{
    [_fmdb commit];
}


+ (NSString *)escape:(NSString *)value{
    NSString *escapeValue = @"";
    if([value isEqual:[NSNull null]] == NO){
        escapeValue = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    return escapeValue;
}
@end
