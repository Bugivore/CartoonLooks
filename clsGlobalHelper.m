//
//  clsGlobalHelper.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsGlobalHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation clsGlobalHelper

+ (UIImage *)resizeImage:(UIImage*)inImage :(int)iInMaxDim:(float*)fOutScale {
    
    /*CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    */
    int iBig;
    if(inImage.size.width>inImage.size.height)
        iBig = inImage.size.width;
    else
        iBig = inImage.size.height;
    float fScale ;
    if(iInMaxDim>0)
        fScale= (float)iInMaxDim/iBig;
    else {
        fScale = *fOutScale;
    }
    //if(inImage.size.width<=1024 && inImage.size.height<=1024)
        //fScale =1.0;
    
    CGSize szNew = CGSizeMake(inImage.size.width*fScale, inImage.size.height*fScale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, szNew.width,szNew.height));
    CGImageRef imageRef = inImage.CGImage;
    
    /*UIGraphicsBeginImageContext( newSize );
    [image drawInRect:newRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    UIGraphicsBeginImageContextWithOptions(szNew, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescalingsz
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);

    CGContextTranslateCTM(context, 0, szNew.height);
    CGContextScaleCTM(context, 1.0f,-1.0f);  
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);

    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();    
    
    *fOutScale = fScale;
    return newImage;
}
+(void) SaveImageToRoll:(UIImage*)inImage:(NSString*) fileName
{
    NSError *error = nil;
    NSString *filePath2 = [NSString stringWithFormat:@"/Users/vishalsinhjhala/Library/Application Support/iPhone Simulator/5.1/Media/DCIM/100APPLE/%@.jpg",  fileName];
    NSData* imageData = UIImageJPEGRepresentation(inImage, 1.0);
    [imageData writeToFile:filePath2 options:NSDataWritingAtomic error:&error];
    
    //if(error)
        //NSLog(@"Write returned error: %@", [error localizedDescription]);

    error = NULL;
    filePath2 = NULL;
    imageData = NULL;
}
+(int) Min_Max:(long*) hist: (long *)imin: (long *)imax
{
	short i;
	// for min, first number which is bigger than 0 is imin
	i=0;
	while( (i<256) && (hist[i] == 0) ) 
		i++;
	*imin = i;
	// same as above for max
	i=255;
	while( (i>=0) && (hist[i] == 0) ) 
		i--;
	*imax = i;	
    
	return 0;
}
+(long) round: (double) x
{
    long q;
    double temp;
    
    temp = (int)x;
    temp = x - temp;
    if( temp<0.5){
        q = (int)x;
    }
    
    else {
        q = (int)x + 1;
    }
    
    return q;
}
+(int) Hist_Eq:(short *)img_data: (long) width: (long) height
{
    
	double s_hist_eq[256]={0.0}, sum_of_hist[256]={0.0};
	long i, j, k, n, imin, imax;
    long hist[256]={0};
    
	for(i=0;i<256;i++)
	{
		hist[i] = 0;
	}
    int iStep;
	for(i=0;i<height;i++)
	{
		iStep = i*width;
        for(j=0;j<width;j++)
		{
			hist[img_data[iStep+j]]++;
		}
	}
	[self Min_Max:hist: &imin: &imax];
	n = width * height;
    
	for (i=0;i<256;i++)  // pdf of image
	{
		s_hist_eq[i] = (double)hist[i]/(double)n;
	}
	sum_of_hist[0] = s_hist_eq[0];
	for (i=1;i<256;i++)	 // cdf of image
	{
		sum_of_hist[i] = sum_of_hist[i-1] + s_hist_eq[i];
	}
    
	for(i=0;i<height;i++)
	{
		iStep = i*width;
        for(j=0;j<width;j++)
		{
			k = img_data[iStep+j];
			img_data[iStep+j] = (unsigned char)round( sum_of_hist[k] * 255.0 );
		}
	}
    
	return 0;
}
+(CGPoint) TranslatePointByRadians:(CGPoint)inPoint:(double)fRotAngle:(CGPoint)inCenter
{
    //Apple formula
    int iNewX = (inPoint.x)*cos(fRotAngle) - (inPoint.y)*sin(fRotAngle);//+inCenter.x;
    
    int iNewY = (inPoint.x)*sin(fRotAngle) + (inPoint.y)*cos(fRotAngle);//-inCenter.y;
    
    //Desi formula
/*    int iDist = sqrt((double)(inCenter.x-inPoint.x)*(inCenter.x-inPoint.x) + (inCenter.y-inPoint.y)*(inCenter.y-inPoint.y));
    int iNewX = iDist*cos(fRotAngle);
    
    int iNewY = iDist*sin(fRotAngle);*/
    
    return CGPointMake(iNewX,iNewY);
}
+ (UIImage *)imageRotatedByRadians:(UIImage*)img:(CGFloat)radians:(CGPoint)inCenter 
{   
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,img.size.width, img.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    //CGSize rotatedSize = CGSizeMake(img.size.width,img.size.height);
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
       // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-img.size.width / 2, -img.size.height / 2, img.size.width, img.size.height), [img CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //rotatedViewBox = NULL;
    return newImage;
    
}
/*+ (UIImage *)resizeImageAvg:(UIImage*)inImage :(int)iInMaxDim:(float*)fOutScale
{
    float fSkewRatio = (float)inImage.size.width/(float)iInMaxDim;
    *fOutScale = 1.0/fSkewRatio;
 
    CGImageRef cgImage = inImage.CGImage;
    int m_iH = iInMaxDim;
    int m_iW = iInMaxDim;
    UInt8 *buffer = calloc( m_iW * m_iH * 4,sizeof(UInt8));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate(buffer, m_iW, m_iH, 8, m_iW * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetBlendMode(cgContext, kCGBlendModeCopy);
    CGContextDrawImage(cgContext, CGRectMake(0.0f, 0.0f, m_iW, m_iH), cgImage);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(cgContext);
    UIImage* img = [UIImage imageWithCGImage:imgRef];

    CGImageRelease(imgRef);
    
    free(buffer);
    CGContextRelease(cgContext);
    CGColorSpaceRelease(colorSpace);
    
    return img;
    
}*/
/*
+ (UIImage *)resizeImageAvg:(UIImage*)inImage :(int)iInMaxDim:(float*)fOutScale
{
    float fSkewRatio = (float)inImage.size.width/(float)iInMaxDim;
    *fOutScale = 1.0/fSkewRatio;
 
    int iDiameter = floor(fSkewRatio+0.5);
    int iHalfL,iHalfR;
    if(iDiameter%2==0)
        { iHalfL = iDiameter/2.0;iHalfR = iDiameter/2.0 - 1;}
    else
        {iHalfL = iHalfR = (iDiameter-1)/2.0;}
 
    UInt8**piData = [self UIImage2GrayInt:inImage];
 
    UInt8*piOutData = calloc(iInMaxDim *iInMaxDim*4,sizeof(UInt8));
    //[self initVal:iInMaxDim :iInMaxDim];

    int iStep,jStep;
    int m_iH = iInMaxDim;
    int m_iW = iInMaxDim;
	int srcW = inImage.size.width;
	int srcH = inImage.size.height;
    
    int iTot;
    int iAdds;
    int inX,inY;
    for (int i = 0; i < m_iH; i++) 
    {
		iStep = i*m_iW*4;
		//iStepGrey = i*m_iW;
        for (int j = 0; j < m_iW; j++) 
        {
            jStep = j*4;
            iTot = iAdds = 0;
            inX = j*fSkewRatio;
            inY = i*fSkewRatio;
            
            if(iHalfL==0 && iHalfR==0)
            {
               piOutData[iStep+jStep] = piOutData[iStep+jStep+1] = piOutData[iStep+jStep+2] = piData[inY][inX]; 
            }
            else {
                
                for (int k=inY-iHalfL; k<inY+iHalfR; k++) {
                    if(k<0 || k>=srcH)
                        continue;
                    for (int l=inX-iHalfL; l<inX+iHalfR; l++) {
                        if(l<0 || l>=srcW)
                            continue;
                        iTot +=piData[k][l];
                        iAdds++;
                    }
                }
                piOutData[iStep+jStep] = piOutData[iStep+jStep+1] = piOutData[iStep+jStep+2] = (float)iTot/iAdds;
            }
        }
    }
    CGContextRef ctx = CGBitmapContextCreate(piOutData,  
											 m_iW,  
											 m_iH,  
											 CGImageGetBitsPerComponent(inImage.CGImage),
											 m_iW*4,  
											 CGImageGetColorSpace(inImage.CGImage),  
											 CGImageGetBitmapInfo(inImage.CGImage) 
											 ); 
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);

    free(piOutData);
    
    for (int i = 0; i < m_iH; i++)
        free(piData[i]);
    free(piData);

    return finalImage;
    
}
+ (UInt8**) UIImage2GrayInt:(UIImage*)inImage
{
    CGImageRef cgImage = inImage.CGImage;
	//CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
	//const UInt8 *m_PixelBuf = CFDataGetBytePtr(m_DataRef);
    int m_iH = CGImageGetHeight(cgImage);
    int m_iW = CGImageGetWidth(cgImage);
    
    UInt8*m_PixelBuf = calloc(m_iW*m_iH*4,sizeof(UInt8));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate(m_PixelBuf, m_iW, m_iH, 8, m_iW * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetBlendMode(cgContext, kCGBlendModeCopy);
    CGContextDrawImage(cgContext, CGRectMake(0.0f, 0.0f, m_iW, m_iH), cgImage);

    
    //UInt8**piData = [self initVal:m_iH:m_iW];
    //Convert GreyScale and copy data

    UInt8 **buffer;// = [self initValUInt:m_iH:m_iW];
    buffer = calloc(m_iH,sizeof(UInt8*));
    
    for(int i = 0; i < m_iH; i++)
        buffer[i] = calloc(m_iW,sizeof(UInt8));

    
    int iStep,jStep;
    
	
    for (int i = 0; i < m_iH; i++) 
    {
		iStep = i*m_iW*4;
		//iStepGrey = i*m_iW;
        for (int j = 0; j < m_iW; j++) 
        {
            jStep = j*4;
            buffer[i][j] =   ((double)m_PixelBuf[iStep + jStep] + (double)m_PixelBuf[iStep + jStep +1] + (double)m_PixelBuf[iStep + jStep +2])/3.0;
        }
    }
    CGContextRelease(cgContext);
    CGColorSpaceRelease(colorSpace);

    free(m_PixelBuf);

    return buffer;
}
+(UInt8**) initValUInt:(int) Nr:( int) Nc
{
    UInt8 ** p;
    p = calloc(Nr,sizeof(UInt8*));
    
    for(int i = 0; i < Nr; i++)
    {
        p[i] = calloc(Nc,sizeof(UInt8));
        
    }
    return p;
}

+(int**) initVal:(int) Nr:( int) Nc
{
    int ** p;
    p = calloc(Nr,sizeof(int*));

    for(int i = 0; i < Nr; i++)
    {
        p[i] = calloc(Nc,sizeof(int));

    }
    return p;
}*/
+(UIImage*)rotateToOrientUp:(UIImage*)inImage:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = inImage.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            // would get you an exact copy of the original
            //assert(false);
            return inImage;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);

            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);

            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);

            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);

            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);

            //m_fAngle = M_PI / 2.0;
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);

            break;
            
        default:
            // orientation value supplied is invalid

            assert(false);
            return nil;
    }

    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctxt, kCGInterpolationHigh);
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}
static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}
/** Creates a multipart HTTP POST request.
 *  @param url is the target URL for the POST request
 *  @param dictionary is a key/value dictionary with the DATA of the multipart post.
 *  
 *  Should be constructed like:
 *      NSArray *keys = [[NSArray alloc] initWithObjects:@"login", @"password", nil];
 *      NSArray *objects = [[NSArray alloc] initWithObjects:@"TheLoginName", @"ThePassword!", nil];    
 *      NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
 */
