import ComposableArchitecture
import ReactiveSwift
import XCTest

@testable import SwiftUICaseStudies

@MainActor
class EffectsBasicsTests: XCTestCase {
  func testCountDown() async {
    let store = TestStore(
      initialState: EffectsBasicsState(),
      reducer: effectsBasicsReducer,
      environment: .unimplemented
    )

    store.environment.mainQueue = ImmediateScheduler()

    await store.send(.incrementButtonTapped) {
      $0.count = 1
    }
    await store.send(.decrementButtonTapped) {
      $0.count = 0
    }
  }

  func testNumberFact() async {
    let store = TestStore(
      initialState: EffectsBasicsState(),
      reducer: effectsBasicsReducer,
      environment: .unimplemented
    )

    store.environment.fact.fetch = { "\($0) is a good number Brent" }
    store.environment.mainQueue = ImmediateScheduler()

    await store.send(.incrementButtonTapped) {
      $0.count = 1
    }
    await store.send(.numberFactButtonTapped) {
      $0.isNumberFactRequestInFlight = true
    }
    await store.receive(.numberFactResponse(.success("1 is a good number Brent"))) {
      $0.isNumberFactRequestInFlight = false
      $0.numberFact = "1 is a good number Brent"
    }
  }

  func testDecrement() async {
    let store = TestStore(
      initialState: EffectsBasicsState(),
      reducer: effectsBasicsReducer,
      environment: .unimplemented
    )

    store.environment.mainQueue = ImmediateScheduler()

    await store.send(.decrementButtonTapped) {
      $0.count = -1
    }
    await store.receive(.decrementDelayResponse) {
      $0.count = 0
    }
  }

  func testDecrementCancellation() async {
    let store = TestStore(
      initialState: EffectsBasicsState(),
      reducer: effectsBasicsReducer,
      environment: .unimplemented
    )

    store.environment.mainQueue = TestScheduler()

    await store.send(.decrementButtonTapped) {
      $0.count = -1
    }
    await store.send(.incrementButtonTapped) {
      $0.count = 0
    }
  }
}

extension EffectsBasicsEnvironment {
  static let unimplemented = Self(
    fact: .unimplemented,
    mainQueue: UnimplementedScheduler()
  )
}
