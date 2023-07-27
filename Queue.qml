import QtQuick 2.15
import QtQml.Models 2.3
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15


Rectangle {
    id: queueScreen

    color: blue_subdued

    height: parent.height - playerFooter
    width: parent.width

    property bool isActive: false

    x: 0
    y: isActive ? 0 : player.height

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

    function findThisItem(myIndex) {
        for (let i = 0; i < visualModel.items.count; i++) {
            let p = visualModel.items.get(i)
            console.log(p.model.index)
            if (p.model.index === myIndex) {
                return i
            }
        }
        return -1
    }

    property int pageHeight: this.height
    property int pageWidth: this.width
    property int pageMargin: this.width * (25 / 1024)

    Component {
        id: dragDelegate

        MouseArea {
            id: dragArea

            property bool held: false
            required property string title
            required property string artist
            required property int duration
            required property string art
            required property bool playing
            required property int index

            property int moveFrom: -1

            anchors {
                left: parent.left
                right: parent.right
            }
            height: windowHeight * 0.1667

            drag.target: held ? content : undefined
            drag.axis: Drag.YAxis

            onPressAndHold: {
                moveFrom = findThisItem(index)
                held = true
            }
            onReleased: {
                held = false
                musicAPIRequest("move/" + index + "/" + findThisItem(index))
            }
            onClicked: {
                musicAPIRequest("jump/" + index)
            }

            Rectangle {
                id: content
                color: "transparent"
                clip: true

                Rectangle {
                    anchors.fill: parent
                    color: white
                    opacity: held ? .25 : playing ? 0.15 : .07
                    radius: this.height * radiusPercent
                    Behavior on opacity {
                        NumberAnimation {
                            easing.type: Easing.InOutCubic
                            duration: 300
                        }
                    }
                }

                radius: this.height * radiusPercent

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                width: dragArea.width
                height: dragArea.height

                Drag.active: dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                states: State {
                    when: dragArea.held

                    ParentChange {
                        target: content
                        parent: queueScreen
                    }
                    AnchorChanges {
                        target: content
                        anchors {
                            horizontalCenter: undefined
                            verticalCenter: undefined
                        }
                    }
                }

                Row {
                    id: row
                    anchors {
                        fill: parent
                        margins: 2
                    }
                    leftPadding: parent.height * 0.1


                    Item {
                        height: parent.height * 0.8
                        width: parent.height * 0.8
                        anchors.verticalCenter: parent.verticalCenter

                        Item {
                            anchors.fill: parent

                            Image {
                                id: artImage
                                source: "image://AsyncImage" +  dragArea.art
                                width: parent.width - 2
                                height: parent.height - 2
                                anchors.centerIn: parent
                                fillMode: Image.PreserveAspectCrop
                                smooth: true

                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: mask
                                }
                            }

                            Rectangle {
                                id: mask
                                anchors.fill: artImage
                                radius: this.height * radiusPercent
                                visible: false
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
                    height: 46
                    width: 46
                    color: red
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 30
                    radius: 46

                    Image {
                        source: "icons/trash.svg"
                        width: parent.width * 0.5
                        height: parent.height * 0.5
                        sourceSize.width: this.width
                        sourceSize.height: this.height
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("queue/" + index, null, "DELETE")
                        }
                    }
                }
            }

            DropArea {
                anchors {
                    fill: parent
                    margins: 10
                }

                onEntered: (drag) => {
                    visualModel.items.move(
                        drag.source.DelegateModel.itemsIndex, dragArea.DelegateModel.itemsIndex)
                }
            }
        }
    }

    DelegateModel {
        id: visualModel

        model: queueList
        delegate: dragDelegate
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
                color: primary_color
                height: childrenRect.height
                width: childrenRect.width
                radius: this.height

                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                Text {
                    text: "Clear"
                    color: background_pop_color
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    font.pixelSize: parent.parent.height * 0.5

                    topPadding: (parent.parent.height - this.font.pixelSize) / 1.5
                    bottomPadding: topPadding

                    leftPadding: this.topPadding * 1.5
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

        Rectangle {
            color: "transparent"

            width: parent.width - pageMargin * 2
            height: parent.height - row1.height - pageMargin * 2

            ListView {
                id: view

                anchors {
                    fill: parent
                    margins: 2
                }

                topMargin: pageMargin * 2
                spacing: queueScreen.height * 0.03

                model: visualModel

                focus: true
                currentIndex: playPosition > -1 ? playPosition : 0
                snapMode: ListView.SnapToItem

                highlightFollowsCurrentItem: false

                cacheBuffer: 50
            }
        }
    }
}
