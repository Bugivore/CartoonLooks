//
//  clsSelectLayer.h
//  MessMyLooks
//
//  Created by Vishalsinh Jhala on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clsSelectLayer : UIView<UIPickerViewDelegate>
{
    UIPickerView *layerPickerView;
    UIPickerView *flagPickerView;
    NSArray  *countryNames;

}
-(void)Create:(BOOL)bFlag;

@end
