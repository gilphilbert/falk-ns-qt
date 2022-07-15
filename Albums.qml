import QtQuick 2.15

import "components"

Item {
    signal click(string data)

    LibraryList {
        url: qsTr("albums")
        onNavigate: {
            click(data)
        }
    }
}
