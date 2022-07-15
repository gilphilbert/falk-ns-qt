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
        id: playingArt
        source: "image://AsyncImage/" + playArt
        height: 200
        width: 200
        x: 50
        y: 50
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
    }
    Rectangle {
        id: playingArtMask
        height: 200
        width: 200
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
        x: 310
        y: 92
        color: "white"
        font.pixelSize: 45
        font.family: poppins.name
        font.weight: Font.Light
        text: appWindow.playTitle
    }
    Text {
        id: homeArtist
        x: 310
        y: 165
        color: "#c0c0c0"
        font.pixelSize: 22
        font.family: poppins.name
        font.weight: Font.Medium
        text: appWindow.playArtist
    }


    // -------- PROGRESS BAR -------- //
    Rectangle {
        id: progressBar
        height: 3
        width: parent.width - 100
        color: "#4b6281"
        y: 300
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle {
            height: 3
            width: (parent.width / appWindow.playDuration) * appWindow.playElapsed//parent.width / 2
            color: "#E3B505"
            x: 0
            y: 0
        }
    }
    Text {
        anchors.left: progressBar.left
        y: 310
        color: "#c0c0c0"
        font.pixelSize: 14
        text: getPrettyTime(appWindow.playElapsed) //"1:30"
        font.family: kentledge.name
    }
    Text {
        anchors.right: progressBar.right
        y: 310
        color: "#c0c0c0"
        font.pixelSize: 14
        text: getPrettyTime(appWindow.playDuration)
        font.family: kentledge.name
    }

    // -------- PREV BUTTON -------- //
    Rectangle {
        height: 80
        width: 80
        color: 'transparent'
        radius: 40
        border.color: 'white'
        border.width: 3
        x: (parent.width / 2) - 195
        y: 375
        Rectangle {
            height: 66
            width: 66
            color: 'transparent'
            radius: 52
            border.color: "#4b6281"
            border.width: 3
            anchors.centerIn: parent

            Rectangle {
                height: 16
                width: 15
                anchors.centerIn: parent
                color: "transparent"

                Rectangle {
                    height: parent.height
                    width: 3
                    color: "white"
                    anchors.top: parent.top
                    anchors.left: parent.left
                }

                Shape {
                    width: 12
                    height: 16
                    anchors.top: parent.top
                    anchors.right: parent.right
                    ShapePath {
                        fillColor: "white"
                        fillRule: ShapePath.WindingFill
                        startX: 12; startY: 0
                        PathLine { x: 0; y: 8 }
                        PathLine { x: 12; y: 16 }
                        PathLine { x: 12; y: 0 }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                apiRequest("prev")
            }
        }
    }

    // -------- PAUSE/PLAY BUTTON -------- //
    Rectangle {
        height: 110
        width: 110
        color: 'transparent'
        radius: 55
        border.color: 'white'
        border.width: 3
        anchors.horizontalCenter: parent.horizontalCenter
        y: 360
        Rectangle {
            height: 96
            width: 96
            color: 'transparent'
            radius: 52
            border.color: "#4b6281"
            border.width: 3
            anchors.centerIn: parent


            // -------- PAUSE ICON -------- //
            Rectangle {
                height: 28
                width: 18
                anchors.centerIn: parent
                color: "transparent"
                visible: ! appWindow.playPaused

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    height: parent.height
                    width: 5
                    color: "white"
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: parent.height
                    width: 5
                    color: "white"
                }
            }

            // -------- PLAY ICON -------- //
            Shape {
                width: 24
                height: 28
                anchors.centerIn: parent
                visible: appWindow.playPaused
                ShapePath {
                    fillColor: "white"
                    fillRule: ShapePath.WindingFill
                    startX: 0; startY: 0
                    PathLine { x: 24; y: 14 }
                    PathLine { x: 0; y: 28 }
                    PathLine { x: 0; y: 0 }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    apiRequest("toggle")
                }
            }
        }
    }

    // -------- SKIP BUTTON -------- //
    Rectangle {
        height: 80
        width: 80
        color: 'transparent'
        radius: 40
        border.color: 'white'
        border.width: 3
        x: (parent.width / 2) + 110
        y: 375
        Rectangle {
            height: 66
            width: 66
            color: 'transparent'
            radius: 52
            border.color: "#4b6281"
            border.width: 3
            anchors.centerIn: parent

            Rectangle {
                height: 16
                width: 15
                anchors.centerIn: parent
                color: "transparent"

                Shape {
                    width: 12
                    height: 16
                    anchors.top: parent.top
                    anchors.left: parent.left
                    ShapePath {
                        fillColor: "white"
                        fillRule: ShapePath.WindingFill
                        startX: 0; startY: 0
                        PathLine { x: 12; y: 8 }
                        PathLine { x: 0; y: 16 }
                        PathLine { x: 0; y: 0 }
                    }
                }

                Rectangle {
                    height: parent.height
                    width: 3
                    color: "white"
                    anchors.top: parent.top
                    anchors.right: parent.right
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                apiRequest("skip")
            }
        }
    }
}
