import QtQuick 2.0
import QtGraphicalEffects 1.12

Rectangle {
    property bool isCurrent: title.startsWith(appWindow.pageName) && title !== ""
    property string title: ""

    signal click(string page)

    width: appWindow.width / 8 //128
    height: footerHeight
    color: "transparent"
    clip: true

    Text {
        id: pageTitle
        anchors.centerIn: parent
        font.family: kentledge.name
        font.pixelSize: appWindow.height * 0.026666667
        color: white
        opacity: ((isCurrent) ? 1 : 0.6)
        text: title.toUpperCase()
    }
    Rectangle {
        id: divider
        x: 0
        y: 0
        height: 3
        width: parent.width
        color: isCurrent ? yellow : blue_light
    }
    Glow {
        anchors.fill: divider
        radius: 15
        samples: 17
        color: isCurrent ? yellow : "transparent"
        source: divider
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            click(title)
        }
    }

}
