// <!------------ QT5 ------------!> //
import QtQuick 2.15
import QtQuick.Controls 2.15

/*
// <!------------ QT6 ------------!> //
import QtQuick
import QtQuick.Controls
*/

Item {
    id: connecting
    x: 0
    y: 0
    anchors.fill: parent

    function open() {
        this.folded = false
    }

    function close() {
        this.folded = true
    }

    property bool folded: false

    state: !folded ? "Visible" : "Invisible"
    states: [
        State{
            name: "Visible"
            PropertyChanges {
                target: connecting
                opacity: 1.0
            }
            PropertyChanges {
                target: connecting
                visible: true
            }
        },
        State{
            name:"Invisible"
            PropertyChanges {
                target: connecting
                opacity: 0.0
            }
            PropertyChanges {
                target: connecting
                visible: false
            }
        }
    ]

    transitions: [
        Transition {
            from: "Visible"
            to: "Invisible"

            SequentialAnimation{
                NumberAnimation {
                    target: connecting
                    property: "opacity"
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: connecting
                    property: "visible"
                    duration: 0
                }
            }
        },

        Transition {
            from: "Invisible"
            to: "Visible"
            SequentialAnimation{
                NumberAnimation {
                    target: connecting
                    property: "visible"
                    duration: 0
                }
                NumberAnimation {
                    target: connecting
                    property: "opacity"
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }
    ]

    Rectangle {
        anchors.fill: parent
        color: black
        opacity: 0.7
    }

    Rectangle {
        height: (titleText.paintedHeight + titleText.topPadding + checkModalIndicator.height + checkModalIndicator.topPadding + checkModalIndicator.topPadding + button.height) * 1.2
        width: parent.width * 0.66
        anchors.centerIn: parent
        color: primary_color
        radius: this.height * 0.05

        Column {
            width: parent.width
            height: childrenRect.height
            anchors.centerIn: parent
            leftPadding: this.width * 0.15
            rightPadding: this.leftPadding

            Text {
                id: titleText
                text: "Connecting"
                color: gray_darkish
                font.pixelSize: text_h1
                font.family: inter.name
                font.weight: Font.ExtraBold
                anchors.horizontalCenter: parent.horizontalCenter
            }

            BusyIndicator {
                id: checkModalIndicator
                running: true
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: text_h1
                bottomPadding: text_h1
            }

            Rectangle {
                id: button
                color: gray_darkish
                width: parent.width * 0.3
                height: text_h2 * 3
                radius: this.height
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "Settings"
                    color: white
                    anchors.fill: parent
                    font.pixelSize: text_h2
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        folded = true
                        settingsScreen.open()
                    }
                }
            }
        }
    }
}
