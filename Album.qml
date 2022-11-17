import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15


Item {
    width: Window.width
    height: Window.height - footerHeight

    property string url

    readonly property int rowHeight: Math.round(this.height * 0.166666667)
    readonly property int rowPadding: Math.round(this.width * 0.05)
    readonly property int titleTextSize: Math.round(this.height * 0.048888889)
    readonly property int subtitleTextSize: Math.round(this.height * 0.03)
    readonly property real qualityFont: this.width * 0.013

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
        title = data.title
        artist = data.artist
        art = data.art
        genre = data.genre
        year = data.year
        shortformat = data.shortformat

        trackList.clear()
        data.tracks.forEach(item => {
            trackList.append(item)
        })
    }

    Component {
        id: trackDelegate
        Item {
            height: rowHeight
            width: parent.width

            Item {
                width: parent.width
                height: parent.height
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        const apiData = JSON.stringify({ tracks: [ id ] })
                        musicAPIRequest("enqueue", null, "POST", apiData)
                    }
                    onPressAndHold: {
                        //additionalOptions.visible = true
                        additionalTrackID = id
                        additionalOptions.open()
                    }
                }
            }

            Row {
                height: parent.height
                width: parent.width

                Column {
                    leftPadding: appWindow.width * 0.014648438
                    bottomPadding: appWindow.height * 0.008333333
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
                        font.pixelSize: subtitleTextSize
                    }
                }
            }
        }
    }


    /// this whole thing needs to scroll..... container?
    Column {
        anchors.fill: parent
        leftPadding: pageItemPadding
        rightPadding: pageItemPadding
        topPadding: pageItemPadding


        Row {
            height: parent.height * 0.3
            width: parent.width

            Item {
                width: parent.height
                height: parent.height

                Image {
                    id: artImage
                    source: "image://AsyncImage/" + "http://" + settings.host + art + "?size=" + Math.ceil(this.height)
                    height: parent.height * 0.8
                    width: parent.height * 0.8
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    visible: false
                }

                Rectangle {
                    id: artMask
                    anchors.fill: artImage
                    radius: rowRadius
                    visible: false
                }
                OpacityMask {
                    anchors.fill: artImage
                    source: artImage
                    maskSource: artMask
                }
            }

            Column {
                id: textContent
                //anchors.verticalCenter: parent.verticalCenter
                spacing: this.height * 0.03
                height: childrenRect.height

                Text {
                    text: title
                    color: text_color
                    font.family: kentledge.name
                    font.weight: Font.ExtraBold
                    font.pixelSize: titleTextSize
                    wrapMode: Text.WordWrap
                }
                Text {
                    text: artist
                    color: text_color
                    font.family: kentledge.name
                    font.weight: Font.Bold
                    font.pixelSize: subtitleTextSize
                    wrapMode: Text.WordWrap
                }
                Text {
                    text: year
                    color: text_color
                    font.family: kentledge.name
                    font.weight: Font.Bold
                    font.pixelSize: subtitleTextSize
                    wrapMode: Text.WordWrap
                    opacity: 0.7
                }
                Rectangle {
                    color: primary_color
                    Text {
                        text: shortformat
                        font.pixelSize: qualityFont
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: appWindow.color
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

            Row {
                width: parent.width - parent.height - textContent.width - pageItemPadding * 2
                height: parent.height

                layoutDirection: Qt.RightToLeft

                Text {
                    text: "ellipses"
                }

                /*

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height

                    color: blue_dark
                    border.color: primary_color
                    border.width: 2

                    Text {
                        color: primary_color
                        text: 'Enqueue'
                        font.pixelSize: qualityFont
                        font.family: kentledge.name
                        font.weight: Font.Medium
                        leftPadding: qualityPadding
                        rightPadding: qualityPadding
                        topPadding: qualityPadding / 2.05
                        bottomPadding: this.topPadding
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height

                    color: blue_dark
                    border.color: primary_color
                    border.width: 2

                    Text {
                        color: primary_color
                        text: 'Play'
                        font.pixelSize: qualityFont
                        font.family: kentledge.name
                        font.weight: Font.Medium
                        leftPadding: qualityPadding
                        rightPadding: qualityPadding
                        topPadding: qualityPadding / 2.05
                        bottomPadding: this.topPadding
                    }
                }
                */
            }

        }

        Row {
            height: parent.height * 0.7 - pageItemPadding
            width: parent.width - pageItemPadding * 2

            bottomPadding: pageItemPadding

            clip: true

            ListView {
                id: trackListView
                height: parent.height
                width: parent.width
                spacing: appWindow.height * 0.03
                model: trackList
                delegate: trackDelegate
                focus: true
                snapMode: ListView.SnapToItem

                //how to stop this being flickable?
            }
        }
    }

    /*
    Component {
        id: playlistButton
        RadioButton {
            //height: 200
            //width: parent.width
            text: name
            onClicked: {
                selectedPlaylist = id
            }
        }
    }

    onSelectedPlaylistChanged: {
        console.info(selectedPlaylist)
    }
    */

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
            color: blue
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
/*
            ListView {
                id: playlistButtons

                Layout.columnSpan: 2

                Layout.preferredHeight: parent.height * 0.7
                Layout.preferredWidth: parent.width

                spacing: appWindow.height * 0.03

                model: playlistList
                delegate: playlistButton
                focus: true
                snapMode: ListView.SnapToItem
            }
*/
        }

        Rectangle {
            width: iconSize * 0.8
            height: iconSize * 0.8

            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 15

            radius: iconSize * 0.8

            Image {
                source: 'icons/x-blue.svg'
                height: iconSize * 0.5
                width: iconSize * 0.5
                sourceSize.width: this.width
                sourceSize.height: this.height
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    additionalOptions.close()
                }
            }
        }
    }
/*
    function playlistHandler(data) {
        console.info(JSON.stringify(data))
        playlistList.clear()
        data.forEach(item => {
            playlistList.append(item)
        })
    }

    Component.onCompleted: {
        musicAPIRequest("playlist", playlistHandler)
    }
*/
}
