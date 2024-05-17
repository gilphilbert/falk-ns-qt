// <!------------ QT5 ------------!> //
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.15

/*
// <!------------ QT6 ------------!> //
import QtQuick
import QtQuick.Controls
import QtQml.Models
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Effects
*/

Item {
    width: Window.width
    height: playerHeight - playerFooter
    clip: true

    property int thumbSize: Math.round(width / 5)

    property string url

    ListModel {
        id: libraryModel
        Component.onCompleted: {
            musicAPIRequest(url, processResults)
        }
    }
    property int padding: 20

    function setURL(_url) {
        url = _url
    }

    Component {
        id: libraryDelegate
        Item {
            width: grid.cellWidth
            height: grid.cellHeight

            Column {
                anchors.fill: parent
                Item {
                    height: parent.height * 0.7
                    width: this.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        anchors.fill: parent
                        color: background_pop_color
                        radius: this.height
                        visible: thumb === ""
                    }

                    // <!------------ QT5 ------------!> //
                    Image {
                        id: artImage
                        source: thumb !== "" ? "image://AsyncImage" + thumb : ""
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
                        radius: this.height * ((url !== "artists") ? radiusPercent : 1)
                        visible: false
                    }

                    /*
                    // <!------------ QT6 ------------!> //
                    Image {
                        id: artImage
                        source: thumb !== "" ? "image://AsyncImage/" + thumb : "icons/placeholder.png"
                        width: parent.width - 2
                        height: parent.height - 2
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        visible: false
                    }

                    MultiEffect {
                        source: artImage
                        anchors.fill: artImage
                        maskEnabled: true
                        maskSource: mask
                    }

                    Item {
                        id: mask
                        width: artImage.width
                        height: artImage.height
                        layer.enabled: true
                        visible: false

                        Rectangle {
                            width: artImage.width
                            height: artImage.height
                            radius: this.height * ((url !== "artists") ? radiusPercent : 1)
                            color: "black"
                        }
                    }
                    */
                }
                Text {
                    text: name
                    color: text_color
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    font.pixelSize: text_h2
                    width: parent.width
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    topPadding: parent.height * 0.04
                }

                Text {
                    text: artist
                    color: text_color
                    font.family: inter.name
                    font.weight: Font.Normal
                    font.pixelSize: text_h3
                    width: parent.width
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter

                    visible: artist !== ""
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    let nav = ""
                    if (url == "artists") nav = "artist/" + encodeURIComponent(name)
                    else if (url == "genres") nav = "genre/" + encodeURIComponent(name)

                    if (nav != "") {
                        stack.push("Library.qml", { "url": nav })
                    } else {
                        if (url != "playlists") {
                            // load an album
                            stack.push("Album.qml", { "url": "album/" + encodeURIComponent(artist) + "/" + encodeURIComponent(name) })
                        } else {
                            // load the playlist
                            stack.push("Album.qml", { "url": "playlist/" + id })
                        }
                    }
                }
            }

        }
    }

    DelegateModel {
        id: displayDelegateModel

        delegate: libraryDelegate

        model: libraryModel

        function filter(filterLetter) {
            for (let i = 0; i < items.count; i++) {

                let item = items.get(i)
                let startPos = 0
                if (item.model.name.startsWith("The ")) {
                    startPos = 4
                }

                let showThis = true

                if (textFilter.length === 1) {
                    if (item.model.name.slice(startPos, startPos + 1).toLowerCase() !== textFilter) {
                        showThis = false
                        //scroll to?
                    }
                } else if (textFilter.length > 1) {
                    if (! item.model.name.slice(startPos, item.model.name.length).toLowerCase().includes(textFilter)) {
                        showThis = false
                    }
                }

                if (showThis) {
                    items.addGroups(i, 1, "shown")
                } else {
                    items.removeGroups(i, 1, "shown")
                }
            }
        }

        groups: [
            DelegateModelGroup {
                includeByDefault: true
                id: shownGroup
                name: "shown"
            }
        ]
        filterOnGroup: "shown"

    }

    property string textFilter: ""
    onTextFilterChanged: displayDelegateModel.filter()

    GridView {
        id: grid
        width: parent.width - padding * 2
        height: parent.height
        anchors.centerIn: parent
        model: displayDelegateModel
        cellWidth: this.width / 4
        cellHeight: this.cellWidth
        //ScrollBar.vertical: ScrollBar { width: 0 }
        snapMode: GridView.SnapToRow
    }

    Item {
        height: parent.height * 0.05
        width: this.height
        x: 0
        y: 10 - player.height * 0.14
        z: 2

        // <!------------ QT5 ------------!> //
        Image {
            id: filterIcon
            source: "icons/filter.svg"
            height: parent.height
            width: this.height
            anchors.centerIn: parent
            smooth: true
            sourceSize.width: this.width
            sourceSize.height: this.height
        }

        ColorOverlay{
            anchors.fill: filterIcon
            source: filterIcon
            color: textFilter === "" ? white : primary_color
            transform: rotation
            antialiasing: true
        }

        /*
        // <!------------ QT6 ------------!> //
        IconImage {
            id: filterIcon
            source: "icons/filter.svg"
            height: parent.height
            width: this.height
            anchors.centerIn: parent
            smooth: true
            sourceSize.width: this.width
            sourceSize.height: this.height
            color: textFilter === "" ? white : primary_color
        }
        */

        MouseArea {
            anchors.fill: parent
            onClicked: {
                //if (textFilter === "") {
                    drawer.open()
                //} else {
                //    textFilter = ""
                //}
            }
        }
    }

    property var alphaNumeric: [ "123", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" ]

    function openDrawer() {
        drawer.open()
    }

    Drawer {
        id: drawer
        width: 0.55 * player.width
        height: player.height
        edge: Qt.RightEdge

        Rectangle {
            anchors.fill: parent
            color: background_pop_color

            Column {
                //anchors.fill: parent
                height: parent.height
                width: parent.width

                Row {
                    width: parent.width
                    topPadding: this.height * 0.5

                    Item {
                        height: 1
                        width: parent.width * 0.25
                    }

                    Text {
                        text: "Filter"
                        font.family: inter.name
                        font.pixelSize: text_h1
                        font.weight: Font.ExtraBold
                        color: white
                        horizontalAlignment: Text.AlignHCenter

                        width: parent.width * 0.5
                        height: text_h1
                    }

                    Item {
                        width: parent.width * 0.25
                        height: childrenRect.height

                        Rectangle {
                            color: textFilter === "" ? gray_dark : primary_color
                            height: clearButtonText.paintedHeight * 1.3
                            width: clearButtonText.paintedWidth * 1.4
                            radius: this.height

                            Text {
                                id: clearButtonText
                                text: "Clear"
                                font.family: inter.name
                                font.pixelSize: text_h2
                                font.weight: Font.ExtraBold
                                color: gray_darkish
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    textFilter = ""
                                    drawer.close()
                                }
                            }
                        }
                    }

                }

                GridView {
                    id: letterView
                    width: this.cellWidth * 5
                    height: this.cellWidth * 6
                    cellWidth: this.cellHeight
                    cellHeight: parent.height / 9
                    anchors.horizontalCenter: parent.horizontalCenter
                    topMargin: drawer.height * 0.1

                    model: alphaNumeric

                    delegate: Item {
                        height: letterView.cellWidth
                        width: this.height
                        Rectangle {
                            height: parent.width - (parent.width * 0.1)
                            width: height
                            anchors.centerIn: parent
                            color: "transparent"
                            radius: this.height * 0.08
                        }

                        Text {
                            anchors.centerIn: parent
                            text: model.modelData.toUpperCase()
                            font.family: inter.name
                            font.pixelSize: text_h1
                            font.weight: Font.ExtraBold
                            color: white
                        }
                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                //drawer.close()
                                textFilter += model.modelData
                            }
                        }
                    }
                }
            }
        }
    }
    // this loads the page for the first time (once we know which page we are)

    function processResults(data) {
        let items
        const keys = Object.keys(data)

        if (keys.includes("albums")) {
            items = data.albums
        } else {
            items = data
        }

        items.forEach(item => {
            libraryModel.append({
                "name": item.name,
                "artist": item.artist ? item.artist : data.artist ? data.artist : "",
                "thumb": item.art ? item.art : item.coverart ? item.coverart : "",
                "id": Object.keys(item).includes("id") ? item.id : ""
            })
        })

    }
}
