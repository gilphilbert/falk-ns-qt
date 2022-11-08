import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import QtQuick.Shapes 1.15
import QtQml.Models 2.3
import QtQuick.Window 2.15


Item {
    width: Window.width
    height: Window.height - footerHeight
    clip: true

    property string url

    ListModel {
        id: libraryModel
    }
    property int padding: 20

    readonly property int titleTextSize: Math.round((Window.height - 80) * 0.048888889)
    readonly property int subtitleTextSize: Math.round((Window.height - 80) * 0.0289)

    function setURL(_url) {
        url = _url
    }

    Component {
        id: libraryDelegate
        Item {
            id: wrapper
            height: Window.height * 0.166666667

            Rectangle {
                id: rowBackground
                height: parent.height
                width: 1024 - (padding * 2)
                color: "transparent"
                opacity: 0.15
                radius: 5
            }


            Row {
                id: libraryRow
                height: parent.height
                padding: 10

                Rectangle {
                    height: libraryRow.height - 20
                    width: libraryRow.height - 20
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"

                    Image {
                        id: artImage
                        source: "image://AsyncImage/" + thumb
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
                    leftPadding: 15
                    bottomPadding: 5
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text: name
                        color: text_color
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        font.pixelSize: titleTextSize
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        text: artist
                        visible: artist !== ""
                        font.family: kentledge.name
                        font.weight: Font.Bold
                        color: text_color
                        opacity: 0.7
                        font.pixelSize: subtitleTextSize
                        wrapMode: Text.WordWrap
                    }
                }
            }

            MouseArea {
                anchors.fill: rowBackground
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
            console.info("filter")
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


    ListView {
        id: grid
        width: parent.width
        height: parent.height
        spacing: 10
        model: displayDelegateModel
        leftMargin: padding
        rightMargin: padding
        topMargin: padding
        ScrollBar.vertical: ScrollBar { }
        property string textFilter: ""
        onTextFilterChanged: displayDelegateModel.filter()
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
                font.family: kentledge.name
                font.pixelSize: 22
                font.weight: Font.ExtraBold
                anchors.centerIn: parent
                topPadding: 3
            }

            MouseArea {
                anchors.fill: parent
                // do something here with a virtual keyboard sort-of-thing
                onClicked: {
                    //textSearch.visible = true
                    console.info('here')
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
                font.family: kentledge.name
                font.pixelSize: 22
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
                        font.family: kentledge.name
                        font.pixelSize: 28
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
    Component.onCompleted: {
        musicAPIRequest(url, processResults)
    }

    function processResults(data) {
        let items
        if (Object.keys(data).includes("albums")) {
            items = data.albums
        } else {
            items = data
        }

        items.forEach(item => {
            libraryModel.append({
                "name": item.name,
                "artist": item.artist ? item.artist : data.artist ? data.artist : "",
                "thumb": "http://" + settings.host + item.art + "?size=150",
            })
        })
    }
}
