import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    id: player

    property real playerFooter: this.height * 0.15
    property real playerHeight: this.height * 0.85

    function musicAPIRequest(urlComponent, callback, action = "GET", data = "", testIP = "") {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = (function (myxhr) {
            return function () {
                if (xhr.readyState === XMLHttpRequest.DONE)
                    if (callback) {
                        console.log("in callback processor")
                        let data = {}
                        try {
                            data = JSON.parse(xhr.responseText)
                        } catch (e) {
                            console.log("Parse failed")
                        }
                        callback(data)
                    }
            }
        })(xhr)

        let _host = testIP !== "" ? testIP : getSettings("host")

        console.log(_host)
        let fullURL = "http://" + _host + "/api/" + urlComponent

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
            id: iconRow
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

                    sourceSize.width: this.width
                    sourceSize.height: this.height

                    anchors.centerIn: parent
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
                anchors.centerIn: parent
                spacing: this.height * 0.3

                Rectangle {
                    color: currentPage === "playlists" ? primary_color : background_pop_color
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    Text {
                        text: "Playlists"
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        color: currentPage === "playlists" ? secondary_text_color: text_color
                        leftPadding: parent.parent.height * 0.22
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height * radiusPercent
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("playlists")
                        }
                    }
                }

                Rectangle {
                    color: currentPage === "artists" ? primary_color : background_pop_color
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    Text {
                        text: "Artists"
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        color: currentPage === "artists" ? secondary_text_color: text_color
                        leftPadding: parent.parent.height * 0.22
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height * radiusPercent
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
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    Text {
                        text: "Albums"
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        color: currentPage === "albums" ? secondary_text_color: text_color
                        leftPadding: parent.parent.height * 0.22
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height * radiusPercent
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
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    Text {
                        text: "Genres"
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        color: currentPage === "genres" ? secondary_text_color: text_color
                        leftPadding: parent.parent.height * 0.22
                        rightPadding: this.leftPadding
                        topPadding: this.leftPadding / 1.8
                        bottomPadding: this.topPadding - 3
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height * radiusPercent
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

    function startPlayer() {
        stack.pop(null)
        sse.setServer("http://" + getSettings("host") + "/events")
        stack.push("Library.qml", { "url": "artists" })
    }

    Component.onCompleted: {
        touchEvents.onTouchDetected.connect(resetTouchTimer)
        if (typeof getSettings("host") !== "undefined" && getSettings("host") !== "") {
            startPlayer()
        } else {
            welcomeScreen.open()
        }
    }

    Timer {
        id: touchTimer
        interval: 30000
        running: true
        onTriggered: {
            if (playPaused) {
                //nothing is playing, turn off the display
                display.off()
                screenCover.visible = true
            } else {
                //something is playing so open the playing screen:
                mainPlaying.open()
            }
        }
    }

    function resetTouchTimer() {
        touchTimer.restart()
    }


    Row {
        height: parent.height * 0.14
        anchors.right: parent.right
        anchors.top: parent.top
        rightPadding: this.height * 0.2

        Item {
            height: player.height * 0.083
            width: this.height
            anchors.verticalCenter: parent.verticalCenter

            Image {
                source: "icons/filter.svg"
                height: parent.height * .45
                width: this.height
                anchors.centerIn: parent
                smooth: true
                sourceSize.width: this.width
                sourceSize.height: this.height
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.currentItem.openDrawer()
                }
            }
        }

        Item {
            height: player.height * 0.083
            width: this.height
            anchors.verticalCenter: parent.verticalCenter
            visible: !(!ac && batteryPercent === 0)

            Image {
                source: ac ? "icons/battery-charging.svg" : batteryPercent > 83 ? "icons/battery-100.svg" : batteryPercent > 66 ? "icons/battery-75.svg" :  batteryPercent > 33  ? "icons/battery-50.svg" : batteryPercent > 15 ? "icons/battery-25.svg" : "icons/battery-0.svg"
                height: parent.height * .45
                width: this.height
                anchors.centerIn: parent
                smooth: true
                sourceSize.width: this.width
                sourceSize.height: this.height
            }
        }

        Item {
            height: player.height * 0.083
            width: this.height
            anchors.verticalCenter: parent.verticalCenter

            Image {
                source: "icons/settings.svg"
                height: parent.height * .45
                width: this.height
                anchors.centerIn: parent
                smooth: true
                sourceSize.width: this.width
                sourceSize.height: this.height
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                   mainSettings.open()
                }
            }
        }
    }

    Queue {
      id: mainQueue
    }

//    DragDropTest {
//        id: mainQueue
//    }

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
            color: gray_mid

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

                    Item {
                        height: parent.height * 0.7
                        width: this.height
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            id: playingArt
                            source: currentTrack.art !== "" ? "image://AsyncImage" + currentTrack.art : ""
                            fillMode: Image.PreserveAspectCrop
                            width: parent.width - 2
                            height: parent.height - 2
                            anchors.centerIn: parent
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: mask
                            }
                        }

                        Rectangle {
                            id: mask
                            anchors.fill: playingArt
                            radius: this.height * radiusPercent
                            visible: false
                        }
                    }
                }
                Column {
                    height: childrenRect.height
                    width: parent.width - parent.leftPadding - playingArt.width
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        color: text_color
                        font.pixelSize: text_h3
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        text: currentTrack.title // needs to have default text
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    Text {
                        color: text_color
                        font.pixelSize: text_h4
                        font.family: inter.name
                        font.weight: Font.Normal
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
                    anchors.centerIn: parent
                    smooth: true
                    sourceSize.width: this.width
                    sourceSize.height: this.height

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
                color: appWindow.playPaused ? gray_mid : primary_color
                radius: this.height * 0.5
                anchors.centerIn: parent

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                Image {
                    id: playPauseIcon
                    source: appWindow.playPaused ? "icons/play.svg" : "icons/pause.svg"
                    height: parent.height * 0.45
                    width: this.height
                    anchors.centerIn: parent
                    smooth: true
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                }

                ColorOverlay{
                    anchors.fill: playPauseIcon
                    source: playPauseIcon
                    color: appWindow.playPaused ? primary_color : background_pop_color
                    transform: rotation
                    antialiasing: true
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
                    anchors.centerIn: parent
                    smooth: true
                    sourceSize.width: this.width
                    sourceSize.height: this.height

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

                    sourceSize.width: this.width
                    sourceSize.height: this.height

                    anchors.centerIn: parent
                }

                ColorOverlay{
                    anchors.fill: queueButton
                    source: queueButton
                    color: mainQueue.isActive ? primary_color : white
                    transform: rotation
                    antialiasing: true
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
                    font.family: inter.name
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

    Settings {
      id: mainSettings
    }

    Playing {
        id: mainPlaying
        z: 3
    }

    Rectangle {
        id: screenCover
        anchors.fill: parent
        color: "black"
        visible: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                display.on();
                screenCover.visible = false
            }
        }
    }

    Welcome {
        id: welcomeScreen
    }

    function animateEnqueue() {
        enqueueReaction.opacity = 1
        enqueueReaction.y = 50
        enqueueAnimation.start()
    }
}
