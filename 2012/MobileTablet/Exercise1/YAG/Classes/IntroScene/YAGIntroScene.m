//
//  YAGIntroScene.m
//  YAG
//
//  Created by Tiago Janela on 11/29/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "YAGIntroScene.h"

@implementation YAGIntroScene

#define yagGridSide (16.0f)

- (void) onEnter
{
	[super onEnter];
	
	_controlLayer = [YAGControlLayer node];
	[self addChild:_controlLayer];
	_controlLayer.motionDelegate = self;
	[_controlLayer startMotionUpdates];
	
	_backgroundLayer = [CCLayerGradient layerWithColor:ccc4(0xff, 0xff, 0xff, 0xff) fadingTo:ccc4(0xda,0xda,0xda,0xff)];
	[self addChild:_backgroundLayer];
	
	_gridSprite = [CCSprite spriteWithFile:@"Grid-64.png"];
	[self addChild:_gridSprite];
	ccTexParams texParams = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
	[_gridSprite.texture setTexParameters:&texParams];
	_gridSprite.textureRect = CGRectMake(0,0,yagWinSize.width, yagWinSize.height);
	_gridSprite.anchorPoint = ccp(0.5,0.5);
	_gridSprite.contentSize = yagWinSize;
	_gridSpritePosition = ccp(yagWinSize.width / 2, yagWinSize.height / 2);
	_gridSprite.position = _gridSpritePosition;
	
	_titleLabel = [CCLabelTTF labelWithString:NSLocalizedString(@"Yet Another Game", @"Yet Another Game") fontName:@"Futura" fontSize:26];
	_titleLabel.color = ccc3(0,0,0);
	[self addChild:_titleLabel];
	_titleLabel.anchorPoint = ccp(0.5,1);
	
	_titleLabel.position = ccp(roundf(yagWinSize.width / 2), roundf(yagWinSize.height - 10));
	
	_squareHoleNode = [YAGSquareNode node];
	_squareHoleNode.contentSize = CGSizeMake(yagGridSide,yagGridSide);
	_squareHoleNode.anchorPoint = ccp(0.5,0.5);
	_squareHoleNode.fillColor = ccc4(0x00,0xcc,0x33,0xaa);
	_squareHoleNode.strokeColor = ccc4(0xcc,0xcc,0xcc,0x33);
	[self addChild:_squareHoleNode];
	
	_roundPegNode = [YAGCircleNode node];
	_roundPegNode.anchorPoint = ccp(0.5,0.5);
	_roundPegNode.radius = yagGridSide / 2.0f;
	
	_roundPegNode.fillColor = ccc4(0x00,0xcc,0xff,0xaa);
	_roundPegNode.strokeColor = ccc4(0xcc,0xcc,0xcc,0x33);
	_roundPegNode.contentSize = CGSizeMake(_roundPegNode.radius*2, _roundPegNode.radius*2);
	[self addChild:_roundPegNode];
	
	_roundPegNode.position = ccp(10, yagWinSize.height - yagGridSide - 10);
	_squareHoleNode.position = ccp(yagWinSize.height - (_roundPegNode.radius * 2) - 10, 10);
	
	_motionStreak = [CCMotionStreak streakWithFade:10 minSeg:1 width:8 color:ccc3(0x00, 0xcc, 0xff) textureFilename:@"MotionTexture.png"];
	_motionStreak.position = _roundPegNode.position;
	_motionStreak.fastMode = NO;
	[self addChild:_motionStreak];
	
	_debugLayer = [YAGDebugLayer layerWithColor:ccc4(0, 0, 0, 0x00)];
	[self addChild:_debugLayer];
	_debugLayer.delegate = self;
	[self scheduleUpdate];
}

#pragma mark - YAGControlLayerMotionDelegate

- (void)controlLayer:(YAGControlLayer *)controlLayer deviceAcceleration:(CMAcceleration)accelerationData
{
	_acceleration = accelerationData;
}

- (void)controlLayer:(YAGControlLayer *)controlLayer deviceAttitude:(CMAttitude*)deviceAttitude
{
	_attitude.pitch = deviceAttitude.pitch;
	_attitude.roll = deviceAttitude.roll;
	_attitude.yaw = deviceAttitude.yaw;
}

#define kFilteringFactor 0.1
#define kAccelerationEpsilon 0.00001

