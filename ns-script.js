var component;
var sprite;

function createTiles() {
    component = Qt.createComponent("tile.qml");
    if (component.status === Component.Ready)
        finishCreation();
    else
        component.statusChanged.connect(finishCreation);
}


function finishCreation() {
    if (component.status === Component.Ready) {
        let red = true
        for (let i=0; i<40; i++) {
            sprite = component.createObject(grid, {x: 0, y: 0});
            if (sprite === null) {
                // Error Handling
                console.log("Error creating object");
            }
        }
    } else if (component.status === Component.Error) {
        // Error Handling
        console.log("Error loading component:", component.errorString());
    }
}
