import ComposableArchitecture
import ReactiveSwift
import XCTest

@testable import SwiftUICaseStudies

class AnimationTests: XCTestCase {
  let mainQueue = TestScheduler()

  func testRainbow() {
    let store = TestStore(
      initialState: AnimationsState(),
      reducer: animationsReducer,
      environment: AnimationsEnvironment(
        mainQueue: self.mainQueue
      )
    )

    store.send(.rainbowButtonTapped)

    store.receive(.setColor(.red)) {
      $0.circleColor = .red
    }

    self.mainQueue.advance(by: 1)
    store.receive(.setColor(.blue)) {
      $0.circleColor = .blue
    }

    self.mainQueue.advance(by: 1)
    store.receive(.setColor(.green)) {
      $0.circleColor = .green
    }

    self.mainQueue.advance(by: 1)
    store.receive(.setColor(.orange)) {
      $0.circleColor = .orange
    }

    self.mainQueue.advance(by: 1)
    store.receive(.setColor(.pink)) {
      $0.circleColor = .pink
    }

    self.mainQueue.advance(by: 1)
    store.receive(.setColor(.purple)) {
      $0.circleColor = .purple
    }

    self.mainQueue.advance(by: 1)
    store.receive(.setColor(.yellow)) {
      $0.circleColor = .yellow
    }

    self.mainQueue.advance(by: 1)
    store.receive(.setColor(.black)) {
      $0.circleColor = .black
    }

    self.mainQueue.run()
  }

  func testReset() {
    let mainQueue = TestScheduler()

    let store = TestStore(
      initialState: AnimationsState(),
      reducer: animationsReducer,
      environment: AnimationsEnvironment(
        mainQueue: mainQueue
      )
    )

    store.send(.rainbowButtonTapped)

    store.receive(.setColor(.red)) {
      $0.circleColor = .red
    }

    mainQueue.advance(by: .seconds(1))
    store.receive(.setColor(.blue)) {
      $0.circleColor = .blue
    }

    store.send(.resetButtonTapped) {
      $0.alert = AlertState(
        title: TextState("Reset state?"),
        primaryButton: .destructive(
          TextState("Reset"),
          action: .send(.resetConfirmationButtonTapped, animation: .default)
        ),
        secondaryButton: .cancel(TextState("Cancel"))
      )
    }

    store.send(.resetConfirmationButtonTapped) {
      $0 = AnimationsState()
    }

    mainQueue.run()
  }
}
