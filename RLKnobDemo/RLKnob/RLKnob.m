//
//  RLKnob.m
//  RLKnob
//
//  Created by Casper Eekhof on 20-11-13.
//  Copyright (c) 2013 Redlake. All rights reserved.
//

#import "RLKnob.h"

@interface RLKnob () {
    // The knob
    UIImageView * knob;
    // The shadow of the knob
    UIImageView * knobShadow;
    // The current degree
    CGFloat degree;
}

@end

@implementation RLKnob

// Called by xib and storyboard files. Auto inits the RLKnob.
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

// Called code. Auto inits the RLKnob.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

// Setup the RLKnob; load images and set frames.
-(void)setup {
    knob = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"knob"]];
    CGRect newFrame = knob.frame;
    newFrame.size = self.frame.size;
    knob.frame = newFrame;
    
    // Add shadow
    knobShadow = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"knob_shadow"]];
    newFrame = knobShadow.frame;
    newFrame.size = self.frame.size;
    newFrame.size.height += self.frame.size.height*.17;
    newFrame.size.width += self.frame.size.width*.15;
    knobShadow.frame = newFrame;

    
    
    [self setBackgroundColor: [UIColor clearColor]];
    [self addSubview: knob];
    [self addSubview: knobShadow];
    _range = NSMakeRange(0, 360);
}

#pragma Touches methods
// Act on the user movement, call any delegate methods if delegate is present
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [self pointToCoordinateSystemPoint:[touch locationInView: self ] inSuperFrame:self.frame];
    CGFloat cornerRadius = 0.0f;
    
    
    if((location.y > 0 && location.x > 0)) // Upper half
        cornerRadius = atan(location.x/location.y);
    else if((location.y < 0 && location.x > 0) || (location.y < 0 && location.x < 0)) // Lowerhalf
        cornerRadius = atan(location.x/location.y) + RADIANS(180);
    else if (location.y > 0 && location.x < 0) {
        cornerRadius = RADIANS(360) + atan(location.x/location.y);
    }
    
    CGFloat cornerDegrees = DEGREES(cornerRadius);
    if(_range.location > _range.length) {
        if((cornerDegrees < 360 && cornerDegrees > _range.location) || (cornerDegrees > 0 && cornerDegrees < _range.length)) {
            [self rotateToRadius: cornerRadius];
        }
    } else if((cornerDegrees >= _range.location && cornerDegrees <= _range.length)){
        [self rotateToRadius: cornerRadius];
    }
    
}

// Call the delegate method as soon as the touch stopped
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(_delegate && [_delegate conformsToProtocol: @protocol(RLKnobDelegate)] && [_delegate respondsToSelector: @selector(rlKnobValueChanged:)]) {
        [_delegate rlKnobValueChanged: [self degreesOnRange:DEGREES(degree)]];
    }
}

#pragma Animation methods
// Animate the RLKnob to a new radius
-(void)rotateToRadius:(CGFloat) radius {
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, radius);
    knob.transform = leftWobble;
    
    [UIView beginAnimations:@"RLKnob_Rotation_Animation" context:(__bridge void *)(knob)];
    [UIView setAnimationRepeatCount:0];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    [UIView commitAnimations];
    degree = radius;
    
    if(_delegate && [_delegate conformsToProtocol: @protocol(RLKnobDelegate)] && [_delegate respondsToSelector: @selector(rlKnobRotatingToValue:)]) {
        [_delegate rlKnobRotatingToValue: [self degreesOnRange:DEGREES(degree)]];
    }
}

#pragma Overide methods
// Set the range and  move it the the start position
-(void)setRange:(NSRange)range {
    _range = range;
    [self rotateToRadius: RADIANS(_range.location)];
}

// Resize the knob image when the size of the superframe changes, making the RLKnob dynamic
-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect newFrame = knob.frame;
    newFrame.size = self.frame.size;
    knob.frame = newFrame;
    
    newFrame = knobShadow.frame;
    newFrame.size = self.frame.size;
    newFrame.size.height += self.frame.size.height*.17;
    newFrame.size.width += self.frame.size.width*.15;
    knobShadow.frame = newFrame;
}

#pragma RLKnobHelper methods
// Get the percentage the knob is rotated towards
-(CGFloat)degreesOnRange:(CGFloat) degrees {
    if(_range.location < _range.length)
        return (degrees - _range.location) / [self getTotalRange:_range];
    else
        if(degrees <= 360 && degrees > _range.location)
            return  (degrees - _range.location)/ [self getTotalRange:_range];
        else
            return (360 - _range.location + degrees)/ [self getTotalRange:_range];
    return 0.f;
}

// Get the total degrees a user can rotate the RLKnob
-(CGFloat)getTotalRange: (NSRange) range {
    return range.location > range.length ?
    ((360 - range.location) + range.length) :
    (range.length - range.location);
}

// Convert a normal point to a Coordinate System point
-(CGPoint)pointToCoordinateSystemPoint:(CGPoint)point inSuperFrame:(CGRect)superframe {
    const CGFloat frameHeight = superframe.size.height/2;
    const CGFloat frameWidth = superframe.size.height/2;
    point.y = (point.y < frameHeight) ? frameHeight - point.y : -(point.y - frameHeight);
    point.x = (point.x < frameWidth) ? (point.x - frameWidth) : -(frameWidth - point.x);
    return point;
}

@end