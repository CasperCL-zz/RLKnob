//
//  ViewController.m
//  NNRSnapSlide
//
//  Created by Casper Eekhof on 20-11-13.
//  Copyright (c) 2013 Redlake. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [slider setDelegate: self];
    [slider setRange: NSMakeRange(0, 360)];
}

-(void)rlKnobValueChanged:(CGFloat)newPercentage {
    [valueChangedLabel setText: [NSString stringWithFormat:@"%.f", newPercentage*100]];
}

-(void)rlKnobRotatingToValue:(CGFloat)newPercentage {
    [valueChangingLabel setText: [NSString stringWithFormat:@"%.f", newPercentage*100]];
}

- (IBAction)changeRangePressed:(id)sender {
    [slider setRange: NSMakeRange([fromTextfield.text intValue], [toTexfield.text intValue])];
    [self.view endEditing: YES];
}


#pragma UIView manipulations
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing: YES];
}

-(void) slideViewY:(CGFloat) newY {
    CGRect newFrame = embedView.frame;
    newFrame.origin.y = newY;
    [UIView animateWithDuration:.3f animations:^{
        embedView.frame = newFrame;
    }];
}

-(void) slideViewUp {
    [self slideViewY: embedView.frame.origin.y - 200];
}

-(void) slideViewDown {
    [self slideViewY: embedView.frame.origin.y + 200];
}

#pragma UITextFieldDelegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(![fromTextfield isFirstResponder] ^ ![toTexfield isFirstResponder])
        [self slideViewUp];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(![fromTextfield isFirstResponder] && ![toTexfield isFirstResponder])
        [self slideViewDown];
}

@end
