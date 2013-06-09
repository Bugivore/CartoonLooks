//
//  clsGlobalHelper.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 iPhone 3G - 480 320
 iPhone 4/s - 960 640
 iPad 2 - 1024×768
 iPad 3 - 2048×1536
 
 */

#import <Foundation/Foundation.h>

@interface clsGlobalHelper : NSObject
{
    
}
+(UIImage *)resizeImage:(UIImage*)inImage :(int)iInMaxDim:(float*)fOutScale;
+(void) SaveImageToRoll:(UIImage*)inImage:(NSString*) fileName;
+(int) Min_Max:(long*) hist: (long *)imin: (long *)imax;
+(long) round: (double) x;
+(int) Hist_Eq:(short *)img_data:  (long) width: (long) height;
+ (UIImage *)imageRotatedByRadians:(UIImage*)img:(CGFloat)radians:(CGPoint)inCenter ;
+(CGPoint) TranslatePointByRadians:(CGPoint)inPoint:(double)fRotAngle:(CGPoint)inCenter;
//+ (UIImage *)resizeImageAvg:(UIImage*)inImage :(int)iInMaxDim:(float*)fOutScale;
+(UIImage*)rotateToOrientUp:(UIImage*)inImage:(UIImageOrientation)orient;
+ (NSMutableURLRequest *) multipartRequestWithURL:(NSURL *)url andDataDictionary:(NSDictionary *) dictionary;
+(UIView*)GetGradientLabel:(NSString*)str:(CGRect)rct:(float)fntSize;
@end
