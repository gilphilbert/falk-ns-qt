import QtQuick 2.15
import QtQuick.Window 2.15


Rectangle {
    width: Window.width
    height: parent.height
    color: background_color

    property bool isActive: false

    x: isActive ? 0 : this.width
    y: 0

    Behavior on x {
        NumberAnimation {
            easing.type: Easing.InOutCubic
            duration: 300
        }
    }

    function open() {
        isActive = true
    }
    function close() {
        isActive = false
    }


    Text {
        x: 0
        y: 0
        color: text_color
        font.pixelSize: text_h1
        font.family: inter.name
        font.weight: Font.ExtraBold
        text: 'Settings'
        height: 30
        width: 100
    }

  // set the ip address of the server here
    Rectangle {
        x: 0
        y: 30
        height: parent.height * 0.1
        width: parent.width * 0.5
        color: background_pop_color
        radius: this.height * radiusPercent

        TextInput {
            id: input
            color: "white"
            text: settings.host
            width: parent.width-16; height: 28
            anchors.centerIn: parent
            focus: true
            font.pixelSize: text_h2
            font.family: inter.name
            font.weight: Font.ExtraBold
            padding: 0
        }
    }
    // button to save

    /*
    Rectangle {
        x: 0
        y: parent.height - this.height
        width: parent.width
        height: 100
        color: '#333333'
    }
    */

}
