//
//  UPLExerciseSummary.m
//  Wake
//
//  Created by Alex Ryan on 8/28/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "UPLExerciseSummary.h"
//static CGFloat const UPLKeyDefaultFontSize = 32.0f;
static CGFloat const UPLDefaultBarValue = 70.0;
static CGFloat const UPLBarWidth = 50.0;
static CGFloat const kBarGraphBottomY = 270.0;
#define UPLBarColor [UIColor whiteColor]


@interface UPLExerciseSummary ()

@property (strong, nonatomic) CAShapeLayer *barOneLayer;
@property (strong, nonatomic) CAShapeLayer *barTwoLayer;
@property (strong, nonatomic) CAShapeLayer *barThreeLayer;
@property (strong, nonatomic) UILabel *headerOneLabel;
@property (strong, nonatomic) UILabel *percentageOneLabel;
@property (strong, nonatomic) UILabel *headerTwoLabel;
@property (strong, nonatomic) UILabel *percentageTwoLabel;
@property (strong, nonatomic) UILabel *headerThreeLabel;
@property (strong, nonatomic) UILabel *percentageThreeLabel;

@property (nonatomic) CGPathRef preAnimationPathBar1;
@property (nonatomic) CGPathRef preAnimationPathBar2;
@property (nonatomic) CGPathRef preAnimationPathBar3;


@end


@implementation UPLExerciseSummary


- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSetup];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self initSetup];
    }
    
    return self;
}

- (void)initSetup
{
    //TODO:  Incorporate these properties
    _barColor = UPLBarColor;
    _textHeaderColor = UPLBarColor;
    _percentageColor = UPLBarColor;
    _headerTitles = [NSMutableArray arrayWithArray:@[@"Essential", @"Optional", @"Stretches"]];
    _barOneValue = 60;
    _barTwoValue = 80;
    _barThreeValue = 10;
    [self createBarsAndHeaders];
    
}

- (void)createBarsAndHeaders
{
    

    
    self.headerOneLabel = [[UILabel alloc] init];
    self.headerTwoLabel = [[UILabel alloc] init];
    self.headerThreeLabel = [[UILabel alloc] init];
    
    self.percentageOneLabel = [[UILabel alloc] init];
    self.percentageTwoLabel = [[UILabel alloc] init];
    self.percentageThreeLabel = [[UILabel alloc] init];
    
    //Frames
    CGRect headerFrame = CGRectMake(0, 0, 80, 40);
    CGRect percentageFrame = CGRectMake(0, 0, 90, 40);

    //First Header & Percentage Label
    self.headerOneLabel.frame = headerFrame;
    self.headerOneLabel.text = self.headerTitles[0];
    self.headerOneLabel.textColor = [UIColor whiteColor];
    self.headerOneLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.headerOneLabel.textAlignment = NSTextAlignmentCenter;
    self.headerOneLabel.center = CGPointMake(self.frame.size.width * 0.20, 30);
    
    self.percentageOneLabel.frame = percentageFrame;
    self.percentageOneLabel.text = @"0%";
    self.percentageOneLabel.textColor = [UIColor whiteColor];
    self.percentageOneLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    self.percentageOneLabel.textAlignment = NSTextAlignmentCenter;
    self.percentageOneLabel.center = CGPointMake(self.headerOneLabel.center.x, self.headerOneLabel.center.y + 30);
    
    //Second Header & Percentage Label
    self.headerTwoLabel.frame = headerFrame;
    self.headerTwoLabel.text = self.headerTitles[1];
    self.headerTwoLabel.textColor = [UIColor whiteColor];
    self.headerTwoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.headerTwoLabel.textAlignment = NSTextAlignmentCenter;
    self.headerTwoLabel.center = CGPointMake(self.frame.size.width * 0.50, 30);
    
    self.percentageTwoLabel.frame = percentageFrame;
    self.percentageTwoLabel.text = @"10%";
    self.percentageTwoLabel.textColor = [UIColor whiteColor];
    self.percentageTwoLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    self.percentageTwoLabel.textAlignment = NSTextAlignmentCenter;
    self.percentageTwoLabel.center = CGPointMake(self.headerTwoLabel.center.x, self.headerTwoLabel.center.y + 30);
    
    //Third Header & Percentage Label
    self.headerThreeLabel.frame = headerFrame;
    self.headerThreeLabel.text = self.headerTitles[2];
    self.headerThreeLabel.textColor = [UIColor whiteColor];
    self.headerThreeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.headerThreeLabel.textAlignment = NSTextAlignmentCenter;
    self.headerThreeLabel.center = CGPointMake(self.frame.size.width * 0.80, 30);
    
    self.percentageThreeLabel.frame = percentageFrame;
    self.percentageThreeLabel.text = @"0%";
    self.percentageThreeLabel.textColor = [UIColor whiteColor];
    self.percentageThreeLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    self.percentageThreeLabel.textAlignment = NSTextAlignmentCenter;
    self.percentageThreeLabel.center = CGPointMake(self.headerThreeLabel.center.x, self.headerThreeLabel.center.y + 30);

    
    //Add Headers and Percentages to the View
    [self addSubview:self.headerOneLabel];
    [self addSubview:self.headerTwoLabel];
    [self addSubview:self.headerThreeLabel];
    
    [self addSubview:self.percentageOneLabel];
    [self addSubview:self.percentageTwoLabel];
    [self addSubview:self.percentageThreeLabel];
    
    [self.layer addSublayer:self.barOneLayer];
    [self.layer addSublayer:self.barTwoLayer];
    [self.layer addSublayer:self.barThreeLayer];

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextMoveToPoint(context, (self.frame.size.width*0.5) - 20, self.frame.size.height - 40);
    CGContextAddLineToPoint(context, (self.frame.size.width*0.5), self.frame.size.height - 20);
    CGContextAddLineToPoint(context, (self.frame.size.width*0.5) + 20, self.frame.size.height - 40);
    
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 20, self.frame.size.height - 30);
    CGContextAddLineToPoint(context, self.frame.size.width*0.5 - 40, self.frame.size.height - 30);
    
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, self.frame.size.width*0.5 + 40, self.frame.size.height - 30);
    CGContextAddLineToPoint(context, self.frame.size.width - 20, self.frame.size.height - 30);
    
    CGContextStrokePath(context);
    
}


