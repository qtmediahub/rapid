import QtQuick 1.0

import QTerminalMode 1.0

Window {
    id: root

    TerminalMode { id: tm; x: 100; y: 100 }

    Engine { name: qsTr("TerminalMode"); role: "terminalMode"; visualElement: root }
}