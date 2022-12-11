import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import Qt.labs.settings 1.0
import QtQml.Models 2.15

//import "ns-script.js" as NSScript
//Component.onCompleted: NSScript.createTiles()

Window {
    width: 1350
    height: 900
    title: qsTr("FALK NS")
    color: background_color
    id: appWindow
    visible: true
    //flags: Qt.FramelessWindowHint
    //visibility: "FullScreen"

    readonly property color yellow: "#e3e444" //"#E3B505"
    readonly property color white: "#FFFFFF"
    readonly property color blue: "#4A6FA5"
    readonly property color blue_light: "#353a50"
    readonly property color blue_lighter: "#454c63"
    readonly property color blue_dark: "#2a2e43"
    readonly property color black: "#444"
    readonly property color gray_light: "#cccccc"
    readonly property color gray_lighter: "#eeeeee"
    readonly property color pink: "#e4447c"

    readonly property color background_color: blue_dark
    readonly property color background_pop_color: blue_light
    readonly property color primary_color: pink
    readonly property color secondary_color: white
    readonly property color text_color: white
    readonly property color secondary_text_color: white

    readonly property int text_h1: Math.round(this.height * 0.042)
    readonly property int text_h2: Math.round(this.height * 0.028)
    readonly property int text_h3: Math.round(this.height * 0.022)
    readonly property int text_h4: Math.round(this.height * 0.018)

    property real windowHeight: this.height * 0.866666667
    property real footerHeight: this.height * 0.133333333

    readonly property real radiusPercent: 0.18


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

    property var queue: []
    property bool playPaused: true
    property int playPosition: -1
    property int playElapsed: 0

    property var currentTrack: { "title":"", "artist":"", "duration":0, "album":"", "art":"", "discart":"", "playing":false, "shortformat":"" }

    ListModel {
        id: queueList
    }

    function processState(_state) {
        //playPaused = _state.paused
        playElapsed = _state.elapsed
        if (queue.length > 0) {
            playPosition = _state.position
            currentTrack = queue[_state.position]
        }
    }

    function eventHandler(event){
        let rawevents = event.split("event: ")
        rawevents.forEach(evt => {
            if (evt !== "") {
                let evtName = evt.substr(0, evt.indexOf(" ")),
                    evtData = JSON.parse(evt.slice(evt.indexOf(" ")).trim())

                if (evtName === "queue") {
                    queue = evtData.queue

                                      // <!------------------------------- super rudimentary, we need to actually check the items to make sure it's an enqueue
                    if (queue.length === queueList.count + 1 && playPosition > -1) {
                        try {
                            stackView.currentItem.animateEnqueue()
                        } catch (e) {
                            // don't really need this, it means that the player isn't active
                        }
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

    Timer {
        id: playTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: if (currentTrack.duration > 0 && playElapsed < currentTrack.duration) playElapsed++
    }

    function eventDisconnect(event){
        //server connection lost (couldn't connect/reconnect)
    }

    Settings {
        id: settings
        property string host: "127.0.0.1:8080"
    }

    Component.onCompleted: {
        //settings.host = "127.0.0.1:8080"
        //settings.host = "192.168.68.105"
        sse.onEventData.connect(eventHandler)
        sse.onDisconnected.connect(eventDisconnect)
        sse.onPaused.connect(function (state) { playPaused = state; playTimer.running = !state })
        //sse.onPosition.connect(function (position) { playPosition = position })
        sse.setServer("http://" + settings.host + "/events")
    }

    StackView {
        id: stackView
        initialItem: "Player.qml"
        width: parent.width
        height: windowHeight
        clip: true
    }

    Rectangle {
        height: footerHeight
        width: parent.width
        anchors.bottom: parent.bottom
        color: "#222"
    }

}
