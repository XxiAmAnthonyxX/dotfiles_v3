import Quickshell
import QtQuick
import qs

ShellRoot {
    PanelWindow {
        id: bar

        anchors {
            top: true
            left: true
            right: true
        }

        // Uniform with Hyprland gaps (both 5)
        implicitHeight: Theme.pillHeight + 5
        color: "transparent"

        Item {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            Visualizer {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 5
            }

            Clock {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 5
            }

            Media {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 5
            }
        }
    }
}
