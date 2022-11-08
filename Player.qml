import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "components"

Item {
    id: player

    property real playerFooter: this.height * 0.15
    property real playerHeight: this.height * 0.85

    function musicAPIRequest(urlComponent, callback, action = "GET", data = "") {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = (function (myxhr) {
            return function () {
                if (xhr.readyState === XMLHttpRequest.DONE)
                    if (callback) {
                        try {
                            callback(JSON.parse(xhr.responseText))
                        } catch (e) {
                            console.error(e)
                            console.error(xhr.responseText)
                        }
                    }
            }
        })(xhr)

        let fullURL = "http://" + settings.host + "/api/" + urlComponent
        //console.info(fullURL)

        xhr.open(action, fullURL, true)

        if (action === "POST") {
            xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        }

        xhr.send(data)
    }

    function str_pad_left(string,pad,length) {
        return (new Array(length+1).join(pad)+string).slice(-length);
    }
    function getPrettyTime(t_seconds) {
        let seconds = t_seconds

        const hours = Math.floor(seconds / 3600)
        seconds = seconds - hours * 3600

        const minutes = Math.floor(seconds / 60)
        seconds = seconds - minutes * 60

        return ((hours > 0) ? hours + ":" : "") + ((hours > 0) ? str_pad_left(minutes, '0', 2) : minutes) + ':' + str_pad_left(seconds, '0', 2)
    }

    function setLibraryPage (page) {
        stack.pop(null)
        stack.push("Library.qml", { "url": page })
    }

    Column {
        anchors.fill: parent

        Item {
            width: parent.width
            height: parent.height * 0.14

            Rectangle {
                color: pink
                width: parent.height
                height: parent.height
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //!<--------------------- only if there are more items in the stack!
                        stack.pop()
                    }
                }
            }

            Row {
                height: parent.height
                //width: childrenRect.width
                anchors.centerIn: parent
                spacing: this.height * 0.3

                Item {
                    height: parent.height * 0.5
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text: "Playlists"
                        anchors.centerIn: parent
                        font.pixelSize: parent.height * 0.4
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: white
                        leftPadding: this.width * 0.15
                        rightPadding: this.width * 0.15
                        topPadding: (parent.height * 0.4) * 0.2

                        Rectangle {
                            anchors.fill: parent
                            color: pink
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("playlist")
                        }
                    }
                }

                Rectangle {
                    color: background_pop_color
                    height: parent.height * 0.5
                    radius: this.height * 0.18
                    anchors.verticalCenter: parent.verticalCenter
                    //width: childrenRect.width
                    Text {
                        text: "Artists"
                        anchors.centerIn: parent
                        font.pixelSize: parent.height * 0.4
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: white
                        //leftPadding: this.width * 0.15
                        //rightPadding: this.width * 0.15
                        topPadding: (parent.height * 0.4) * 0.2
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("artists")
                        }
                    }
                }

                Rectangle {
                    color: background_pop_color
                    height: parent.height * 0.5
                    radius: this.height * 0.18
                    anchors.verticalCenter: parent.verticalCenter
                    //width: childrenRect.width
                    Text {
                        text: "Albums"
                        anchors.centerIn: parent
                        font.pixelSize: parent.height * 0.4
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: white
                        //leftPadding: this.width * 0.15
                        //rightPadding: this.width * 0.15
                        topPadding: (parent.height * 0.4) * 0.2
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("albums")
                        }
                    }
                }

                Rectangle {
                    color: background_pop_color
                    height: parent.height * 0.5
                    radius: this.height * 0.18
                    anchors.verticalCenter: parent.verticalCenter
                    //width: childrenRect.width
                    Text {
                        text: "Genres"
                        anchors.centerIn: parent
                        font.pixelSize: parent.height * 0.4
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: white
                        //leftPadding: this.width * 0.15
                        //rightPadding: this.width * 0.15
                        topPadding: (parent.height * 0.4) * 0.2
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("genres")
                        }
                    }
                }
            }
        }

        StackView {
            id: stack
            width: parent.width
            height: playerHeight * 0.86
            clip: true
        }

    }

    Component.onCompleted: {
        stack.pop(null)
        stack.push("Library.qml", { "url": "artists" })
    }

    Drawer {
        id: queueDrawer
        width: parent.width
        height: parent.height * 0.80
        edge: Qt.BottomEdge
        background: Rectangle {
            color: background_pop_color
        }
        Queue { }
    }

    Item {
        height: playerFooter
        width: parent.width
        anchors.bottom: parent.bottom

        Rectangle {
            anchors.fill: parent
            color: background_pop_color
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.04
            color: blue_lighter

            Rectangle {
                width: parent.width * (playElapsed / currentTrack.duration)
                height: parent.height
                color: primary_color
            }
        }


        Item {
            width: parent.width
            height: parent.height * 0.96
            anchors.bottom: parent.bottom

            Row {
                leftPadding: this.height * .15
                height: parent.height
                width: parent.width * 0.33
                spacing: this.height * 0.15

                Item {
                    height: parent.height
                    width: this.height * 0.7
                    Image {
                        id: playingArt
                        source: "image://AsyncImage/" + "http://" + settings.host + currentTrack.art
                        height: parent.height * 0.7
                        width: this.height
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        visible: false
                    }
                    Rectangle {
                        id: artMask
                        anchors.fill: playingArt
                        radius: this.height * 0.07
                        visible: true
                    }
                    OpacityMask {
                        anchors.fill: playingArt
                        source: playingArt
                        maskSource: artMask
                    }
                }
                Column {
                    height: childrenRect.height
                    width: parent.width - parent.leftPadding - playingArt.width
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        color: text_color
                        font.pixelSize: parent.parent.height * 0.2
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        text: currentTrack.title
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    Text {
                        color: text_color
                        font.pixelSize: parent.parent.height * 0.14
                        font.family: kentledge.name
                        font.weight: Font.Bold
                        text: currentTrack.artist
                        elide: Text.ElideRight
                        width: parent.width
                    }
                }
            }

            Item {
                height: parent.height * 0.6
                width: this.height
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 0 - ((parent.height * 0.6) * 1.3)

                Image {
                    id: iconBack
                    source: "icons/skip-back.svg"
                    height: parent.height * 0.45
                    width: this.height
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("prev")
                        }
                    }
                }
                ColorOverlay{
                    anchors.fill: iconBack
                    source: iconBack
                    color: primary_color
                    antialiasing: true
                }
            }

            Rectangle {
                height: parent.height * 0.6
                width: this.height
                color: white
                radius: this.height * 0.5
                anchors.centerIn: parent

                Image {
                    id: iconPlayPause
                    source: appWindow.playPaused ? 'icons/play.svg' : 'icons/pause.svg'
                    height: parent.height * 0.45
                    width: this.height
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("toggle")
                        }
                    }
                }

                ColorOverlay{
                    anchors.fill: iconPlayPause
                    source: iconPlayPause
                    color: primary_color
                    antialiasing: true
                }
            }

            Item {
                height: parent.height * 0.6
                width: this.height
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: (parent.height * 0.6) * 1.3

                Image {
                    id: iconNext
                    source: "icons/skip-forward.svg"
                    height: parent.height * 0.45
                    width: this.height
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("next")
                        }
                    }
                }
                ColorOverlay{
                    anchors.fill: iconNext
                    source: iconNext
                    color: primary_color
                    antialiasing: true
                }
            }

            Rectangle {
                color: pink
                height: parent.height
                width: parent.height
                anchors.right: parent.right
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        queueDrawer.open()
                    }
                }
            }
        }
    }

    /*
        Rectangle {
            id: rect
            width: 50
            height: 50
            color: primary_color
            x: (appWindow.width / 8) * 2 - 50
            y: footerHeight / 2 - this.height / 2
            opacity: 0
            radius: this.width / 2

            Text {
                text: "+1"
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 2
                color: white
                font.pixelSize: 22
                font.family: kentledge.name
                font.weight: Font.ExtraBold
            }

            ParallelAnimation {
                id: testAnimation
                NumberAnimation {
                    target: rect
                    property: "y"
                    to: 0
                    duration: 500
                }
                NumberAnimation {
                    target: rect
                    property: "opacity"
                    to: 0
                    duration: 500
                }
            }
        }
    */
}
