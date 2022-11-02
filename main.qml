import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import Qt.labs.settings 1.0
import QtQml.Models 2.15

import "components"

//import "ns-script.js" as NSScript
//Component.onCompleted: NSScript.createTiles()

Window {
    width: 1350
    height: 900
    title: qsTr("FALK NS")
    color: white // blue_dark
    id: appWindow
    visible: true
    //flags: Qt.FramelessWindowHint
    //visibility: "FullScreen"

    readonly property color yellow: "#E3B505"
    readonly property color white: "#FFFFFF"
    readonly property color blue: "#4A6FA5"
    readonly property color blue_light: "#4B6281"
    readonly property color blue_dark: "#465b7a"
    readonly property color black: "#444"
    readonly property color gray_light: "#cccccc"
    readonly property color gray_lighter: "#eeeeee"

    readonly property color primary_color: blue
    readonly property color secondary_color: yellow
    readonly property color text_color: black
    readonly property color secondary_text_color: blue

    property real footerHeight: this.height * 0.133333333

    FontLoader {
        id: kentledge
        source: "fonts/Kentledge-Regular.otf"
    }
    FontLoader {
        id: kentledgeBold
        source: "fonts/Kentledge-Bold.otf"
    }
    FontLoader {
        id: kentledgeHeavy
        source: "fonts/Kentledge-Heavy.otf"
    }

    Timer {
        id: playTimer
        interval: 1000
        running: !playPaused
        repeat: true
        onTriggered: if (currentTrack.duration > 0 && playElapsed < currentTrack.duration) playElapsed++
    }

    property var queue: []
    property bool playPaused: true
    property int playPosition: -1
    property int playElapsed: 0

    property var currentTrack: { "title":"", "artist":"", "duration":0, "album":"", "art":"", "discart":"", "playing":false, "shortformat":"" }

    ListModel {
        id: queueList
    }

    function processState(_state) {
        playPaused = _state.paused
        playElapsed = _state.elapsed
        if (queue.length > 0) {
            playPosition = _state.position
            currentTrack = queue[_state.position]
        }
    }

    function signalHandling(event){
        let rawevents = event.split("event: ")
        rawevents.forEach(evt => {
            if (evt !== "") {
                let evtName = evt.substr(0, evt.indexOf(" ")),
                    evtData = JSON.parse(evt.slice(evt.indexOf(" ")).trim())

                if (evtName === "queue") {
                    queue = evtData.queue

                    if (queue.length === queueList.count + 1) {
                        rect.opacity = 1
                        rect.y = 50
                        testAnimation.start()
                    }

                    queueList.clear()
                    queue.forEach(item => {
                        queueList.append(item)
                    })

                    processState(evtData.state)
                }
                else if (evtName === "status") {
                    processState(evtData)
                }
            }

        })
    }

    function serverDisconnect(event){
        //server connection lost (couldn't connect/reconnect)
    }

    Component.onCompleted: {
        settings.host = "127.0.0.1:8080"
        //settings.host = "192.168.68.105"
        sse.onEventData.connect(signalHandling)
        sse.onDisconnected.connect(serverDisconnect)
        sse.setServer("http://" + settings.host + "/events")
    }

    function apiRequest(urlComponent, callback, action = "GET", data = "") {
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
        console.info(fullURL)

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

    Settings {
        id: settings
        property string host: "192.168.68.105"
    }

    StackView {
        id: stack
        initialItem: "Playing.qml"
        anchors.fill: parent
    }

    Drawer {
        id: queueDrawer
        width: parent.width
        height: parent.height * 0.80
        edge: Qt.BottomEdge
        background: Rectangle {
            color: gray_lighter
        }
        Queue { }
    }

    Rectangle {
        id: footer
        x: 0
        anchors.bottom: parent.bottom
        width: parent.width
        height: footerHeight
        color: gray_lighter

        Grid {
            id: footerGrid
            columns: 8

            FooterItem {
                title: qsTr("Playing")
                onClick: { stack.pop(null) }
            }
            FooterItem {
                title: qsTr("Queue")
                onClick: { queueDrawer.open() }
            }
            FooterItem {
                title: qsTr("")
            }
            FooterItem {
                title: qsTr("playlists")
                onClick: {
                    stack.pop(null)
                    stack.push("Library.qml", { "url": "playlist" })
                }
            }
            FooterItem {
                title: qsTr("Artists")
                onClick: {
                    stack.pop(null)
                    stack.push("Library.qml", { "url": "artists" })
                }
            }
            FooterItem {
                title: qsTr("Albums")
                onClick: {
                    stack.pop(null)
                    stack.push("Library.qml", { "url": "albums" })
                }
            }
            FooterItem {
                title: qsTr("Genres")
                onClick: {
                    stack.pop(null)
                    stack.push("Library.qml", { "url": "genres" })
                }
            }
            FooterItem {
                title: qsTr("")
            }
        }


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

    }
}
