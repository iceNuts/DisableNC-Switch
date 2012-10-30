#import <sys/stat.h>

static NSString* filePath = @"/var/mobile/Library/DisableNCSwitch/disableNC.plist";
id userAgent; 

@interface CPDistributedMessagingCenter
+ (id)centerNamed:(id)arg1;
- (BOOL)sendMessageName:(id)arg1 userInfo:(id)arg2;
- (void)runServerOnCurrentThread;
- (void)registerForMessageName:(id)arg1 target:(id)arg2 selector:(SEL)arg3;
@end


%hook SpringBoard
- (void)hideSpringBoardStatusBar{
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: filePath];
	[plistDict setValue:@"YES" forKey:@"inApp"];
	[plistDict writeToFile:filePath atomically: YES];
	[plistDict release];
	plistDict = NULL;
	%orig;
}
- (void)showSpringBoardStatusBar{
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: filePath];
	[plistDict setValue:@"NO" forKey:@"inApp"];
	[plistDict writeToFile:filePath atomically: YES];
	[plistDict release];
	plistDict = NULL;
	%orig;
}
%end

static void sendMessage(BOOL arg1){
	
	NSString* bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
				
	if([userAgent lockScreenIsShowing] || [bundleId isEqualToString:@"com.apple.springboard"]){
		return;
	}
	
	if(arg1){
		CPDistributedMessagingCenter *center;
		center = [CPDistributedMessagingCenter centerNamed:@"com.icenuts.disablencswitch.server"];
		[center sendMessageName:@"com.icenuts.statusbarhidden" userInfo: nil];
	}else{
		CPDistributedMessagingCenter *center;
		center = [CPDistributedMessagingCenter centerNamed:@"com.icenuts.disablencswitch.server"];
		[center sendMessageName:@"com.icenuts.statusbarshow" userInfo: nil];
	}
}

%hook UIApplication
- (void)setStatusBarHidden:(BOOL)arg1 withAnimation:(int)arg2{
	sendMessage(arg1);
	%orig;
}
- (void)setStatusBarHidden:(BOOL)arg1 duration:(double)arg2{
	sendMessage(arg1);
	%orig;
}
- (void)setStatusBarHidden:(BOOL)arg1 duration:(double)arg2 changeApplicationFlag:(BOOL)arg3{
	sendMessage(arg1);
	%orig;
}
- (void)setStatusBarHidden:(BOOL)arg1 animationParameters:(id)arg2{
	sendMessage(arg1);
	%orig;
}
- (void)setStatusBarHidden:(BOOL)arg1 animationParameters:(id)arg2 changeApplicationFlag:(BOOL)arg3{
	sendMessage(arg1);
	%orig;
}
- (void)applicationDidResumeForEventsOnly{
	sendMessage([self isStatusBarHidden]);
	%orig;
}
- (void)applicationDidResume{
	sendMessage([self isStatusBarHidden]);
	%orig;
}
- (void)applicationDidResumeFromUnderLock{
	sendMessage([self isStatusBarHidden]);
	%orig;
}
- (void)applicationResume:(struct __GSEvent *)arg1{
	sendMessage([self isStatusBarHidden]);
	%orig;
}
- (void)_run{
	sendMessage([self isStatusBarHidden]);
	%orig;
}
%end


%hook SBBulletinListController
- (void)handleShowNotificationsGestureBeganWithTouchLocation:(struct CGPoint)arg1{
		
	if([userAgent lockScreenIsShowing]){
		%orig;
		return;
	}
	
	BOOL myHidden = NO;
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: filePath];	
	
	if([[plistDict objectForKey:@"enable"] isEqualToString: @"YES"] 
	&& [[plistDict objectForKey:@"inApp"] isEqualToString: @"YES"]
	&& [[plistDict objectForKey:@"inAppStatusBarHidden"] isEqualToString: @"YES"])
	{
		myHidden = YES;
	}
	if(myHidden){
	}else{
		%orig;
	}
}
%end

static int isStart = 0;

static void modifyPref(int flag){
	NSString* bundle = @"/var/mobile/Library/Preferences/com.iceNuts.disablencsettings.plist";
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: bundle];
	if(plistDict == nil){
		plistDict = [[NSMutableDictionary alloc] init];
	}
	[plistDict setValue:[NSNumber numberWithBool: flag?YES:NO] forKey:@"switchToggle"];
	[plistDict writeToFile: bundle atomically: YES];
}


%hook SBApplicationController
-(id)init{
	userAgent = [%c(SBUserAgent) sharedUserAgent];
	if(isStart){
		return %orig;
	}
	isStart = 1;
	CPDistributedMessagingCenter *
		center = [CPDistributedMessagingCenter centerNamed:@"com.icenuts.disablencswitch.server"];
	[center runServerOnCurrentThread];
	[center registerForMessageName:@"com.icenuts.statusbarhidden" target:self selector:@selector(handleMessage:)];
	[center registerForMessageName:@"com.icenuts.statusbarshow" target:self selector:@selector(handleMessage:)];
	[center registerForMessageName:@"com.icenuts.settingschanged" target:self selector:@selector(handleSettingsMsg:)];
	///INIT
	NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath: filePath]){
		NSLog(@"---INIT------");
		mkdir("/var/mobile/Library/", 0777);
		mkdir("/var/mobile/Library/DisableNCSwitch/", 0777);
    	//Enable for Signal Only
    	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
    	[plistDict setValue:@"NO" forKey:@"enable"];
    	[plistDict setValue:@"NO" forKey:@"inApp"];
    	[plistDict setValue:@"NO" forKey:@"inAppStatusBarHidden"];
    	[plistDict writeToFile: filePath atomically: YES];
	}
	///INIT
	return %orig;
}

%new(v@:@)
- (void) handleMessage: (NSString*)name
{
	if([name isEqualToString: @"com.icenuts.statusbarhidden"]){
		NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: filePath];
		[plistDict setValue:@"YES" forKey:@"inAppStatusBarHidden"];
		[plistDict writeToFile:filePath atomically: YES];
		[plistDict release];
		plistDict = NULL;
	}else if([name isEqualToString: @"com.icenuts.statusbarshow"]){
		NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: filePath];
		[plistDict setValue:@"NO" forKey:@"inAppStatusBarHidden"];
		[plistDict writeToFile:filePath atomically: YES];
		[plistDict release];
		plistDict = NULL;
	}		
}

%new(v@:@)
- (void) handleSettingsMsg: (NSString*)name{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if([fileManager fileExistsAtPath: filePath]){
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: filePath];
    }else{
		mkdir("/var/mobile/Library/", 0777);
		mkdir("/var/mobile/Library/DisableNCSwitch/", 0777);
        //Enable for Signal Only
        plistDict = [[NSMutableDictionary alloc] init];
        [plistDict setValue:@"NO" forKey:@"enable"];
        [plistDict setValue:@"NO" forKey:@"inApp"];
        [plistDict setValue:@"NO" forKey:@"inAppStatusBarHidden"];
        [plistDict writeToFile: filePath atomically: YES];
    }
    if([[plistDict objectForKey:@"enable"] isEqualToString: @"YES"]){
		modifyPref(0);
        [plistDict setValue:@"NO" forKey:@"enable"];
        [plistDict writeToFile: filePath atomically: YES];
    }else{
		modifyPref(1);
        [plistDict setValue:@"YES" forKey:@"enable"];
        [plistDict writeToFile: filePath atomically: YES];
    }
    [plistDict release];
}
%end
