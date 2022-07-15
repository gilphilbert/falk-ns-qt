import QtQuick 2.15
import QtQml.Models 2.15
import QtQuick.Shapes 1.15
//import QtGraphicalEffects 1.12


Rectangle {
    property string page

    id: queueScreen
    width: parent.width
    height: parent.height - 80
    color: "transparent"

    Component {
        id: queueDelegate
        Item {
            id: wrapper
            height: 100
            Row {
                leftPadding: 10
                height: parent.height
                id: queueRow
                Image {
                    source: "image://AsyncImage/" + getArt(art)
                    fillMode: Image.PreserveAspectCrop
                    anchors.verticalCenter: parent.verticalCenter
                    height: 80
                    width: 80
                }

                Column {
                    leftPadding: 15
                    bottomPadding: 5
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        color: "white"
                        text: title
                        font.family: poppins.name
                        font.weight: Font.Light
                        font.pixelSize: 30
                    }
                    Text {
                        text: artist + " - " + getPrettyTime(duration)
                        font.family: poppins.name
                        color: "#c0c0c0"
                        font.pixelSize: 18
                    }
                }

            }

            Rectangle {
                color: "transparent"
                height: 50
                width: 50
                anchors.verticalCenter: parent.verticalCenter
                x: queueScreen.width - 100
                visible: index === playPosition
                layer.enabled: true
                layer.samples: 4
                Shape {
                    width: 8
                    height: 14

                    ShapePath {
                        strokeWidth: 2
                        strokeColor: "white"
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        startX: 10
                        startY: 14
                        PathArc {
                            x: 10
                            y: 36
                            radiusX: 20
                            radiusY: 20
                            direction: PathArc.Counterclockwise
                        }
                    }

                    ShapePath {
                        strokeWidth: 2
                        strokeColor: "white"
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        startX: 15
                        startY: 18
                        PathArc {
                            x: 15
                            y: 32
                            radiusX: 14
                            radiusY: 14
                            direction: PathArc.Counterclockwise
                        }
                    }

                    ShapePath {
                        fillColor: "white"
                        fillRule: ShapePath.WindingFill
                        startX: 22
                        startY: 18
                        PathLine { x: 22; y: 32 }
                        PathLine { x: 30; y: 25 }
                        PathLine { x: 22; y: 18 }
                    }

                    ShapePath {
                        strokeWidth: 2
                        strokeColor: "white"
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        startX: 35
                        startY: 18
                        PathArc {
                            x: 35
                            y: 32
                            radiusX: 14
                            radiusY: 14
                            direction: PathArc.Clockwise
                        }
                    }

                    ShapePath {
                        strokeWidth: 2
                        strokeColor: "white"
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        startX: 40
                        startY: 14
                        PathArc {
                            x: 40
                            y: 36
                            radiusX: 20
                            radiusY: 20
                            direction: PathArc.Clockwise
                        }
                    }
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        topMargin: 25
        leftMargin: 25
        rightMargin: 25
        model: queueList
        delegate: queueDelegate
        focus: true
    }
}
