//
//  UIView+FQExtension.m
//  common
//
//  Created by koji.
//  Copyright (c) 2012年 fq. All rights reserved.
//

#import "UIView+FQExtension.h"

@implementation UIView (FQExtension)

- (CGFloat)x{
    return [self frame].origin.x;
}

- (void)setX:(CGFloat)x{
    CGRect rect = [self frame];
    CGPoint point = rect.origin;
    point.x = x;
    
    rect.origin = point;
    [self setFrame:rect];
}

- (CGFloat)y{
    return [self frame].origin.y;
}

- (void)setY:(CGFloat)y{
    CGRect rect = [self frame];
    CGPoint point = rect.origin;
    point.y = y;
    
    rect.origin = point;
    [self setFrame:rect];
}

- (CGFloat)width{
    return [self frame].size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect rect = [self frame];
    CGSize size = rect.size;
    size.width = width;

    rect.size = size;
    [self setFrame:rect];
}

- (CGFloat)height{
    return [self frame].size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect rect = [self frame];
    CGSize size = rect.size;
    size.height = height;
    
    rect.size = size;
    [self setFrame:rect];
}

- (CGFloat)centerX{
    return [self center].x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = [self center];
    center.x = centerX;
    [self setCenter:center];
}

- (CGFloat)centerY{
    return [self center].y;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = [self center];
    center.y = centerY;
    [self setCenter:center];
}

@end
