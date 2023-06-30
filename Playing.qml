import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15

/* HOME SCREEN */
Item {
    width: Window.width
    height: Window.height - footerHeight

    // main grid properties
    readonly property real gridWidth: this.width * 0.9
    readonly property real gridVSpacing: this.height * 0.115

    // top row properties
    readonly property real artSize: this.width * 0.26
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

        RowLayout {
            width: parent.width
            spacing: gridVSpacing * 0.6

            Item {
                Layout.preferredHeight: artSize
                Layout.preferredWidth: artSize

                Image {
                    id: playingArt
                    source: "image://AsyncImage/" + "http://" + settings.host + currentTrack.art
                    height: artSize
                    width: artSize
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                }
            }


            Column {
                spacing: 15

                Text {
                    id: homeTitle
                    color: text_color
                    font.pixelSize: titleFont
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    text: currentTrack.title
                    elide: Text.ElideRight
                    width: gridWidth - artSize - gridVSpacing

                }
                Text {
                    color: text_color
                    font.pixelSize: mainFont
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    text: currentTrack.artist + " - " + currentTrack.album
                    elide: Text.ElideRight
                    width: gridWidth - artSize - gridVSpacing
                }
                Rectangle {
                    color: primary_color
                    Text {
                        text: currentTrack.shortformat
                        font.pixelSize: qualityFont
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        color: appWindow.color
                        leftPadding: appWindow.height * 0.0172
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height
                }

                Column {
                    width: gridWidth - artSize - gridVSpacing * 0.6
                    height: childrenRect.height
                    spacing: gridVSpacing * 0.1
                    // -------- PROGRESS BAR -------- //
                    Rectangle {
                        id: progressBar
                        height: progressBarHeight
                        width: parent.width
                        color: gray_lighter
                        Rectangle {
                            height: parent.height
                            width: parent.width * (playElapsed / currentTrack.duration)
                            color: primary_color
                            x: 0
                            y: 0
                        }
                    }

                    Item {
                        width: parent.width
                        height: childrenRect.height

                        Text {
                            color: text_color
                            font.pixelSize: appWindow.width * 0.017
                            text: getPrettyTime(playElapsed)
                            font.family: inter.name
                            font.weight: Font.ExtraBold
                            anchors.left: parent.left
                        }
                        Text {
                            color: text_color
                            font.pixelSize: appWindow.width * 0.017
                            text: getPrettyTime(currentTrack.duration)
                            font.family: inter.name
                            font.weight: Font.ExtraBold
                            anchors.right: parent.right
                        }
                    }
                    /* END PROGRESS BAR */
                }

            } // Column
        } // Row


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
                    id: iconPrev
                    source: 'icons/skip-back.svg'
                    height: iconSize
                    width: iconSize
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("prev")
                        }
                    }
                }

//                ColorOverlay{
//                    anchors.fill: iconPrev
//                    source: iconPrev
//                    color: secondary_color
//                    antialiasing: true
//                }
            }

            Item  {
                Layout.preferredWidth: iconCellWidth
                Layout.fillHeight: true

                Image {
                    id: iconPlayPause
                    source: appWindow.playPaused ? 'icons/play.svg' : 'icons/pause.svg'
                    height: playIconSize
                    width: playIconSize
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("toggle")
                        }
                    }
                }

//                ColorOverlay{
//                    anchors.fill: iconPlayPause
//                    source: iconPlayPause
//                    color: secondary_color
//                    antialiasing: true
//                }

            }

            Item {
                Layout.preferredWidth: iconCellWidth
                Layout.fillHeight: true

                Image {
                    id: iconNext
                    source: "icons/skip-forward.svg"
                    height: iconSize
                    width: iconSize
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("next")
                        }
                    }
                }
//                ColorOverlay{
//                    anchors.fill: iconNext
//                    source: iconNext
//                    color: secondary_color
//                    antialiasing: true
//                }
            }

            Rectangle {
                Layout.preferredWidth: iconCellWidth
                color: 'transparent'
                Layout.fillHeight: true
            }

        }

    } // Grid
}
