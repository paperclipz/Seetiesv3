//
//  MapManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/23/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "MapManager.h"
@interface MapManager()<UIActionSheetDelegate>
@property(nonatomic,strong)NSString* latitude;
@property(nonatomic,strong)NSString* longitude;

@end
@implementation MapManager

+ (id)Instance {
    
    static MapManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)showMapOptions:(UIView*)view LocationLat:(NSString*)lat LocationLong:(NSString*)longt
{
    self.latitude = lat;
    self.longitude = longt;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalisedString(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:
                            @"Waze",
                            @"Google Maps",
                            @"Apple Maps",
                            nil];
    popup.tag = 999;
    [popup showInView:view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(actionSheet.tag == 999){
        NSString *latlong = [[NSString alloc]initWithFormat:@"%@,%@",self.latitude,self.longitude];
        switch (buttonIndex) {
            case 0:{
                NSLog(@"Waze");
                if ([[UIApplication sharedApplication]
                     canOpenURL:[NSURL URLWithString:@"waze://"]]) {
                    
                    // Waze is installed. Launch Waze and start navigation
                    NSString *urlStr =
                    [NSString stringWithFormat:@"waze://?ll=%@&navigate=yes",
                     latlong];
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    
                } else {
                    
                    // Waze is not installed. Launch AppStore to install Waze app
                    [[UIApplication sharedApplication] openURL:[NSURL
                                                                URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
                }
            }
                break;
            case 1:{
                NSLog(@"Google Maps");
                if ([[UIApplication sharedApplication] canOpenURL:
                     [NSURL URLWithString:@"comgooglemaps://"]]) {
                    NSString *url = [NSString stringWithFormat: @"comgooglemaps://?q=%@&zoom=10",
                                     latlong];
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                } else {
                    NSLog(@"Can't use comgooglemaps://");
                    NSString *url = [NSString stringWithFormat: @"http://maps.apple.com?q=%@",
                                     [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
            }
                break;
            case 2:{
                NSLog(@"Apple Maps");
                NSString *url = [NSString stringWithFormat: @"http://maps.apple.com?q=%@",
                                 [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
                break;
            default:
                break;
        }

    }
}

@end