- (CAShapeLayer *)barOneLayer
{
    if (_barOneLayer == nil) {
        
        NSLog(@"Inside barOneLayer");
        
        _barOneLayer = [[CAShapeLayer alloc] init];
        _barOneLayer.lineWidth = 2.0f;
        _barOneLayer.fillColor = self.barColor.CGColor;
        _barOneLayer.strokeColor = self.barColor.CGColor;
        //_barOneLayer.anchorPoint = CGPointMake(0.5, 0.5);
        
        _barOneLayer.path = [self barOnePath].CGPath;

    }
    
    NSLog(@"Outside barOneLayer");
    
    return _barOneLayer;
}


- (CAShapeLayer *)barTwoLayer
{
    if (_barTwoLayer == nil) {
        
        _barTwoLayer = [[CAShapeLayer alloc] init];
        _barTwoLayer.lineWidth = 2.0f;
        _barTwoLayer.fillColor = self.barColor.CGColor;
        _barTwoLayer.strokeColor = self.barColor.CGColor;
        //_barTwoLayer.anchorPoint = CGPointMake(0.5, 1.0);
        
        _barTwoLayer.path = [self barTwoPath].CGPath;
        
    }
    
    return _barTwoLayer;
}


- (CAShapeLayer *)barThreeLayer
{
    if (_barThreeLayer == nil) {
        
        _barThreeLayer = [[CAShapeLayer alloc] init];
        _barThreeLayer.lineWidth = 2.0f;
        _barThreeLayer.fillColor = self.barColor.CGColor;
        _barThreeLayer.strokeColor = self.barColor.CGColor;
        //_barThreeLayer.anchorPoint = CGPointMake(1.0, 1.0);
        
        _barThreeLayer.path = [self barThreePath].CGPath;
        
    }
    
    return _barThreeLayer;
}


- (UIBezierPath *)barOnePath
{
    NSLog(@"Bar 1 Bezier Path");
    CGRect barRectangle = CGRectMake(self.headerOneLabel.center.x - UPLBarWidth/2.0, kBarGraphBottomY - self.barOneValue, UPLBarWidth, self.barOneValue);
    UIBezierPath *barPath = [UIBezierPath bezierPathWithRoundedRect:barRectangle byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
    
    return barPath;
}

- (UIBezierPath *)barTwoPath
{
    NSLog(@"Bar 2 Bezier Path");
    CGRect barRectangle = CGRectMake(self.headerTwoLabel.center.x - UPLBarWidth/2.0, kBarGraphBottomY - self.barTwoValue, UPLBarWidth, self.barTwoValue);
    UIBezierPath *bar2Path = [UIBezierPath bezierPathWithRoundedRect:barRectangle byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
    
    return bar2Path;
}

- (UIBezierPath *)barThreePath
{
    NSLog(@"Bar 3 Bezier Path");
    CGRect barRectangle = CGRectMake(self.headerThreeLabel.center.x - UPLBarWidth/2.0, kBarGraphBottomY - self.barThreeValue, UPLBarWidth, self.barThreeValue);
    UIBezierPath *bar3Path = [UIBezierPath bezierPathWithRoundedRect:barRectangle byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
    
    return bar3Path;
}



-(void)setBarOneValue:(CGFloat)barOneValue
{
    [self setBarOneValue:barOneValue animated:YES];
}

-(void)setBarTwoValue:(CGFloat)barTwoValue
{
    [self setBarOneValue:barTwoValue animated:YES];
}

-(void)setBarThreeValue:(CGFloat)barThreeValue
{
    [self setBarOneValue:barThreeValue animated:YES];
}

- (void)setBarOneValue:(CGFloat)value animated:(BOOL)animated
{
    value *= 1.7;

    if (value != _barOneValue) {
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(barOneValue))];
        self.preAnimationPathBar1 = self.barOneLayer.path;
        _barOneValue = value;
        NSLog(@"Just changed the barOneValue...");
        [self updateBar:1 withValue:value animated:YES];
        [self didChangeValueForKey:NSStringFromSelector(@selector(barOneValue))];
    }
}

- (void)setBarTwoValue:(CGFloat)value animated:(BOOL)animated
{
    value *= 1.7;
    
    if (value != _barTwoValue) {
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(barTwoValue))];
        self.preAnimationPathBar2 = self.barTwoLayer.path;
        _barTwoValue = value;
        NSLog(@"Just changed the barTwoValue...");
        [self updateBar:2 withValue:value animated:YES];
        [self didChangeValueForKey:NSStringFromSelector(@selector(barTwoValue))];
    }
}