- (void) update:(ccTime)deltaTime
{
	_lastAcceleration.x = (_acceleration.x * kFilteringFactor) + (_lastAcceleration.x * (1.0 - kFilteringFactor));
	_lastAcceleration.y = (_acceleration.y * kFilteringFactor) + (_lastAcceleration.y * (1.0 - kFilteringFactor));
	_lastAcceleration.z = (_acceleration.z * kFilteringFactor) + (_lastAcceleration.z * (1.0 - kFilteringFactor));
	
	float accelXDelta = _lastAcceleration.x;
	float accelYDelta = _lastAcceleration.y;
	
	accelXDelta = fabs(accelXDelta) < kAccelerationEpsilon ? 0 : accelXDelta;
	accelYDelta = fabs(accelYDelta) < kAccelerationEpsilon ? 0 : accelYDelta;
	
	_squareHoleNode.position = ccp((accelYDelta * 100) + _gridSpritePosition.x,  (-accelXDelta * 100) + _gridSpritePosition.y);
	
	float deltaX = _attitude.pitch * 1;
	float deltaY = _attitude.roll * 1;
	//float deltaZ = _attitude.yaw * 1;
	
	_roundPegNode.position = ccp(-deltaX + _roundPegNode.position.x, -deltaY + _roundPegNode.position.y);
	_motionStreak.position = _roundPegNode.position;
	[self updateContacts];
	
	[self checkForFinish];
}

- (void) checkForFinish
{
	CGRect roundPegRect = [self worldRectForNode:_roundPegNode];
	CGRect squareHoleRect = [self worldRectForNode:_squareHoleNode];
	
	CGRect intersectionRect = CGRectIntersection(roundPegRect, squareHoleRect);
	
	NSInteger squareHoleRectArea = squareHoleRect.size.width * squareHoleRect.size.height;
	NSInteger intersectionRectArea = intersectionRect.size.width * intersectionRect.size.height;
	
	if(!_finished && intersectionRectArea > squareHoleRectArea / 2)
	{
		[self finish];
	}
}

- (void) finish
{
	if(_finishLabel)
	{
		return;
	}
	
	_finishLabel = [CCLabelTTF labelWithString:@"Hooray!" dimensions:CGSizeMake(100, 40) hAlignment:kCCTextAlignmentCenter vAlignment:kCCTextAlignmentCenter fontName:@"Futura" fontSize:18];
	_finishLabel.color = ccc3(0x33, 0x33, 0x33);
	[self addChild:_finishLabel];
	
	_finishLabel.anchorPoint = ccp(0.5,0.5);
	
	_finishLabel.position = ccp(yagWinSize.width / 2, - 40);
	
	CCMoveTo *moveTo = [CCMoveTo actionWithDuration:1 position:ccp(yagWinSize.width/2, yagWinSize.height/2)];
	[_finishLabel runAction:moveTo];
	
	_finished = YES;
}

- (void)debugLayerWantsDraw:(YAGDebugLayer *)debugLayer
{
	CGRect roundPegRect = [self worldRectForNode:_roundPegNode];
	ccDrawColor4B(0xff, 0x00, 0x00, 0xff);
	ccDrawRect(roundPegRect.origin, ccpAdd(roundPegRect.origin, ccp(roundPegRect.size.width, roundPegRect.size.height)));
	
	CGRect squareHoleRect = [self worldRectForNode:_squareHoleNode];
	ccDrawColor4B(0xaa, 0x55, 0x00, 0xff);
	ccDrawRect(squareHoleRect.origin, ccpAdd(squareHoleRect.origin, ccp(squareHoleRect.size.width, squareHoleRect.size.height)));
}

- (CGRect) worldRectForNode:(CCNode*)node
{
	CGAffineTransform nodeTransform = node.nodeToWorldTransform;
	CGRect nodeRect = CGRectMake(node.position.x, node.position.y, node.contentSize.width, node.contentSize.height);
	CGRect worldNodeRect = CGRectApplyAffineTransform(CGRectMake(0, 0, nodeRect.size.width, nodeRect.size.height), nodeTransform);
	return worldNodeRect;
}

- (void) updateContacts
{
	
	CGFloat x = _roundPegNode.position.x;
	CGFloat y = _roundPegNode.position.y;
	
	CGFloat minXIndex = floorf(x / yagGridSide);
	
	CGFloat minYIndex = floorf(y / yagGridSide);
	
	
	if(!_contactNode){
		_contactNode = [YAGCircleNode node];
		[_backgroundLayer addChild:_contactNode];
	}
	_contactNode.radius = yagGridSide/2;
	_contactNode.strokeColor = ccc4(0x33, 0x33, 0x33, 0x88);
	_contactNode.fillColor = ccc4(0x02, 0x76, 0xc6, 0x88);
	
	_contactNode.position = ccp(minXIndex*yagGridSide, minYIndex*yagGridSide);	
}

@end
