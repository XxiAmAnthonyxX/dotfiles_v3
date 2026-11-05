import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs

Scope {
    id: root

    property int selectedIndex: -1

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcherPanel.visible = !launcherPanel.visible
            if (launcherPanel.visible) {
                searchInput.text = ""
                root.selectedIndex = -1
                searchInput.forceActiveFocus()
            }
        }

        function show(): void {
            launcherPanel.visible = true
            searchInput.text = ""
            root.selectedIndex = -1
            searchInput.forceActiveFocus()
        }

        function hide(): void {
            launcherPanel.visible = false
        }
    }

    ScriptModel {
        id: filteredApps
        objectProp: "id"
        values: {
            const all = [...DesktopEntries.applications.values]
            const q = searchInput.text.trim().toLowerCase()

            if (q === "")
                return all.sort((a, b) => a.name.localeCompare(b.name))

            return all.filter(d =>
                (d.name && d.name.toLowerCase().includes(q))
                || (d.genericName && d.genericName.toLowerCase().includes(q))
                || (d.comment && d.comment.toLowerCase().includes(q))
                || (d.keywords && d.keywords.some(k => k.toLowerCase().includes(q)))
                || (d.categories && d.categories.some(c => c.toLowerCase().includes(q)))
            ).sort((a, b) => {
                const an = (a.name || "").toLowerCase()
                const bn = (b.name || "").toLowerCase()
                const aStarts = an.startsWith(q)
                const bStarts = bn.startsWith(q)
                if (aStarts && !bStarts) return -1
                if (!aStarts && bStarts) return 1
                return an.localeCompare(bn)
            })
        }
    }

    function launchApp(entry) {
        if (entry)
            entry.execute()
        // stay open after launch
    }

    FloatingWindow {
        id: launcherPanel
        title: "APPLICATIONS"
        visible: false
        color: "transparent"
        width: 620
        height: 540
        minimumSize: Qt.size(620, 540)
        maximumSize: Qt.size(620, 540)

        ChamferPanel {
            id: launcherBox
            anchors.fill: parent

            ColumnLayout {
                anchors.fill: parent
                spacing: 14

                Item {
                    Layout.fillWidth: true
                    height: launcherHeader.implicitHeight

                    ColumnLayout {
                        id: launcherHeader
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 2

                        Text {
                            text: "APPLICATIONS"
                            color: Theme.accentBright
                            font.pixelSize: 15
                            font.family: Theme.fontFamily
                            font.bold: true
                            font.letterSpacing: Theme.fontLetterSpacing
                        }
                        Text {
                            text: resultsList.count + " PROCESS" + (resultsList.count !== 1 ? "ES" : "")
                                  + "  //  DESKTOP ENTRIES"
                            color: Theme.muted
                            font.pixelSize: 11
                            font.family: Theme.fontFamily
                            font.bold: Theme.fontBold
                            font.letterSpacing: Theme.fontLetterSpacing
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.SizeAllCursor
                        onPressed: launcherPanel.startSystemMove()
                    }
                }

                TextField {
                    id: searchInput
                    Layout.fillWidth: true
                    placeholderText: "SEARCH // APPLICATIONS"
                    color: Theme.foreground
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: Theme.fontBold
                    font.letterSpacing: Theme.fontLetterSpacing
                    placeholderTextColor: Theme.muted

                    background: Rectangle {
                        color: searchInput.activeFocus
                               ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.18)
                               : Qt.darker(Theme.background, 1.25)
                        radius: 0
                    }

                    onTextChanged: root.selectedIndex = text === "" ? -1 : 0

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            launcherPanel.visible = false
                            event.accepted = true
                        } else if (event.key === Qt.Key_Down || event.key === Qt.Key_Tab) {
                            event.accepted = true
                            root.selectedIndex = Math.min(root.selectedIndex + 1, resultsList.count - 1)
                            resultsList.positionViewAtIndex(root.selectedIndex, ListView.Contain)
                        } else if (event.key === Qt.Key_Up || event.key === Qt.Key_Backtab) {
                            event.accepted = true
                            root.selectedIndex = Math.max(root.selectedIndex - 1, 0)
                            resultsList.positionViewAtIndex(root.selectedIndex, ListView.Contain)
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            event.accepted = true
                            if (root.selectedIndex >= 0) {
                                const entry = filteredApps.values[root.selectedIndex]
                                root.launchApp(entry)
                            }
                        }
                    }
                }

                ListView {
                    id: resultsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: filteredApps
                    clip: true
                    spacing: 3
                    boundsBehavior: Flickable.StopAtBounds
                    currentIndex: root.selectedIndex
                    highlightMoveDuration: 0
                    highlightResizeDuration: 0

                    ScrollBar.vertical: ScrollBar {
                        policy: resultsList.contentHeight > resultsList.height
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

                    delegate: Rectangle {
                        id: delegateRoot
                        required property var modelData
                        required property int index

                        width: resultsList.width
                        height: 44
                        radius: 0
                        color: root.selectedIndex === index
                               ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.28)
                               : "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                margins: 12
                            }
                            text: (delegateRoot.modelData.name || "").toUpperCase()
                            color: root.selectedIndex === index ? Theme.accentBright : Theme.foreground
                            elide: Text.ElideRight
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize
                            font.bold: Theme.fontBold
                            font.letterSpacing: Theme.fontLetterSpacing
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.selectedIndex = delegateRoot.index
                                root.launchApp(delegateRoot.modelData)
                            }
                            onDoubleClicked: root.launchApp(delegateRoot.modelData)
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "NO SIGNAL\n// NO APPLICATIONS FOUND"
                        color: Theme.muted
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 13
                        font.family: Theme.fontFamily
                        font.bold: Theme.fontBold
                        font.letterSpacing: Theme.fontLetterSpacing
                        visible: resultsList.count === 0 && searchInput.text !== ""
                    }
                }
            }
        }
    }
}
