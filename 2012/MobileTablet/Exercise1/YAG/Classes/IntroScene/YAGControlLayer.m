//
//  YAGControlLayer.m
//  YAG
//
//  Created by Tiago Janela on 11/29/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "YAGControlLayer.h"

#define YAG_PRINT_ACCELEROMETER_DATA 0
#define YAG_PRINT_MAGNETOMETER_DATA 0
#define YAG_PRINT_GYRO_DATA 0

@implementation YAGControlLayer

@synthesize motionDelegate = _motionDelegate;

- (id)init
{
	self = [super init];
	if (self)
	{
		_motionManager = [[CMMotionManager alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_motionManager release];
	_motionManager = nil;
	[super dealloc];
}

- (void)onEnter
{
	[super onEnter];
	[self scheduleUpdate];
}

- (void) onExit
{
	[super onExit];
}

#pragma mark - Core Motion Helpers

- (void) startCMUpdates
{
	[_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];

}

- (void) stopCMUpdates
{
	[_motionManager stopDeviceMotionUpdates];
}

#pragma mark 

- (void) update:(ccTime)deltaTime
{
	if(_shouldNotifyMotionDelegate)
	{
		[self processMotionDataAndNotifyDelegate];
	}
}

#pragma mark - Motion

- (void) processMotionDataAndNotifyDelegate
{
	CMDeviceMotion *deviceMotion = _motionManager.deviceMotion;
	CMAttitude *attitude = deviceMotion.attitude;
	CMQuaternion quaternion = attitude.quaternion;
	
	CMMagneticFieldCalibrationAccuracy magneticFieldCalibrationAccuracy = deviceMotion.magneticField.accuracy;
	CMMagneticField magneticField = deviceMotion.magneticField.field;
	CMAcceleration acceleration = deviceMotion.userAcceleration;
	CMRotationRate rotationRate = deviceMotion.rotationRate;
	
#if YAG_PRINT_MAGNETOMETER_DATA == 1
	NSString *magneticFieldCalibrationState = @"";
	switch (magneticFieldCalibrationAccuracy) {
		case CMMagneticFieldCalibrationAccuracyHigh:
			magneticFieldCalibrationState = @"High";
			break;
		case CMMagneticFieldCalibrationAccuracyMedium:
			magneticFieldCalibrationState = @"Medium";
			break;
		case CMMagneticFieldCalibrationAccuracyLow:
			magneticFieldCalibrationState = @"Low";
			break;
		case CMMagneticFieldCalibrationAccuracyUncalibrated:
			magneticFieldCalibrationState = @"Uncalibrated";
			break;
	}
	DDLogVerbose(@"Magnetic Field [Calibration State: %@] <x,y,z> µT = <%f, %f, %f>",magneticFieldCalibrationState,magneticField.x, magneticField.y, magneticField.z);
#endif
	
#if YAG_PRINT_ACCELEROMETER_DATA == 1
	DDLogVerbose(@"Acceleration <x,y,z> = <%f, %f, %f>",acceleration.x, acceleration.y, acceleration.z);
#endif
	
#if YAG_PRINT_GYRO_DATA == 1
	DDLogVerbose(@"Rotation Rate <x,y,z> = <%f, %f, %f>",rotationRate.x, rotationRate.y, rotationRate.z);
	DDLogVerbose(@"Attitude (3D) <x,y,z> = <%f, %f, %f>",attitude.pitch, attitude.roll, attitude.yaw);
	DDLogVerbose(@"Quaternion (4D) <w + xi + yj + zk> = <%f, %f, %f, %f>",quaternion.w, quaternion.x, quaternion.y, quaternion.z);
#endif
	
	[self.motionDelegate controlLayer:self deviceAcceleration:acceleration];
	[self.motionDelegate controlLayer:self deviceAttitude:attitude];
}

- (void) startMotionUpdates
{
	[self startCMUpdates];
	_shouldNotifyMotionDelegate = YES;
}

- (void) stopMotionUpdates
{
	_shouldNotifyMotionDelegate = NO;
	[self stopCMUpdates];
}

@end
