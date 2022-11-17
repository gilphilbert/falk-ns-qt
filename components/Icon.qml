import QtQuick 2.15
import QtGraphicalEffects 1.12


Item {
    property string icon
    property color iconColor

    signal clicked()

    property real containerHeight
    property real containerWidth

    height: containerHeight
    width: containerWidth

    property real iconHeight//: this.height
    property real iconWidth//: this.width

    Image {
        source: "../icons/" + icon + ".svg"
        height: iconHeight
        width: iconWidth

        sourceSize.height: this.height
        sourceSize.width: this.width

        //anchors.centerIn: parent

        ColorOverlay{
            anchors.fill: parent
            source: parent
            color: iconColor
            antialiasing: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                clicked()
            }
        }
    }

    Component.onCompleted: {
        console.info("icons/" + icon + ".svg")
    }
}
