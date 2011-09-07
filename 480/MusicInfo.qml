import QtQuick 1.0
import QtMediaHub.components.media 1.0


Item {
    id: root

    property variant mediaInfo
    property int position
    property int duration                       // TODO: duration is not working in QMHPlayer!!

    property int lablePixelSize: height * 0.035
    property int textPixelSize: height * 0.048

    function ms2string(ms)
    {
        var ret = "";

        if (ms <= 0)
            return "00:00";

        var h = Math.floor(ms/(1000*60*60))
        var m = Math.floor((ms%(1000*60*60))/(1000*60))
        var s = Math.floor(((ms%(1000*60*60))%(1000*60))/1000)

        if (h >= 1) {
            ret += h < 10 ? "0" + h : h + "";
            ret += ":";
        }

        ret += m < 10 ? "0" + m : m + "";
        ret += ":";
        ret += s < 10 ? "0" + s : s + "";

        return ret;
    }


    clip: true

    Image {
        id: coverArt
        source: mediaInfo.thumbnail
        fillMode: Image.PreserveAspectFit
        height: root.height * 0.25
    }

    Text {
        id: artistLabel;
        anchors.top: coverArt.bottom
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: root.lablePixelSize;
        text: "Artist:"
    }
    Item {
        id: artist;
        anchors.top: artistLabel.bottom
        height: root.textPixelSize * 2.3;
        width: root.width
//        color: "transparent"
        clip: true
        Text {
            color: "white"
            font.pixelSize: root.textPixelSize;
            text: mediaInfo.artist
            width: parent.width
            wrapMode: Text.Wrap
        }
    }

    Text { id: titleLabel;
        anchors.top: artist.bottom
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: root.lablePixelSize;
        text: "Title:"
    }
    Item {
        id: title;
        anchors.top: titleLabel.bottom
        height: root.textPixelSize * 3.5;
        width: root.width
        clip: true
        Text {
            color: "white"
            font.pixelSize: root.textPixelSize;
            text: mediaInfo.title
            width: parent.width
            wrapMode: Text.Wrap
        }
    }

    Text { id: albumLabel;
        anchors.top: title.bottom
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: root.lablePixelSize;
        text: "Album:"
    }
    Item {
        id: album;
        anchors.top: albumLabel.bottom
        height: root.textPixelSize * 3.5;
        width: root.width
        clip: true
        Text {
            color: "white"
            font.pixelSize: root.textPixelSize;
            text: mediaInfo.album
            width: parent.width
            wrapMode: Text.Wrap
        }
    }



    Text {
        id: playPosition
        anchors.bottom: root.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        font.pixelSize: root.height * 0.052;
        text: ms2string(root.position) + " / " + ms2string(root.duration)
    }

}
