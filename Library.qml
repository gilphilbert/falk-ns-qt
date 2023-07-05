import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQml.Models 2.3
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3


Item {
    width: Window.width
    height: playerHeight
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

                    Image {
                        id: artImage
                        source: thumb !== "" ? "image://AsyncImage/" + thumb : ""
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        visible: thumb !== ""
                    }

                    Canvas {
                        property int _radPerc: url === 'artists' ? parent.height: parent.height * radiusPercent
                        anchors.fill: parent
                        antialiasing: true
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.fillStyle = background_color
                            ctx.beginPath()
                            ctx.rect(0, 0, width, height)
                            ctx.fill()

                            ctx.beginPath()
                            ctx.globalCompositeOperation = 'source-out'
                            ctx.roundedRect(0, 0, width, height, _radPerc, _radPerc)
                            ctx.fill()
                        }
                    }
                }
                Text {
                    text: name
                    color: text_color
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    font.pixelSize: text_h2 //(parent.height * 0.2) * 0.4
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
                        if (url != "playlist") {
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
                if (grid.textFilter === "" || item.model.name.slice(0, 1).toLowerCase() === grid.textFilter) {
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


    GridView {
        id: grid
        width: parent.width - padding * 2
        height: parent.height
        anchors.centerIn: parent
        model: displayDelegateModel
        cellWidth: this.width / 4
        cellHeight: this.cellWidth
        ScrollBar.vertical: ScrollBar { }
        property string textFilter: ""
        onTextFilterChanged: displayDelegateModel.filter()
        snapMode: GridView.SnapToRow
    }

    Item {
        height: 70
        width: 70
        anchors.verticalCenter: parent.verticalCenter
        x: parent.width - 80

        Rectangle {
            anchors.fill: parent
            radius: 35
            color: white
            visible: grid.textFilter === ""

            Text {
                text: "A-Z"
                color: primary_color
                font.family: inter.name
                font.pixelSize: text_h2
                font.weight: Font.ExtraBold
                anchors.centerIn: parent
                topPadding: 3
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    drawer.open()
                }
            }

        }
        Rectangle {
            anchors.fill: parent
            radius: 35
            color: primary_color
            visible: grid.textFilter !== ""

            Text {
                text: "X"
                color: white
                font.family: inter.name
                font.pixelSize: text_h2
                font.weight: Font.ExtraBold
                anchors.centerIn: parent
                topPadding: 3
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    grid.textFilter = ""
                }
            }
        }
    }

    property var alphaNumeric: [ "123", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" ]

    Drawer {
        id: drawer
        width: 0.55 * appWindow.width
        height: appWindow.height
        edge: Qt.RightEdge

        Rectangle {
            anchors.fill: parent
            color: background_pop_color

            GridView {
                id: letterView
                width: this.cellWidth * 5
                height: this.cellWidth * 6
                anchors.centerIn: parent
                cellWidth: parent.width * 0.19
                cellHeight: this.cellWidth

                model: alphaNumeric

                delegate: Item {
                    height: letterView.cellWidth
                    width: this.height
                    Rectangle {
                        height: parent.width - (parent.width * 0.1)
                        width: height
                        anchors.centerIn: parent
                        color: white
                        radius: this.height * 0.08
                    }

                    Text {
                        anchors.centerIn: parent
                        text: model.modelData.toUpperCase()
                        font.family: inter.name
                        font.pixelSize: text_h1
                        font.weight: Font.ExtraBold
                        color: primary_color
                    }
                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            drawer.close()
                            grid.textFilter = model.modelData
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
                "thumb": item.art,
                "id": Object.keys(item).includes("id") ? item.id : ""
            })
        })

    }
}
