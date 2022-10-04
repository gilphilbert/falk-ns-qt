import QtQuick 2.15
import QtQml.Models 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.12

Rectangle {
    property string page

    property int pageMargin: queueScreen.width * (25 / 1024)

    id: queueScreen
    width: parent.width
    height: parent.height - 80
    color: "transparent"

    Component {
        id: queueDelegate
        Item {
            id: wrapper
            height: appWindow.height * 0.166666667

            Rectangle {
                id: rowBackground
                color: "white"
                width: queueScreen.width - pageMargin * 2
                height: parent.height
                opacity: 0.07
                radius: appWindow.height * 0.013333333
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        apiRequest("jump/" + index)
                    }
                }
            }
            /*
            Rectangle {
                id: rowBackground
                color: "transparent"
                width: queueScreen.width - pageMargin * 2
                height: parent.height
                //radius: appWindow.height * 0.013333333

                Rectangle {
                    color: white
                    anchors.fill: parent
                    opacity: index === queueListView.currentIndex ? 0.18 : 0.07
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: (parent.width / appWindow.playDuration) * appWindow.playElapsed
                    height: 5
                    color: yellow
                    opacity: 1
                    visible: index === queueListView.currentIndex
                }

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: rowBackground.width
                        height: rowBackground.height
                        Rectangle {
                            //anchors.centerIn: rowBackground
                            width: rowBackground.width
                            height: rowBackground.height
                            radius: 8
                        }
                    }
                }


            }
            */

            Row {
                leftPadding: parent.height * 0.1
                height: parent.height
                width: parent.width
                id: queueRow

                Rectangle {
                    height: parent.height * 0.8
                    width: parent.height * 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"

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
                        radius: 8
                        visible: false
                    }
                    OpacityMask {
                        anchors.fill: artImage
                        source: artImage
                        maskSource: artMask
                    }
                }

                Column {
                    leftPadding: appWindow.width * 0.014648438
                    bottomPadding: appWindow.height * 0.008333333
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        color: white
                        text: title
                        font.family: poppins.name
                        //font.weight: Font.Light
                        font.pixelSize: appWindow.width * 0.024414062
                    }
                    Text {
                        text: artist + " - " + getPrettyTime(duration)
                        font.family: poppins.name
                        color: white
                        opacity: 0.7
                        font.pixelSize: appWindow.width * 0.017578125
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
            width: parent.width
            height: queueListView.currentItem.height
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
                        //anchors.centerIn: rowBackground
                        width: highlightBox.width
                        height: highlightBox.height
                        radius: appWindow.height * 0.013333333
                    }
                }
            }
        }
    }

    ListView {
        id: queueListView
        anchors.fill: parent
        topMargin: pageMargin
        bottomMargin: pageMargin
        leftMargin: pageMargin
        rightMargin: pageMargin
        spacing: appWindow.height * 0.03
        model: queueList
        delegate: queueDelegate
        focus: true
        currentIndex: playPosition
        snapMode: ListView.SnapToItem

        highlight: highlightBar
        highlightFollowsCurrentItem: false
    }
}
