//
//  MPButton.m
//  MPMessenger
//
//  Created by Manjusha on 8/12/15.
//  Copyright © 2015 Manjusha. All rights reserved.
//

#import "MPButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation MPButton
-(void)setupView{
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.cornerRadius = 7.0f;
}

-(id)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
        [self setupView];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        [self setupView];
    }
    
    return self;
}

@end
