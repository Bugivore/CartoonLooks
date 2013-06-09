//
//  Created by Vishalsinh Jhala on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imatrix : NSObject
{
	//int Nr, Nc;
	
}
-(void) delete_all;
//-(void)imatrix:(int) i:( int) j; 
//-(void)imatrix:(imatrix*) b;
-(void) initVal:(int) i:( int) j ;
-(void)dealloc;
-(int) get:( int) i: (int) j;   
-(int) getRow;
-(int) getCol;
-(void) zero;
-(void) copy:(imatrix*) b;

@property int Nr;
@property int Nc;
@property  int** p; 

@end