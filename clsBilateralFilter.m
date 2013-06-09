//
//  clsBilateralFilter.m
//  CartoonLooks
//
//  Created by Vishalsinh Jhala on 1/3/13.
//  Copyright (c) 2013 CartoonLooks.com. All rights reserved.
//

#import "clsBilateralFilter.h"

@implementation clsBilateralFilter

-(int**) allocInt:(int) i:( int) j
{

    int Nr = i; int Nc = j;
    int **p = malloc(Nr*sizeof(int*));
    for(int i = 0; i < Nr; i++)
        p[i] = malloc(Nc*sizeof(int));
    return p;
}
-(float**) allocFloat:(int) i:( int) j
{
    
    int Nr = i; int Nc = j;
    float **p = malloc(Nr*sizeof(float*));
    for(int i = 0; i < Nr; i++)
        p[i] = malloc(Nc*sizeof(float));
    return p;
}
/*-(void)logAllFilters {
    NSArray *properties = [CIFilter filterNamesInCategory:
                           kCICategoryBuiltIn];
    NSLog(@"%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}*/
-(void)BFilterMain:(imatrix*)imgR:(imatrix*)imgG:(imatrix*)imgB:(int) iFilterSize: (float) fSigmaDist: (float) fSigmaColor:(int) iNR:(int) iNC
{
	//[self logAllFilters];
    //int **ppfConvLum,**ppfConvA,**ppfConvB;
    imatrix *imgRTemp = [imatrix new];
	[imgRTemp initVal:iNR: iNC];
    imatrix *imgGTemp = [imatrix new];
	[imgGTemp initVal:iNR: iNC];
    imatrix *imgBTemp = [imatrix new];
	[imgBTemp initVal:iNR: iNC];
    
    float **ppfFilter = NULL,**ppfFilterProduct = NULL;
	
	//ppfConvLum = [self allocInt:iNR:iNC];
	//ppfConvA   = [self allocInt:iNR:iNC];
	//ppfConvB   = [self allocInt:iNR:iNC];
	
	ppfFilter        = [self allocFloat:iFilterSize:iFilterSize];
	ppfFilterProduct = [self allocFloat:iFilterSize:iFilterSize];
    
	[self CreateGaussFilter:iFilterSize:ppfFilter:fSigmaDist];
    
	fSigmaColor *=100;
    
	for(int loop=0;loop<5;loop++)
	{
		[self Convolution:imgR:imgG:imgB: imgRTemp:imgGTemp:imgBTemp:ppfFilter: ppfFilterProduct:iFilterSize: fSigmaDist: fSigmaColor:iNR:iNC];
        
		[imgR copy:imgRTemp];
		[imgG copy:imgGTemp];
		[imgB copy:imgBTemp];
        /*for(int i=0;i<iNR;i++)
		{
			for(int j=0;j<iNC;j++)
			{
				iCIEL->data[i][j] = ppfConvLum[i][j];
				iCIEA->data[i][j] = ppfConvA[i][j];
				iCIEB->data[i][j] = ppfConvB[i][j];
			}
		}*/
	}
    
	//Memory Cleaning
	free(ppfFilter[0]); free(ppfFilter);
	free(ppfFilterProduct[0]); free(ppfFilterProduct);
	imgRTemp = imgGTemp = imgBTemp = NULL;
    //free(imgRTemp[0]); free(imgRTemp);
	//free(imgGTemp[0]); free(imgGTemp);
	//free(imgBTemp[0]); free(imgBTemp);
    
}
-(void)CreateGaussFilter:(int) iFilterSize:(float**)ppfFilter:(float) fSigmaDist
{
	int iCenter = (int)((float)iFilterSize/2);
    
	for(int i=0;i<iFilterSize;i++)
		for(int j=0;j<iFilterSize;j++)
			ppfFilter[i][j] = [self Gauss:i-iCenter:j-iCenter:fSigmaDist];
}
-(float) Gauss:(int) y: (int) x: (float) fSigmaDist
{
	float fNorm = (float)( (double)(x*x+y*y)/(2*fSigmaDist*fSigmaDist)  );
	
	return exp(-fNorm);
}
-(void) Convolution:(imatrix*)imgR:(imatrix*)imgG:(imatrix*)imgB:(imatrix*)imgRTemp:(imatrix*)imgGTemp:(imatrix*)imgBTemp:(float **)ppfFilter:(float **)ppfFilterProduct:(int) iFilterSize: (float) fSigmaDist: (float) fSigmaColor:(int) iNR:(int) iNC
{
	int iCenter = (float)iFilterSize/2;
	int m,n;
	int lum,a,b;
	float fTot,sumLum,sumA,sumB;
	for(int i=0;i<iNR;i++)
	{
		for(int j=0;j<iNC;j++)
		{
			fTot = 0;sumLum=sumA=sumB=0;
			for(int k=-iCenter;k<=iCenter;k++)
			{
				for(int l=-iCenter;l<=iCenter;l++)
				{
					m = i+k;
					n = j+l;
					if(m<0 || m>=iNR) continue;
					if(n<0 || n>=iNC) continue;
					lum = imgR.p[m][n] - imgR.p[i][j];
					a = imgG.p[m][n] - imgG.p[i][j];
					b = imgB.p[m][n] - imgB.p[i][j];
                    
					ppfFilterProduct[k+iCenter][l+iCenter] = exp(  -(lum*lum + a*a + b*b)/(2*fSigmaColor*fSigmaColor)  );
					ppfFilterProduct[k+iCenter][l+iCenter]*=ppfFilter[k+iCenter][l+iCenter];
					fTot += ppfFilterProduct[k+iCenter][l+iCenter];
				}
			}
			fTot = 1/fTot;
            
			for(int k=-iCenter;k<=iCenter;k++)
			{
				for(int l=-iCenter;l<=iCenter;l++)
				{
					m = i+k;
					n = j+l;
					if(m<0 || m>=iNR) continue;
					if(n<0 || n>=iNC) continue;
					sumLum += imgR.p[m][n]*ppfFilterProduct[k+iCenter][l+iCenter]*fTot;
					sumA += imgG.p[m][n]*ppfFilterProduct[k+iCenter][l+iCenter]*fTot;
					sumB += imgB.p[m][n]*ppfFilterProduct[k+iCenter][l+iCenter]*fTot;
				}
			}
			imgRTemp.p[i][j] = sumLum;
			imgGTemp.p[i][j] = sumA;
			imgBTemp.p[i][j] = sumB;
		}
	}
    
}
@end
