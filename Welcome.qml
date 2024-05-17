// <!------------ QT5 ------------!> //
import QtQuick 2.15

/*
// <!------------ QT6 ------------!> //
import QtQuick
*/


Item {
    id: welcome
    x: 0
    y: 0
    anchors.fill: parent

    function open() {
        this.folded = false
    }

    function close() {
        this.folded = true
    }

    property bool folded: true
    state: !folded ? "Visible" : "Invisible"
    states: [
        State{
            name: "Visible"
            PropertyChanges {
                target: welcome
                opacity: 1.0
            }
            PropertyChanges {
                target: welcome
                visible: true
            }
        },
        State{
            name:"Invisible"
            PropertyChanges {
                target: welcome
                opacity: 0.0
            }
            PropertyChanges {
                target: welcome
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
                    target: welcome
                    property: "opacity"
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: welcome
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
                    target: welcome
                    property: "visible"
                    duration: 0
                }
                NumberAnimation {
                    target: welcome
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
        height: (titleText.paintedHeight + titleText.topPadding + introText1.paintedHeight + introText1.topPadding + introText2.paintedHeight + introText2.topPadding + introText2.bottomPadding + button.height) * 1.2
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
                text: "Welcome"
                color: gray_darkish
                font.pixelSize: text_h1
                font.family: inter.name
                font.weight: Font.ExtraBold
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: introText1
                text: "This controller unit is designed to connect to a FALK-DP player on the same network as this device. To continue, you'll need the IP address of a FALK-DP player on your network."
                color: gray_darkish
                wrapMode: Text.WordWrap
                font.pixelSize: text_h4
                font.family: inter.name
                font.weight: Font.Bold
                topPadding: text_h4 * 2
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - parent.leftPadding - parent.rightPadding
            }

            Text {
                id: introText2
                text: "When you've got the address, click Continue to set up this device"
                color: gray_darkish
                wrapMode: Text.WordWrap
                font.pixelSize: text_h4
                font.family: inter.name
                font.weight: Font.Bold
                topPadding: text_h4 * 2
                bottomPadding: text_h4 * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: button
                color: gray_darkish
                width: parent.width * 0.3
                height: text_h2 * 3
                radius: this.height
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "Continue"
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
                        settingsScreen.open()
                        welcome.close()
                    }
                }
            }
        }
    }
}