+ (NSMutableURLRequest *) multipartRequestWithURL:(NSURL *)url andDataDictionary:(NSDictionary *) dictionary
{
    // Create POST request
    NSMutableURLRequest *mutipartPostRequest = [NSMutableURLRequest requestWithURL:url];
    [mutipartPostRequest setHTTPMethod:@"POST"];
    
    // Add HTTP header info
    NSString *POSTBoundary = @"0xHttPbOuNdArY"; // You could calculate a better boundary here.
    [mutipartPostRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", POSTBoundary] forHTTPHeaderField:@"Content-Type"];
    
    // Add HTTP Body
    NSMutableData *POSTBody = [NSMutableData data];
    [POSTBody appendData:[[NSString stringWithFormat:@"--%@\r\n",POSTBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add Key/Values to the Body
    NSEnumerator *enumerator = [dictionary keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject])) {
        [POSTBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [POSTBody appendData:[[NSString stringWithFormat:@"%@", [dictionary objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (key != nil) {
            [POSTBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", POSTBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // Add the closing -- to the POST Form
    [POSTBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", POSTBoundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    // Add the body to the mutipartPostRequest & return
    [mutipartPostRequest setHTTPBody:POSTBody];
    return mutipartPostRequest;
}
+(UIView*)GetGradientLabel:(NSString*)str:(CGRect)rct:(float)fntSize
{
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Bold"  size:fntSize];
    UILabel* label = [[UILabel alloc] initWithFrame:rct ];
    label.textColor =[UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.shadowColor = [UIColor lightGrayColor ];
    label.shadowOffset = CGSizeMake(0,-1);
    //label.layer.cornerRadius = 5.0;
    label.textAlignment = UITextAlignmentCenter;
    
    UIView *vwHdr = [[UIView alloc] initWithFrame:label.frame];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    gradient.frame = label.bounds;
    [vwHdr.layer insertSublayer:gradient atIndex:0];
    label.text = str;
    [vwHdr addSubview:label];
    
    str = nil;font = nil;label = nil;
    return vwHdr;

}


@end
