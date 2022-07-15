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
    width: 1024
    height: 600
    //title: qsTr("NS Viewer")
    color: "#222c3b"
    id: appWindow
    visible: true
    //flags: Qt.FramelessWindowHint

    //Image {
        //source: "image://CachedImageProvider/https://www.musicdirect.com/Portals/0/Hotcakes/Data/products/8cb25687-cad5-40ca-87ab-17dcb55ebbce/medium/LDM31011_.jpg"
        //source: "image://AsyncImage/https://www.musicdirect.com/Portals/0/Hotcakes/Data/products/8cb25687-cad5-40ca-87ab-17dcb55ebbce/medium/LDM31011_.jpg"
    //    height: 200
    //    width: 200
    //    x: 0
    //    y: 0
    //}

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
                    playArt = "http://" + settings.host + queue[playPosition].art + "?size=300"
                    playTitle = queue[playPosition].title
                    playArtist = queue[playPosition].artist
                    playDuration = queue[playPosition].duration
                    queueList.clear()
                    queue.forEach(item => {
                        queueList.append(item)
                    })
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
        settings.host = "192.168.68.104"
        sse.onEventData.connect(signalHandling)
        sse.onDisconnected.connect(serverDisconnect)
        sse.setServer("http://" + settings.host + "/events")
    }

    function apiRequest(urlComponent, callback) {
        const fullURL = "http://" + settings.host + "/api/" + urlComponent
        console.error(fullURL);
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = (function (myxhr) {
            return function () {
                if (xhr.readyState === XMLHttpRequest.DONE)
                    if (callback) {
                        try {
                            callback(JSON.parse(xhr.responseText))
                        } catch (e) {
                            console.info(e)
                            console.info(xhr.responseText)
                        }
                    }
            }
        })(xhr)
        xhr.open("GET", fullURL, true)
        xhr.send('')
    }

    function getArt(uri, size = 150) {
        if (uri !== "")
          return "http://" + settings.host + uri + "?size=" + size
        return ""
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


    property bool playPaused: true
    property int playPosition: 0
    property int playElapsed: 0
    property int playDuration: 0
    property string playArt: ""
    property string playTitle: ""
    property string playArtist: ""

    Settings {
        id: settings
        property string host: "192.168.68.104"
    }

     /*
    property variant pagesList: [
        {
            "page": "home",
            "name": "PLAYING",
            "file": "home",
        },
        {
            "page": "queue",
            "name": "QUEUE",
            "file": "queue",
        },
        {
            "page": "",
            "name": "",
            "file": "",
        },
        {
            "page": "playlists",
            "name": "PLAYLISTS",
            "file": "library",
        },
        {
            "page": "artists",
            "name": "ARTISTS",
            "file": "library",
        },
        {
            "page": "albums",
            "name": "ALBUMS",
            "file": "library",
        },
        {
            "page": "genres",
            "name": "GENRES",
            "file": "library",
        },
        {
            "page": "",
            "name": "",
            "file": "",
        }
    ];
    property string currentPage: "home"

    Component {
        id: footerItem
        Rectangle {
            width: footer.width / pagesList.length;
            height: footer.height
            color: (( currentPage === "home" ) ? "transparent" : "#3d4d66")
            clip: true

            Text {
                id: pageTitle
                anchors.centerIn: parent
                font.family: kentledge.name
                color: (( modelData.page === appWindow.currentPage) ? "#ffffff" : "#c0c0c0")
                text: modelData.name
            }
            Glow {
                anchors.fill: pageTitle
                radius: 8
                opacity: 0.25
                samples: 17
                color: (( modelData.page === appWindow.currentPage ) ? "white" : "transparent")
                source: pageTitle
            }
            Rectangle {
                id: divider
                x: 0
                y: 0
                height: 3
                width: parent.width
                color: (( modelData.page === appWindow.currentPage ) ? "#E3B505" : "#4b6281")
            }
            Glow {
                anchors.fill: divider
                radius: 15
                samples: 17
                color: (( modelData.page === appWindow.currentPage ) ? "#E3B505" : "transparent")
                source: divider
            }
            MouseArea {
                anchors.fill: parent
                onClicked: { if (modelData.page !== "") { appWindow.currentPage = modelData.page } }
            }
        }
    }
    */

    Image {
        id: backgroundArt
        source: playArt
        height: parent.height
        width: parent.width
        x: 0
        y: 0
        fillMode: Image.PreserveAspectCrop
        clip: true
        visible: playArt !== ""
        Rectangle {
            width: parent.width
            height: parent.height
            x: 0
            y: 0
            color: "#283445"
            opacity: 0.92
        }
    }
    FastBlur {
        anchors.fill: backgroundArt
        source: backgroundArt
        radius: 45
    }

    function loadNext(data) {
        const _data = JSON.parse(data)

        switch (pageName) {
        case "Genres":
            pageName = "Genre"
            apiURL = "genre/" + _data.name
            break
        case "Artists":
            pageName = "Artist"
            apiURL = "artist/" + _data.name
            break
        }

        pageLoader.setSource("components/LibraryList.qml")
    }

    property string apiURL: ""
    property string pageName: "Playing"
    Loader {
        id: pageLoader
        anchors.fill: parent
        source: "Playing.qml"
        onLoaded: function() {
            switch (pageLoader.source.toString()) {

                case Qt.resolvedUrl("/components/LibraryList.qml"):
                    pageLoader.item.navigate.connect(loadNext)
                    pageLoader.item.url = apiURL
                    break;
            }
        }
    }

    function pageHandler(page) {
        if (page === "Playing" || page === "Queue") {
            pageLoader.setSource(page + ".qml")
            pageName = page
        } else {
            apiURL = page.toLowerCase()
            pageName = page
            pageLoader.setSource("components/LibraryList.qml")
        }
    }

    Rectangle {
        id: footer
        x: 0
        y: parent.height - 80
        width: parent.width
        height: 80
        color: "transparent"

        Rectangle {
            width: parent.width
            height: parent.height
            x: 0
            y: 0
            color: "#506687"
            opacity: 0.3
        }

        Row {
            FooterItem {
                title: qsTr("Playing")
                onClick: { pageHandler(page) }
            }
            FooterItem {
                title: qsTr("Queue")
                onClick: { pageHandler(page) }
            }
            FooterItem {
                title: qsTr("")
            }
            FooterItem {
                title: qsTr("playlists")
            }
            FooterItem {
                title: qsTr("Artists")
                onClick: { pageHandler(page) }
            }
            FooterItem {
                title: qsTr("Albums")
                onClick: { pageHandler(page) }
            }
            FooterItem {
                title: qsTr("Genres")
                onClick: { pageHandler(page) }
            }
            FooterItem {
                title: qsTr("")
            }
        }
    }
}
