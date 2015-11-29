import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.0 as ListItems
import Ubuntu.Content 1.1

Page {
    id: importer
    title: "Import from..."

    // Content Importer
    property list<ContentItem> importItems
    property var activeTransfer
    ContentPeerPicker {
        id: sourcePicker
        contentType: ContentType.Pictures
        handler: ContentHandler.Source

        showTitle: false

        onPeerSelected: {
            peer.selectionType = ContentTransfer.Single;
            importer.activeTransfer = peer.request(appStore);
            pageStack.pop();
        }

        onCancelPressed: {
            pageStack.pop()
        }
    }

    ContentTransferHint {
        id: importHint
        anchors.fill: parent
        activeTransfer: importer.activeTransfer
    }
    ContentStore {
        id: appStore
        scope: ContentScope.App
    }
    Connections {
        target: importer.activeTransfer ? importer.activeTransfer : null
        onStateChanged: {
            if (importer.activeTransfer.state === ContentTransfer.Charged) {
                console.log("Content transfer is charged")
                importItems = importer.activeTransfer.items;
                for (var i=0; i<importItems.length; i++) {
                    checkinpage.addImportedImage(importItems[i]);
                }
            }
        }
    }


}
