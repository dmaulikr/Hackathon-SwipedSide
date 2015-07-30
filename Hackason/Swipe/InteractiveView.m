//
//  interactiveView.m
//  SwipeToAccess
//
//  Created by Yohei Sashikata on 2015/06/23.
//  Copyright (c) 2015年 Yohei Sashikata. All rights reserved.
//
#import "InteractiveView.h"

int const kMinVelocity = -1000;
int const kVelocity = -2000;

@implementation InteractiveView{
    
    float _startY;
    float _defaultViewY;

    UIPanGestureRecognizer *_pan;
}
- (void)drawRect:(CGRect)rect{
    FUNC();
    [super drawRect:rect];
    UIPanGestureRecognizer *panGestureRecognizer =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDragged:)];
    [self addGestureRecognizer:panGestureRecognizer];
    _defaultViewY = self.y;
}


- (void)viewDragged:(id)sender{
    _pan = sender;
    if(_pan.state == UIGestureRecognizerStateBegan){
        _startY = self.y;
    }else if(_pan.state == UIGestureRecognizerStateChanged){
        [self moveView];
    }else{
        [self animateDragFinish];
    }
}

- (void)animateDragFinish{
    //float diffY = _defaultViewY - (_startY + [_pan translationInView:self].y);
    float velocityY = [_pan velocityInView:self].y;
    
    if(velocityY < kMinVelocity){
        
        if([self.delegate respondsToSelector:@selector(didFinishSwipe)]){
            //[self.delegate didFinishSwipe];////////////////////////////////////////////////////
        }
        
        [self animateSwipe:velocityY];
    }else{
        [self animateSwipeCancel];
    }
}

- (void)animateSwipe:(float)velocityY{
    [UIView animateWithDuration:1.0f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.y = kVelocity;
                     }completion:^(BOOL finished){
                         [self animateFadeInView];
                         [self.delegate didFinishSwipe];
                     }];
}

- (void)animateSwipeCancel{
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.y = _defaultViewY;
                     }completion:^(BOOL finished){
                     }];
}

- (void)animateFadeInView{
    self.alpha = 0;
    self.y = _defaultViewY;
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1;
                     }completion:^(BOOL finished){
                     }];
}

- (void)moveView{
    CGPoint point = [_pan translationInView:self];
    
    float nextY = _startY + point.y;
    
    if(_defaultViewY - nextY < 0){
        self.y = _startY + (point.y * 0.1);
    }else{
        self.y = _startY + (point.y);
    }
}

@end
