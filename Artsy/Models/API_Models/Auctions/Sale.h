#import <Mantle/Mantle.h>
#import "ARSpotlight.h"

@class BuyersPremium, Profile;
@class AFHTTPRequestOperation;


@interface Sale : MTLModel <MTLJSONSerializing, ARSpotlightMetadataProvider>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *saleID;
@property (nonatomic, copy, readonly) NSString *saleDescription;

@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, strong, readonly) NSDate *endDate;

@property (nonatomic, strong, readonly) BuyersPremium *buyersPremium;

@property (nonatomic, strong) Profile *profile;

@property (nonatomic, readonly) BOOL isAuction;

- (NSString *)bannerImageURLString;
- (BOOL)isCurrentlyActive;
- (BOOL)hasBuyersPremium;

- (AFHTTPRequestOperation *)getArtworks:(void (^)(NSArray *artworks))success;

@end
