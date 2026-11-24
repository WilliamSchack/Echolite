import QtQuick

Item {
    id: root

    required property bool isLoading
    property bool loadingFailed: false
    property string contentLabel: ""
    property int indicatorSize: 50

    implicitWidth: parent.width
    implicitHeight: parent.height

    Row {
        anchors.centerIn: parent
        visible: root.isLoading
        spacing: 10

        Image {
            id: visuals
            height: root.indicatorSize
            width: root.indicatorSize

            source: "qrc:/icons/ui/Update.svg"
            sourceSize.width: width
            sourceSize.height: width

            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: root.isLoading

                onRunningChanged: {
                    if (!running)
                        visuals.rotation = 0
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.contentLabel !== ""
            text: "Loading " + root.contentLabel + "..."
            color: "white"
            font.bold: true
            font.pixelSize: 28
        }
    }

    Text {
        anchors.centerIn: parent
        visible: root.contentLabel !== "" && root.loadingFailed
        text: "Failed to Get " + root.contentLabel
        color: "white"
        font.bold: true
        font.pixelSize: 28
    }
}