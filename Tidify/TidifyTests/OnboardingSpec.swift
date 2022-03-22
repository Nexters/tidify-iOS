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

    describe("Onboarding ViewModel") {
      beforeEach {
        viewModel = OnboardingViewModel()
      }
      context("When Created") {
        it("contents count will be 5", closure: {
          expect(viewModel.onboardingDataSource.count).to(equal(5))
        })
      }
    }
    afterEach {
      viewModel = nil
    }
  }
}
