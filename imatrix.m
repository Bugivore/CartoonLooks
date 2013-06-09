//
//  imatrix.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "imatrix.h"

@implementation imatrix
@synthesize Nr;
@synthesize Nc;
@synthesize p;

-(void) delete_all
{
    if (!p) {
        return;
    }
    for (int i = 0; i < Nr; i++)
        free( p[i]);
    free(p);
}
-(void) initVal:(int) i:( int) j 
{
    [self delete_all ];
    Nr = i, Nc = j;
    p = malloc(Nr*sizeof(int*));
    for(int i = 0; i < Nr; i++)
        p[i] = malloc(Nc*sizeof(int));

}

-(void)dealloc {
    [self delete_all];
}

-(int) get:( int) i: (int) j   
{ 
    return p[i][j]; 
}
-(int) getRow
{ 
    return Nr; 
}
-(int) getCol
{ 
    return Nc; 
}

-(void) zero
{
    for (int i = 0; i < Nr; i++) 
        for (int j = 0; j < Nc; j++) 
            p[i][j] = 0;
}
-(void) copy:(imatrix*) b
{
    [self initVal:b.Nr: b.Nc];
    for (int i = 0; i < Nr; i++) 
        for (int j = 0; j < Nc; j++) 
            p[i][j] = b.p[i][j];
}

@end
