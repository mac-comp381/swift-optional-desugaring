import XCTest
@testable import OptionalDesugaring

#if os(Windows)  // Windows cmd & Powershell are both terrible at handling Unicode
    let notCompletedIcon = "[NOT IMPLEMENTED]"
    let completedIcon = String(repeating: " ", count: notCompletedIcon.count)
    let testFailureIcon = "TEST FAILURE:"
    let listBullet = "-"
    let dividerLine = String(repeating: "-", count: 80)
#else
    let completedIcon = "✅"
    let notCompletedIcon = "❌"
    let testFailureIcon = "❌"
    let listBullet = "•"
    let dividerLine = String(repeating: "━", count: 80)
#endif

class OptionalDesugaringTests: XCTestCase {
    private static var desugarings: Set<String> = []
    private static var desugaringsUnimplemented: [String:ExerciseStepUnimplemented] = [:]

    let theme0 = Style(
        backgroundColor: nil,
        foregroundColor: .fulvous)

    let theme1 = Style(
        backgroundColor: .fuchsia,
        foregroundColor: .smaragdine)

    let theme2 = Style(
        backgroundColor: .mauve,
        foregroundColor: .wenge)

    func testAvatarHasBackgroundColor() {
        assertBackgroundColorDesugarings(
            allEqual: Color.mauve,
            forAvatarStyle: theme2,
            appTheme: theme1)
    }

    func testAvatarHasNoBackgroundColor() {
        assertBackgroundColorDesugarings(
            allEqual: Color.fuchsia,
            forAvatarStyle: theme0,
            appTheme: theme1)
    }

    func testAvatarAndAppThemeBothHaveNoBackgroundColor() {
        assertBackgroundColorDesugarings(
            allEqual: nil,
            forAvatarStyle: theme0,
            appTheme: theme0)
    }

    func testNoAvatar() {
        assertBackgroundColorDesugarings(
            allEqual: Color.mauve,
            forAvatarStyle: nil,
            appTheme: theme2)
    }

    func testNoStylesAtAll() {
        assertBackgroundColorDesugarings(
            allEqual: nil,
            forAvatarStyle: nil,
            appTheme: theme0)
    }

    private func assertBackgroundColorDesugarings(
            allEqual expectedValue: Color?,
            forAvatarStyle avatarStyle: Style?,
            appTheme: Style
    ) {
        let avatar: StyledImage?
        if let avatarStyle = avatarStyle {
            avatar = StyledImage(image: Image(), style: avatarStyle)
        } else {
            avatar = nil
        }
        let user = User(name: "Sally Nguyen", avatar: avatar)

        for (stepName, sugaringFunc) in desugaringExercise(user: user, appTheme: appTheme) {
            Self.desugarings.insert(stepName)
            do {
                let result = try sugaringFunc()
                XCTAssertEqual(expectedValue, result, {
                    func describe<T>(_ value: T?) -> String {
                        if let value = value {
                            return String(describing: value)
                        } else {
                            return "nil"
                        }
                    }
                    var explanation = "\n\n\(testFailureIcon) Wrong value `\(describe(result))` returned by \"\(stepName)\" when:"

                    func describeNilness<T>(of color: T?, nameInExercise: String) {
                        explanation += "\n    \(listBullet) \(nameInExercise) = \(describe(color))"
                    }
                    describeNilness(of: (avatar == nil ? nil : "not nil"), nameInExercise: "user.avatar")
                    if user.avatar != nil {
                        describeNilness(
                            of: avatarStyle?.backgroundColor,
                            nameInExercise: "user.avatar.style.backgroundColor")
                    }
                    describeNilness(
                        of: appTheme.backgroundColor,
                        nameInExercise: "appTheme.backgroundColor")
                    return explanation + "\n"
                }())
            } catch let unimplementedError as ExerciseStepUnimplemented {
                Self.desugaringsUnimplemented[stepName] = unimplementedError
            } catch let error {
                XCTFail("\(error)")
            }
        }
    }

    func testZZZ_allDesugaringsAreImplemented() {  // test run in lexical order, so name makes this test run last
        if Self.desugarings.isEmpty {
            XCTFail("At least one of the desugaring tests needs to run before this test runs")
        }

        print(dividerLine)
        print("Steps implemented:")
        print()
        let maxStepNameWidth = Self.desugarings.lazy.map(\.count).max() ?? 0
        for stepName in Self.desugarings.sorted() {
            if let unimplemented = Self.desugaringsUnimplemented[stepName] {
                print(
                    notCompletedIcon,
                    stepName.padded(with: " ", toWidth: maxStepNameWidth),
                    "(in \(unimplemented.file), line \(unimplemented.line))")
            } else {
                print(completedIcon, stepName)
            }
        }
        print()
        print("NOTE: The list above only indicates whether a step is implemented,")
        print("      not whether it is full desugared or working correctly.")
        print(dividerLine)

        if !Self.desugaringsUnimplemented.isEmpty {
            XCTFail("Some desugaring steps are not yet implemented")
        }
    }
}

extension String {
    func padded(with padding: Character, toWidth width: Int) -> String {
        self + String(repeating: padding, count: max(0, width - self.count))
    }
}
