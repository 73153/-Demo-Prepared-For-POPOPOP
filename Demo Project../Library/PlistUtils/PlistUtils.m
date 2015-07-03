//
//  PlistUtils.m
//  youyouapp
//
//  Created by Yi Xu on 12-12-3.
//  Copyright (c) 2012年 CuiYiLong. All rights reserved.
//

#import "PlistUtils.h"

@implementation PlistUtils

+(NSString *) getPlistFilePathByName:(NSString *) plistName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:plistName];
    return plistPath;
}

+(void) createPlistFileByName:(NSString *) plistName withDictionary:(NSMutableDictionary *) dictionary{

    NSString *plistPath = [self getPlistFilePathByName:plistName];
    [dictionary writeToFile:plistPath atomically:YES];

}

+(void) createPlistFileByName:(NSString *) plistName withArray:(NSMutableArray *) array{
    
    NSString *plistPath = [self getPlistFilePathByName:plistName];
    [array writeToFile:plistPath atomically:YES];

}

+(NSMutableDictionary *)getDictionaryFromPlistFileByName:(NSString *) plistName{
    NSString *plistPath = [self getPlistFilePathByName:plistName];
    NSMutableDictionary *plistDictionary= [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    return plistDictionary;
}

+(NSMutableArray *)getArrayFromPlistFileByName:(NSString *) plistName{
    NSString *plistPath = [self getPlistFilePathByName:plistName];
    NSMutableArray *plistArray= [[[NSMutableArray alloc]initWithContentsOfFile:plistPath]mutableCopy];
    return plistArray;
}


+ (id) getPlistWithName:(NSString *)plistName{
    NSArray *myArray = [NSArray arrayWithContentsOfFile:[self fileLocation:plistName]];
    if(myArray != nil){
        return myArray;
    }else{
        myArray = nil;
        NSDictionary *myDictionary = [NSDictionary dictionaryWithContentsOfFile:[self fileLocation:plistName]];
        return myDictionary;
    }
}

+ (void) saveToPlist:(NSString *)plistName data:(id)data{
    [data writeToFile:[self fileLocation:plistName] atomically:YES];
}


+ (void) clearPlist:(NSString *)plistName{
    NSArray *myArray = [[NSArray alloc] init];
    [myArray writeToFile:[self fileLocation:plistName] atomically:YES];
}

+ (NSString *) fileLocation:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
}

+(NSString*) getRealPathPlist: (NSString*) plistFile
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent:plistFile];
}

+(NSMutableArray*) getPlistData:(NSString*)plistFile
{
    return [[NSMutableArray alloc] initWithContentsOfFile: [self getRealPathPlist:plistFile]];
}

+(NSString*) saveDictionaryToPlist: (NSMutableDictionary*) dictionary in:(NSString*)plistFile
{
    NSString* error;
    NSString* pathPList = [self getRealPathPlist:plistFile];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList: dictionary
                                                                   format:NSPropertyListXMLFormat_v1_0  errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:pathPList atomically:YES];
    }
    else {
        NSLog(@"Error : %@",error);
        return error;
    }
    
    return nil;
}

+(NSString*) saveArrayToPlist: (NSMutableArray*) array in:(NSString*)plistFile
{
    NSString* error;
    NSString* pathPList = [self getRealPathPlist:plistFile];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList: array
                                                                   format:NSPropertyListXMLFormat_v1_0  errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:pathPList atomically:YES];
    }
    else {
        NSLog(@"Error : %@",error);
        return error;
    }
    
    return nil;
}

+ (NSString *)domainPath
{
    //初始化路徑
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains
                          (NSDocumentDirectory,NSUserDomainMask, YES)
                          objectAtIndex:0];
    return rootPath;
}

+ (NSString *)plistPath:(NSString *)fileName
{
    NSString *domainPath = [self domainPath];
    NSString *plistPathWithExtension = [NSString stringWithFormat:@"%@.plist", fileName];
    
    NSString *plistPath = [domainPath stringByAppendingPathComponent:plistPathWithExtension];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSString *projectPlistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        
        NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:projectPlistPath];
        //將 Dictionary 儲存至指定的檔案
        [plistDictionary writeToFile:plistPath atomically:YES];
    }
    
    return plistPath;
}

+ (void)writePlistWithFilename:(NSString *)fileName
                           Key:(NSString *)key
                         Value:(NSString *)value
{
    NSString *plistPath = [self plistPath:fileName];
    
    //建立一個 Dictionary
    NSMutableDictionary *plistDictionary;
    
    //將取得的 plist 內容載入至剛才建立的 Dictionary 中
    plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    //接荖我們來試著修改其內容
    [plistDictionary setObject:[NSString stringWithFormat:@"%@", value] forKey:key];
    
    //將 Dictionary 儲存至指定的檔案
    [plistDictionary writeToFile:plistPath atomically:YES];
    
}

+ (NSString *)getPlistValueWithFilename:(NSString *)fileName
                                    Key:(NSString *)key
{
    NSString *plistPath = [self plistPath:fileName];
    
    //建立一個 Dictionary
    NSMutableDictionary *plistDictionary;
    
    //將取得的 plist 內容載入至剛才建立的 Dictionary 中
    plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    return [plistDictionary objectForKey:key];
    
}
@end
