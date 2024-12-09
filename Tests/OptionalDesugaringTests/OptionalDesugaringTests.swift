import Testing
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

struct OptionalDesugaringTests {
    let theme0 = Style(
        backgroundColor: nil,
        foregroundColor: .fulvous)

    let theme1 = Style(
        backgroundColor: .fuchsia,
        foregroundColor: .smaragdine)

    let theme2 = Style(
        backgroundColor: .mauve,
        foregroundColor: .wenge)

    @Test
    func avatarHasBackgroundColor() {
        assertBackgroundColorDesugarings(
            allEqual: Color.mauve,
            forAvatarStyle: theme2,
            appTheme: theme1)
    }

    @Test
    func avatarHasNoBackgroundColor() {
        assertBackgroundColorDesugarings(
            allEqual: Color.fuchsia,
            forAvatarStyle: theme0,
            appTheme: theme1)
    }

    @Test
    func avatarAndAppThemeBothHaveNoBackgroundColor() {
        assertBackgroundColorDesugarings(
            allEqual: nil,
            forAvatarStyle: theme0,
            appTheme: theme0)
    }

    @Test
    func noAvatar() {
        assertBackgroundColorDesugarings(
            allEqual: Color.mauve,
            forAvatarStyle: nil,
            appTheme: theme2)
    }

    @Test
    func noStylesAtAll() {
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
            do {
                let result = try sugaringFunc()
                #expect(expectedValue == result, {
                    func describe<T>(_ value: T?) -> String {
                        if let value = value {
                            return String(describing: value)
                        } else {
                            return "nil"
                        }
                    }
                    var explanation = "\n\n\(testFailureIcon) Wrong value `\(describe(result))` returned by \"\(stepName)\" when:"

                    func describeNilness<T>(of color: T?, usingName name: String) {
                        explanation += "\n    \(listBullet) \(name) = \(describe(color))"
                    }
                    describeNilness(of: (avatar == nil ? nil : "not nil"), usingName: "user.avatar")
                    if user.avatar != nil {
                        describeNilness(
                            of: avatarStyle?.backgroundColor,
                            usingName: "user.avatar.style.backgroundColor")
                    }
                    describeNilness(
                        of: appTheme.backgroundColor,
                        usingName: "appTheme.backgroundColor")
                    return Comment(rawValue: explanation + "\n")
                }())
            } catch is ExerciseStepUnimplemented {
                // ignore; allDesugaringsAreImplemented will report
            } catch let error {
                Issue.record("\(error)")
            }
        }
    }

    @Test
    func allDesugaringsAreImplemented() throws {  // tests run in lexical order, so name makes this test run last
        var desugarings: Set<String> = []
        var desugaringsUnimplemented: [String:ExerciseStepUnimplemented] = [:]

        let user = User(name: "Sally Nguyen", avatar: nil)
        for (stepName, sugaringFunc) in desugaringExercise(user: user, appTheme: theme0) {
            desugarings.insert(stepName)
            do {
                _ = try sugaringFunc()
            } catch let unimplementedError as ExerciseStepUnimplemented {
                desugaringsUnimplemented[stepName] = unimplementedError
            }
        }

        // Because tests run concurrently, we have to build our multiline report first and then
        // print it all at once.
        var report = ""
        func addToReport(_ items: Any...) {
            report += items.map { "\($0)" }.joined(separator: " ") + "\n"
        }

        addToReport(dividerLine)
        addToReport("Steps implemented:")
        addToReport()
        let maxStepNameWidth = desugarings.lazy.map(\.count).max() ?? 0
        for stepName in desugarings.sorted() {
            if let unimplemented = desugaringsUnimplemented[stepName] {
                addToReport(
                    notCompletedIcon,
                    stepName.padded(with: " ", toWidth: maxStepNameWidth),
                    "(in \(unimplemented.file), line \(unimplemented.line))")
            } else {
                addToReport(completedIcon, stepName)
            }
        }
        addToReport()
        addToReport("NOTE: The list above only indicates whether a step is implemented,")
        addToReport("      not whether it is full desugared or working correctly.")
        addToReport(dividerLine)

        print(report)

        if !desugaringsUnimplemented.isEmpty {
            Issue.record("Some desugaring steps are not yet implemented")
        }
    }
}

extension String {
    func padded(with padding: Character, toWidth width: Int) -> String {
        self + String(repeating: padding, count: max(0, width - self.count))
    }
}
