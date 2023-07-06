import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15

/* HOME SCREEN */
Rectangle {
    width: Window.width
    height: Window.height

    x: 0
    y: 0 //- Window.height

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

    Image {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        source: "image://AsyncImage/" + currentTrack.art
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: currentTrack.art !== ""
    }
    Rectangle {
        anchors.fill: parent
        color: background_color
        opacity: 0.8
        visible: currentTrack.art !== ""
    }


    Column {
        width: parent.width
        spacing: parent.height * 0.035
        topPadding: parent.height * 0.07

        Image {
            id: playingArt
            source: "image://AsyncImage/" + currentTrack.art
            height: artSize
            width: artSize
            fillMode: Image.PreserveAspectCrop
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: homeTitle
            color: text_color
            font.pixelSize: titleFont
            font.family: inter.name
            font.weight: Font.ExtraBold
            text: currentTrack.title
            elide: Text.ElideRight
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            color: text_color
            font.pixelSize: mainFont
            font.family: inter.name
            font.weight: Font.ExtraBold
            text: currentTrack.artist + " - " + currentTrack.album
            elide: Text.ElideRight
            width: gridWidth - artSize - gridVSpacing
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
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
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            width: gridWidth - artSize - gridVSpacing * 0.6
            height: childrenRect.height
            spacing: gridVSpacing * 0.1
            anchors.horizontalCenter: parent.horizontalCenter
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
            /* END PROGRESS BAR */
        }

    } // Column


    MouseArea {
        anchors.fill: parent
        onClicked: {
            close()
        }
    }
}
