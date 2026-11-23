import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects

OverlayPopup {
    id: root

    Component {
        id: messageDialogComponent
        CustomMessageDialog {}
    }

    Column {
        width: parent.width
        anchors.margins: root.padding

        spacing: 10

        Text {
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter

            text: "Add Tracks"
            color: "white"
            font.bold: true
            font.pixelSize: 30
        }

        Column {
            width: parent.width
            spacing: 5

            // Download Link
            RowLayout {
                width: parent.width
                height: 40
                spacing: 5

                CustomTextField {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    placeholderText: qsTr("Enter a Song/Album/Playlist URL...")
                    font.pixelSize: 18

                    verticalAlignment: TextInput.AlignVCenter
                    leftPadding: 10

                    text: _manager.music.addTracksPopup.linkInputText
                    onTextChanged: _manager.music.addTracksPopup.linkInputText = text
                }

                CustomButton {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40

                    iconSource: "qrc:/icons/ui/Clipboard.svg"
                    iconColour: "black"

                    onClicked: _manager.music.addTracksPopup.PasteButtonClicked()
                }
            }

            // Folder Path
            RowLayout {
                width: parent.width
                height: 40
                spacing: 5

                CustomTextField {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    placeholderText: qsTr("Select a Save Location...")
                    font.pixelSize: 18

                    verticalAlignment: TextInput.AlignVCenter
                    leftPadding: 10

                    text: _manager.music.addTracksPopup.folderInputText
                    onTextChanged: _manager.music.addTracksPopup.folderInputText = text
                }

                CustomButton {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40

                    iconSource: "qrc:/icons/ui/Folder.svg"
                    iconColour: "black"

                    onClicked: _manager.music.addTracksPopup.FolderButtonClicked()
                }
            }
        }

        Column {
            width: parent.width

            spacing: 5

            CustomButton {
                width: parent.width
                height: 40
                enabled: !_manager.music.addTracksPopup.checkingInputs
                text: _manager.music.addTracksPopup.checkingInputs ? "Getting Link Details..." : "Add Track(s) & Start Download"
                font.bold: true
                font.pixelSize: 16
                backgroundColour: "#9A607D"

                onClicked: {
                    if (_manager.info.updates.allInstalled) {
                        _manager.music.addTracksPopup.DownloadButtonClicked()
                        return
                    }

                    const dialog = messageDialogComponent.createObject(root, {
                        title: "Could Not Start Download",
                        text: "One or more of the dependencies are not installed. Please install all the dependencies from the Info Screen in the Updates tab, or on your system. If they are already installed on your system make sure they are in your PATH",
                        standardButtons: Dialog.Ok
                    })
                    dialog.open()
                }
            }

            CustomButton {
                visible: _manager.music.tracks.length != 0

                width: parent.width
                height: 30
                enabled: !_manager.music.addTracksPopup.checkingInputs
                text: "Close"
                font.bold: true
                font.pixelSize: 16
                backgroundColour: '#9A607D'

                onClicked: _manager.music.addTracksPopup.visible = false
            }
        }
    }

    Connections {
        target: _manager.music.addTracksPopup
        function onStartError(error) {
            const dialog = messageDialogComponent.createObject(root, {
                title: "Could Not Start Download",
                text: error,
                standardButtons: Dialog.Ok
            })
            dialog.open()
        }
    }
}