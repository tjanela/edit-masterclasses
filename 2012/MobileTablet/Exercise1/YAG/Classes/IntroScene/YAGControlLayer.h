//
//  YAGControlLayer.h
//  YAG
//
//  Created by Tiago Janela on 11/29/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "CCLayer.h"

@class YAGControlLayer;

@protocol YAGControlLayerMotionDelegate <NSObject>

- (void) controlLayer:(YAGControlLayer*)controlLayer deviceAcceleration:(CMAcceleration)accelerationData;
- (void) controlLayer:(YAGControlLayer*)controlLayer deviceAttitude:(CMAttitude*)attitudeData;

@end

@interface YAGControlLayer : CCLayer
{
	CMMotionManager *_motionManager;
	id<YAGControlLayerMotionDelegate> _motionDelegate;
	
	BOOL _shouldNotifyMotionDelegate;
}

@property (nonatomic, assign) id<YAGControlLayerMotionDelegate> motionDelegate;

- (void) startMotionUpdates;
- (void) stopMotionUpdates;

@end
