//
//  SearchModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"

@protocol SearchModel


@end

@protocol SearchLocationModel


@end

@interface SearchModel : Model

@property(nonatomic,strong)NSArray<SearchLocationModel>* predictions;
@end


@interface SearchLocationModel : JSONModel
@property(nonatomic,strong)NSString* longDescription;
@property(nonatomic,strong)NSArray* terms;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)NSString* reference;
@property(nonatomic,strong)NSNumber<Optional>* latitude;
@property(nonatomic,strong)NSNumber<Optional>* longitude;
@property(nonatomic,strong)NSString<Optional>* name;

@end

@interface SearchLocationDetailModel : JSONModel
@property(nonatomic,strong)NSString* formatted_address;
@property(nonatomic,strong)NSString<Optional>* name;
@property(nonatomic,strong)NSString* formatted_phone_number;
@property(nonatomic,strong)NSString* website;
@property(nonatomic,strong)NSString* vicinity;
@property(nonatomic,strong)NSString* reference;
@property(nonatomic,strong)NSString* place_id;
//@property(nonatomic,strong)NSString* long_name;
@property(nonatomic,strong)NSString* lat;
@property(nonatomic,strong)NSString* lng;

@property(nonatomic,strong)NSString<Optional>* state;
@property(nonatomic,strong)NSString<Optional>* city;//locality
@property(nonatomic,strong)NSString<Optional>* route;
@property(nonatomic,strong)NSString<Optional>* country;
@property(nonatomic,strong)NSString<Optional>* postal_code;
@property(nonatomic,strong)NSString<Optional>* political;

@property(nonatomic,strong)NSDictionary<Optional>* address_components;

//@property(nonatomic,strong)NSString* opening_hours;
//@property(nonatomic,strong)NSString* weekday_text;
//@property(nonatomic,strong)NSString* periods;

//@property(nonatomic,strong)NSString* close;
//@property(nonatomic,strong)NSString* open;

-(void)process;

@end



//
//NSLog(@"Get_Country is %@",Get_Country);
//NSLog(@"Get_State is %@",Get_State);
//NSLog(@"Get_City is %@",Get_City);
//NSLog(@"Get_postalCode is %@",Get_postalCode);
//
//NSDictionary *geometryData = [GetresultsData valueForKey:@"geometry"];
////NSLog(@"geometryData ===== %@",geometryData);
//NSDictionary *locationData = [geometryData valueForKey:@"location"];
//NSString *Get_Lat = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lat"]];
//NSString *Get_Lng = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lng"]];
//NSLog(@"Get_Lat is %@",Get_Lat);
//NSLog(@"Get_Lng is %@",Get_Lng);
//
//NSDictionary *OpeningHourData = [GetresultsData valueForKey:@"opening_hours"];
//NSString *sourceData = [[NSString alloc]initWithFormat:@"%@",OpeningHourData];
//NSLog(@"sourceData is %@",sourceData);
//NSArray *WeekdayData = (NSArray *)[OpeningHourData valueForKey:@"weekday_text"];
//NSLog(@"WeekdayData is %@",WeekdayData);
//
//NSDictionary *periodsData = [OpeningHourData valueForKey:@"periods"];
//NSString *periodsDataString = [[NSString alloc]initWithFormat:@"%@",periodsData];
//NSLog(@"periodsDataString is %@",periodsDataString);
//
//NSDictionary *closeData = [periodsData valueForKey:@"close"];
//NSDictionary *openData = [periodsData valueForKey:@"open"];
//NSLog(@"closeData is %@",closeData);
//NSLog(@"openData is %@",openData);
//
//NSMutableArray *CloseArray = [[NSMutableArray alloc]init];
//NSMutableArray *OpenArray = [[NSMutableArray alloc]init];
//for (NSDictionary *dict in closeData) {//close data
//    NSString *GetDay = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"day"]];
//    NSString *GetTime = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"time"]];
//    //    NSLog(@"GetDay is %@",GetDay);
//    //    NSLog(@"GetTime is %@",GetTime);
//    
//    NSString *TempString = [[NSString alloc]initWithFormat:@"{\"close\":{\"day\":%@,\"time\":\"%@\"}",GetDay,GetTime];
//    //NSLog(@"TempString is %@",TempString);
//    [CloseArray addObject:TempString];
//}
//
//for (NSDictionary *dict in openData) {//open data
//    NSString *GetDay = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"day"]];
//    NSString *GetTime = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"time"]];
//    //  NSLog(@"GetDay is %@",GetDay);
//    // NSLog(@"GetTime is %@",GetTime);
//    
//    NSString *TempString = [[NSString alloc]initWithFormat:@"\"open\":{\"day\":%@,\"time\":\"%@\"}}",GetDay,GetTime];
//    // NSLog(@"TempString is %@",TempString);
//    [OpenArray addObject:TempString];
//}
//
//NSLog(@"CloseArray is %@",CloseArray);
//NSLog(@"OpenArray is %@",OpenArray);
//
//NSMutableArray *FullArray = [[NSMutableArray alloc]init];
//for (int i = 0; i < [CloseArray count]; i++) {
//    NSString *TestString = [[NSString alloc]initWithFormat:@"%@,%@",[CloseArray objectAtIndex:i],[OpenArray objectAtIndex:i]];
//    [FullArray addObject:TestString];
//}
//
//NSString *greeting = [FullArray componentsJoinedByString:@","];
//NSLog(@"greeting %@",greeting);
//
//NSString *open_nowData = [[NSString alloc]initWithFormat:@"%@",[OpeningHourData valueForKey:@"open_now"]];

