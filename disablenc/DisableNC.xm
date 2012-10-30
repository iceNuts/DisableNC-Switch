#import <notify.h>
static NSString* filePath = @"/var/mobile/Library/DisableNCSwitch/disableNC.plist";
extern NSString* PSValueKey;
extern NSString* PSSwitchAlternateColorsKey;
extern NSString* PSNegateValuekey;

@interface CPDistributedMessagingCenter
+ (id)centerNamed:(id)arg1;
- (BOOL)sendMessageName:(id)arg1 userInfo:(id)arg2;
- (void)runServerOnCurrentThread;
- (void)registerForMessageName:(id)arg1 target:(id)arg2 selector:(SEL)arg3;
@end

@interface PSListController{
    NSArray *_specifiers;
}
- (id)loadSpecifiersFromPlistName:(id)arg1 target:(id)arg2;
- (void)removeSpecifierAtIndex:(int)arg1 animated:(BOOL)arg2;
- (void)removeSpecifierAtIndex:(int)arg1;
- (void)removeSpecifierID:(id)arg1 animated:(BOOL)arg2;
- (void)beginUpdates;
- (void)endUpdates;
- (void)reloadSpecifiers;
- (void)reloadSpecifierAtIndex:(int)arg1 animated:(BOOL)arg2;
- (void)reloadSpecifierID:(id)arg1 animated:(BOOL)arg2;
- (int)indexOfSpecifierID:(id)arg1;
- (id)specifierAtIndex:(int)arg1;

@end

@interface PSSpecifier
@property(retain) NSMutableDictionary* properties;
- (void)setProperty:(id)arg1 forKey:(id)arg2;
- (void)setValues:(id)arg1 titles:(id)arg2;
@property(retain, nonatomic) NSDictionary *shortTitleDictionary; // @synthesize shortTitleDictionary=_shortTitleDict;
@property(retain, nonatomic) NSString *identifier;
@property(retain, nonatomic) NSString *name; // @synthesize name=_name;
@property(retain, nonatomic) NSArray *values; // @synthesize values=_values;
@property(retain, nonatomic) NSDictionary *titleDictionary; // @synthesize titleDictionary=_titleDict;
@property(retain, nonatomic) id userInfo; // @synthesize userInfo=_userInfo;
- (id)propertyForKey:(id)arg1;
@end

@interface DisableNCListController: PSListController {
}
@end

@implementation DisableNCListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"DisableNC" target:self] retain];
	}	
    return _specifiers;
}

-(void) getMore:(PSSpecifier*)spec{
    NSURL *url = [[NSURL alloc] initWithString: @"http://apt.thebigboss.org/packagesfordev.php?name=Photo2Weibo&uuid=&ua=Mozilla/5.0%20(iPhone;%20CPU%20iPhone%20OS%205_1%20like%20Mac%20OS%20X)%20AppleWebKit/534.46%20(KHTML,%20like%20Gecko)%20Version/5.1%20Mobile/9B179%20Safari/7534.48.3&ip=114.250.83.134&id=114.250.83.134"];
    [[UIApplication sharedApplication] openURL:url];
}

-(void) setValue:(PSSpecifier*)spec{
	NSLog(@"-------DOING------");
	CPDistributedMessagingCenter *CPCenter;
	CPCenter = [CPDistributedMessagingCenter centerNamed:@"com.icenuts.disablencswitch.server"];
	[CPCenter sendMessageName:@"com.icenuts.settingschanged" userInfo: nil];
}
@end

// vim:ft=objc
