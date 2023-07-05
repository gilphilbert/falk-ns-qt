import QtQuick 2.15
import QtQml.Models 2.15
import QtQuick.Shapes 1.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15


Rectangle {
    //anchors.fill: parent
    height: parent.height - playerFooter
    width: parent.width

    id: queueScreen

    color: background_pop_color

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

    Component {
        id: queueDelegate
        Item {
            height: windowHeight * 0.1667
            width: queueListView.width

            Rectangle {
                color: playing ? white : "transparent"
                anchors.fill: parent
                opacity: 0.07
                radius: this.height * radiusPercent
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

                    Item {
                        anchors.fill: parent

                        Image {
                            id: artImage
                            source: "image://AsyncImage/" +  art
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                        }

                        Canvas {
                            anchors.fill: parent
                            antialiasing: true
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.fillStyle = background_pop_color
                                ctx.beginPath()
                                ctx.rect(0, 0, width, height)
                                ctx.fill()

                                ctx.beginPath()
                                ctx.globalCompositeOperation = 'source-out'
                                ctx.roundedRect(0, 0, width, height, parent.height * radiusPercent, parent.height * radiusPercent)
                                ctx.fill()
                            }
                        }
                    }
                }

                Column {
                    leftPadding: queueScreen.width * 0.014648438
                    bottomPadding: queueScreen.height * 0.008333333
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        color: text_color
                        text: title
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        font.pixelSize: text_h2
                    }
                    Text {
                        text: artist + " - " + getPrettyTime(duration)
                        font.family: inter.name
                        font.weight: Font.Normal
                        color: text_color
                        font.pixelSize: text_h3
                    }
                }
            }

            Rectangle {
                color: white
                height: parent.height * 0.4
                width: this.height
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: this.height * 0.5
                radius: this.height * 0.5

                Text {
                    text: "X"
                    color: pink
                    font.family: inter.name
                    font.pixelSize: text_h2
                    font.weight: Font.ExtraBold
                    anchors.centerIn: parent
                    topPadding: 3
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        musicAPIRequest("queue/" + index, null, "DELETE")
                    }
                }
            }
        }
    }

    Column {
        anchors.fill: parent

        padding: pageMargin

        RowLayout {
            height: text_h1
            width: parent.width - pageMargin * 2
            id: row1

            Text {
                text: "Queue"
                color: text_color
                font.family: inter.name
                font.weight: Font.ExtraBold
                font.pixelSize: text_h1
            }

            Rectangle {
                color: pink
                height: childrenRect.height
                width: childrenRect.width
                radius: this.height * radiusPercent

                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                Text {
                    text: "Clear"
                    color: text_color
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    font.pixelSize: parent.parent.height * 0.5

                    topPadding: (parent.parent.height - this.font.pixelSize) / 2
                    bottomPadding: topPadding

                    leftPadding: this.topPadding * 1.3
                    rightPadding: this.leftPadding
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        musicAPIRequest("queue", null, "DELETE")
                    }
                }
            }
        }


        ListView {
            id: queueListView

            width: parent.width - pageMargin * 2
            height: parent.height - row1.height - pageMargin * 2

            clip: true

            topMargin: pageMargin * 2
            spacing: queueScreen.height * 0.03

            model: queueList
            delegate: queueDelegate
            focus: true
            currentIndex: playPosition > -1 ? playPosition : 0
            snapMode: ListView.SnapToItem

            highlightFollowsCurrentItem: false
        }
    }
}
