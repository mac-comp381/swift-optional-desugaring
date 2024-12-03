# Swift Optional Desugaring

## Setup

[Install Swift](https://www.swift.org/install/). Post in the class channel if you encounter problems! If you do, there’s a good chance you’re not the only one.

Open a terminal / console **in this project’s directory**, and run the tests:

```bash
swift test
```

You should see 6 tests run, with one failing:

```
...
<lots of output>
...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Steps implemented:

✅ Step 0: Original code
❌ Step 1: Remove ?? (nil coalescing)                 (in OptionalDesugaring/DesugaringExercise.swift, line 50)
❌ Step 2: Remove ?. (optional chaining)              (in OptionalDesugaring/DesugaringExercise.swift, line 88)
❌ Step 3: Translate `if let` to `case`               (in OptionalDesugaring/DesugaringExercise.swift, line 118)
❌ Step 4: Translate optional type names to full form (in OptionalDesugaring/DesugaringExercise.swift, line 131)
❌ Step 5: Make implicit optional wrapping explicit   (in OptionalDesugaring/DesugaringExercise.swift, line 160)
❌ Step 6: Verify desugaring using FakeOptional       (in OptionalDesugaring/DesugaringExercise.swift, line 184)

NOTE: The list above only indicates whether a step is implemented,
      not whether it is full desugared or working correctly.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
...
<lots more output>
...
Test Suite 'All tests' failed at 2021-11-24 16:49:29.414.
	 Executed 6 tests, with 1 failure (0 unexpected) in 0.212 (0.214) seconds
```

The one failure indicates that you have not yet completed all the desugaring tasks.

If you are on a Mac, you can also open the project directory in Xcode and run the tests with cmd-U.

## Your task

Briefly study the model in `Sources/Model.swift`. This example shows an app in which users may have a custom avatars and theme colors for their profile.

Take a look in `Sources/OptionalDesugaring/DesugaringExercise.swift`. This file starts with a snippet of code that returns the user’s custom background color if present, and the app’s default otherwise. The model is contrived so that several different things here are optional, but the implementation correctly handles all of them using Swift’s syntactic sugar.

Follow the instructions in the file to successively remove Swift’s syntactic sugar for optionals.

When you are done, double check that all the tests passing, then commit and push.
