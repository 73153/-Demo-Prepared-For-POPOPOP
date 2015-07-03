//
//  UIImage+Helpers.h
//  OMDBProject
//
//  Created by Jose Alvarado on 3/19/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helpers)

+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback;

@end
