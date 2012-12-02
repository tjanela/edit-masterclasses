//
//  YAGIntroScene.h
//  YAG
//
//  Created by Tiago Janela on 11/29/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "CCScene.h"

#import "YAGControlLayer.h"

#import "YAGSquareNode.h"
#import "YAGCircleNode.h"

#import "YAGDebugLayer.h"

typedef struct
{
	double roll;
	double pitch;
	double yaw;
}YAGAttitude;

@interface YAGIntroScene : CCScene
<YAGControlLayerMotionDelegate,
YAGDebugLayerDelegate
>
{
	YAGControlLayer *_controlLayer;
	CCLayerGradient *_backgroundLayer;
	CCSprite *_gridSprite;
	CCLabelTTF *_titleLabel;
	
	CCMenu *_gameMenu;
	
	YAGSquareNode *_squareHoleNode;
	YAGCircleNode *_roundPegNode;
	
	CMAcceleration _acceleration;
	
	CMAcceleration _lastAcceleration;
	
	YAGAttitude _attitude;
	
	CGPoint _gridSpritePosition;
	
	CCMotionStreak *_motionStreak;
	
	YAGCircleNode *_contactNode;
	
	YAGDebugLayer *_debugLayer;
	
	CCLabelTTF *_finishLabel;
	
	BOOL _finished;
	
	
}
@end
