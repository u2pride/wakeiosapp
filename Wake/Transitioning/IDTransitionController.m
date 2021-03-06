//
//  IDTransitionController.m
//  AnimationExperiments
//
//  Created by Ian Dundas on 24/09/2013.
//  Copyright (c) 2013 Ian Dundas. All rights reserved.
//

#import "IDTransitionController.h"

@implementation IDTransitionController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.reverse ? 1.0 : 1.2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)context
{
    UIView *inView = [context containerView];
    UIView *toView = [[context viewControllerForKey:UITransitionContextToViewControllerKey]view];
    UIView *fromView = [[context viewControllerForKey:UITransitionContextFromViewControllerKey]view];

    if (self.reverse) {
        [inView insertSubview:toView belowSubview:fromView];
    }
    else {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        toView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        toView.transform = CGAffineTransformMakeScale(0, 0);
        [inView addSubview:toView];
    }
    
    CGFloat damping = self.reverse ? 1.0 : 0.8;
    NSTimeInterval duration = [self transitionDuration:context];

    [toView setUserInteractionEnabled: true];
    [fromView setUserInteractionEnabled: false];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:6.0 options:0 animations:^{
        if (self.reverse) {
            fromView.transform = CGAffineTransformMakeScale(0, 0);
        }
        else {
            toView.transform = CGAffineTransformIdentity; // i.e. CGAffineTransformMakeScale(1, 1);
        }

    } completion:^(BOOL finished) {
        [context completeTransition:finished]; // vital
    }];
}


@end
