//
//  YAGEllipseNode.m
//  YAG
//
//  Created by Tiago Janela on 11/30/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "YAGCircleNode.h"

@implementation YAGCircleNode

@synthesize fillColor = _fillColor;
@synthesize strokeColor = _strokeColor;
@synthesize radius = _radius;

- (void)draw
{
	CGPoint center = ccp(self.radius, self.radius);
	ccColor4F strokeColor = ccc4FFromccc4B(_strokeColor);
	ccColor4F fillColor = ccc4FFromccc4B(_fillColor);
	yagDrawColor4F(fillColor.r, fillColor.g, fillColor.b, fillColor.a);
	yagDrawSolidCircle(center, self.radius, 360, 20);
	ccDrawColor4F(strokeColor.r, strokeColor.g, strokeColor.b, strokeColor.a);
	ccDrawCircle(center, self.radius, 360, 20, YES);
}

@end
