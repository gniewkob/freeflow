import Foundation

enum EditResultDeliveryTests {
    static func run() {
        testDictationAlwaysInserts()
        testEditModeWithoutTrackingKeepsUpstreamBehaviour()
        testEditModeIntoEditableFieldInserts()
        testEditModeIntoReadOnlyOrMissingFieldShowsPanel()
        testFailedInsertionStatusesShowPanelOnlyForEditMode()
    }

    private static func testDictationAlwaysInserts() {
        for tracks in [true, false] {
            for hasTarget in [true, false] {
                for editable in [true, false] {
                    TestSupport.expectEqual(
                        EditResultDeliveryPolicy.decide(
                            isCommandMode: false, tracksOriginalField: tracks,
                            hasTarget: hasTarget, targetIsEditable: editable
                        ),
                        .insert
                    )
                }
            }
        }
    }

    private static func testEditModeWithoutTrackingKeepsUpstreamBehaviour() {
        TestSupport.expectEqual(
            EditResultDeliveryPolicy.decide(
                isCommandMode: true, tracksOriginalField: false, hasTarget: false, targetIsEditable: false
            ),
            .insert
        )
    }

    private static func testEditModeIntoEditableFieldInserts() {
        TestSupport.expectEqual(
            EditResultDeliveryPolicy.decide(
                isCommandMode: true, tracksOriginalField: true, hasTarget: true, targetIsEditable: true
            ),
            .insert
        )
    }

    private static func testEditModeIntoReadOnlyOrMissingFieldShowsPanel() {
        TestSupport.expectEqual(
            EditResultDeliveryPolicy.decide(
                isCommandMode: true, tracksOriginalField: true, hasTarget: true, targetIsEditable: false
            ),
            .showPanel
        )
        TestSupport.expectEqual(
            EditResultDeliveryPolicy.decide(
                isCommandMode: true, tracksOriginalField: true, hasTarget: false, targetIsEditable: true
            ),
            .showPanel
        )
    }

    private static func testFailedInsertionStatusesShowPanelOnlyForEditMode() {
        let failures = [
            "Original field unavailable — use Paste Again",
            "Original field changed or unavailable — use Paste Again",
            "Insertion unavailable — use Paste Again",
            "Insertion unconfirmed — use Paste Again"
        ]
        for status in failures {
            TestSupport.expect(
                EditResultDeliveryPolicy.shouldShowPanelAfterInsertion(isCommandMode: true, status: status),
                "Edit Mode failure '\(status)' should show the result panel"
            )
            TestSupport.expect(
                !EditResultDeliveryPolicy.shouldShowPanelAfterInsertion(isCommandMode: false, status: status),
                "Dictation failure '\(status)' should keep the upstream Paste Again flow"
            )
        }
        for status in ["Pasted at cursor!", "Inserted in original field", "Pasted in original field", "Copied to clipboard!"] {
            TestSupport.expect(
                !EditResultDeliveryPolicy.shouldShowPanelAfterInsertion(isCommandMode: true, status: status),
                "Successful insertion '\(status)' must not show the panel"
            )
        }
    }
}
