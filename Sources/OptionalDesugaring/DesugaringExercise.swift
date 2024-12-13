import Foundation

func desugaringExercise(user: User, appTheme: Style) -> [String : () throws -> Color?] {
    [
        "Step 0: Original code": {
            // This is a snippet of hypothetical code from a hypothetical app that computes the
            // custom background color for a user’s profile screen. It returns the user’s avatar’s
            // style’s background color if it exists; otherwise returns the app’s theme’s default
            // background color.

            return user.avatar?.style.backgroundColor ?? appTheme.backgroundColor

            // This snippet of code contains several things that could be nil. Swift, however, makes
            // a compile time-time guarantee that this code will always treat nil safely -- no such
            // thing as a NilPointerException here!
            //
            // To make this convenient, Swift offers a lot of syntactic sugar. You will remove all
            // this sugar step by step, while preserving Swift's static guarantee of nil safety.
        },

        "Step 1: Remove ?? (nil coalescing)": {
            // Swift’s ??, the “nil-coalescing” operator, takes an optional left-hand side (LHS). It
            // returns the LHS if it is not nil, and the RHS if it is. You first job is to remove
            // the ?? from the code.
            //
            // How can you unwrap an optional value without the help of a special operator? Swift
            // gives us this special syntax:
            //
            //     // optionalValue has type T?
            //     if let unwrapped = optionalValue {
            //         // we only enter this block if optionalValue was not nil,
            //         // and unwrapped has type T
            //     }
            //
            // In other words, putting it all together, this:
            //
            //     let x = a ?? b
            //
            // ...is sugar for this:
            //
            //     let x: SomeType  // or maybe SomeType? if b is also optional
            //     if let aUnwrapped = a {
            //         x = aUnwrapped
            //     } else {
            //         x = b
            //     }
            //
            // Copy the previous implementation here, and remove the nil coalescing.
            //
            // (Make sure that you COPY the previous step forward to each next step!)
            //
            // ⚠️⚠️⚠️
            // Implement this step so that you **only access each property once**, and do not repeat
            // subexpressions. (For example, your solution should say `appTheme.backgroundColor`
            // once.) You can achieve this by creating multiple intermediate variables, just like
            // `x` in the example above.
            
            // Step 1 Implementation
            let fallback = appTheme.backgroundColor
            let potentialColor = user.avatar?.style.backgroundColor

            if let c = potentialColor {
                return c
            } else {
                return fallback
            }

            // Remember to run the tests when you have completed each step!
        },
        
        "Step 2: Remove ?. (optional chaining)": {
            // Swift’s ?. operator, “optional chaining,” makes a property accesses evaluate to nil
            // if the LHS is nil, and otherwise continues following the property chain.
            //
            // In other words, this:
            //
            //     let x = a?.b
            //
            // ...is sugar for this:
            //
            //     let x: T?
            //     if let aUnwrapped = a {
            //         x = aUnwrapped.b
            //     } else {
            //         x = nil
            //     }
            //
            // Note that the ?. operator does not just affect its own node in the AST; it
            // short-circuits an entire _chain_ of property accesses. In other words, this:
            //
            //    let x = a?.b.c.d.e.f.g
            //
            // ...is sugar for this:
            //
            //     let x: T?
            //     if let aUnwrapped = a {
            //         x = aUnwrapped.b.c.d.e.f.g
            //     } else {
            //         x = nil
            //     }
            //
            // Copy the previous method here, and remove all the optional chaining.
            //
            // When you have combined step 1 and step 2, you should end up with something like this:
            //
            //     let firstVariable: SomeType
            //     <code that sets firstVariable to be the result of just the LHS of ??>
            //     –––––––––––––––––––––––
            //     let secondVariable: SomeType
            //     <code that sets secondVariable to be the result of the whole ?? expression,
            //      using firstVariable where appropriate>
            //     –––––––––––––––––––––––
            //     return secondVariable
            
            // Step 2 Implementation
            let fallback = appTheme.backgroundColor

            let avatarOptional = user.avatar
            let primary: Color?

            if let avatarUnwrapped = avatarOptional {
                primary = avatarUnwrapped.style.backgroundColor
            } else {
                primary = nil
            }

            if let c = primary {
                return c
            } else {
                return fallback
            }

            // (You may find that this step is tricky to unpuzzle. The solution is not so terrible,
            // but it’s easy to get tangled up looking for it! For the problems students most
            // commonly encounter on this step, the solution is to take a step back, reread the
            // directions, and **apply the substitutions in the directions more literally**.)
            // 
            // (Ask for a hint if you find yourself going down the rabbit hole.)
        },

        "Step 3: Translate `if let` to `case`": {
            // Swift’s “if let” syntax, “optional binding,” is itself sugar for a case statement
            // that matches the two possible values of the algebraic type Optional, some and none.
            //
            // In other words, this:
            //
            //     if let b = a {
            //         doSomething(b)
            //     } else {
            //         doSomethingElse()
            //     }
            //
            // ...is sugar for this:
            //
            //     switch a {
            //         case .some(let b):
            //             doSomething(b)
            //         case .none:
            //             doSomethingElse()
            //     }
            //
            // Copy the previous implementation here, and remove all the optional binding.

            // Step 3 Implementation
            let fallback = appTheme.backgroundColor
            let avatarOptional = user.avatar
            let primary: Color?

            switch avatarOptional {
            case .some(let avatarUnwrapped):
                primary = avatarUnwrapped.style.backgroundColor
            case .none:
                primary = nil
            }

            switch primary {
            case .some(let c):
                return c
            case .none:
                return fallback
            }

            // (You’re remembering to rerun the tests after each step, right?)
        },

        "Step 4: Translate optional type names to full form": {
            // The type syntax T? is sugar for Optional<T>. Desugar any types that use the T? syntax.
            //
            // Also, in Swift, nil is sugar for Optional.none. Your implementation might not actually
            // use nil at all, but if it does, replace it with Optional.none instead. (You can also
            // say .none instead of Optional.none if Swift can already infer that it’s an Optional
            // from context, but for this exercise, we’re spelling everything out in full!)

            //Step 4 implementation
            let fallback: Optional<Color> = appTheme.backgroundColor
            let avatarOptional: Optional<StyledImage> = user.avatar
            let primary: Optional<Color>

            switch avatarOptional {
            case .some(let avatarUnwrapped):
                primary = avatarUnwrapped.style.backgroundColor
            case .none:
                primary = Optional.none
            }

            switch primary {
            case .some(let c):
                return c
            case .none:
                return fallback
            }
        },

        "Step 5: Make implicit optional wrapping explicit": {
            // If you use an expression x of type T in a context that expects Optional<T>, you do
            // not need to explicitly wrap x in Optional.some(...); Swift will do it for you.
            //
            // This bit of sugar is hard to spot, but it is still sugar, and it is specific to
            // optionals. With any other enum, you would need to explicitly wrap the result, but for
            // Optional, Swift will magically add Optional.some(...) for you if necessary.
            //
            // In other words, this:
            //
            //     let x: T = ...   // x is not an optional, i.e. it is not an Optional<T>, just a T
            //     let y: T? = x    // y magically becomes an Optional<T>
            //
            // ...is sugar for this:
            //
            //     let x: T = ...
            //     let y: T? = Optional.some(x)
            //
            // Note that this only applies above when x is _not_ optional but y _is_. Here there
            // is no wrapping, because x is already an Optional value:
            //
            //     let x: T? = ...
            //     let y: T? = x    // No sugar here; x is already optional
            //
            // Copy the previous implementation here and remove Swift’s automatic Optional wrapping.
            
            // Step 5 Implementation
               let fallback: Optional<Color> = appTheme.backgroundColor
               // `user.avatar` is Optional<StyledImage> already, no wrapping needed.
               let avatarOptional: Optional<StyledImage> = user.avatar
               let primary: Optional<Color>

               switch avatarOptional {
               case .some(let avatarUnwrapped):
                   // `avatarUnwrapped.style.backgroundColor` is already Optional<Color>, so no extra wrapping needed.
                   primary = avatarUnwrapped.style.backgroundColor
               case .none:
                   primary = Optional.none
               }

               switch primary {
               case .some(let c):
                   // `c` is a Color, but we need to return a Color?
                   // Previously, `return c` would implicitly wrap `c` into Optional.some(c).
                   // Now we must write it explicitly:
                   return Optional.some(c)

               case .none:
                   // `fallback` is already Optional<Color>, so no wrapping needed:
                   return fallback
               }
           },

        "Step 6: Verify desugaring using FakeOptional": { try { () -> FakeOptional<Color> in  // 🚨 DO NOT MODIFY THIS LINE! It ensures that you are returning a FakeOptional.
            // Finally, a correctness check. This project declares an enum type named FakeOptional
            // which has exactly the same structure as Swift’s Optional, but is a separate,
            // unrelated type.
            //
            // Because it is a different type, Swift will not let you use **any** Optional sugar
            // with FakeOptional. You can use this to verify your desugaring: replace Optional →
            // FakeOptional in your implementation, then convert back to a real Optional only at
            // the very end.
            //
            // Here's how:
            //
            // - Anywhere you use the type name Optional, replace it with FakeOptional.
            // - Anywhere you use the two model properties that return Optional, convert them to
            //   FakeOptional instead:
            //     - Replace .avatar → .avatar.fakeOptional
            //     - Replace .backgroundColor → .backgroundColor.fakeOptional
            //
            // After doing this, your code should still compile and all the tests should still pass.

            let fallback: FakeOptional<Color> = appTheme.backgroundColor.fakeOptional
               let avatarOptional: FakeOptional<StyledImage> = user.avatar.fakeOptional
               let primary: FakeOptional<Color>

               switch avatarOptional {
               case .some(let avatarUnwrapped):
                   primary = avatarUnwrapped.style.backgroundColor.fakeOptional
               case .none:
                   primary = FakeOptional.none
               }

               switch primary {
               case .some(let c):
                   return FakeOptional.some(c)
               case .none:
                   return fallback
               }

            // Run the tests one more time, and make sure it says:
            //
            //     Test Suite 'All tests' passed
            //
            // ...at the end of the output. Note that the tests only check whether your logic is
            // correct, but do *not* check whether you removed all the sugar correctly. That you
            // have to check carefully with your own eyes.

        }().realOptional },  // 🚨 DO NOT MODIFY THIS LINE! It turns your FakeOptional result back into a real one.
    ]
}

struct ExerciseStepUnimplemented: Error {
    let file: String
    let line: Int

    init(file: String = #fileID, line: Int = #line) {
        self.file = file
        self.line = line
    }
}
