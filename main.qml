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

    readonly property color yellow: "#EFCB68"
    readonly property color white: "#FCF7F8"
    readonly property color blue: "#4A6FA5"
    readonly property color blue_light: "#353a50"
    readonly property color blue_lighter: "#454c63"
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

    readonly property color background_color: blue_dark //gray_dark
    readonly property color background_pop_color: blue_darkish //gray_darkish
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

    Timer {
        id: playTimer
        interval: 1000
        running: !playPaused
        repeat: true
        onTriggered: if (currentTrack.duration > 0 && playElapsed < currentTrack.duration) playElapsed++
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
    function eventDisconnect(event){
        //server connection lost (couldn't connect/reconnect)
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

    function pausedChanged(state) {
        if (playPaused && !state) {
            resetTouchTimer()
            mainPlaying.close()
        }
        playPaused = state
    }

    ListModel {
        id: queueList
    }

    function queueUpdated(newQueue) {
        queue = newQueue

        queueList.clear()
        queue.forEach(item => {
            queueList.append(item)
        })
        //stackView.currentItem.animateEnqueue()
    }

    function elapsedChanged(seconds) {
        playElapsed = seconds
    }

    function positionChanged(index) {
        playPosition = index
        currentTrack = queue[index]
    }
    Component.onCompleted: {
        sse.onDisconnected.connect(eventDisconnect)
        sse.onPaused.connect(pausedChanged)
        sse.onElapsed.connect(elapsedChanged)
        sse.onPosition.connect(positionChanged)
        sse.onQueue.connect(queueUpdated)

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
