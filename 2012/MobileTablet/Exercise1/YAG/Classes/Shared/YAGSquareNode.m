//
//  YAGSquareNode.m
//  YAG
//
//  Created by Tiago Janela on 11/30/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "YAGSquareNode.h"

@implementation YAGSquareNode

@synthesize fillColor = _fillColor;
@synthesize strokeColor = _strokeColor;

- (void) draw
{
	ccColor4F strokeColor = ccc4f(_strokeColor.r / (0xff * 1.0f), _strokeColor.g / (0xff * 1.0f), _strokeColor.b / (0xff * 1.0f), _strokeColor.a / (0xff * 1.0f));
	ccColor4F fillColor = ccc4f(_fillColor.r / (0xff * 1.0f), _fillColor.g / (0xff * 1.0f), _fillColor.b / (0xff * 1.0f), _fillColor.a / (0xff * 1.0f));
	ccDrawSolidRect(CGPointZero, ccp(self.contentSize.width,self.contentSize.height), fillColor);
	ccDrawColor4F(strokeColor.r, strokeColor.g, strokeColor.b, strokeColor.a);
	ccDrawRect(CGPointZero, ccp(self.contentSize.width,self.contentSize.height));
}

@end
