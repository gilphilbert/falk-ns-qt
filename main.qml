import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0
import QtQml.Models 2.15

Window {
    width: 1024
    height: 600
    color: background_color
    id: appWindow
    visible: true

    readonly property color yellow: "#F9C22E"
    readonly property color white: "#FCF7F8"
    readonly property color blue: "#4A6FA5"
    readonly property color blue_light: "#353a50"
    readonly property color blue_lighter: "#454c63"
    readonly property color blue_dark: "#2a2e43"
    readonly property color black: "#444"
    readonly property color gray_light: "#cccccc"
    readonly property color gray_lighter: "#eeeeee"
    readonly property color pink: "#e4447c"
    readonly property color gray_dark: "#373F47"
    readonly property color gray_darkish: "#4C5965"
    readonly property color gray_mid: "#5F6E7B"
    readonly property color red: "#F9682E"

    readonly property color background_color: gray_dark
    readonly property color background_pop_color: gray_darkish
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

    property var currentTrack: { "title":"", "artist":"", "duration":0, "album":"", "art":"", "discart":"", "artistart": "", "backgroundart": "", "playing":false, "shortformat":"" }

    ListModel {
        id: queueList
    }

    function processState(_state) {
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

                    // check to see if the queue is the same other than one new item, then show the enqueue animation
                    if (evtData.queue.length === queue.length + 1) {
                        let matchCount = 0
                        evtData.queue.forEach(function (nqi) {
                            queue.forEach(function (oqi) {
                                if (nqi.title === oqi.title && nqi.artist === oqi.artist && nqi.album === oqi.album) {
                                    matchCount++
                                }
                            })
                        })
                        if (matchCount == queue.length) {
                            try {
                                stackView.currentItem.animateEnqueue()
                            } catch (e) {
                                // don't really need this, it means that the player isn't active
                            }
                        }
                    }

                    queue = evtData.queue

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
        property string host: ""
    }

    function setSettings(key, value) {
        settings.setValue(key, value)
        settings.sync()
    }

    function getSettings(key) {
        return settings.value(key)
    }

    function connectToServer() {
        currentTrack = { "title":"", "artist":"", "duration":0, "album":"", "art":"", "discart":"", "artistart": "", "backgroundart": "", "playing":false, "shortformat":"" }
        queue = []
        playPaused = true
        playPosition = -1
        playElapsed = 0
        stackView.clear();

        stackView.push("Player.qml")

    }

    Component.onCompleted: {
        sse.onEventData.connect(eventHandler)
        sse.onDisconnected.connect(eventDisconnect)
        sse.onPaused.connect(function (state) { playPaused = state; playTimer.running = !state })
        //sse.onPosition.connect(function (position) { playPosition = position })

        connectToServer()

        power.onAcChanged.connect(updatePower)
        power.onBatteryChanged.connect(updateBattery)
        power.init();
    }

    property bool ac: false;
    property int batteryPercent: 0;

    function updatePower(value) {
        ac = value
    }

    function updateBattery(value) {
        batteryPercent = value
    }

    StackView {
        id: stackView
        width: parent.width
        height: windowHeight
        clip: true
    }

}
