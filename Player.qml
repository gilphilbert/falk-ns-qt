// <!------------ QT5 ------------!> //
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.15
import QtWebSockets 1.15

/*
// <!------------ QT6 ------------!> //
import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Effects
import QtCore
*/

ApplicationWindow {
    width: 1024
    height: 600
    visible: true

    id: player
    color: background_color

    FontLoader {
        id: inter
        source: "fonts/Inter-Regular.otf"
    }
    FontLoader {
        id: interBold
        source: "fonts/Inter-Bold.otf"
    }
    FontLoader {
        id: interHeavy
        source: "fonts/Inter-Black.otf"
    }

    property bool ac: false
    property int batteryPercent: 0
    property bool scanState: false

    readonly property color yellow: "#EFCB68"
    readonly property color white: "#FCF7F8"
    readonly property color blue: "#4A6FA5"
    readonly property color blue_light: "#517ab5"
    readonly property color blue_lighter: "#617fab"
    readonly property color blue_subdued: "#416291"
    readonly property color blue_dark: "#465b7a"
    readonly property color blue_darkish: "#596c88"
    readonly property color black: "#444"
    readonly property color gray_light: "#cccccc"
    readonly property color gray_lighter: "#eeeeee"
    readonly property color pink: "#e4447c"
    readonly property color gray_dark: "#373F47"
    readonly property color gray_darkish: "#4C5965"
    readonly property color gray_mid: "#5F6E7B"
    readonly property color red: "#B76163"

    readonly property color background_color: blue_dark
    readonly property color background_pop_color: blue_darkish
    readonly property color primary_color: yellow
    readonly property color secondary_color: white
    readonly property color text_color: white
    readonly property color secondary_text_color: gray_dark
    readonly property color danger_color: red

    readonly property int text_h1: Math.round(this.height * 0.042)
    readonly property int text_h2: Math.round(this.height * 0.028)
    readonly property int text_h3: Math.round(this.height * 0.025)
    readonly property int text_h4: Math.round(this.height * 0.022)

    property real windowHeight: this.height

    readonly property real radiusPercent: 0.075

    property real playerFooter: this.height * 0.15
    property real playerHeight: this.height * 0.85

Rectangle {
    color: 'transparent'
    anchors.fill: parent

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
                    color: currentPage === "playlists" ? primary_color : "transparent" //background_pop_color
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
                        bottomPadding: this.topPadding// - 3
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height //* radiusPercent
                    anchors.verticalCenter: parent.verticalCenter
                    border {
                        width: 2
                        color: primary_color
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("playlists")
                        }
                    }
                }

                Rectangle {
                    color: currentPage === "artists" ? primary_color : "transparent" //background_pop_color
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
                        bottomPadding: this.topPadding// - 3
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height //* radiusPercent
                    anchors.verticalCenter: parent.verticalCenter
                    border {
                        width: 2
                        color: primary_color
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("artists")
                        }
                    }
                }

                Rectangle {
                    color: currentPage === "albums" ? primary_color : "transparent" //background_pop_color
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
                        bottomPadding: this.topPadding// - 3
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height //* radiusPercent
                    anchors.verticalCenter: parent.verticalCenter
                    border {
                        width: 2
                        color: primary_color
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            setLibraryPage("albums")
                        }
                    }
                }

                Rectangle {
                    color: currentPage === "genres" ? primary_color : "transparent" //background_pop_color
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
                        bottomPadding: this.topPadding// - 3
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                    radius: childrenRect.height// * radiusPercent
                    anchors.verticalCenter: parent.verticalCenter
                    border {
                        width: 2
                        color: primary_color
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
                   settingsScreen.open()
                }
            }
        }
    }

    Queue {
      id: mainQueue
    }

    Item {
        height: playerFooter
        width: parent.width
        anchors.bottom: parent.bottom

        Rectangle {
            anchors.fill: parent
            color: blue //background_pop_color
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.04
            color: blue_lighter

            Rectangle {
                width: parent.width * (playElapsed / (currentTrack.duration * 1000))
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

                        // <!------------ QT5 ------------!> //
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

                        /*
                        // <!------------ QT6 ------------!> //
                        Image {
                            id: playingArt
                            source: currentTrack.art !== "" ? "image://AsyncImage/" + currentTrack.art : ""
                            width: parent.width - 2
                            height: parent.height - 2
                            anchors.centerIn: parent
                            visible: false
                        }

                        MultiEffect {
                            source: playingArt
                            anchors.fill: playingArt
                            maskEnabled: true
                            maskSource: mask
                        }

                        Item {
                            id: mask
                            width: playingArt.width
                            height: playingArt.height
                            layer.enabled: true
                            visible: false

                            Rectangle {
                                width: playingArt.width
                                height: playingArt.height
                                radius: this.height * radiusPercent
                                color: "black"
                            }
                        }
                        */

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
                color: playPaused ? blue_subdued : primary_color
                radius: this.height * 0.5
                anchors.centerIn: parent

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                // <!------------ QT5 ------------!> //
                Image {
                    id: playPauseIcon
                    source: playPaused ? "icons/play.svg" : "icons/pause.svg"
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
                    color: playPaused ? white : background_pop_color
                    transform: rotation
                    antialiasing: true
                }

                /*
                // <!------------ QT6 ------------!> //
                IconImage {
                    id: playPauseIcon
                    source: playPaused ? "icons/play.svg" : "icons/pause.svg"
                    height: parent.height * 0.45
                    width: this.height
                    anchors.centerIn: parent
                    smooth: true
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    color: playPaused ? white : background_pop_color
                }
                */

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
                //anchors.right: volSupport ? volumeButton.left : parent.right
                anchors.right: parent.right

                // <!------------ QT5 ------------!> //
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

                /*
                // <!------------ QT6 ------------!> //
                IconImage {
                    source: "icons/list.svg"
                    height: parent.height * 0.32
                    width: this.height

                    sourceSize.width: this.width
                    sourceSize.height: this.height

                    anchors.centerIn: parent

                    color: mainQueue.isActive ? primary_color : white
                }
                */

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

            Item {
                id: volumeButton
                height: parent.height
                width: parent.height
                //anchors.right: parent.right
                anchors.right: queueButton.left

                visible: volSupport

                // <!------------ QT5 ------------!> //
                Image {
                    source: "icons/volume.svg"
                    height: parent.height * 0.32
                    width: this.height

                    sourceSize.width: this.width
                    sourceSize.height: this.height

                    anchors.centerIn: parent
                }

                ColorOverlay{
                    anchors.fill: volumeButton
                    source: volumeButton
                    color: volumeControl.visible ? yellow : white
                    transform: rotation
                    antialiasing: true
                }

                /*
                // <!------------ QT6 ------------!> //
                IconImage {
                    source: "icons/volume.svg"
                    height: parent.height * 0.32
                    width: this.height

                    sourceSize.width: this.width
                    sourceSize.height: this.height

                    anchors.centerIn: parent

                    color: volumeControl.visible ? yellow : white
                }
                */

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        volumeControl.visible = !volumeControl.visible
                    }
                }
            }

            Rectangle {
                id: volumeControl
                color: blue
                width: volumeButton.width
                height: Window.height / 3
                anchors.bottom: volumeButton.top
                anchors.left: volumeButton.left
                anchors.bottomMargin: -10

                visible: false

                radius: 10

                Slider {
                    id: volumeSlider
                    height: parent.height - 40
                    width: parent.width
                    from: 0
                    value: 25
                    to: 100
                    orientation: Qt.Vertical
                    anchors.centerIn: parent

                    onMoved: {
                        musicAPIRequest("volume/" + Math.round(volumeSlider.value), null, "PUT", null)
                    }

                    background: Rectangle {
                        implicitWidth: volumeSlider.width * .1
                        implicitHeight: volumeSlider.height - volumeSlider.topPadding - volumeSlider.bottomPadding
                        width: implicitWidth
                        height: implicitHeight

                        radius: this.width
                        color: blue_lighter
                        anchors.centerIn: parent

                        Rectangle {
                            width: parent.width
                            height: (1 - volumeSlider.visualPosition) * volumeSlider.availableHeight
                            color: yellow
                            radius: this.width
                            anchors.bottom: parent.bottom
                        }

                    }

                    handle: Rectangle {
                        width: 20
                        height: 20
                        implicitWidth: 20
                        implicitHeight: 20
                        color: primary_color
                        x: volumeSlider.leftPadding + volumeSlider.availableWidth / 2 - width / 2
                        y: volumeSlider.topPadding + volumeSlider.visualPosition * (volumeSlider.availableHeight - height)
                        radius: 20
                    }

                }
            }
        }
    }

    Configure {
        id: settingsScreen
    }

    Rectangle {
        anchors.bottom: player.bottom
        anchors.top: player.top
        anchors.bottomMargin: player.height * 0.05
        anchors.leftMargin: player.height * 0.05

        height: 60
        width: 200

        color: primary_color

        visible: scanState
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

    Connecting {
        id: connectingScreen
    }

}

    //api requests to the server
    function musicAPIRequest(urlComponent, callback, action = "GET", data = "", testIP = "") {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = (function (myxhr) {
            return function () {
                if (xhr.readyState === XMLHttpRequest.DONE)
                    if (callback) {
                        let data = {}
                        try {
                            data = JSON.parse(xhr.responseText)
                        } catch (e) {
                            console.info("Parse failed")
                        }
                        callback(data)
                    }
            }
        })(xhr)

        if (testIP !== "") {
            console.info("http://" + testIP + "/api/" + urlComponent)
        }

        let _host = testIP !== "" ? testIP : getSettings("host")

        let fullURL = "http://" + _host + "/api/" + urlComponent

        xhr.open(action, fullURL, true)

        if (action === "POST") {
            xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        }

        xhr.send(data)
    }

    //left-pads a string with the supplied character (used by getPrettyTime(...) below)
    function str_pad_left(string,pad,length) {
        return (new Array(length+1).join(pad)+string).slice(-length);
    }

    //shows time in h:mm:ss instead of just seconds
    function getPrettyTime(t_seconds) {
        let seconds = t_seconds //Math.round(t_seconds)

        const hours = Math.floor(seconds / 3600)
        seconds = seconds - hours * 3600

        const minutes = Math.floor(seconds / 60)
        seconds = seconds - minutes * 60

        return ((hours > 0) ? hours + ":" : "") + ((hours > 0) ? str_pad_left(minutes, '0', 2) : minutes) + ':' + str_pad_left(seconds, '0', 2)
    }
    function getPrettyTimeMs(t_milliseconds) {
        return getPrettyTime(Math.round(t_milliseconds / 1000))
    }

    //holds the current library page
    property string currentPage: "artists"

    //change the library page
    function setLibraryPage (page) {
        if (page !== currentPage) {
            stack.clear()
            stack.push("Library.qml", { "url": page })
            currentPage = page
        }
    }

    //shows a nice animation when a new track is enqueued
    function animateEnqueue() {
        enqueueReaction.opacity = 1
        enqueueReaction.y = 50
        enqueueAnimation.start()
    }

    //clears the player and connects to the event server
    function startPlayer() {
        // clear screens from stack
        stack.pop(null)

        // reset the player
        resetPlayer()

        // connect to the socket server
        sse.setServer("http://" + getSettings("host") + "/events")
    }

    function scanStarted(data) {
        if (data.status === 'started') {
            scanState = true
            switch (data.type) {
              case 'scan':
              case 'rescan':
                scanToastText = "Updating library"
                break;
              case 'art':
                scanToastText = "Updating art"
                  break;
            }
        } else {
            scanState = false
        }

    }

    Component.onCompleted: {
        //configure the event handlers
        sse.onConnected.connect(eventConnect)
        sse.onDisconnected.connect(eventDisconnect)
        sse.onPaused.connect(pausedChanged)
        sse.onElapsed.connect(elapsedChanged)
        sse.onPosition.connect(positionChanged)
        sse.onVolume.connect(volumeChanged)
        sse.scanState.connect(scanStarted)
        sse.onQueue.connect(queueUpdated)

        power.onAcChanged.connect(updatePower)
        power.onBatteryChanged.connect(updateBattery)
        power.init();

        //attach the touch event handler
        touchEvents.onTouchDetected.connect(resetTouchTimer)

        //start the player or show the welcome screen if host not configured
        if (typeof getSettings("host") !== "undefined" && getSettings("host") !== "") {
            startPlayer()
        } else {
            welcomeScreen.open()
        }
    }

    //these hold the  (the list model is required for rearranging the queue)
    property var queue: []
    ListModel { id: queueList }
    //general state information for the player
    property bool playPaused: true
    property int playPosition: -1
    property int playElapsed: 0
    //holds the current playing item
    property var currentTrack: { "title":"", "artist":"", "duration":0, "album":"", "art":"", "discart":"", "artistart": "", "backgroundart": "", "playing":false, "shortformat":"" }
    property bool volSupport: true

    //timer increments the play
    Timer {
        id: playTimer
        interval: 100
        running: !playPaused
        repeat: true
        onTriggered: if (currentTrack.duration > 0 && playElapsed < currentTrack.duration * 1000) playElapsed += 100
    }

    //reset the player (useful for changing falkdp hosts, etc.)
    function resetPlayer() {
        currentTrack = { "title":"", "artist":"", "duration":0, "album":"", "art":"", "discart":"", "artistart": "", "backgroundart": "", "playing":false, "shortformat":"" }
        queue = []
        playPaused = true
        playPosition = -1
        playElapsed = 0
        volSupport = true
    }

    //event fired when the server tells us about play/pause
    function pausedChanged(state) {
        if (playPaused === state)
            return

        playPaused = state

        if (playPaused) {
            resetTouchTimer()
            mainPlaying.close()
        }
    }

    //new items in the queue
    function queueUpdated(newQueue) {
        queue = newQueue

        queueList.clear()
        if (queue.length > 0) {
            queueList.clear()
            queue.forEach(item => {
                queueList.append(item)
            })
        } else {
            currentTrack = { "title":"", "artist":"", "duration":0, "album":"", "art":"", "discart":"", "artistart": "", "backgroundart": "", "playing":false, "shortformat":"" }
        }
        player.animateEnqueue()
    }

    //play elapsed time has changed (sent with play/pause/new track, etc.)
    function elapsedChanged(seconds) {
        playElapsed = seconds * 1000 // elapsed is in ms
    }

    //when the currently playing track has changed
    function positionChanged(index) {
        playPosition = index
        if (queue.length > 0) {
            currentTrack = queue[index]
        }
    }

    function volumeChanged(vol) {
        if (vol === -1) {
            volSupport = false
            return
        }
        volumeSlider.value = vol
    }

    function eventConnect(event) {
        // we're connected to the server, let's get started!

        // load the library
        stack.push("Library.qml", { "url": "artists" })
        connectTimer.stop()
        connectingScreen.close()
    }

    //when we're disconnected from the server
    function eventDisconnect(event) {
        //server connection lost (couldn't connect/reconnect)
        console.info('Couldn\'t connect');

        // wait five seconds and retry...
        resetPlayer()
        //startPlayer();
        connectTimer.start()
    }
    Timer {
        id: connectTimer
        interval: 5000
        running: false
        onTriggered: {
            startPlayer()
            connectTimer.stop()
        }
    }

    // timer to hold the "now playing" screen
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

    //resets the touch timer (useful to extend the amount of time)
    function resetTouchTimer() {
        touchTimer.restart()
    }

    Settings {
        id: appSettings
        property string host: ""
    }

    function setSettings(key, value) {
        appSettings.setValue(key, value)
        appSettings.sync()
    }

    function getSettings(key) {
        return appSettings.value(key)
    }

    function updatePower(value) {
        ac = value
    }

    function updateBattery(value) {
        batteryPercent = value
    }
}
