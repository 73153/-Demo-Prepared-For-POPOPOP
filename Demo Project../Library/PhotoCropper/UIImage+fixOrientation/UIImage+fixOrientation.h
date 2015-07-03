//
//  UIImage+fixOrientation.h
//  Numbers
//
//  Created by Optiplex790 on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

-(UIImage *) fixOrientation;

+(UIImage *) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+(UIImage *) memoryOptimizedImageWithImage:(UIImage *)image;

+(UIImage*) imageByScalingToSize:(CGSize)targetSize image:(UIImage *)image;
@end
