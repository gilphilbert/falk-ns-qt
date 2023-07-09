import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15


Rectangle {
    width: Window.width
    height: parent.height
    color: background_color

    property bool isActive: false

    property bool hostHasChanged: false

    function setHostHasChanged(state) {
        hostHasChanged = state
    }

    x: isActive ? 0 : this.width
    y: 0

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
                        text: getSettings("host")
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
                    color: hostHasChanged ? primary_color : background_pop_color
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    radius: this.height * radiusPercent
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
                            setSettings("host", ipInput.text)
                            connectToServer()
                            settingsContainer.focus = true
                        }
                    }
                }
                Rectangle {
                    width: settingsContainer.width * 0.13
                    height: settingsContainer.height * 0.1
                    color: background_pop_color

                    radius: this.height * radiusPercent
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
        }
        // button to save
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
               mainSettings.close()
            }
        }
    }
}
