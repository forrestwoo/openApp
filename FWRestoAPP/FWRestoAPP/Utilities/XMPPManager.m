//
//  XMPPManager.m
//  FWRestoAPP
//
//  Created by forrest on 2017/9/1.
//  Copyright © 2017年 forrest. All rights reserved.
//

#import "XMPPManager.h"
#import "CONSTANTS.h"

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

@interface XMPPManager ()<XMPPStreamDelegate, XMPPRosterDelegate>
{
    NSString *_userName;
    NSString *_password;
    BOOL isLogin;
}

- (void)SetupXMPPStream;
- (void)goOnline;
- (void)goOffline;
- (void)connectServer;

@end

@implementation XMPPManager
static XMPPManager *instance = nil;

+ (XMPPManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMPPManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self SetupXMPPStream];
        isLogin = YES;
        
    }
    return self;
}

- (void)SetupXMPPStream
{
    NSAssert(self.xmppStream == nil, @"Method setupStream invoked multiple times");
    
    self.xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        self.xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    self.xmppReconnect = [[XMPPReconnect alloc] init];
    
    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
    
    self.xmppRoster.autoFetchRoster = YES;
    self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    self.xmppvCardCoreDataStorage = [XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.xmppvCardCoreDataStorage];
    
    self.xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.xmppvCardTempModule];
    
    self.xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    self.xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:self.xmppCapabilitiesStorage];
    
    self.xmppCapabilities.autoFetchHashedCapabilities = YES;
    self.xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // Activate xmpp modules
    
    [self.xmppReconnect         activate:self.xmppStream];
    [self.xmppRoster            activate:self.xmppStream];
    [self.xmppvCardTempModule   activate:self.xmppStream];
    [self.xmppvCardAvatarModule activate:self.xmppStream];
    [self.xmppCapabilities      activate:self.xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    //
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    [self.xmppStream setHostName:kXMPPHostName];
    [self.xmppStream setHostPort:kXMPPHostPort];
    
    
    // You may need to alter these settings depending on the server you're connecting to
    customCertEvaluation = YES;
}

- (void)clearXMPP
{
    [self.xmppStream removeDelegate:self];
    [self.xmppRoster removeDelegate:self];
    [self.xmppReconnect         deactivate];
    [self.xmppRoster            deactivate];
    [self.xmppvCardTempModule   deactivate];
    [self.xmppvCardAvatarModule deactivate];
    [self.xmppCapabilities      deactivate];
    [self.xmppStream disconnect];
    
    self.xmppStream = nil;
    self.xmppReconnect = nil;
    self.xmppRoster = nil;
    self.xmppRosterStorage = nil;
    self.xmppvCardCoreDataStorage = nil;
    self.xmppvCardTempModule = nil;
    self.xmppvCardAvatarModule = nil;
    self.xmppCapabilities = nil;
    self.xmppCapabilitiesStorage = nil;
}

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    DDXMLElement *element = [DDXMLElement elementWithName:@"status" xmlns:@"我上线了！"];
    [presence addChild:element];
    
    [self.xmppStream sendElement:presence];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (void)connectServer
{
    
}

- (void)xmppLoginWithUserName:(NSString *)userName password:(NSString *)password
{
    isLogin = YES;
    
    _userName = userName;
    _password = password;
    if (self.xmppStream == nil) {
        [self SetupXMPPStream];
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithUser:userName domain:kXMPPDomain resource:@"iOS"]];
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:NULL];
    
}

- (void)xmppRegisterWithUserName:(NSString *)userName password:(NSString *)password
{
    isLogin = NO;
    _userName = userName;
    _password = password;
    if (self.xmppStream == nil) {
        [self SetupXMPPStream];
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithUser:userName domain:kXMPPDomain resource:@"iOS"]];
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:NULL];
    
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"已连接");
    if (isLogin)
        [self.xmppStream authenticateWithPassword:_password error:NULL];
    else
        [self.xmppStream registerWithPassword:_password error:NULL];
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"登录成功！");
    [[NSUserDefaults standardUserDefaults] setObject:_userName forKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] setObject:_password forKey:kXMPPmyPassword];
    [[NSUserDefaults  standardUserDefaults] synchronize];
    
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    if ([self.delegate respondsToSelector:@selector(ErrorString:)]) {
        [self.delegate performSelector:@selector(ErrorString:) withObject:@"用户名或密码错误，请重新输入！"];
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    
    NSLog(@"注册成功");
    
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败");
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    
}

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [self.xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [self.xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    // A simple example of inbound message handling.
    
    if ([message isChatMessageWithBody])
    {
        XMPPUserCoreDataStorageObject *user = [self.xmppRosterStorage userForJID:[message from]
                                                                      xmppStream:self.xmppStream
                                                            managedObjectContext:[self managedObjectContext_roster]];
        
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [user displayName];
        
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                                message:body
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            // We are not active, so use a local notification instead
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"Ok";
            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    
    XMPPUserCoreDataStorageObject *user = [self.xmppRosterStorage userForJID:[presence from]
                                                                  xmppStream:self.xmppStream
                                                        managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
    }
    else
    {
        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
    }
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil
                                                  cancelButtonTitle:@"Not implemented"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Not implemented";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
    
}

@end
