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
    color: blue_dark //"#222c3b"
    id: appWindow
    visible: true
    //flags: Qt.FramelessWindowHint
    //visibility: "FullScreen"

    readonly property color yellow: "#E3B505"
    readonly property color white: "#FFFFFF"
    readonly property color blue: "#4A6FA5"
    readonly property color blue_light: "#4B6281"
    readonly property color blue_dark: "#465b7a"

    property real footerHeight: this.height * 0.133333333

    FontLoader {
        id: kentledge
        source: "fonts/Kentledge-Heavy.otf"
    }
    FontLoader {
        id: poppins
        source: "fonts/Poppins-Light.otf"
    }
    FontLoader {
        id: poppinsMedium
        source: "fonts/Poppins-Medium.otf"
    }

    Timer {
        id: playTimer
        interval: 1000
        running: !playPaused
        repeat: true
        onTriggered: if (playDuration > 0 && playElapsed < playDuration) playElapsed++
    }

    property var queue: []
    property bool playPaused: true
    property int playPosition: 0
    property int playElapsed: 0
    property int playDuration: 0

    ListModel {
        id: queueList
    }

    function signalHandling(event){
        let rawevents = event.split("event: ")
        rawevents.forEach(evt => {
            if (evt !== "") {
                let evtName = evt.substr(0, evt.indexOf(" ")),
                    evtData = JSON.parse(evt.slice(evt.indexOf(" ")).trim())

                if (evtName === "queue") {
                    queue = evtData.queue
                    queueList.clear()
                    queue.forEach(item => {
                        queueList.append(item)
                    })

                    let _state = evtData.state
                    playPaused = _state.paused
                    playPosition = _state.position
                    playDuration = queue[playPosition].duration
                    playElapsed = _state.elapsed

                }
                else if (evtName === "status") {
                    playPaused = evtData.paused
                    playPosition = evtData.position
                    playElapsed = evtData.elapsed
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
        Queue { }
    }

    Rectangle {
        id: footer
        x: 0
        anchors.bottom: parent.bottom
        width: parent.width
        height: footerHeight
        color: "#4A6FA5"

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
    }
}
