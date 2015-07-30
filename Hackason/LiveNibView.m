//
//  LiveNibView.m
//  Hackason
//
//  Created by Yohei Sashikata on 2015/07/17.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "LiveNibView.h"

@implementation LiveNibView
{

}

- (LiveNibView *)loadNib
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    return [bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LiveNibView *view = [self loadNib];
        view.frame = self.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self = view;
    }
    
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    if([[self subviews] count] == 0) {
        LiveNibView *view = [self loadNib];
        [view setTranslatesAutoresizingMaskIntoConstraints:false];
        NSArray *constraints =[self constraints];
        [self removeConstraints:constraints];
        [view addConstraints:constraints];
        
        return view;
    }
    
    return self;
}

@end
