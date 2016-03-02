#import <Mantle/Mantle.h>

#import "ARAppConstants.h"
#import "Sale.h"
#import "Bidder.h"
#import "BidderPosition.h"
#import "Bid.h"
#import "ARAppConstants.h"

@class Artwork;

typedef NS_ENUM(NSInteger, ARReserveStatus) {
    ARReserveStatusNoReserve,
    ARReserveStatusReserveNotMet,
    ARReserveStatusReserveMet
};

NS_ASSUME_NONNULL_BEGIN


@interface SaleArtwork : MTLModel <MTLJSONSerializing>

- (BidderPosition *_Nullable)userMaxBidderPosition;
- (BOOL)hasEstimate;
- (NSString *)estimateString;
- (NSString *)numberOfBidsString;
- (NSString *)highestOrStartingBidString;

@property (nonatomic, copy, readonly) NSString *saleArtworkID;
@property (nonatomic, strong) Sale *_Nullable auction;
@property (nonatomic, strong) Bidder *_Nullable bidder;
@property (nonatomic, strong) Bid *_Nullable saleHighestBid;
@property (nonatomic, strong) NSNumber *artworkNumPositions;
@property (nonatomic, strong) BidderPosition *_Nullable userBidderPosition;
@property (nonatomic, strong) NSArray *positions;
@property (nonatomic, strong) NSNumber *_Nullable openingBidCents;
@property (nonatomic, strong) NSNumber *minimumNextBidCents;
@property (nonatomic, strong) NSNumber *_Nullable lowEstimateCents;
@property (nonatomic, strong) NSNumber *_Nullable highEstimateCents;
@property (nonatomic, strong) NSNumber *_Nullable bidCount;
@property (nonatomic, copy, readonly) NSNumber *_Nullable lotNumber;
@property (nonatomic, assign, readonly) ARAuctionState auctionState;
@property (nonatomic, assign) ARReserveStatus reserveStatus;
@property (nonatomic, strong, readonly) Artwork *artwork;

@end

NS_ASSUME_NONNULL_END
