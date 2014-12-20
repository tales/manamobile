import QtQuick 2.0
import QtQuick.Layouts 1.0

MouseArea {
    id: statusPanel;

    state: "closed"

    readonly property bool partlyVisible: x > -width

    function toggle() {
        state = state === "closed" ? "open" : "closed";
    }

    function limitPrecision(number, precision) {
        var p = Math.pow(10, precision);
        return Math.round(number * p) / p;
    }

    function openOrClose() {
        var open = -statusPanel.x < statusPanel.width / 2;
        statusPanel.state = ""  // hack to make sure to trigger transition
        statusPanel.state = open ? "open" : "closed";
    }

    drag.target: statusPanel;
    drag.axis: Drag.XAxis;
    drag.minimumX: -statusPanel.width;
    drag.maximumX: 0;
    drag.filterChildren: true
    onReleased: openOrClose();

    Image {
        id: tab
        source: "images/tab.png"
        y: parent.height / 4
        anchors.left: parent.right
        anchors.leftMargin: -3
        smooth: false
    }
    Image {
        source: "images/tab_icon_character.png"
        anchors.centerIn: tab
        smooth: false
    }
    MouseArea {
        id: handle;

        anchors.fill: tab
        anchors.margins: -5

        drag.target: statusPanel;
        drag.axis: Drag.XAxis;
        drag.minimumX: -statusPanel.width;
        drag.maximumX: 0;

        onClicked: toggle();
        onReleased: openOrClose();
    }

    BorderImage {
        anchors.fill: parent
        anchors.leftMargin: -33;
        anchors.rightMargin: -1

        source: "images/scroll_medium_horizontal.png"
        border.left: 40; border.top: 31
        border.right: 38; border.bottom: 32
        smooth: false
        visible: partlyVisible
    }

    Item {
        id: contents

        anchors.fill: parent
        anchors.topMargin: 22
        anchors.rightMargin: 28
        anchors.bottomMargin: 7

        clip: flickable.interactive
        visible: partlyVisible

        Flickable {
            id: flickable
            property bool showDistributablePoints: gameClient.attributePoints > 0 ||
                                                   gameClient.correctionPoints > 0

            anchors.top: headerOrnamental.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 8

            interactive: contentHeight > height
            contentHeight: attributeGrid.height

            Column {
                anchors.fill: parent
                spacing: flickable.showDistributablePoints ? 10 : 0

                RowLayout {
                    visible: flickable.showDistributablePoints
                    Column {
                        Text {
                            text: qsTr("%L1 Points to distribute!").arg(attributeGrid.pointsToDistribute)
                            font.pixelSize: 10
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "green"
                        }

                        Text {
                            text: qsTr("%L2 corrections are possible").arg(attributeGrid.pointsToCorrect)
                            font.pixelSize: 10
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "red"
                        }
                    }

                    BrownButton {
                        width: 30
                        text: "✓"
                        visible: attributeGrid.changesPlanned

                        onClicked: {
                            gameClient.modifyAttributes(attributeGrid.plannedChanges)
                            attributeGrid.resetChanges();
                        }
                    }
                }

                AttributeList {
                    id: attributeGrid

                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
        }

        Image {
            id: headerOrnamental
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            source: "images/header_ornamental.png"
            fillMode: Image.TileHorizontally
            horizontalAlignment: Image.AlignLeft
            smooth: false
        }

        Text {
            id: nameLabel
            text: gameClient.playerName
            font.pixelSize: 12
            font.bold: true
            anchors.left: parent.left
            anchors.baseline: levelLabel.baseline
            anchors.leftMargin: 8
            color: "#3F2B25"
        }

        Text {
            id: levelLabel
            anchors.bottom: headerOrnamental.bottom
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.bottomMargin: 1
            text: 'Level ' + Math.floor(playerAttributes.level)
            font.pixelSize: 12
            color: "#3F2B25"
        }

/*
  // TODO: This would be useful as a debug window

        ListView {
            anchors.fill: parent;
            anchors.leftMargin: 5
            anchors.rightMargin: 5

            topMargin: 5
            bottomMargin: 5

            model: attributeDB.isLoaded ? gameClient.attributeListModel : null;
            delegate: Item {
                anchors.left: parent.left;
                anchors.right: parent.right;
                height: attributeName.height;

                Text {
                    id: attributeName;
                    text: {
                        var attributeInfo = attributeDB.getInfo(model.value.attributeId);
                        return attributeInfo.name + " " + model.value.modified;
                    }
                    font.pixelSize: 12
                }
                Text {
                    property real diff: model.value.modified - model.value.base;
                    text: diff > 0 ? "(+" + diff + ")" : "(" + diff + ")";
                    visible: diff != 0;
                    color: diff > 0 ? "green" : "red";
                    font.pixelSize: 12
                    anchors.left: parent.right;
                    anchors.leftMargin: -50;
                }
            }
        }
*/
    }

    ScrollTitle {
        text: qsTr("Character")
        anchors.horizontalCenterOffset: -14
        visible: partlyVisible
    }

    states: [
        State {
            name: "open";

            PropertyChanges {
                target: statusPanel;
                x: 0;
            }
        },
        State {
            name: "closed";
            PropertyChanges {
                target: statusPanel;
                x: -statusPanel.width;
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "x"; easing.type: Easing.OutQuad }
        }
    ]
}
