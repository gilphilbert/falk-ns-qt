import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import QtQuick.Shapes 1.15
import QtQml.Models 2.3

Rectangle {
    color: "transparent"
    height: 520
    width: 1024

    property string url
    signal navigate(string data)

    ListModel {
        id: libraryModel
    }
    property int padding: 20
    Component {
        id: libraryDelegate
        Item {
            id: wrapper
            height: 100

            Rectangle {
                id: rowBackground
                height: 100
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
                        color: white
                        font.family: poppins.name
                        font.pixelSize: 25
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        text: artist
                        visible: artist !== ""
                        font.family: poppins.name
                        color: "#c0c0c0"
                        font.pixelSize: 18
                        wrapMode: Text.WordWrap
                    }
                }
            }

            MouseArea {
                anchors.fill: rowBackground
                onClicked: {
                    const data = JSON.stringify({ "name": name, "artist": artist })
                    navigate(data)
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
        anchors.fill: parent
        spacing: 10
        model: displayDelegateModel
        leftMargin: padding
        rightMargin: padding
        topMargin: padding
        ScrollBar.vertical: ScrollBar { }
        property string textFilter: ""
        onTextFilterChanged: displayDelegateModel.filter()
    }

    Rectangle {
        color: "transparent"
        height: 70
        width: 70
        radius: 35
        anchors.verticalCenter: parent.verticalCenter
        x: parent.width - 80

        Rectangle {
            anchors.centerIn: parent
            height: 58
            width: 58
            border.color: "#506687"
            border.width: 3
            color: "transparent"
            radius: 29
            visible: grid.textFilter === ""

            Text {
                text: "A-Z"
                color: white
                font.family: kentledge.name
                font.pixelSize: 22
                anchors.centerIn: parent
                topPadding: 3
            }

            MouseArea {
                anchors.fill: parent
                // do something here with a virtual keyboard sort-of-thing
                onClicked: {
                    textSearch.visible = true
                }
            }

        }
        Rectangle {
            anchors.centerIn: parent
            height: 58
            width: 58
            border.color: "#506687"
            border.width: 3
            color: "transparent"
            radius: 29
            visible: grid.textFilter !== ""

            Text {
                text: "X"
                color: white
                font.family: kentledge.name
                font.pixelSize: 22
                anchors.centerIn: parent
                topPadding: 3
            }

            MouseArea {
                anchors.fill: parent
                // do something here with a virtual keyboard sort-of-thing
                onClicked: {
                    grid.textFilter = ""
                }
            }
        }

        border.color: white
        border.width: 3

    }

    property var alphaNumeric: [ "123", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" ]
    Rectangle {
        id: textSearch
        anchors.fill: parent
        visible: false
        color: "#222c3b"

        GridView {
            width: parent.width
            height: parent.height
            x: 0
            y: 0
            leftMargin: 16
            rightMargin: 16
            topMargin: 14
            cellWidth: 124
            cellHeight: 124

            model: alphaNumeric

            delegate: Item {
                height: 120
                width: 120
                Rectangle {
                    color: white
                    opacity: 0.05
                    anchors.fill: parent
                }

                Text {
                    text: model.modelData.toUpperCase()
                    anchors.centerIn: parent
                    font.family: poppins.name
                    font.pixelSize: 28
                    color: white
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        textSearch.visible = false
                        grid.textFilter = model.modelData
                    }
                }
            }
        }
    }

    // this loads the page for the first time (once we know which page we are)
    Component.onCompleted: {
      //apiRequest(url, processResults)
    }
    onUrlChanged: {
        console.info("URL CHANGED:: " + url)
        apiRequest(url, processResults)
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
