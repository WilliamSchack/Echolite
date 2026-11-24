import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle {
    id: root

    radius: 10
    color: "transparent"

    Component {
        id: messageDialogComponent
        CustomMessageDialog {}
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0

        spacing: 0

        // Header
        Item {
            Layout.minimumHeight: 40
            Layout.fillWidth: true

            // Background
            Rectangle {
                anchors.fill: parent

                // Qt 6.7+
                topLeftRadius: 10
                topRightRadius: 10
                
                color: Qt.alpha("#262626", 0.9)
            }
    
            // Items
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 6
                anchors.bottomMargin: 6

                spacing: 8

                // Download / Cancel
                CustomButton {
                    id: downloadButton

                    Layout.fillHeight: true

                    enabled: _manager.music.downloadButtonEnabled

                    text: _manager.music.downloadButtonText
                    font.pixelSize: 14
                    spacing: 5
                    radius: 8
                    backgroundColour: "#A16583"

                    iconSource: _manager.music.downloadButtonIcon
                    iconMargins: 15

                    onClicked: {
                        if (!_manager.music.downloadButtonCancels) {
                            _manager.music.DownloadButtonClicked()
                            return
                        }

                        const dialog = messageDialogComponent.createObject(root, {
                            title: "Cancel Download",
                            text: "Are you sure you want to cancel the download?",
                            standardButtons: Dialog.Yes | Dialog.No
                        })

                        dialog.onAccepted.connect(function() {
                            _manager.music.DownloadButtonClicked()
                        })
                        
                        dialog.open()
                    }
                }

                // Pause
                CustomButton {
                    Layout.fillHeight: true

                    text: _manager.music.playPauseButtonText
                    font.pixelSize: 14
                    spacing: 5
                    radius: 8
                    backgroundColour: "#A16583"

                    iconSource: _manager.music.playPauseButtonIcon
                    iconMargins: 15

                    onClicked: _manager.music.PlayPauseButtonClicked()
                }

                Text {
                    text: "Downloads Completed: " + _manager.music.downloadsCompleted + "/" + _manager.music.tracks.length + " (" + _manager.music.downloadErrors + " Error" + (_manager.music.downloadErrors === 1 ? "" : "s") + ")"
                    font.pixelSize: 14
                    color: "white"

                    leftPadding: 5

                    // Dont let announcements queue up incase multiple downloads finish at once
                    onTextChanged: downloadsCompletedAnnounceTimer.restart()

                    Timer {
                        id: downloadsCompletedAnnounceTimer
                        interval: 1000
                        
                        onTriggered: () => {
                            // Only announce if the app is focused
                            if (!root.Window.active)
                                return

                            let message = "Downloads Completed: " + _manager.music.downloadsCompleted + " out of " + _manager.music.tracks.length
                            if (_manager.music.downloadErrors != 0)
                                message += " with " + _manager.music.downloadErrors + " error" + (_manager.music.downloadErrors === 1 ? "" : "s")

                            root.Accessible.announce(message)
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                CustomButton {
                    Layout.fillHeight: true

                    visible: root.firstDownloadFinished

                    text: "Support Development"
                    font.pixelSize: 14
                    backgroundColour: "#A16583"
                    radius: 8

                    onClicked: {
                        const dialog = messageDialogComponent.createObject(root, {
                            title: "Support Development",
                            text: "Thanks for using my app! Echolite is made by a single developer and donations make it possible for me to continue updating it\n\nWould you like to donate and support development? Even the smallest amount goes a long way :)",
                            standardButtons: Dialog.Yes | Dialog.No
                        })

                        dialog.onAccepted.connect(function() {
                            Qt.openUrlExternally("https://ko-fi.com/williamschack")
                        })
                        
                        dialog.open()
                    }
                }
            }
        }

        // Main Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            bottomLeftRadius: 10
            bottomRightRadius: 10

            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.alpha("#373737", 0.8) }
                GradientStop { position: 1.0; color: Qt.alpha("#3D2B3F", 0.8) }
            }

            // Column Widths (Will be adjustable later)
            QtObject {
                id: columnWidthsObject
                property real number: 0.05
                property real title: 0.25
                property real album: 0.25
                property real sources: 0.15
                property real downloadStatus: 0.3
            }

            ColumnLayout {
                anchors.fill: parent

                spacing: 0

                // Progress Bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 5

                    color: Qt.alpha('#6a6a6a', 0.2)

                    Rectangle {
                        visible: _manager.music.tracks.length > 0

                        width: parent.width * (_manager.music.tracks.length > 0 ? (_manager.music.downloadsCompleted / _manager.music.tracks.length) : 0)
                        height: parent.height

                        color: Qt.alpha('#4DFF36', 0.4)

                        Behavior on width {
                            NumberAnimation {
                                duration: 500
                                easing.type: Easing.InOutCubic
                            }
                        }
                    }
                }

                // Top Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 40

                    color: "transparent"

                    Row {
                        anchors.fill: parent
                        spacing: 0

                        // Number
                        Item {
                            width: parent.width * columnWidthsObject.number
                            height: parent.height
                            Text {
                                anchors.centerIn: parent
                                text: "#"
                                color: "white"
                                font.pixelSize: 14
                            }
                        }

                        // Title / Artist
                        Item {
                            width: parent.width * columnWidthsObject.title
                            height: parent.height
                            
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Title"
                                color: "white"
                                font.pixelSize: 14
                            }
                        }

                        // Album
                        Item {
                            width: parent.width * columnWidthsObject.album
                            height: parent.height
                            
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Album"
                                color: "white"
                                font.pixelSize: 14
                            }
                        }

                        // Sources
                        Item {
                            width: parent.width * columnWidthsObject.sources
                            height: parent.height
                            
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Sources"
                                color: "white"
                                font.pixelSize: 14
                            }
                        }

                        // Download Status
                        Item {
                            width: parent.width * columnWidthsObject.downloadStatus
                            height: parent.height
                            
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Download Status"
                                color: "white"
                                font.pixelSize: 14
                            }
                        }
                    }
                }

                // Tracks
                ListView {
                    id: trackList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 0

                    model: _manager.music.tracks

                    property bool scrollBarActive: contentHeight > height

                    ScrollBar.vertical: CustomScrollBar {
                        policy: trackList.scrollBarActive ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                    }

                    delegate: Track {
                        required property QtObject modelData
                        trackData: modelData
                        columnWidths: columnWidthsObject
                        width: ListView.view.width
                    }
                }
            }
        }
    }

    // Missing Dependencies Popup
    MissingDependenciesPopup {
        id: missingDependenciesPopup
        shown: !_manager.info.updates.allInstalled && (parent ? parent.visible : false)

        radius: parent.radius

        onShownChanged: {
            if (shown)
                return
                
            downloadButton.forceActiveFocus()
        }
    }

    // Add Tracks Popup
    AddTracksPopup {
        id: addTracksPopup
        shown: _manager.music.addTracksPopup.visible && (parent ? parent.visible : false) && !missingDependenciesPopup.visible
        
        radius: parent.radius

        onShownChanged: {
            if (shown)
                return

            downloadButton.forceActiveFocus()
        }
    }
}