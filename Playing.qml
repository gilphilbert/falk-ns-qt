import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.12

/* HOME SCREEN */
Rectangle {
    property string page

    width: parent.width
    height: parent.height - 80
    color: "transparent"
    id: homeScreen

    // -------- PLAYING SONG INFO-------- //
    Image {
        id: mediaArt
        source: "image://AsyncImage/" + "http://" + settings.host + queue[playPosition].discart + "?size=" + Math.ceil(appWindow.width * 0.2)
        height: playingArt.height
        width: playingArt.width
        x: playingArt.x + (appWindow.width * 0.035)
        y: playingArt.y
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: true
        /*
        RotationAnimator on rotation {
            id: discRotate
            from: 0
            to: 360
            duration: 3000
            loops: Animation.Infinite
        }
        */
    }

    Image {
        id: playingArt
        source: "image://AsyncImage/" + "http://" + settings.host + queue[playPosition].art + "?size=" + Math.ceil(appWindow.width * 0.2)
        height: appWindow.width * 0.2
        width: appWindow.width * 0.2
        x: appWindow.width * 0.05
        y: appWindow.width * 0.05
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
    }
    Rectangle {
        id: playingArtMask
        height: appWindow.width * 0.2
        width: appWindow.width * 0.2
        radius: 10
        visible: false
    }
    OpacityMask {
        anchors.fill: playingArt
        source: playingArt
        maskSource: playingArtMask
    }

    Text {
        id: homeTitle
        x: appWindow.width * 0.3
        y: appWindow.height * 0.115
        color: white
        font.pixelSize: appWindow.width * 0.0439
        font.family: poppins.name
        font.weight: Font.Light
        text: queue[playPosition].title
    }
    Text {
        id: homeAlbum
        x: appWindow.width * 0.3
        y: appWindow.height * 0.23
        color: white
        opacity: 0.7
        font.pixelSize: appWindow.width * 0.021
        font.family: poppins.name
        font.weight: Font.Medium
        text: "From " + queue[playPosition].album
    }

    Text {
        id: homeArtist
        x: appWindow.width * 0.3
        y: appWindow.height * 0.3
        color: white
        opacity: 0.7
        font.pixelSize: appWindow.width * 0.021
        font.family: poppins.name
        font.weight: Font.Medium
        text: "By " + queue[playPosition].artist
    }
    Rectangle {
        color: yellow
        Text {
            text: queue[playPosition].shortformat
            font.pixelSize: appWindow.width * 0.013
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

        x: appWindow.width * 0.3
        y: appWindow.height * 0.37
    }

    //> --------------------------- why isn't this working?


    // -------- PROGRESS BAR -------- //
    Rectangle {
        id: progressBar
        height: appWindow.height * 0.0045
        width: appWindow.width * 0.90
        color: blue_light
        y: appWindow.height * 0.55
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle {
            height: parent.height
            width: (parent.width / appWindow.playDuration) * appWindow.playElapsed//parent.width / 2
            color: yellow
            x: 0
            y: 0
        }
    }
    Text {
        anchors.left: progressBar.left
        y: appWindow.height * 0.57
        color: white
        opacity: 0.7
        font.pixelSize: appWindow.width * 0.014
        text: getPrettyTime(appWindow.playElapsed) //"1:30"
        font.family: kentledge.name
    }
    Text {
        anchors.right: progressBar.right
        y: appWindow.height * 0.57
        color: white
        opacity: 0.7
        font.pixelSize: appWindow.width * 0.014
        text: getPrettyTime(appWindow.playDuration)
        font.family: kentledge.name
    }

    Grid {
        width: parent.width
        height: appWindow.height * 0.04
        x: 0
        y: appWindow.height * 0.70
        horizontalItemAlignment: Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter

        columns: 5
        rows: 1

        Item {
            width: parent.width / parent.columns
            height: appWindow.height * 0.04
        }

        // -------- PREV BUTTON -------- //
        Item {
            width: parent.width / parent.columns
            height: appWindow.height * 0.04

            Image {
                source: 'icons/skip-back.svg'
                height: parent.height
                width: parent.height
                sourceSize.width: this.width
                sourceSize.height: this.height
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        apiRequest("prev")
                    }
                }

            }
        }

        // -------- PAUSE/PLAY BUTTON -------- //
        Item {
            width: parent.width / parent.columns
            height: appWindow.height * 0.05
            Image {
                source: appWindow.playPaused ? 'icons/play.svg' : 'icons/pause.svg'
                height: parent.height
                width: parent.height
                sourceSize.width: this.width
                sourceSize.height: this.height
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        apiRequest("toggle")
                    }
                }
            }
        }

        // -------- SKIP BUTTON -------- //
        Item {
            width: parent.width / parent.columns
            height: appWindow.height * 0.04
            Image {
                source: "icons/skip-forward.svg"
                height: parent.height
                width: parent.height
                sourceSize.width: this.width
                sourceSize.height: this.height
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        apiRequest("next")
                    }
                }
            }
        }

        Item {
            width: parent.width / parent.columns
            height: appWindow.height * 0.04
        }
    }
}
