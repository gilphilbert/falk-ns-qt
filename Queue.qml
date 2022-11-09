import QtQuick 2.15
import QtQml.Models 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.12
import QtQuick.Window 2.15

Rectangle {
    //anchors.fill: parent
    height: parent.height
    width: parent.width

    id: queueScreen

    color: background_color

    property bool isActive: false

    x: 0
    y: isActive ? 0 : this.height

    function open() {
        isActive = true
    }
    function close() {
        isActive = false
    }
    function toggle() {
        isActive = !isActive
    }
    function isOpen() {
        return isActive
    }

    Behavior on y {
        NumberAnimation {
            easing.type: Easing.InOutCubic
            duration: 300
        }
    }

    property int pageHeight: this.height
    property int pageWidth: this.width
    property int pageMargin: this.width * (25 / 1024)

    readonly property int titleTextSize: Math.round(this.height * 0.048888889)

    Component {
        id: queueDelegate
        Item {
            height: pageHeight * 0.166666667
            width: pageWidth - pageMargin * 2
            x: pageMargin

            Rectangle {
                color: playing ? white : "transparent"
                anchors.fill: parent
                opacity: 0.07
                radius: this.height * 0.1
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        musicAPIRequest("jump/" + index)
                    }
                }
            }

            Row {
                leftPadding: parent.height * 0.1
                anchors.fill: parent

                Item {
                    height: parent.height * 0.8
                    width: parent.height * 0.8
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: artImage
                        source: "image://AsyncImage/" + "http://" + settings.host + art + "?size=" + Math.ceil(appWindow.height * 0.2)
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        visible: false
                    }
                    Rectangle {
                        id: artMask
                        anchors.fill: parent
                        radius: parent.height * 0.1
                        visible: false
                    }
                    OpacityMask {
                        anchors.fill: artImage
                        source: artImage
                        maskSource: artMask
                    }
                }

                Column {
                    leftPadding: queueScreen.width * 0.014648438
                    bottomPadding: queueScreen.height * 0.008333333
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        color: text_color
                        text: title
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        font.pixelSize: titleTextSize
                    }
                    Text {
                        text: artist + " - " + getPrettyTime(duration)
                        font.family: kentledge.name
                        font.weight: Font.Bold
                        color: text_color
                        font.pixelSize: queueScreen.width * 0.017578125
                    }
                }
            }
        }
    }

    ListView {
        id: queueListView

        anchors.fill: parent

        clip: true

        topMargin: pageMargin
        bottomMargin: pageMargin

        spacing: queueScreen.height * 0.03

        model: queueList
        delegate: queueDelegate
        focus: true
        currentIndex: playPosition > -1 ? playPosition : 0
        snapMode: ListView.SnapToItem

        highlightFollowsCurrentItem: false
    }
}
