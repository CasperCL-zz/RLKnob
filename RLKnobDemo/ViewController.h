//
//  ViewController.h
//  RLKnobDemo
//
//  Created by Casper Eekhof on 23-11-13.
//  Copyright (c) 2013 Redlake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLKnob.h"

@interface ViewController : UIViewController <RLKnobDelegate, UITextFieldDelegate> {
    
    __weak IBOutlet RLKnob *slider;
    
    __weak IBOutlet UIView *embedView;
    
    __weak IBOutlet UITextField *fromTextfield;
    __weak IBOutlet UITextField *toTexfield;
    
    __weak IBOutlet UILabel *valueChangedLabel;
    __weak IBOutlet UILabel *valueChangingLabel;
}


@end
