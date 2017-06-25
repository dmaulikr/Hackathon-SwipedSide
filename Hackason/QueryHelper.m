//
//  QueryHelper.m
//  Hackason
//
//  Created by Yohei Sashikata on 2015/07/22.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "QueryHelper.h"
#import "DbManager.h"
@implementation QueryHelper {
    DbManager *dbManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        FUNC();
        dbManager = [[DbManager alloc] initDb:NO];
        [self initTable];
    }
    return self;
}

- (void)initTable {
    NSString *strSql = @"";
    [dbManager begin];
    
    strSql = @"CREATE TABLE IF NOT EXISTS TBL_UPLOAD (";
    strSql = [strSql stringByAppendingString:@"MAJOR INTEGER, "];
    strSql = [strSql stringByAppendingString:@"MINOR INTEGER UNIQUE)"];
    [dbManager update:strSql];
    LOG(@"initTable:TBL_UPLOAD = %@", strSql);
    
    strSql = @"CREATE TABLE IF NOT EXISTS TBL_DOWNLOAD (";
    strSql = [strSql stringByAppendingString:@"MAJOR INTEGER, "];
    strSql = [strSql stringByAppendingString:@"MINOR INTEGER UNIQUE)"];
    [dbManager update:strSql];
    LOG(@"initTable:TBL_DOWNLOAD = %@", strSql);
    [dbManager commit];
}

- (void)insertUploadContents:(Contents *)contents {
    [self insertContents:@"TBL_UPLOAD" contents:contents];
}

- (void)insertDownLoadContents:(Contents *)contents {
    [self insertContents:@"TBL_DOWNLOAD" contents:contents];
}

- (void)insertContents:(NSString *)strTableName contents:(Contents *)contents {
    NSString *strSql = @"";
    strSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (", strTableName];
    strSql = [strSql stringByAppendingString:@"MAJOR, "];
    strSql = [strSql stringByAppendingString:@"MINOR)"];
    strSql = [strSql stringByAppendingString:@"VALUES ("];
    strSql = [strSql stringByAppendingString:[NSString stringWithFormat:@"%d, ", contents.major]];
    strSql = [strSql stringByAppendingString:[NSString stringWithFormat:@"%d)", contents.minor]];
    LOG(@"insertContent:%@ = %@",strTableName, strSql);
    [dbManager update:strSql];
}

- (NSArray *)selectUploadContents {
    return  [self selectContents:@"TBL_UPLOAD"];
}
- (NSArray *)selectDownloadContents {
    return  [self selectContents:@"TBL_DOWNLOAD"];
}

- (NSArray *)selectContents:(NSString *)strTableName {
    NSString *strSql = @"";
    NSMutableArray *aryContents = [[NSMutableArray alloc] init];
    
    strSql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY MINOR ASC", strTableName];
    LOG(@"selectContents:%@ = %@",strTableName, strSql);
    FMResultSet *resultSet = [dbManager select:strSql];
    while ([resultSet next]){
        Contents *contents = [[Contents alloc] init];
        contents.major = [resultSet intForColumn:@"MAJOR"];
        contents.minor = [resultSet intForColumn:@"MINOR"];
        [aryContents addObject:contents];
    }
    return [[NSArray alloc] initWithArray:aryContents];
}
@end
