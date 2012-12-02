//
//  YAGDebugLayer.m
//  YAG
//
//  Created by Tiago Janela on 12/1/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "YAGDebugLayer.h"


@implementation YAGDebugLayer

@synthesize delegate = _delegate;

- (void)draw
{
	[self.delegate debugLayerWantsDraw:self];
}

@end
