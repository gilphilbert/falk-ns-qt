import QtQuick 2.15
import QtQml.Models 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.12
import QtQuick.Window 2.15

Item {
    anchors.fill: parent
    id: queueScreen

    property int pageMargin: this.width * (25 / 1024)

    readonly property int titleTextSize: Math.round(this.height * 0.048888889)

    Component {
        id: queueDelegate
        Item {
            height: queueScreen.height * 0.166666667
            width: parent.width - pageMargin * 2
            x: pageMargin

            Rectangle {
                color: "black"
                anchors.fill: parent
                opacity: 0.07
                radius: this.height * 0.1
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        apiRequest("jump/" + index)
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

    Component {
        id: highlightBar
        Rectangle {
            id: highlightBox
            color: "transparent"
            width: queueListView.currentItem.width
            height: queueListView.currentItem.height
            x: queueListView.currentItem.x
            y: queueListView.currentItem.y
            Behavior on y { SmoothedAnimation { duration: 300 } }

            Rectangle {
                color: white
                opacity: 0.07
                anchors.fill: parent
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: (parent.width / appWindow.playDuration) * appWindow.playElapsed
                height: 5
                color: yellow
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: highlightBox.width
                    height: highlightBox.height
                    Rectangle {
                        width: highlightBox.width
                        height: highlightBox.height
                        radius: queueScreen.height * 0.013333333
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
        currentIndex: playPosition
        snapMode: ListView.SnapToItem

        highlight: highlightBar
        highlightFollowsCurrentItem: false
    }
}
