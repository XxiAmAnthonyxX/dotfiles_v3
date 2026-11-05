import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs

FloatingWindow {
    id: root

    title: "CLIPBOARD"
    visible: false
    color: "transparent"
    width: 760
    height: 520
    minimumSize: Qt.size(760, 520)
    maximumSize: Qt.size(760, 520)

    property bool open: false
    property string previewText: ""
    property string previewImage: ""

    ListModel { id: fullModel }
    ListModel { id: filteredModel }

    onOpenChanged: {
        visible = open
        if (open) {
            searchField.text = ""
            refresh()
            searchField.forceActiveFocus()
        } else {
            previewText = ""
            previewImage = ""
        }
    }

    function refresh() {
        fullModel.clear()
        filteredModel.clear()
        getClips.running = true
    }

    function applyFilter(query) {
        filteredModel.clear()
        const q = query.trim().toLowerCase()
        for (let i = 0; i < fullModel.count; i++) {
            const item = fullModel.get(i)
            if (q === "" || item.preview.toLowerCase().includes(q))
                filteredModel.append(item)
        }
        list.currentIndex = filteredModel.count > 0 ? 0 : -1
        updatePreview()
    }

    function updatePreview() {
        if (list.currentIndex < 0 || list.currentIndex >= filteredModel.count) {
            previewText = ""
            previewImage = ""
            return
        }
        const item = filteredModel.get(list.currentIndex)
        if (item.preview.startsWith("[[ binary data ")
            || item.preview.toLowerCase().includes("image/")) {
            previewText = "[IMAGE]"
            previewImage = ""
        } else {
            getFullText.command = ["sh", "-c", "printf '%s' \"$1\" | cliphist decode", "_", item.id]
            getFullText.running = true
            previewImage = ""
        }
    }

    function selectItem(index) {
        if (index < 0 || index >= filteredModel.count)
            return
        const item = filteredModel.get(index)
        copyProc.command = ["sh", "-c", "printf '%s' \"$1\" | cliphist decode | wl-copy", "_", item.id]
        copyProc.running = true
    }

    Process {
        id: getClips
        command: ["cliphist", "list"]
        running: false
        stdout: SplitParser {
            onRead: line => {
                const trimmed = line.trim()
                if (!trimmed)
                    return
                const tab = trimmed.indexOf("\t")
                if (tab === -1)
                    return
                fullModel.append({
                    id: trimmed.substring(0, tab),
                    preview: trimmed.substring(tab + 1)
                })
            }
        }
        onRunningChanged: {
            if (!running)
                applyFilter(searchField.text)
        }
    }

    Process {
        id: getFullText
        stdout: StdioCollector {
            onStreamFinished: previewText = this.text
        }
    }

    Process { id: copyProc }

    ChamferPanel {
        id: panel
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 12

            // Header (drag to move)
            Item {
                Layout.fillWidth: true
                height: headerCol.implicitHeight

                ColumnLayout {
                    id: headerCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 2

                    Text {
                        text: "CLIPBOARD"
                        color: Theme.accentBright
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                        font.bold: true
                        font.letterSpacing: Theme.fontLetterSpacing
                    }
                    Text {
                        text: filteredModel.count + " ENTRY" + (filteredModel.count !== 1 ? "S" : "")
                              + "  //  CLIPHIST"
                        color: Theme.muted
                        font.family: Theme.fontFamily
                        font.pixelSize: 11
                        font.bold: Theme.fontBold
                        font.letterSpacing: Theme.fontLetterSpacing
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.SizeAllCursor
                    onPressed: root.startSystemMove()
                }
            }

            // Search
            TextField {
                id: searchField
                Layout.fillWidth: true
                placeholderText: "SEARCH // CLIPBOARD"
                color: Theme.foreground
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: Theme.fontBold
                font.letterSpacing: Theme.fontLetterSpacing
                placeholderTextColor: Theme.muted

                background: Rectangle {
                    color: searchField.activeFocus
                           ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.18)
                           : Qt.darker(Theme.background, 1.25)
                    // chamfer-ish sharp corners
                    radius: 0
                }

                onTextChanged: applyFilter(text)

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        root.open = false
                        event.accepted = true
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        selectItem(list.currentIndex)
                        event.accepted = true
                    } else if (event.key === Qt.Key_Down) {
                        list.incrementCurrentIndex()
                        updatePreview()
                        event.accepted = true
                    } else if (event.key === Qt.Key_Up) {
                        list.decrementCurrentIndex()
                        updatePreview()
                        event.accepted = true
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12

                // List
                ListView {
                    id: list
                    Layout.preferredWidth: 300
                    Layout.fillHeight: true
                    clip: true
                    model: filteredModel
                    currentIndex: 0
                    spacing: 4
                    boundsBehavior: Flickable.StopAtBounds
                    highlightMoveDuration: 0
                    highlightResizeDuration: 0

                    ScrollBar.vertical: ScrollBar {
                        policy: list.contentHeight > list.height
                                ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                        padding: 2
                        contentItem: Rectangle {
                            implicitWidth: 6
                            radius: 0
                            color: Theme.muted
                            opacity: parent.hovered || parent.pressed ? 0.9 : 0.55
                        }
                        background: Rectangle {
                            radius: 0
                            color: Qt.darker(Theme.background, 1.25)
                            opacity: 0.5
                        }
                    }

                    onCurrentIndexChanged: updatePreview()

                    delegate: Rectangle {
                        width: list.width
                        height: 44
                        radius: 0
                        color: ListView.isCurrentItem
                               ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.28)
                               : "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                margins: 12
                            }
                            text: model.preview
                            color: ListView.isCurrentItem ? Theme.accentBright : Theme.foreground
                            elide: Text.ElideRight
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize
                            font.bold: Theme.fontBold
                            font.letterSpacing: Theme.fontLetterSpacing
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: list.currentIndex = index
                            onDoubleClicked: selectItem(index)
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: filteredModel.count === 0
                        text: fullModel.count === 0
                              ? "BUFFER EMPTY\n// NO HISTORY"
                              : "NO MATCH"
                        color: Theme.muted
                        horizontalAlignment: Text.AlignHCenter
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        font.bold: Theme.fontBold
                        font.letterSpacing: Theme.fontLetterSpacing
                    }
                }

                // Preview pane
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 0
                    color: Qt.darker(Theme.background, 1.18)

                    Flickable {
                        id: previewFlick
                        anchors.fill: parent
                        anchors.margins: 14
                        visible: previewText !== "[IMAGE]" && previewText !== ""
                        clip: true
                        // Allow horizontal scroll for long lines; vertical for height
                        contentWidth: Math.max(width, previewLabel.implicitWidth)
                        contentHeight: previewLabel.implicitHeight
                        boundsBehavior: Flickable.StopAtBounds
                        flickableDirection: Flickable.HorizontalAndVerticalFlick

                        Text {
                            id: previewLabel
                            text: previewText
                            color: Theme.foreground
                            // No wrap so long lines use the horizontal scrollbar
                            wrapMode: Text.NoWrap
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize
                            font.letterSpacing: Theme.fontLetterSpacing
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: previewFlick.contentHeight > previewFlick.height
                                    ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                            padding: 2
                            contentItem: Rectangle {
                                implicitWidth: 6
                                radius: 0
                                color: Theme.muted
                                opacity: parent.hovered || parent.pressed ? 0.9 : 0.55
                            }
                            background: Rectangle {
                                radius: 0
                                color: Qt.darker(Theme.background, 1.25)
                                opacity: 0.5
                            }
                        }

                        ScrollBar.horizontal: ScrollBar {
                            policy: previewFlick.contentWidth > previewFlick.width
                                    ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                            padding: 2
                            contentItem: Rectangle {
                                implicitHeight: 6
                                radius: 0
                                color: Theme.muted
                                opacity: parent.hovered || parent.pressed ? 0.9 : 0.55
                            }
                            background: Rectangle {
                                radius: 0
                                color: Qt.darker(Theme.background, 1.25)
                                opacity: 0.5
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: previewText === "" && previewImage === ""
                        text: "SELECT AN ENTRY\n// PREVIEW"
                        color: Theme.muted
                        horizontalAlignment: Text.AlignHCenter
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        font.bold: Theme.fontBold
                        font.letterSpacing: Theme.fontLetterSpacing
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: previewText === "[IMAGE]"
                        text: "IMAGE\n// PREVIEW PENDING"
                        color: Theme.muted
                        horizontalAlignment: Text.AlignHCenter
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        font.bold: Theme.fontBold
                        font.letterSpacing: Theme.fontLetterSpacing
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "clipboard"
        function toggle(): void { root.open = !root.open }
        function open(): void { root.open = true }
        function close(): void { root.open = false }
    }
}
