import QtQuick 2.15

import "components"

Item {
    signal click(string data)

    property string genreName

    LibraryList {
        url: "genre/" + genreName
        onNavigate: {
            click(data)
        }
    }
}
