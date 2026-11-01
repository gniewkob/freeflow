import Foundation

/// How an Edit Mode result reaches the user (fork: gniewkob/freeflow).
/// Edit Mode replaces the selection; when the selection lives in read-only content
/// (a chat transcript, a web page) there is nothing to replace, so the result is shown
/// in a panel instead of being dropped silently.
enum EditResultDelivery: Equatable {
    case insert
    case showPanel
}

enum EditResultDeliveryPolicy {
    /// Decides before insertion. Only Edit Mode results with original-field tracking are affected;
    /// plain dictation and setups without tracking keep the upstream behaviour.
    static func decide(
        isCommandMode: Bool,
        tracksOriginalField: Bool,
        hasTarget: Bool,
        targetIsEditable: Bool
    ) -> EditResultDelivery {
        guard isCommandMode, tracksOriginalField else { return .insert }
        return hasTarget && targetIsEditable ? .insert : .showPanel
    }

    /// Insertion statuses that mean the result did not land in the field.
    static func isFailedInsertionStatus(_ status: String) -> Bool {
        status.contains("use Paste Again")
    }

    /// Decides after an insertion attempt finished with `status`.
    static func shouldShowPanelAfterInsertion(isCommandMode: Bool, status: String) -> Bool {
        isCommandMode && isFailedInsertionStatus(status)
    }
}
