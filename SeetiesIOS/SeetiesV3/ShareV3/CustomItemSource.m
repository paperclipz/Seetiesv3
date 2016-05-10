//
//  CustomItemSource.m
//  SeetiesIOS
//
//  Created by Lai on 11/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CustomItemSource.h"

@implementation CustomItemSource

- (id)init {
    self = [super init];
    
    if (self) {
        self.title = @"";
        self.userID = @"";
        self.shareID = @"";
        self.postImageURL = @"";
        self.shareType = 0;
        self.postID = @"";
        self.fbShareContent = nil;
    }
    
    return self;
}

#pragma mark - Getter

- (FBSDKShareLinkContent *)fbShareContent {
    
    if (!_fbShareContent) {
        _fbShareContent = [[FBSDKShareLinkContent alloc] init];
        
        _fbShareContent.contentURL = [NSURL URLWithString:[self getShareLink:self.shareType]];
        _fbShareContent.contentDescription = [self GetFormattedStringWithAppendURL:YES];
        _fbShareContent.contentTitle = [self.title isEqualToString:@""] ? @"SEETIES" : self.title;
        _fbShareContent.imageURL = [NSURL URLWithString:self.postImageURL];
    }
    
    return _fbShareContent;
}

#pragma mark - protocol

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    // called to determine data type. only the class of the return type is consulted. it should match what -itemForActivityType: returns later
    return @"";
}

- (nullable id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    // called to fetch data after an activity is selected. you can return nil.
    
//    if ([activityType isEqualToString:UIActivityTypeMail]) {
//        return [self GetFormattedStringWithAppendURL:YES];
//    }
    
    if ([activityType isEqualToString:@"com.custom.whatsapp"] ||[activityType isEqualToString:@"net.whatsapp.WhatsApp.ShareExtension"]) {
                
        NSString *str = [self GetFormattedStringWithAppendURL:YES];
        NSString *string = [NSString stringWithFormat:@"whatsapp://send?text=%@",str];
        NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL: url];

        
        return @"";
    }
    else if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]) {
        return [NSURL URLWithString:[self getShareLink:self.shareType]];
    }
    else if ([activityType isEqualToString:@"com.custom.line"]) {
        NSString *str = [self GetFormattedStringWithAppendURL:YES];
        NSString *string = [NSString stringWithFormat:@"line://msg/text/%@",str];
        NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL: url];

        return @"";
    }
//    else if ([activityType isEqualToString:@"com.custom.messenger"]) {
//        
//        NSURL *url = [NSURL URLWithString:@"sms:98765432"];
//        [[UIApplication sharedApplication] openURL:url];
//    }
    
    return [self GetFormattedStringWithAppendURL:YES];
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(nullable NSString *)activityType{
    // if activity supports a Subject field. iOS 7.0
    
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        return [self GetMailSubjectTitle];
    }
    
    return @"";
}

#pragma mark - Get String & Link Functions


- (NSString *)GetMailSubjectTitle {
    
    NSString *messageSubject = @"";
    
    switch (self.shareType) {
        default:
        case ShareTypePost:
            messageSubject = @"Seeties Post";
            break;
        case ShareTypeCollection:
            messageSubject = @"Seeties Collection";
            break;
        case ShareTypePostUser:
            messageSubject = @"Seeties User";
            break;
        case ShareTypeReferralInvite:
        case ShareTypeInvite:
            messageSubject = LocalisedString(@"Invite Friends");
            break;
    }
    
    return messageSubject;
}

