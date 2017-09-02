//
//  XMPPManager.h
//  FWRestoAPP
//
//  Created by forrest on 2017/9/1.
//  Copyright © 2017年 forrest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>

extern NSString * const kXMPPmyJID;
extern NSString *const kXMPPmyPassword;

@protocol XMPPManagerDelegate <NSObject>

@optional
- (void)ErrorString:(NSString *)errorString;

@end

@interface XMPPManager : NSObject
{
    BOOL customCertEvaluation;
}
@property (nonatomic, weak) id<XMPPManagerDelegate> delegate;
@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;

@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardCoreDataStorage;
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;

@property (nonatomic, strong) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

+ (XMPPManager *)sharedManager;
- (void)xmppLoginWithUserName:(NSString *)userName password:(NSString *)password;
- (void)xmppRegisterWithUserName:(NSString *)userName password:(NSString *)password;
- (void)clearXMPP;

@end
