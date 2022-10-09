import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.15

/* HOME SCREEN */
Rectangle {
    color: 'transparent'
    property string page

    width: Window.width
    height: Window.height - 80
    id: homeScreen

    // main grid properties
    readonly property real gridWidth: this.width * 0.9
    readonly property real gridVSpacing: this.height * 0.115

    // top row properties
    readonly property real artSize: this.width * 0.2
    readonly property real titleFont: this.width * 0.0439
    readonly property real mainFont: this.width * 0.021
    readonly property real qualityFont: this.width * 0.013
    readonly property real textSpacing: this.width * 0.0125

    //progress bar
    readonly property real progressBarHeight: this.height * 0.007

    // icon properties
    readonly property real iconRowWidth: this.width * 0.8
    readonly property real iconRowMargin: this.width * 0.1
    readonly property real iconCellWidth: iconRowWidth / 5
    readonly property real iconSize: this.height * 0.06
    readonly property real playIconSize: this.height * 0.07

    GridLayout {
        columns: 2
        width: gridWidth
        anchors.horizontalCenter: parent.horizontalCenter
        y: gridVSpacing

        Row {
            width: parent.width
            spacing: gridVSpacing

            Item {
                height: artSize
                width: artSize

                /*
                Image {
                    id: mediaArt
                    source: "image://AsyncImage/" + "http://" + settings.host + queue[playPosition].discart + "?size=" + Math.ceil(appWindow.width * 0.2)
                    height: artSize
                    width: artSize
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                }
                */

                Image {
                    id: playingArt
                    source: queue.length >= playPosition - 1 ? "image://AsyncImage/" + "http://" + settings.host + queue[playPosition].art + "?size=" + Math.ceil(appWindow.width * 0.2) : ''
                    height: artSize
                    width: artSize
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    visible: false
                }
                Rectangle {
                    id: playingArtMask
                    height: artSize
                    width: artSize
                    radius: 10
                    visible: false
                }
                OpacityMask {
                    anchors.fill: playingArt
                    source: playingArt
                    maskSource: playingArtMask
                }
            }


            Column {
                spacing: 15

                Text {
                    id: homeTitle
                    color: white
                    font.pixelSize: titleFont
                    font.family: poppins.name
                    font.weight: Font.Light
                    text: queue[playPosition].title
                }
                Text {
                    id: homeAlbum
                    color: white
                    opacity: 0.7
                    font.pixelSize: mainFont
                    font.family: poppins.name
                    font.weight: Font.Medium
                    text: "From " + queue[playPosition].album
                }

                Text {
                    id: homeArtist
                    color: white
                    opacity: 0.7
                    font.pixelSize: mainFont
                    font.family: poppins.name
                    font.weight: Font.Medium
                    text: "By " + queue[playPosition].artist
                }
                Rectangle {
                    color: yellow
                    Text {
                        text: queue[playPosition].shortformat
                        font.pixelSize: qualityFont
                        font.family: poppins.name
                        font.weight: Font.Medium
                        color: appWindow.color
                        leftPadding: appWindow.height * 0.0172
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 2.05
                        bottomPadding: this.topPadding
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height
                }
            } // Column

        } // Row

        // -------- PROGRESS BAR -------- //
        Rectangle {
            Layout.columnSpan: 2
            Layout.topMargin: gridVSpacing
            Layout.preferredHeight: progressBarHeight
            Layout.preferredWidth: gridWidth
            color: blue_light
            Rectangle {
                height: parent.height
                width: (parent.width / appWindow.playDuration) * appWindow.playElapsed//parent.width / 2
                color: yellow
                x: 0
                y: 0
            }
        }


        Text {
            color: white
            opacity: 0.7
            font.pixelSize: appWindow.width * 0.017
            text: getPrettyTime(appWindow.playElapsed)
            font.family: kentledge.name
            horizontalAlignment: Text.AlignLeft
        }
        Text {
            color: white
            opacity: 0.7
            font.pixelSize: appWindow.width * 0.017
            text: getPrettyTime(appWindow.playDuration)
            font.family: kentledge.name
            horizontalAlignment: Text.AlignRight
        }

        RowLayout {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: gridVSpacing

            width: iconRowWidth
            height: playIconSize
            spacing: 0

            Rectangle {
                Layout.preferredWidth: iconCellWidth
                color: 'transparent'
                Layout.fillHeight: true
            }

            Item {
                Layout.preferredWidth: iconCellWidth
                Layout.fillHeight: true

                Image {
                    source: 'icons/skip-back.svg'
                    height: iconSize
                    width: iconSize
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            apiRequest("prev")
                        }
                    }
                }
            }

            Item  {
                Layout.preferredWidth: iconCellWidth
                Layout.fillHeight: true

                Image {
                    source: appWindow.playPaused ? 'icons/play.svg' : 'icons/pause.svg'
                    height: playIconSize
                    width: playIconSize
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            apiRequest("toggle")
                        }
                    }
                }

            }

            Item {
                Layout.preferredWidth: iconCellWidth
                Layout.fillHeight: true

                Image {
                    source: "icons/skip-forward.svg"
                    height: iconSize
                    width: iconSize
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            apiRequest("next")
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: iconCellWidth
                color: 'transparent'
                Layout.fillHeight: true
            }

        }

    } // Grid
}