- (void)setBarThreeValue:(CGFloat)value animated:(BOOL)animated
{
    value *= 1.7;
    
    if (value != _barThreeValue) {
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(barThreeValue))];
        self.preAnimationPathBar3 = self.barThreeLayer.path;
        _barThreeValue = value;
        NSLog(@"Just changed the barThreeValue...");
        [self updateBar:3 withValue:value animated:YES];
        [self didChangeValueForKey:NSStringFromSelector(@selector(barThreeValue))];
    }
}

-(void)updateBar:(NSInteger)barNum withValue:(CGFloat)percentage animated:(BOOL)animated
{
    
    switch (barNum) {
        case 1:
            if (animated) {
                NSLog(@"A");
                //self.barOneLayer.path = [self barOnePath].CGPath;
                CABasicAnimation *pathAnim = [[CABasicAnimation alloc] init];
                pathAnim.keyPath = @"path";
                pathAnim.duration = 0.5;
                pathAnim.fromValue = (id)self.preAnimationPathBar1;
                self.barOneLayer.path = [self barOnePath].CGPath;
                pathAnim.toValue = (id)[self barOnePath].CGPath;
                [self.barOneLayer addAnimation:pathAnim forKey:@"keyPathAnim"];
            }
            
            self.percentageOneLabel.text = [NSString stringWithFormat:@"%0.0f%%", percentage/1.7];
            break;
            
        case 2:
            if (animated) {
                NSLog(@"B");
                CABasicAnimation *pathAnim = [[CABasicAnimation alloc] init];
                pathAnim.keyPath = @"path";
                pathAnim.duration = 0.5;
                pathAnim.fromValue = (id)self.preAnimationPathBar2;
                self.barTwoLayer.path = [self barTwoPath].CGPath;
                pathAnim.toValue = (id)[self barTwoPath].CGPath;
                [self.barTwoLayer addAnimation:pathAnim forKey:@"keyPathAnim"];
            }
            
            self.percentageTwoLabel.text = [NSString stringWithFormat:@"%0.0f%%", percentage/1.7];
            break;
            
        case 3:
            if (animated) {
                NSLog(@"C");
                CABasicAnimation *pathAnim = [[CABasicAnimation alloc] init];
                pathAnim.keyPath = @"path";
                pathAnim.duration = 0.5;
                pathAnim.fromValue = (id)self.preAnimationPathBar3;
                self.barThreeLayer.path = [self barThreePath].CGPath;
                pathAnim.toValue = (id)[self barThreePath].CGPath;
                [self.barThreeLayer addAnimation:pathAnim forKey:@"keyPathAnim"];
            }
            
            self.percentageThreeLabel.text = [NSString stringWithFormat:@"%0.0f%%", percentage/1.7];
            break;
            
        default:
            break;
    }
    
}


+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    
    if ([key isEqualToString:NSStringFromSelector(@selector(barOneValue))]) {
        
        return NO;
    
    } else if ([key isEqualToString:NSStringFromSelector(@selector(barTwoValue))]) {
      
        return NO;
    } else if ([key isEqualToString:NSStringFromSelector(@selector(barThreeValue))]) {
        
        return NO;
    } else {
        return [super automaticallyNotifiesObserversForKey:key];
    }
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key
{
    if ([key isEqualToString:@"path"])
    {
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.duration = 10.0;
        transition.subtype = kCATransitionFromTop;
        return transition;
    }
    return [super actionForLayer:layer forKey:key];
}





@end
