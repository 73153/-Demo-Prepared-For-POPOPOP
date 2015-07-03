//
//  PlistUtils.h
//  youyouapp
//
//  Created by Yi Xu on 12-12-3.
//  Copyright (c) 2012年 CuiYiLong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistUtils : NSObject

//根据Plist的名字获得Plist的存放路径(info.plist)
+(NSString *) getPlistFilePathByName:(NSString *) plistFileName;

//根据Plist的名字和Dictionary数据创建Plist文件
+(void) createPlistFileByName:(NSString *) plistName withDictionary:(NSMutableDictionary *) dictionary;

//根据Plist的名字和Array数据创建Plist文件
+(void) createPlistFileByName:(NSString *) plistName withArray:(NSMutableArray *) array;

//根据Plist的名字获得Dictionary的数据
+(NSMutableDictionary *)getDictionaryFromPlistFileByName:(NSString *) plistName;

//根据Plist的名字获得Array的数据
+(NSMutableArray *)getArrayFromPlistFileByName:(NSString *) plistName;

//Returns a NSMutableDictionary that |plistFile| contains
+(NSMutableArray*) getPlistData:(NSString*)plistFile;

//Save |dictionary| to the |plistFile|
+(NSString*) saveDictionaryToPlist: (NSMutableDictionary*) dictionary in:(NSString*)plistFile;

//Save |array| to the |plistFile|
+(NSString*) saveArrayToPlist: (NSMutableArray*) array in:(NSString*)plistFile;

+ (id) getPlistWithName:(NSString *)plistName;

+ (void)writePlistWithFilename:(NSString *)fileName
                           Key:(NSString *)key
                         Value:(NSString *)value;

+ (NSString *)getPlistValueWithFilename:(NSString *)fileName
                                    Key:(NSString *)key;
/**
 * Save to local plist
 * sample: [CallPlist getPlistWithName:@"test" data:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
 */
+ (void) saveToPlist:(NSString *)plistName data:(id)data;

/**
 * Clear local plist file
 * sample: [CallPlist clearPlist:@"test"];
 */
+ (void) clearPlist:(NSString *)plistName;

/**
 * Get local file path
 */
+ (NSString *) fileLocation:(NSString *)name;
@end
