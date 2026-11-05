import QtQuick
import QtQuick.Shapes
import qs

Item {
    id: root

    default property alias content: contentItem.data
    property color fill: Theme.background
    property int chamfer: Theme.panelChamfer
    property real opacityFill: 0.96

    // Sharp chamfered panel — no stroke / outline
    Shape {
        anchors.fill: parent
        antialiasing: true

        ShapePath {
            fillColor: Qt.rgba(root.fill.r, root.fill.g, root.fill.b, root.opacityFill)
            strokeWidth: 0
            joinStyle: ShapePath.MiterJoin

            startX: 0
            startY: root.chamfer

            PathLine { x: 0; y: 0 }
            PathLine { x: root.width - root.chamfer; y: 0 }
            PathLine { x: root.width; y: root.chamfer }
            PathLine { x: root.width; y: root.height }
            PathLine { x: root.chamfer; y: root.height }
            PathLine { x: 0; y: root.height - root.chamfer }
            PathLine { x: 0; y: root.chamfer }
        }
    }

    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: 18
        clip: true
    }
}
