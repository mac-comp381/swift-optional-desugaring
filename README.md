# Swift optional desugaring

### Setup

```bash
cd optional-desugaring
swift test
```

You should see 6 tests run, with one failing:

```
...
OptionalDesugaringTests.swift:61: error: -[OptionalDesugaringTests.OptionalDesugaringTests testAllDesugaringsImplemented] : XCTAssertEqual failed: ("1") is not equal to ("7") - Not all desugarings are implemented yet
...
...other stuff...
...
Test Suite 'OptionalDesugaringTests' failed at 2018-04-24 00:57:59.712.
     Executed 6 tests, with 1 failure (0 unexpected) in 0.234 (0.234) seconds
```

The one failure indicates that you have not yet completed all the desugaring tasks.

If you are on a Mac and you want to use Xcode, run:

```bash
swift package generate-xcodeproj
open OptionalDesugaring.xcodeproj
```

You can run the tests in Xcode with cmd-U.

### Your task

Briefly study the model in `Sources/Model.swift`. This example shows an app in which users may have a custom avatars and theme colors for their profile.

Take a look in `Sources/OptionalDesugaring/ProfileScreen.swift`. This file has a `headerBackgroundColor` computed property which returns the user’s custom background color if present, and the app’s default otherwise. The model is contrived so that several different things are optional, but the implementation correctly handles all of them using Swift’s syntactic sugar.

Underneath it, you will see a `headerBackgroundColorDesugarings` property that returns an array of results, all but the first commented out. For each commented-out entry in the array:

- Uncomment it.
- Run `swift test` and make sure the tests fail. (You should see a message like `Exited with signal code 4`, caused by the `fatalError` that now runs because of the line you uncommented.)
- Find the corresponding `headerBackgroundColor_desugaring_xxxx` implementation below.
- Copy the body of the previous implementation of `headerBackgroundColor` forward into it, replacing the `fatalError` line.
- Follow the instructions in the comment to update the new implementation.
- Run `swift test` again, making sure that your newly desugared implementation passes.

When you are done, you should see all tests passing.
