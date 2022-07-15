import QtQuick 2.0
import QtGraphicalEffects 1.12

Rectangle {
    property bool isCurrent: title.startsWith(appWindow.pageName) && title !== ""
    property string title: ""

    signal click(string page)

    width: 128
    height: 80
    color: appWindow.pageName === "Playing" ? "transparent" : "#3d4d66"
    clip: true

    Text {
        id: pageTitle
        anchors.centerIn: parent
        font.family: kentledge.name
        color: isCurrent ? "#ffffff" : "#c0c0c0"
        text: title.toUpperCase()
    }

    Glow {
        anchors.fill: pageTitle
        radius: 8
        opacity: 0.25
        samples: 17
        color: isCurrent ? "white" : "transparent"
        source: pageTitle
    }
    Rectangle {
        id: divider
        x: 0
        y: 0
        height: 3
        width: parent.width
        color: isCurrent ? "#E3B505" : "#4b6281"
    }
    Glow {
        anchors.fill: divider
        radius: 15
        samples: 17
        color: isCurrent ? "#E3B505" : "transparent"
        source: divider
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            click(title)
        }
    }

}
