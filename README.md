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

## Code coverage

Unfortunately, a very high coverage (even 100%) does not mean that all possible scenarios have been tested. It does mean, however, that at least for the proposed scenarios, certain blocks of code have been run at least once during unit or UI tests without crashing. That's why I personally like this metric as a great way to detect unused, untestable or potentially unsafe code - nothing else.

With that in mind, this repository is set up with [codecov](https://codecov.io), to which code coverage reports are sent at the end of every successful CI build. `codecov` will then reject a commit that has added untested code. That's why you will see "failed" builds (with a ❌ sign) in the [list of commits](https://github.com/gobetti/CodeChallenge-iOS-Marvel/commits/master). I have ensured that all _reachable_ paths are at least executed by tests (methods `required` by Swift but `unavailable` are among the rare unreachable exceptions). [This dirty hack](https://github.com/gobetti/CodeChallenge-iOS-Marvel/commit/09f49f54852f4994d538a52906e827a88a9ff6da) was a sacrifice in name of a more trustworthy coverage metric. On the other hand, I have probably missed testing important scenarios.

IMHO, the best way to stay productive _and_ testable is to add only essential tests at first, considering the "happy path" and any other obviously possible paths that come to mind, leaving edge cases to be added once a bug is actually found or whenever a code reviewer suggests something new.

Finally, I like tests as a replacement for embedded documentation. If this were a project following BDD, with technical specifications written in that format by the QA team before reaching the development team, [Quick+Nimble](https://github.com/Quick/Nimble) would be a great fit. I ended up not using it because it [integrates with RxBlocking](https://github.com/RxSwiftCommunity/RxNimble) rather than [RxTest](https://github.com/gobetti/CocoaHeads-RxTest), and as of today, I consider the later to be far superior for testing Rx code.

## 🚧 WIP

This project is still a big work in progress. Crucial details have been left behind, especially from a UI/UX perspective, for example:

- No loading indicators
- No animations
- No images

Please feel free to check [this other similar repository](https://github.com/gobetti/CodeChallenge-iOS-TMDB) where I've invested a little time on the items above, but don't expect anything fancy 😬

My main concern today with the code itself is [the existence of test code in the production target](https://github.com/gobetti/CodeChallenge-iOS-Marvel/blob/master/Marvel/Navigator.swift), which was done in order to allow network-free UI tests. One of the goals of `RxCocoaNetworking` was to keep `Moya`'s ease of testing while allowing to keep test code out of the production target - that strategy works for unit tests but not for UI tests because we can't add any code there.
