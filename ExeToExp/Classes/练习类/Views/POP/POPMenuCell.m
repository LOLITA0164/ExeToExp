//
//  POPMenuCell.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "POPMenuCell.h"

@implementation POPMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted)
    {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration           = 0.1;
        scaleAnimation.toValue            = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self.textLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
    else
    {
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        scaleAnimation.springBounciness    = 20;
        [self.textLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}






















@end
