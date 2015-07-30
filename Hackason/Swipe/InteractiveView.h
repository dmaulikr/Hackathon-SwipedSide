//
//  interactiveView.h
//  SwipeToAccess
//
//  Created by Yohei Sashikata on 2015/06/23.
//  Copyright (c) 2015年 Yohei Sashikata. All rights reserved.
//

#import "UIView+FQExtension.h"

@protocol InteractiveViewDelegate<NSObject>
- (void)didFinishSwipe;
@end

@interface InteractiveView : UIView
@property id delegate;
@end


