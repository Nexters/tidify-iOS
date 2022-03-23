//
//  OnboardingSpec.swift
//  TidifyTests
//
//  Created by Ian on 2022/03/22.
//

import Nimble
import Quick

@testable import Tidify

class OnboardingSpec: QuickSpec {
  override func spec() {
    var viewModel: OnboardingViewModel!
    var viewController: OnboardingViewController!

    describe("Onboarding ViewController") {
      beforeEach {
        viewModel = OnboardingViewModel()
        viewController = OnboardingViewController(viewModel: viewModel)
        _ = viewController.view
      }
      context("when view is loaded") {
        it("collectionView should have same item count with viewModel's dataSources count") {
          expect(viewController.collectionView.numberOfItems(inSection: 0))
            .to(equal(viewModel.onboardingDataSource.count))
        }
      }
    }
    afterEach {
      viewModel = nil
      viewController = nil
    }
  }
}
