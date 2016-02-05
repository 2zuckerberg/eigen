import Quick
import Nimble
import Nimble_Snapshots
import Foundation
import Interstellar
import OHHTTPStubs
@testable
import Artsy

class AuctionRegistrationStatusNetworkModelSpec: QuickSpec {
    override func spec() {
        let bidderJSON: NSArray = [["id": "bidder", "sale": ["id": "sale"]]]

        afterEach {
            OHHTTPStubs.removeAllStubs()
            ARUserManager.clearUserData()
        }

        it("returns registered when bidders endpoint returns >=1 bidders") {
            ARUserManager.stubAndLoginWithUsername()
            OHHTTPStubs.stubJSONResponseAtPath("/api/v1/me/bidders", withResponse: bidderJSON)

            let subject = AuctionRegistrationStatusNetworkModel()

            var registrationStatus: ArtsyAPISaleRegistrationStatus?
            waitUntil { done in
                subject.fetchRegistrationStatus("whatever", callback: { result in
                    if case .Success(let r) = result {
                        registrationStatus = r
                    }
                    done()
                })
            }

            expect(registrationStatus) == ArtsyAPISaleRegistrationStatusRegistered
        }

        it("returns not registered when bidders endpoint returns zero bidders") {
            ARUserManager.stubAndLoginWithUsername()
            OHHTTPStubs.stubJSONResponseAtPath("/api/v1/me/bidders", withResponse: [])

            let subject = AuctionRegistrationStatusNetworkModel()

            var registrationStatus: ArtsyAPISaleRegistrationStatus?
            waitUntil { done in
                subject.fetchRegistrationStatus("whatever", callback: { result in
                    if case .Success(let r) = result {
                        registrationStatus = r
                    }
                    done()
                })
            }

            expect(registrationStatus) == ArtsyAPISaleRegistrationStatusNotRegistered
        }

        it("returns not logged in when user is not logged in") {
            let subject = AuctionRegistrationStatusNetworkModel()

            var registrationStatus: ArtsyAPISaleRegistrationStatus?
            waitUntil { done in
                subject.fetchRegistrationStatus("whatever", callback: { result in
                    if case .Success(let r) = result {
                        registrationStatus = r
                    }
                    done()
                })
            }

            expect(registrationStatus) == ArtsyAPISaleRegistrationStatusNotLoggedIn
        }



        it("caches the fetched result") {
            ARUserManager.stubAndLoginWithUsername()
            OHHTTPStubs.stubJSONResponseAtPath("/api/v1/me/bidders", withResponse: bidderJSON)

            let subject = AuctionRegistrationStatusNetworkModel()

            waitUntil { done in
                subject.fetchRegistrationStatus("whatever", callback: { result in
                    done()
                })
            }

            expect(subject.registrationStatus) == ArtsyAPISaleRegistrationStatusRegistered
        }
    }
}