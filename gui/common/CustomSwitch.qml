import QtQuick
import QtQuick.Controls.Basic

Switch {
    id: root
    
    property bool initialized: false

    implicitHeight: parent.height
    implicitWidth: 50

    focusPolicy: Qt.StrongFocus

    contentItem: Item {}

    indicator: Rectangle {
        anchors.fill: parent
        radius: 3
        color: root.checked ? "#9A607D" : "#9F9F9F"

        border.color: "#4ec1ff"
        border.width: root.visualFocus ? 2 : 0

        // Knob thing
        Rectangle {
            width: parent.height - 4
            height: parent.height - 4
            y: 2
            radius: 3
            color: "white"

            x: root.checked ? parent.width - width - 2 : 2

            Behavior on x {
                enabled: root.initialized
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        InnerShadow {
            topEnabled: false
            leftEnabled: false

            radius: 3
            size: 4
            strength: 0.2
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: (mouse) => { mouse.accepted = false }
    }

    Component.onCompleted: {
        initialized = true
    }
}