- (NSString *)GetFormattedStringWithAppendURL:(BOOL)appendURL {
    
    NSString* message;
    
    switch (self.shareType) {
            
        default:
        case ShareTypePost:
        {
            message = LocalisedString(@"I was reading [post title] on Seeties and I thought you might be interested in reading it too.\n\n[post url]");
            if (self.title) {
                message = [message stringByReplacingOccurrencesOfString:@"[post title]"
                                                             withString:self.title];
            }
            else{
                message = [message stringByReplacingOccurrencesOfString:@"[post title]"
                                                             withString:@""];
            }
            message = [message stringByReplacingOccurrencesOfString:@"[post url]"
                                                         withString:appendURL ? [self getShareLink:self.shareType] : @""];
        }
            break;
        case ShareTypeCollection:
        {
            message = LocalisedString(@"I was checking this collection [collection title] on Seeties and I thought you might like to see it too.\n\n[post url]");
            if (self.title) {
                message = [message stringByReplacingOccurrencesOfString:@"[collection title]"
                                                             withString:self.title];
            }
            else{
                message = [message stringByReplacingOccurrencesOfString:@"[collection title]"
                                                             withString:@""];
            }
            
            message = [message stringByReplacingOccurrencesOfString:@"[post url]"
                                                         withString:appendURL?[self getShareLink:self.shareType]:@""];
        }
            break;
        case ShareTypePostUser:
        {
            message = [NSString stringWithFormat:@"Check out my profile on Seeties!"];
            message = [NSString stringWithFormat:@"%@ %@",message,appendURL ? [self getShareLink:self.shareType]:@""];
            
            
        }
            break;
            
        case ShareTypeDeal:
        {
            message = [NSString stringWithFormat:@"Check out this deal on Seeties!"];
            message = [NSString stringWithFormat:@"%@ %@",message,appendURL?[self getShareLink:self.shareType]:@""];
            
            
        }
            break;
        
        case ShareTypeReferralInvite:
        {
            message = [LanguageManager stringForKey:@"Sharing is caring! Get an instant reward when you sign up with the invite code '{!referral_code}'.\n{!Seeties URL}" withPlaceHolder:@{@"{!referral_code}":self.shareID, @"{!Seeties URL}":[self getShareLink:self.shareType]}];
        }
            break;
        case ShareTypeInvite:
        {
            message = [LanguageManager stringForKey:@"Sharing is caring!\nSign up with Seeties today.\n{!Seeties URL}" withPlaceHolder:@{@"{!Seeties URL}":[self getShareLink:self.shareType]}];
        }
            break;
            
    }
    
    return message;
    
}

-(NSString*)getShareLink:(ShareType)type
{
    
    
    NSString* seetiesLink = [self GetBaseURLPath];
    
    NSString* subLink;
    NSString* finalLink;
    switch (type) {
            
        default:
        case ShareTypePost:
        {
            subLink = @"post/";
            finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink,subLink,self.shareID];
            
        }
            break;
        case ShareTypeCollection:
        {
            subLink = @"collections/";
            finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink,subLink,self.shareID];
            
        }
            break;
        case ShareTypePostUser:
        {
            subLink = @"";
            finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink,subLink,self.shareID];
            
        }
            break;
            
        case ShareTypeSeetiesShop:
        {
            subLink = @"seetishops/";
            finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink,subLink,self.shareID];
            
        }
            break;
            
        case ShareTypeNonSeetiesShop:
        {
            subLink = @"seetishops/";
            finalLink = [NSString stringWithFormat:@"%@%@%@/%@",seetiesLink,subLink,self.shareID,self.postID];
            
        }
            break;
            
        case ShareTypeDeal:
        {
            subLink = @"deals/";
            finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink,subLink,self.shareID];
            
        }
            break;
            
        case ShareTypeInvite:
        {
            subLink = @"signup/";
            finalLink = [NSString stringWithFormat:@"%@%@", seetiesLink, subLink];
        }
            break;
            
        case ShareTypeReferralInvite:
        {
            subLink = @"referral/signup/";
            finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink, subLink, self.shareID];
        }
            break;
    }
    
    
    return finalLink;
}

- (NSString *)GetBaseURLPath {
    
    if ([Utils isAppProductionBuild]) {
        return PRODUCTION_BASE_PATH;
    }
    
    return DEVELOPMENT_BASE_PATH;
}

@end
