//
//  YAGAppDelegate.m
//  YAG
//
//  Created by Tiago Janela on 11/29/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "YAGAppDelegate.h"

#import "YAGIntroScene.h"
#import "DDTTYLogger.h"

@implementation YAGAppDelegate

- (void)dealloc
{
	[_window release];
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	// Override point for customization after application launch.
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	
	CCGLView *view = [CCGLView viewWithFrame:self.window.frame pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	[[CCDirector sharedDirector] setDelegate:self];
	[[CCDirector sharedDirector] setDisplayStats:YES];
	[[CCDirector sharedDirector] setView:view];
	
	self.window.rootViewController = [CCDirector sharedDirector];
	
	[[CCDirector sharedDirector] runWithScene:[YAGIntroScene node]];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark CCDirectorDelegate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationLandscapeRight;
}

@end
