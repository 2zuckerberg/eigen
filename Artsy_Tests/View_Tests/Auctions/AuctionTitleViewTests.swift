import Quick
import Nimble
import Nimble_Snapshots
import UIKit
import Forgeries
@testable
import Artsy


class AuctionTitleViewSpec: QuickSpec {
    override func spec() {
        let sale = try! Sale(dictionary: ["name": "The 🎉 Sale"], error: Void())
        let viewModel = SaleViewModel(sale: sale, saleArtworks: [])
        
        let delegate = Test_AuctionTitleViewDelegate()
        var fullWidth: Bool!

        sharedExamples("title view") { (context: SharedExampleContext) in
            it("looks good without a registration status") {
                let subject = AuctionTitleView(viewModel: viewModel, registrationStatus: nil, delegate: delegate, fullWidth: fullWidth, showAdditionalInformation: true)
                subject.bounds.size.width = 400

                expect(subject).to( haveValidSnapshot() )
            }

            it("looks good with a logged out registration status") {
                let subject = AuctionTitleView(viewModel: viewModel, registrationStatus: ArtsyAPISaleRegistrationStatusNotLoggedIn, delegate: delegate, fullWidth: fullWidth, showAdditionalInformation: true)
                subject.bounds.size.width = 400

                expect(subject).to( haveValidSnapshot() )
            }

            it("looks good with a not registered registration status") {
                let subject = AuctionTitleView(viewModel: viewModel, registrationStatus: ArtsyAPISaleRegistrationStatusNotRegistered, delegate: delegate, fullWidth: fullWidth, showAdditionalInformation: true)
                subject.bounds.size.width = 400

                expect(subject).to( haveValidSnapshot() )
            }

            it("looks good with a registered registration status") {
                let subject = AuctionTitleView(viewModel: viewModel, registrationStatus: ArtsyAPISaleRegistrationStatusRegistered, delegate: delegate, fullWidth: fullWidth, showAdditionalInformation: true)
                subject.bounds.size.width = 400

                expect(subject).to( haveValidSnapshot() )
            }
            
            it("looks good without a info button") {
                let subject = AuctionTitleView(viewModel: viewModel, registrationStatus: ArtsyAPISaleRegistrationStatusRegistered, delegate: delegate, fullWidth: fullWidth, showAdditionalInformation: false)
                subject.bounds.size.width = 400
                
                expect(subject).to( haveValidSnapshot() )
            }
        }

        describe("with the registration button having side insets") {
            beforeEach {
                fullWidth = false
            }
            itBehavesLike("title view")
        }

        describe("with the registration button spanning the full width") {
            beforeEach {
                fullWidth = true
            }
            itBehavesLike("title view")
        }
    }
}

class Test_AuctionTitleViewDelegate: AuctionTitleViewDelegate {
    @objc func userDidPressInfo(titleView: AuctionTitleView) { }
    @objc func userDidPressRegister(titleView: AuctionTitleView) { }
}
