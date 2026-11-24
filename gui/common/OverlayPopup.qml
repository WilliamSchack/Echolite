import QtQuick
import QtQuick.Effects

// Basically just a popup that doesnt force focus and fades the background

Rectangle {
    id: root

    property int fadeDurationMs: 100
    property int padding: 20
    property bool shown: false

    property Item onShownFocusItem: null

    default property alias content: popupContent.data

    anchors.fill: parent

    color: Qt.alpha("#000000", 0.4)

    opacity: shown ? 1 : 0
    visible: opacity > 0

    // Consume mouse input
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPressed: (mouse) => { mouse.accepted = true }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: root.fadeDurationMs
        }
    }

    // Popup
    StyledBackground {
        anchors.centerIn: parent

        height: popupContent.childrenRect.height + root.padding * 2
        width: 560 + root.padding * 2

        radius: 20

        // Outer Shadow
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowOpacity: 0.25
            shadowBlur: 0.4
            shadowHorizontalOffset: 4
            shadowVerticalOffset: 4
        }

        Item {
            id: popupContent
            anchors.fill: parent
            anchors.margins: root.padding
        }
    }

    onShownChanged: {
        if (onShownFocusItem == null || !shown)
            return

        // Call later so the item is initialised and it can be read
        Qt.callLater(() => {
            onShownFocusItem.forceActiveFocus()
        })
    }
}