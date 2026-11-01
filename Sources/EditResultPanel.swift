import AppKit

/// Small floating panel showing an Edit Mode result that could not replace the selection.
@MainActor
final class EditResultPanelController: NSObject, NSWindowDelegate {
    static let shared = EditResultPanelController()

    private var panel: NSPanel?
    private var textView: NSTextView?
    private var currentText = ""

    /// Safe from any context; the panel is always shown on the main thread.
    nonisolated static func present(_ text: String) {
        DispatchQueue.main.async {
            MainActor.assumeIsolated { shared.show(text) }
        }
    }

    func show(_ text: String) {
        currentText = text
        let panel = self.panel ?? makePanel()
        self.panel = panel
        textView?.string = text
        panel.center()
        NSApp.activate(ignoringOtherApps: true)
        panel.makeKeyAndOrderFront(nil)
    }

    private func makePanel() -> NSPanel {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 460, height: 260),
            styleMask: [.titled, .closable, .resizable, .utilityWindow],
            backing: .buffered,
            defer: false
        )
        panel.title = "Wynik edycji — nie można było podmienić zaznaczenia"
        panel.level = .floating
        panel.isReleasedWhenClosed = false
        panel.hidesOnDeactivate = false
        panel.delegate = self

        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.borderType = .bezelBorder
        let text = NSTextView()
        text.isEditable = false
        text.isSelectable = true
        text.font = NSFont.systemFont(ofSize: 13)
        text.textContainerInset = NSSize(width: 6, height: 6)
        text.isVerticallyResizable = true
        text.autoresizingMask = [.width]
        scroll.documentView = text
        textView = text

        let copy = NSButton(title: "Kopiuj", target: self, action: #selector(copyAndClose))
        copy.keyEquivalent = "\r"
        copy.bezelStyle = .rounded
        let close = NSButton(title: "Zamknij", target: self, action: #selector(closePanel))
        close.keyEquivalent = "\u{1b}"
        close.bezelStyle = .rounded

        let buttons = NSStackView(views: [NSView(), close, copy])
        buttons.orientation = .horizontal
        buttons.spacing = 8
        let stack = NSStackView(views: [scroll, buttons])
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 10
        stack.edgeInsets = NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stack.translatesAutoresizingMaskIntoConstraints = false

        let content = NSView()
        content.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            stack.topAnchor.constraint(equalTo: content.topAnchor),
            stack.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            scroll.widthAnchor.constraint(equalTo: stack.widthAnchor, constant: -24),
            buttons.widthAnchor.constraint(equalTo: stack.widthAnchor, constant: -24),
            scroll.heightAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
        panel.contentView = content
        return panel
    }

    @objc private func copyAndClose() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(currentText, forType: .string)
        closePanel()
    }

    @objc private func closePanel() {
        panel?.orderOut(nil)
    }
}
