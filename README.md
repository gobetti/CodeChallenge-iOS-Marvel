[![Build Status](https://travis-ci.com/gobetti/CodeChallenge-iOS-Marvel.svg)](https://travis-ci.com/gobetti/CodeChallenge-iOS-Marvel) [![codecov.io](http://codecov.io/github/gobetti/CodeChallenge-iOS-Marvel/coverage.svg?branch=master)](http://codecov.io/github/gobetti/CodeChallenge-iOS-Marvel?branch=master)

# CodeChallenge-iOS-Marvel

## Build instructions

Run `pod install` and launch `Marvel.xcworkspace`

## Run instructions

Replace in [`Marvel/API/MarvelApiAuthorization.swift`](https://github.com/gobetti/CodeChallenge-iOS-Marvel/blob/master/Marvel/API/MarvelApiAuthorization.swift#L13-L14) the value of the constants `publicAPIKey` and `privateAPIKey` by valid Marvel API keys.

## Architecture

<img src="https://github.com/gobetti/CodeChallenge-iOS-Marvel/raw/master/Resources/diagram.png" />

- MVVM is the presentation pattern.
- The `ViewModel` encapsulates business logic by providing pure functions which transform input streams into output streams. This layer uses the power of Rx operators for these transformations, without subscribing to any of its passive streams, ensuring all subscriptions begin and end in the `View` layer respecting its lifecycle. Also, `errors` are never emitted to the `View`, which is ensured in compile-time through `Drivers`.
- The `View` subscribes to the `ViewModel` streams, binding them to UI components.
- The network layer is connected to the `ViewModel` through `Services`, which map `Data` streams into domain-specific models (using Swift's `JSONDecoder`)
- `Services` on their turn are the connection to `RxCocoaNetworking`: they encapsulate a `Provider`, which is responsible for firing network requests according to the API specifications. These specs are coded in entities implementing `ProductionTargetType` or `TargetType` - in this repository, `MarvelApi` represents such entity.