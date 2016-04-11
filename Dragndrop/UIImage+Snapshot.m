//
//  UIImage+Snapshot.m
//  Dragndrop
//
//  Created by Oskars Liukis on 4/7/15.
//  Copyright (c) 2015 OL. All rights reserved.
//

#import "UIImage+Snapshot.h"

@implementation UIImage (Snapshot)

+ (UIImage *)imageFromView:(UIView *)view
{
    CGSize size = view.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
