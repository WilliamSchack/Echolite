import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import Echolite.Info.Updates

OverlayPopup {
    id: root

    Column {
        width: parent.width

        spacing: 10

        Text {
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter

            text: "Dependencies Not Installed"
            color: "white"
            font.bold: true
            font.pixelSize: 30
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: "Pleases install all the missing dependencies to use the app"
            color: "white"
            font.pixelSize: 18
        }

        Column {
            width: parent.width
            spacing: 0

            DependencyInstalledVisual {
                id: ffmpegVisual
                info: _manager.info.updates.GetDependency(DependencyInfo.Ffmpeg)
            }

            DependencyInstalledVisual {
                id: ytdlpVisual
                info: _manager.info.updates.GetDependency(DependencyInfo.Ytdlp)
            }

            DependencyInstalledVisual {
                id: qjsVisual
                info: _manager.info.updates.GetDependency(DependencyInfo.Quickjs)
            }
        }

        CustomButton {
            width: parent.width
            height: 40

            text: "Download Missing"
            font.bold: true
            font.pixelSize: 16
            backgroundColour: "#9A607D"

            onClicked: {
                if (ffmpegVisual.visible)
                    ffmpegVisual.info.Download()

                if (ytdlpVisual.visible)
                    ytdlpVisual.info.Download()

                if (qjsVisual.visible)
                    qjsVisual.info.Download()
            }
        }
    }
}