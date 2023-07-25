import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
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

    property bool hasBigArt: currentTrack.backgroundart !== "" || currentTrack.artistart !== ""

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
            source: "image://AsyncImage/lrge" + ((currentTrack.backgroundart !== "") ? currentTrack.backgroundart : ((currentTrack.artistart !== "") ? currentTrack.artistart : currentTrack.art))
            fillMode: Image.PreserveAspectCrop
            smooth: true
            visible: true
        }
        FastBlur {
            anchors.fill: backgroundArt
            source: backgroundArt
            radius: hasBigArt ? 0 : 56
        }
    }

    Rectangle {
        anchors.fill: parent
        color: background_color
        opacity: 0.8
        visible: backgroundArt.visible
    }

    Row {
        height: Window.height
        width: Window.width

        Column {
            id: artColumn
            width: parent.width * ((hasBigArt) ? 0.25 : 0.4)
            //anchors.verticalCenter: parent.verticalCenter
            leftPadding: parent.width * 0.1
            rightPadding: parent.width * 0.1
            y: ((hasBigArt) ? Window.height - this.width * 0.1 - playingArt.height : (Window.height / 2 - playingArt.height / 2))

            Behavior on y {
                NumberAnimation {
                    easing.type: Easing.InOutCubic
                    duration: 300
                }
            }

            Behavior on width {
                NumberAnimation {
                    easing.type: Easing.InOutCubic
                    duration: 300
                }
            }

                Image {
                    id: playingArt
                    source: "image://AsyncImage/lrge" + currentTrack.art
                    height: this.width
                    width: parent.width * 0.8
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
            width: parent.width * ((hasBigArt) ? 0.75 : 0.6) - artColumn.width * 0.1
            spacing: parent.height * 0.025
            leftPadding: 0
            rightPadding: parent.width * 0.1
            anchors.verticalCenter: artColumn.verticalCenter

            Behavior on y {
                NumberAnimation {
                    easing.type: Easing.InOutCubic
                    duration: 400
                }
            }

            Behavior on width {
                NumberAnimation {
                    easing.type: Easing.InOutCubic
                    duration: 300
                }
            }

            Text {
                id: homeTitle
                color: text_color
                font.pixelSize: titleFont
                font.family: inter.name
                font.weight: Font.ExtraBold
                text: currentTrack.title
                elide: Text.ElideRight
                width: parent.width - parent.rightPadding
            }

            Text {
                color: text_color
                font.pixelSize: mainFont
                font.family: inter.name
                font.weight: Font.ExtraBold
                text: currentTrack.artist + " - " + currentTrack.album
                elide: Text.ElideRight
                width: parent.width - parent.rightPadding
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
                    bottomPadding: this.topPadding - 2
                }
                width: childrenRect.width
                height: childrenRect.height
                radius: childrenRect.height
            }

            Column {
                width: parent.width// - parent.rightPadding
                height: childrenRect.height
                spacing: parent.height * 0.035
                // -------- PROGRESS BAR -------- //

                Item {
                    id: progressBar
                    height: progressBarHeight
                    width: parent.width
                    Rectangle {
                        anchors.fill: parent
                        color: white
                        opacity: 0.2
                        radius: this.height
                    }

                    Rectangle {
                        height: parent.height
                        width: parent.width * (playElapsed / (currentTrack.duration * 1000))
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
                        text: getPrettyTimeMs(playElapsed)
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

    Item {
        height: Window.height * 0.083
        width: this.height
        x: Window.width - this.width
        y: 0

        visible: !(!ac && batteryPercent === 0)

        Image {
            source: ac ? "icons/battery-charging.svg" : batteryPercent > 83 ? "icons/battery-100.svg" : batteryPercent > 66 ? "icons/battery-75.svg" :  batteryPercent > 33  ? "icons/battery-50.svg" : batteryPercent > 15 ? "icons/battery-25.svg" : "icons/battery-0.svg"
            height: parent.height * .45
            width: this.height
            anchors.centerIn: parent
            smooth: true
            sourceSize.width: this.width
            sourceSize.height: this.height
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            close()
        }
    }
}
