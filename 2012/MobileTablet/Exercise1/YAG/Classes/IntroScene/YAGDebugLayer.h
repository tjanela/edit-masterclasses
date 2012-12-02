//
//  YAGDebugLayer.h
//  YAG
//
//  Created by Tiago Janela on 12/1/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "CCLayer.h"

@class YAGDebugLayer;

@protocol YAGDebugLayerDelegate <NSObject>

- (void) debugLayerWantsDraw:(YAGDebugLayer*)debugLayer;

@end

@interface YAGDebugLayer : CCLayerColor
{
	id<YAGDebugLayerDelegate> _delegate;
}

@property (nonatomic, assign) id<YAGDebugLayerDelegate> delegate;

@end
