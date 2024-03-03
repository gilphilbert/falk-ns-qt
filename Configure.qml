import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
//import QtGraphicalEffects 1.15

Rectangle {
    width: Window.width
    height: parent.height

    color: background_color

    id: parentItem

    x: isActive ? 0 : this.width
    y: 0

    property bool isActive: false

    Behavior on x {
        NumberAnimation {
            easing.type: Easing.InOutCubic
            duration: 300
        }
    }

    function open() {
        isActive = true
    }
    function close() {
        isActive = false
    }

    property bool hostHasChanged: false

    function setHostHasChanged(state) {
        hostHasChanged = state
    }

    Item {
        width: parent.width - 40
        height: parent.height - 40
        anchors.centerIn: parent

        id: settingsContainer

        // this allows the textinput to lose focus
        MouseArea {
            anchors.fill: parent

            onClicked: {
                focus = true
            }
        }

        Column {

            Row {
                Text {
                    color: text_color
                    font.pixelSize: text_h1
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    text: 'Settings'
                    height: 30
                    width: 100
                }
            }

            Row {
                topPadding: 30
                Text {
                    color: text_color
                    font.pixelSize: text_h2
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    text: 'FALK DP IP address'
                    height: 30
                    width: 100
                }
            }

            Row {
                spacing: 15

              // set the ip address of the server here
                Rectangle {
                    height: settingsContainer.height * 0.1
                    width: settingsContainer.width * 0.5
                    color: background_pop_color
                    radius: this.height * radiusPercent

                    TextInput {
                        id: ipInput
                        color: white
                        text: typeof getSettings("host") === "undefined" ? "" : getSettings("host")
                        width: parent.width - 30
                        height: parent.height
                        anchors.centerIn: parent
                        //focus: true
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        padding: 0
                        verticalAlignment: Text.AlignVCenter

                        onTextChanged: {
                            if (text !== getSettings("host"))
                                setHostHasChanged(true)
                            else
                                setHostHasChanged(false)
                        }

                        cursorDelegate: Rectangle {
                            visible: ipInput.cursorVisible
                            color: primary_color
                            width: ipInput.cursorRectangle.width
                        }
                    }
                }
                Rectangle {
                    width: settingsContainer.width * 0.13
                    height: settingsContainer.height * 0.1
                    color: hostHasChanged ? primary_color : "transparent"//background_pop_color
                    radius: this.height// * radiusPercent
                    border {
                        width: 2
                        color: primary_color
                    }

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    Text {
                        anchors.fill: parent
                        text: "Save"
                        color: hostHasChanged ? background_color : text_color
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            showWaitingmodal()
                            musicAPIRequest("version", function (data) {
                                console.info(JSON.stringify(data))
                                if (Object.keys(data).includes("name") && data.name === "falkdp" ) {
                                    checkModal.folded = true
                                    setSettings("host", ipInput.text)
                                    startPlayer(ipInput.text)
                                    settingsContainer.focus = true
                                    settingsScreen.close()
                                } else {
                                    showConnectErrorModal()
                                }
                            }, "GET", null, ipInput.text)
                        }
                    }
                }
                Rectangle {
                    width: settingsContainer.width * 0.13
                    height: settingsContainer.height * 0.1
                    color: "transparent" //background_pop_color
                    border {
                        width: 2
                        color: primary_color
                    }

                    radius: this.height //* radiusPercent

                    Text {
                        anchors.fill: parent
                        text: "Reset"
                        color: white
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            ipInput.text = getSettings("host")
                            settingsContainer.focus = true
                        }
                    }
                }
            }
            Row {
                topPadding: 30
                Text {
                    color: text_color
                    font.pixelSize: text_h2
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    text: 'System Power'
                    height: 30
                    width: 100
                }
            }
            Row {
                Rectangle {
                    width: settingsContainer.width * 0.13
                    height: settingsContainer.height * 0.1
                    color: danger_color
                    border {
                        width: 2
                        color: danger_color
                    }

                    radius: this.height// * radiusPercent
                    Text {
                        anchors.fill: parent
                        text: "Reboot"
                        color: white
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            power.reboot()
                        }
                    }
                }
            }
        }
        // button to save
    }

    function showWaitingmodal() {
        checkModalMain.color = primary_color
        checkModalTitle.text = "Connecting"
        checkModalIndicator.visible = true
        checkModalText.visible = false
        checkModalbutton.visible = false
        checkModal.folded = false
    }

    function closeModal() {
        checkModal.folded = true
    }

    function showConnectErrorModal() {
        checkModalTitle.text = "Shucks"
        checkModalIndicator.visible = false
        checkModalText.visible = true
        checkModalText.text = "Could't find a FALK DP at this address. Did you get the correct address?"
        checkModalbutton.visible = true
        checkModalButtonText.text = "Close"
    }



    function keyPress(key) {
        if (!isNaN(key) || key === ":" || key === ".")
          ipInput.text += key
        else if (key === '<')
          ipInput.text = ipInput.text.slice(0, -1)
    }

    Rectangle {
        y: ipInput.focus ? parent.height - this.height : parent.height
        width: parent.width / 3.25
        height: this.width
        anchors.horizontalCenter: parent.horizontalCenter
        color: '#333333'

        Behavior on y {
            NumberAnimation {
                easing.type: Easing.InOutCubic
                duration: 250
            }
        }

        id: keyboard

        ListModel {
            id: keyList
            ListElement {
                name: "1"
            }
            ListElement {
                name: "2"
            }
            ListElement {
                name: "3"
            }
            ListElement {
                name: ""
            }

            ListElement {
                name: "4"
            }
            ListElement {
                name: "5"
            }
            ListElement {
                name: "6"
            }
            ListElement {
                name: ""
            }

            ListElement {
                name: "7"
            }
            ListElement {
                name: "8"
            }
            ListElement {
                name: "9"
            }
            ListElement {
                name: ""
            }

            ListElement {
                name: "."
            }
            ListElement {
                name: "0"
            }
            ListElement {
                name: ":"
            }
            ListElement {
                name: "<"
            }

        }

        GridView {
            id: keyGrid
            anchors.fill: parent


            cellWidth: keyboard.width / 4
            cellHeight: this.cellWidth


            model: keyList
            delegate:
                Rectangle {
                    id: key
                    height: keyGrid.cellWidth
                    width: keyGrid.cellWidth
                    color: "transparent"
                    Text {
                        text: name
                        color: "#999"
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        anchors.centerIn: key
                    }

                    states: State {
                        name: "pressed"
                        when: mouseArea.pressed
                        PropertyChanges {
                            target: key;
                            color: "#555"
                        }
                    }

                    transitions: Transition {
                       SequentialAnimation{
                         ColorAnimation {
                             from: "#555";
                             duration: 200
                         }
                         ColorAnimation {
                             from: "transparent";
                             duration: 150
                         }
                       }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                           keyPress(name)
                        }
                    }
                }
        }
    }


    Item {
        height: 50
        width: 50
        anchors.right: parent.right
        anchors.top: parent.top

        Image {
            source: "icons/close.svg"
            height: parent.height * 0.45
            width: this.height
            anchors.centerIn: parent

            sourceSize.width: this.width
            sourceSize.height: this.height

        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.info("here")
               parentItem.close()
            }
        }
    }

    Item {
        id: checkModal
        anchors.fill: parent
        //visible: false
        //opacity: 0.0

        property bool folded: true
        state: !folded ? "Visible" : "Invisible"
        states: [
            State{
                name: "Visible"
                PropertyChanges{target: checkModal; opacity: 1.0}
                PropertyChanges{target: checkModal; visible: true}
            },
            State{
                name:"Invisible"
                PropertyChanges{target: checkModal; opacity: 0.0}
                PropertyChanges{target: checkModal; visible: false}
            }
        ]

        transitions: [
            Transition {
                from: "Visible"
                to: "Invisible"

                SequentialAnimation{
                    NumberAnimation {
                        target: checkModal
                        property: "opacity"
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: checkModal
                        property: "visible"
                        duration: 0
                    }
                }
            },

            Transition {
                from: "Invisible"
                to: "Visible"
                SequentialAnimation{
                    NumberAnimation {
                        target: checkModal
                        property: "visible"
                        duration: 0
                    }
                    NumberAnimation {
                        target: checkModal
                        property: "opacity"
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        ]

        Rectangle {
            anchors.fill: parent
            color: background_color
            opacity: 0.7
        }

        Rectangle {
            id: checkModalMain
            height: parent.height * 0.4
            width: parent.width * 0.4
            anchors.centerIn: parent
            color: primary_color
            radius: this.height * 0.04

            Column {
                width: parent.width
                height: childrenRect.height
                anchors.centerIn: parent
                leftPadding: this.width * 0.15
                rightPadding: this.leftPadding

                Text {
                    id: checkModalTitle
                    text: "Connecting"
                    color: gray_darkish
                    font.pixelSize: text_h1
                    font.family: inter.name
                    font.weight: Font.ExtraBold
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                BusyIndicator {
                    id: checkModalIndicator
                    running: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    topPadding: text_h1
                }

                IconImage {
                    id: checkModalAlert
                    height: checkModalIndicator.height
                    width: this.height
                    source: "icons/alert-circle.svg"
                    smooth: true
                    sourceSize.width: this.width
                    sourceSize.height: this.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: gray_darkish
                }

                Text {
                    id: checkModalText
                    width: parent.width * .8
                    text: ""
                    color: gray_darkish
                    wrapMode: Text.WordWrap
                    font.pixelSize: text_h4
                    font.family: inter.name
                    font.weight: Font.Bold
                    bottomPadding: text_h4 * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }

                Rectangle {
                    id: checkModalbutton
                    color: gray_darkish
                    width: parent.width * 0.3
                    height: text_h2 * 3
                    radius: this.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: false

                    Text {
                        id: checkModalButtonText
                        text: ""
                        color: white
                        anchors.fill: parent
                        font.pixelSize: text_h2
                        font.family: inter.name
                        font.weight: Font.ExtraBold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            checkModal.folded = true
                        }
                    }
                }
            }
        }

    }
}
