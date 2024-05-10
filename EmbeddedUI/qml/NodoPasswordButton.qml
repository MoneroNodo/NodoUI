import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1
import NodoCanvas 1.0

    Item {
    id: root
    property bool hidePassword: true
    signal hideStatusChanged()

    Image {
        id: passwordPrivacy

        fillMode: Image.PreserveAspectFit
        smooth: true;
        sourceSize.width: root.height
        sourceSize.height: root.height
        source:{
            if(root.hidePassword === true)
            {
                "qrc:/Images/eye-off.png"
            }
            else
            {
                "qrc:/Images/eye.png"
            }
        }
    }

    MouseArea {
        id: passwordHideShow

        height: passwordPrivacy.height
        width: passwordPrivacy.height

        onClicked: {
            if(root.hidePassword === false)
            {
                root.hidePassword = true;
            }
            else
            {
                root.hidePassword = false
            }
            root.hideStatusChanged()
        }
    }
}
