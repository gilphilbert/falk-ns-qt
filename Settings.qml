import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    width: Window.width
    height: playerHeight

  // set the ip address of the server here
    Rectangle {
        height: parent.height * 0.1
        width: parent.width * 0.5
        color: background_pop_color
        /*
        TextInput {
            height: parent.height * 0.1
            width: parent.width * 0.5
            color: 'blue'
        }
        */
        radius: this.height * 0.1

        TextInput {
            id: input
            color: "red"
            text: "Default Text"
            width: parent.width-16; height: 28
            anchors.centerIn: parent
            focus: true
        }
    }

}
