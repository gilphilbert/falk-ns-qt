import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Item {
    width: Window.width
    height: playerHeight

    property string url

    readonly property int rowHeight: Math.round(this.height * 0.1)

    readonly property int qualityPadding: this.height * 0.0172

    readonly property int rowRadius: Math.round(this.height * 0.013333333)

    readonly property int pageItemPadding: Math.round(this.width * 0.024414062)

    readonly property real iconSize: this.height * 0.07

    property int selectedPlaylist: -1
    property int additionalTrackID: -1

    property string title: ''
    property string art: ''
    property string artist: ''
    property int year: 0
    property string genre: ''
    property string shortformat: ''

    property bool isPlaylist: false

    ListModel {
        id: trackList
    }

    ListModel {
        id: playlistList
    }

    onUrlChanged: {
        musicAPIRequest(url, processResults)
    }

    function processResults(data) {
        if (Object.keys(data).includes("id")) {
            isPlaylist = true

            title = data.name
            art = data.coverart

            let _d = new Date(data.added)
            year = _d.getFullYear()
            shortformat = "Mixed"
        }
        else {
            title = data.title
            artist = data.artist
            art = data.art
            genre = data.genre
            year = data.year
            shortformat = data.shortformat
        }

        trackList.clear()
        data.tracks.forEach(item => {
            trackList.append(item)
        })
    }

    Component {
        id: trackDelegate
        Rectangle {
            id: container
            height: windowHeight * 0.1666
            width: flickContainer.width - pageItemPadding * 2
            color: background_pop_color
            readonly property int dragRange: 75

            radius: 12

            Image {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
                source: "icons/chevrons-right.svg"
                height: parent.height * 0.3
                width: this.height

                sourceSize.width: this.width
                sourceSize.height: this.height
            }

            Rectangle {
                color: background_pop_color
                width: parent.dragRange * 2
                height: parent.height
                radius: 12

                Image {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 20
                    source: "icons/zap.svg"
                    height: parent.height * 0.3
                    width: this.height

                    sourceSize.width: this.width
                    sourceSize.height: this.height
                }
            }

            Rectangle {
                id: rect
                width: parent.width
                height: parent.height
                color: background_color
                radius: 12

                Rectangle {
                    anchors.fill: parent
                    color: 'white'
                    opacity: 0
                    radius: 12

                    SequentialAnimation on opacity {
                        id: highlight
                        running: false
                        loops: 1
                        PropertyAnimation {
                            to: 0.21
                            duration: 200
                        }
                        PropertyAnimation {
                            to: 0
                            duration: 200
                        }
                    }
                }

                property int beginDrag
                Drag.active: dragArea.drag.active

                Item {
                    width: parent.width
                    height: parent.height
                }

                Row {
                    height: parent.height
                    width: parent.width

                    Item {
                        height: parent.height * 0.8
                        width: parent.height * 0.8
                        anchors.verticalCenter: parent.verticalCenter

                        visible: isPlaylist

                        Image {
                            id: artImage
                            source: "image://AsyncImage" + coverart
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

                    Column {
                        leftPadding: player.width * 0.014648438
                        bottomPadding: player.height * 0.008333333
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width

                        Text {
                            color: text_color
                            text: title
                            font.family: inter.name
                            font.weight: Font.ExtraBold
                            font.pixelSize: text_h2
                            width: parent.parent.width
                        }
                        Text {
                            text: artist + " - " + getPrettyTime(duration)
                            font.family: inter.name
                            font.weight: Font.Normal
                            color: text_color
                            font.pixelSize: text_h3
                            width: parent.parent.width
                        }
                    }
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.XAxis
                    drag.maximumX: container.dragRange
                    drag.minimumX: x - container.dragRange
                    onPressed: {
                        rect.beginDrag = rect.x;
                    }
                    onReleased: {
                        backAnimX.from = rect.x
                        backAnimX.to = rect.beginDrag
                        backAnimX.start()

                        if (rect.x > rect.beginDrag && rect.x - rect.beginDrag === container.dragRange) {
                            // moved right by 50px
                            musicAPIRequest('replaceAndPlay', null, "POST", JSON.stringify({ tracks: [ id ], index: 0  }))
                            highlight.running = true
                        } else if (rect.x < rect.beginDrag && rect.x + container.dragRange === rect.beginDrag) {
                            // moved left by 50px
                            musicAPIRequest('playNext', null, "POST", JSON.stringify({ tracks: [ id ] }))
                            highlight.running = true
                        }
                    }
                    onClicked: {
                        const apiData = JSON.stringify({ tracks: [ id ] })
                        musicAPIRequest("enqueue", null, "POST", apiData)
                        // this should happen on successful return
                        highlight.running = true
                    }
                }
                SpringAnimation {
                  id: backAnimX
                  target: rect
                  property: "x"
                  duration: 300
                  spring: 1
                  damping: 0.2
                }
            }
        }
    }


    ScrollView {
        id: flickContainer
        width: parent.width
        height: parent.height

        // fix direction to vertical only (no horizontal direction) <------------------------------

        leftPadding: pageItemPadding
        rightPadding: pageItemPadding
        bottomPadding: playerFooter + pageItemPadding

        ColumnLayout {
            width: parent.width
            RowLayout {
                Item {
                    Layout.preferredWidth: this.height
                    Layout.preferredHeight: flickContainer.height * 0.3

                    Item {
                        height: parent.height * 0.8
                        width: parent.height * 0.8

                        Image {
                            id: artImage
                            source: art !== "" ? "image://AsyncImage" + art : ""
                            width: parent.width - 2
                            height: parent.height - 2
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            visible: art !== ""
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
                    Layout.fillWidth: true
                    spacing: this.height * 0.03

                    Text {
                        text: title
                        color: text_color
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        font.pixelSize: text_h1
                    }
                    Text {
                        text: artist
                        color: text_color
                        font.family: inter.name
                        font.weight: Font.Bold
                        font.pixelSize: text_h2
                    }
                    Text {
                        text: year
                        color: text_color
                        font.family: inter.name
                        font.weight: Font.Bold
                        font.pixelSize: text_h3
                        //wrapMode: Text.WordWrap
                        //Layout.fillWidth: true
                    }

                    Rectangle {
                        color: primary_color
                        Text {
                            text: shortformat
                            font.pixelSize: text_h3
                            font.family: inter.name
                            font.weight: Font.ExtraBold
                            color: player.color
                            leftPadding: qualityPadding
                            rightPadding: qualityPadding
                            topPadding: qualityPadding / 2.05
                            bottomPadding: this.topPadding
                        }
                        width: childrenRect.width
                        height: childrenRect.height
                        radius: childrenRect.height
                    }

                }
            }

            RowLayout {
                height: childrenRect.height
                width: parent.width
                clip: true
                ListView {
                    id: trackListView
                    Layout.preferredHeight:  childrenRect.height
                    Layout.preferredWidth: parent.width
                    spacing: rowHeight * .1
                    model: trackList
                    delegate: trackDelegate
                    focus: true
                    snapMode: ListView.SnapToItem

                    interactive: false
                }
            }

        }
    } // scrollview

    Popup {
        id: additionalOptions

        height: (parent.height - pageItemPadding * 2) * 0.4
        width: (parent.width - pageItemPadding * 2) * 0.6
        anchors.centerIn: parent
        padding: 0

        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        background: Rectangle {
            color: background_pop_color
            radius: 20
        }

        GridLayout {
            height: parent.height
            width: parent.width * 0.6
            anchors.horizontalCenter: parent.horizontalCenter

            columns: 2
            rows: 1

            Item {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: iconSize
                Layout.preferredHeight: parent.height * 0.3
                Image {
                    source: 'icons/play.svg'
                    height: iconSize
                    width: iconSize
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        musicAPIRequest('replaceAndPlay', null, "POST", JSON.stringify({ tracks: [ additionalTrackID ], index: 0  }))
                        additionalOptions.close()
                    }
                }
            }

            Item {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: iconSize
                Layout.preferredHeight: parent.height * 0.3
                Image {
                    source: 'icons/arrow-right-circle.svg'
                    height: iconSize
                    width: iconSize
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        musicAPIRequest('playNext', null, "POST", JSON.stringify({ tracks: [ additionalTrackID ] }))
                        additionalOptions.close()
                    }
                }
            }


//            ListView {
//                Layout.columnSpan: 2

//                Layout.preferredHeight: parent.height * 0.7
//                Layout.preferredWidth: parent.width

//                spacing: player.height * 0.03

//                model: playlistList
//                delegate: playlistButton
//                focus: true
//                snapMode: ListView.SnapToItem
//            }
        }

        Rectangle {
            width: iconSize * 0.8
            height: iconSize * 0.8

            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 15

            radius: iconSize * 0.8

            /*Image {
                source: 'icons/x-blue.svg'
                height: iconSize * 0.5
                width: iconSize * 0.5
                sourceSize.width: this.width
                sourceSize.height: this.height
                anchors.centerIn: parent
            }*/

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    additionalOptions.close()
                }
            }
        }
    }
}
