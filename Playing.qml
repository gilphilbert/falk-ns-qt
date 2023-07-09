import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15


/* HOME SCREEN */
Rectangle {
    width: Window.width
    height: Window.height

    x: 0
    y: 0 - Window.height

    color: background_color

    Behavior on y {
        NumberAnimation {
            easing.type: Easing.InOutCubic
            duration: 300
        }
    }

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
    readonly property real progressBarHeight: this.height * 0.015

    function open() {
        this.y = 0
    }

    function close() {
        this.y = 0 - Window.height
    }
    Item {
        anchors.fill: parent
        Image {
            id: backgroundArt
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: "image://AsyncImage/blur" + currentTrack.art
            fillMode: Image.PreserveAspectCrop
            smooth: true
            visible: currentTrack.art !== ""
        }
        FastBlur {
            anchors.fill: backgroundArt
            source: backgroundArt
            radius: 56
        }
    }

    Rectangle {
        anchors.fill: parent
        color: background_color
        opacity: 0.8
        visible: currentTrack.art !== ""
    }

    Row {
        anchors.fill: parent
        Column {
            id: artColumn
            width: parent.width * 0.4
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: parent.width * 0.1
            rightPadding: parent.width * 0.1

            Image {
                id: playingArt
                source: "image://AsyncImage/lrge" + currentTrack.art
                height: parent.width * 0.8
                width: this.height
                fillMode: Image.PreserveAspectCrop
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }
            }

            Rectangle {
                id: mask
                anchors.fill: playingArt
                radius: this.height * radiusPercent
                visible: false
            }
        }
        Column {
            width: parent.width * 0.6
            spacing: parent.height * 0.035
            leftPadding: 0
            rightPadding: parent.width * 0.1
            anchors.top: artColumn.top

            Text {
                id: homeTitle
                color: text_color
                font.pixelSize: titleFont
                font.family: inter.name
                font.weight: Font.ExtraBold
                text: currentTrack.title
                elide: Text.ElideRight
                width: parent.width
            }
            Text {
                color: text_color
                font.pixelSize: mainFont
                font.family: inter.name
                font.weight: Font.ExtraBold
                text: currentTrack.artist + " - " + currentTrack.album
                elide: Text.ElideRight
                width: parent.width
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
                width: parent.width - parent.leftPadding - parent.rightPadding
                height: childrenRect.height
                spacing: parent.height * 0.035
                // -------- PROGRESS BAR -------- //

                Rectangle {
                    id: progressBar
                    height: progressBarHeight
                    width: parent.width
                    color: background_pop_color
                    radius: this.height
                    Rectangle {
                        height: parent.height
                        width: parent.width * (playElapsed / currentTrack.duration)
                        color: primary_color
                        x: 0
                        y: 0
                        radius: this.height
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
                //END PROGRESS BAR
            }

        } // Column
    } //Row

    MouseArea {
        anchors.fill: parent
        onClicked: {
            close()
        }
    }
}
