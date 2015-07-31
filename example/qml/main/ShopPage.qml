import QtQuick 2.0
import QtQuick.Layouts 1.1

import Mana 1.0

Item {
    anchors.fill: parent

    ListView {
        anchors.fill: parent

        model: itemDB.isLoaded ? gameClient.shopListModel : null
        delegate: MouseArea {
            id: item
            property variant info: itemDB.getInfo(model.itemId)
            property bool affordable: cost <= playerAttributes.gold
            property bool extended: false

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            //height: extended ? 100 : 36
            height: layout.height

            ColumnLayout {
                id: layout
                anchors.left: parent.left
                anchors.right: parent.right

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    Image {
                        id: itemGraphic
                        x: 2; y: 2
                        // TODO: use imageprovider for this + handling dye
                        source: resourceManager.dataUrl + resourceManager.itemIconsPrefix + info.image
                        smooth: false
                    }

                    Text {
                        text: info.name

                        Layout.fillWidth: true
                        font.pixelSize: 12
                    }

                    Text {
                        text: cost

                        font.bold: true
                        font.pixelSize: 12
                        color: affordable ? "black" : "red"
                    }
                }

                BrownButton {
                    text: "Buy"
                    visible: item.extended && affordable

                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 100

                    onClicked: {
                        onClicked: gameClient.buySell(model.itemId, 1);
                    }
                }
            }

            onClicked: {
                extended = !extended && affordable;
            }
        }
    }
}
