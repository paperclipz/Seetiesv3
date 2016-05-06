//
//  CTFeedModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "Model.h"

//@class Location;
//@class ProfileModel;
//@class PhotoModel;
@class DraftModel;
@class AnnouncementModel;

#import "PaginationModel.h"
@protocol CTFeedTypeModel @end
@protocol CTFeedCollectionModel @end


@interface CTFeedTypeModel : JSONModel
@property(nonatomic,assign)FeedType feedType;//non json attributes
@property(nonatomic,assign)FeedType tempType;//non json attributes

@property(nonatomic,strong)DraftModel<Ignore>* newsFeedData;
@property(nonatomic,strong)NSArray<CollectionModel>* arrCollections;
@property(nonatomic,strong)NSArray<ProfileModel *>* arrSuggestedFeature;
@property(nonatomic,strong)NSArray<DraftModel>* arrPosts;
@property(nonatomic,strong)CollectionModel<Ignore>* followingCollectionData;
@property(nonatomic,strong)NSDictionary* dictData;
@property(nonatomic,strong)AnnouncementModel* announcementData;

@end



@interface NewsFeedModels : PaginationModel

@property(nonatomic,strong)NSArray<CTFeedTypeModel>* items;


@end
