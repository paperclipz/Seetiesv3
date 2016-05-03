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
        case ShareTypeInvite:
        {
            message = [LanguageManager stringForKey:@"Seeties is all about deals and places - discover and collect awesome deals from your favourite shops to eat, play and hangout.\n{Seeties URL}" withPlaceHolder:@{@"{Seeties URL}":[self getShareLink:self.shareType]}];
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
            finalLink = @"http://seeties.me";
        }
            break;
            
        case ShareTypeReferralInvite:
        {
            //To be changed
            subLink = @"referral/";
            finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink, subLink, self.shareID];
        }
            break;
    }
    
    
    return finalLink;
}

- (NSString *)GetBaseURLPath {
    
    if ([Utils isAppProductionBuild]) {
        return kProductionBasePath;
    }
    
    return kDevelopmentBasePath;
}

@end