import Quick
import Nimble
import Nimble_Snapshots
import Foundation
import Interstellar
@testable
import Artsy

class AuctionNetworkModelSpec: QuickSpec {
    override func spec() {
        let saleID = "the-🎉-sale"
        let sale = try! Sale(dictionary: ["name": "The 🎉 Sale"], error: Void())
        let saleArtworks = [SaleArtwork()] as [SaleArtwork]

        var subject: AuctionNetworkModel!
        var saleNetworkModel: Test_AuctionSaleNetworkModel!
        var saleArtworksNetworkModel: Test_AuctionSaleArtworksNetworkModel!
        var registrationStatusNetworkModel: Test_AuctionRegistrationStatusNetworkModel!

        beforeEach {
            saleNetworkModel = Test_AuctionSaleNetworkModel(result: .Success(sale))
            saleArtworksNetworkModel = Test_AuctionSaleArtworksNetworkModel(result: Result.Success(saleArtworks))
            registrationStatusNetworkModel = Test_AuctionRegistrationStatusNetworkModel(result: .Success(ArtsyAPISaleRegistrationStatusNotLoggedIn))

            subject = AuctionNetworkModel(saleID: saleID)
            subject.saleNetworkModel = saleNetworkModel
            subject.saleArtworksNetworkModel = saleArtworksNetworkModel
            subject.registrationStatusNetworkModel = registrationStatusNetworkModel
        }

        it("initializes correctly") {
            expect(subject.saleID) == saleID
        }

        describe("registrationStatus") {
            it("works when not logged in") {
                registrationStatusNetworkModel.registrationStatus = ArtsyAPISaleRegistrationStatusNotLoggedIn
                expect(subject.registrationStatus) == ArtsyAPISaleRegistrationStatusNotLoggedIn
            }

            it("works when registered") {
                registrationStatusNetworkModel.registrationStatus = ArtsyAPISaleRegistrationStatusRegistered
                expect(subject.registrationStatus) == ArtsyAPISaleRegistrationStatusRegistered
            }

            it("works when not registered") {
                registrationStatusNetworkModel.registrationStatus = ArtsyAPISaleRegistrationStatusNotRegistered
                expect(subject.registrationStatus) == ArtsyAPISaleRegistrationStatusNotRegistered
            }
        }

        describe("network fetching") {
            it("fetches") {
                waitUntil { done in
                    subject.fetch().next { _ in
                        done()
                    }
                }
            }

            it("fetches a sale view model") {
                var saleViewModel: SaleViewModel!

                waitUntil { done in
                    subject.fetch().next {
                        saleViewModel = $0
                        done()
                    }
                }

                expect(saleViewModel.numberOfLots) == saleArtworks.count
                expect(saleViewModel.displayName) == sale.name
            }

            it("caches fetched sale view model") {
                var saleViewModel: SaleViewModel!

                waitUntil { done in
                    subject.fetch().next {
                        saleViewModel = $0
                        done()
                    }
                }

                expect(subject.saleViewModel) === saleViewModel
            }

            it("fetches registration status") {
                waitUntil { done in
                    subject.fetch().next { _ in
                        done()
                    }
                }

                expect(registrationStatusNetworkModel.called) == true
            }

            it("fetches the sale") {
                waitUntil { done in
                    subject.fetch().next { _ in
                        done()
                    }
                }

                expect(saleNetworkModel.called) == true
            }

            it("fetches the sale artworks") {
                waitUntil { done in
                    subject.fetch().next { _ in
                        done()
                    }
                }

                expect(saleArtworksNetworkModel.called) == true
            }
        }
    }
}

class Test_AuctionSaleNetworkModel: AuctionSaleNetworkModelType {
    let result: Result<Sale>
    var called = false

    init(result: Result<Sale>) {
        self.result = result
    }

    func fetchSale(saleID: String, callback: Result<Sale> -> Void) {
        called = true
        callback(result)
    }
}

class Test_AuctionSaleArtworksNetworkModel: AuctionSaleArtworksNetworkModelType {
    let result: Result<[SaleArtwork]>
    var called = false

    init(result: Result<[SaleArtwork]>) {
        self.result = result
    }

    func fetchSaleArtworks(saleID: String, callback: Result<[SaleArtwork]> -> Void) {
        called = true
        callback(result)
    }
}

class Test_AuctionRegistrationStatusNetworkModel: AuctionRegistrationStatusNetworkModelType {
    var registrationStatus: ArtsyAPISaleRegistrationStatus?
    let result: Result<ArtsyAPISaleRegistrationStatus>
    var called = false

    init(result: Result<ArtsyAPISaleRegistrationStatus>) {
        self.result = result
    }
    
    func fetchRegistrationStatus(saleID: String, callback: Result<ArtsyAPISaleRegistrationStatus> -> Void) {
        called = true
        callback(result)
    }
}
