import QtQuick 2.0
import Mana 1.0

Item {
    anchors.fill: parent

    ListView {
        anchors.fill: parent

        model: itemDB.isLoaded ? gameClient.shopListModel : null
        delegate: MouseArea {
            property variant info: itemDB.getInfo(model.itemId)

            anchors.left: parent.left
            anchors.right: parent.right

            height: 36

            Image {
                id: itemGraphic
                x: 2; y: 2
                // TODO: use imageprovider for this + handling dye
                source: resourceManager.dataUrl + resourceManager.itemIconsPrefix + info.image
                smooth: false
            }

            Text {
                text: info.name

                anchors.left: parent.left
                anchors.leftMargin: 2 + 32 + 5
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12
            }

            Text {
                text: amount
                visible: amount > 0

                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                font.bold: true
                font.pixelSize: 12
            }
        }
    }
}
