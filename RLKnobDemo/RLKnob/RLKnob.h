//
//  RLKnob.h
//  RLKnob
//
//  Created by Casper Eekhof on 20-11-13.
//  Copyright (c) 2013 Redlake. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RLKnob;
/** Delegate for handling events occuring a RLKnob **/
@protocol RLKnobDelegate <NSObject>

@optional
// Called to the delegate when the user releases the knob after changing it
-(void)rlKnobValueChanged: (CGFloat) newPercentage;
// Called to the delegate when the value of the knob changes as the user moves
-(void)rlKnobRotatingToValue: (CGFloat) newPercentage;

@end

/** The RLKnob is a subclass of UIView. It allows the user to submit a value to 
 the application by rotating a knob. A range can be set on the RLKnob to prevent
 a user to rotate the whole Knob **/
@interface RLKnob : UIView

// Delegate for callback methods
@property id<RLKnobDelegate> delegate;
// The range the user may turn the knob
@property (nonatomic) NSRange range;

// Convert radians to degrees
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
// Convert degrees to radian
#define DEGREES(radian) ((radian * 180) / M_PI)

@end
