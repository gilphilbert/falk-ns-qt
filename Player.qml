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

    property string currentPage: "artists"
    function setLibraryPage (page) {
        if (page !== currentPage) {
            stack.clear()
            stack.push("Library.qml", { "url": page })
            currentPage = page
        }
    }

    Column {
        anchors.fill: parent

        Item {
            width: parent.width
            height: parent.height * 0.14

            Item {
                width: parent.height
                height: parent.height
                visible: stack.depth > 1

                Image {
                    source: "icons/chevron-left.svg"
                    height: parent.height * 0.5
                    width: this.height
                    anchors.centerIn: parent
                    ColorOverlay{
                        anchors.fill: parent
                        source: parent
                        color: primary_color
                        antialiasing: true
                    }
                }



                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stack.pop()
                    }
                }
            }


            Row {
                height: parent.height
                //width: childrenRect.width
                anchors.centerIn: parent
                spacing: this.height * 0.3

                Rectangle {
                    color: currentPage === "playlist" ? primary_color : background_pop_color
                    Text {
                        text: "Playlists"
                        font.pixelSize: text_h2
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: text_color
                        leftPadding: parent.parent.height * 0.22
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height * 0.18
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("playlist")
                        }
                    }
                }

                Rectangle {
                    color: currentPage === "artists" ? primary_color : background_pop_color
                    Text {
                        text: "Artists"
                        font.pixelSize: text_h2
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: text_color
                        leftPadding: parent.parent.height * 0.22
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height * 0.18
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("artists")
                        }
                    }
                }

                Rectangle {
                    color: currentPage === "albums" ? primary_color : background_pop_color
                    Text {
                        text: "Albums"
                        font.pixelSize: text_h2
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: text_color
                        leftPadding: parent.parent.height * 0.22
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height * 0.18
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("albums")
                        }
                    }
                }

                Rectangle {
                    color: currentPage === "genres" ? primary_color : background_pop_color
                    Text {
                        text: "Genres"
                        font.pixelSize: text_h2
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        color: text_color
                        leftPadding: parent.parent.height * 0.22
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height * 0.18
                    anchors.verticalCenter: parent.verticalCenter

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

    Queue {
      id: mainQueue
    }
    /*
    Drawer {
        id: queueDrawer
        width: parent.width
        height: parent.height * 0.5
        edge: Qt.BottomEdge
        y: Window.height
        background: Rectangle {
            color: background_pop_color
        }

    }
    */

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
                        font.pixelSize: text_h3
                        font.family: kentledge.name
                        font.weight: Font.ExtraBold
                        text: currentTrack.title
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    Text {
                        color: text_color
                        font.pixelSize: text_h4
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
                    source: "icons/skip-back.svg"
                    height: parent.height * 0.45
                    width: this.height
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    ColorOverlay{
                        anchors.fill: parent
                        source: parent
                        color: primary_color
                        antialiasing: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("prev")
                        }
                    }
                }
            }

            Rectangle {
                height: parent.height * 0.6
                width: this.height
                color: white
                radius: this.height * 0.5
                anchors.centerIn: parent

                Image {
                    source: appWindow.playPaused ? 'icons/play.svg' : 'icons/pause.svg'
                    height: parent.height * 0.45
                    width: this.height
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    ColorOverlay{
                        anchors.fill: parent
                        source: parent
                        color: primary_color
                        antialiasing: true
                    }
                }


                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        musicAPIRequest("toggle")
                    }
                }
            }

            Item {
                height: parent.height * 0.6
                width: this.height
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: (parent.height * 0.6) * 1.3

                Image {
                    source: "icons/skip-forward.svg"
                    height: parent.height * 0.45
                    width: this.height
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.centerIn: parent

                    ColorOverlay{
                        anchors.fill: parent
                        source: parent
                        color: primary_color
                        antialiasing: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            musicAPIRequest("next")
                        }
                    }
                }
            }

            Item {
                id: queueButton
                height: parent.height
                width: parent.height
                anchors.right: parent.right

                Image {
                    source: "icons/list.svg"
                    height: parent.height * 0.32
                    width: this.height
                    anchors.centerIn: parent
                    ColorOverlay{
                        anchors.fill: parent
                        source: parent
                        color: mainQueue.isOpen() ? primary_color : text_color
                        antialiasing: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainQueue.toggle()
                    }
                }
            }


            Rectangle {
                id: enqueueReaction
                width: 30
                height: 30
                color: primary_color
                anchors.left: queueButton.left
                y: queueButton.y
                opacity: 0
                radius: this.width / 2

                Text {
                    text: "+1"
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 2
                    color: white
                    font.pixelSize: text_h3
                    font.family: kentledge.name
                    font.weight: Font.ExtraBold
                }

                ParallelAnimation {
                    id: enqueueAnimation
                    NumberAnimation {
                        target: enqueueReaction
                        property: "y"
                        to: 0
                        duration: 500
                    }
                    NumberAnimation {
                        target: enqueueReaction
                        property: "opacity"
                        to: 0
                        duration: 500
                    }
                }
            }
        }

        /*
        MouseArea {
            anchors.fill: parent
            onPressAndHold: {
                // this needs to be swipe-up, and it should open the main player.
                // not sure if this is really needed just yet though
            }
        }
        */
    }

    function animateEnqueue() {
        enqueueReaction.opacity = 1
        enqueueReaction.y = 50
        enqueueAnimation.start()
    }
}
