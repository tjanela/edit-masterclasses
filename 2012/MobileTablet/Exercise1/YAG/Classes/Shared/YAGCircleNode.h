//
//  YAGEllipseNode.h
//  YAG
//
//  Created by Tiago Janela on 11/30/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "CCNode.h"

@interface YAGCircleNode : CCNode
{
	CGFloat _radius;
	ccColor4B _strokeColor;
	ccColor4B _fillColor;
}

@property (nonatomic, assign) ccColor4B strokeColor;
@property (nonatomic, assign) ccColor4B fillColor;
@property (nonatomic, assign) CGFloat radius;

@end
