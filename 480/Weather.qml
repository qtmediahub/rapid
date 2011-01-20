/****************************************************************************

This file is part of the QtMediaHub project on http://www.gitorious.org.

Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Nokia Corporation (qt-info@nokia.com)**

You may use this file under the terms of the BSD license as follows:

"Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

****************************************************************************/

import QtQuick 1.0

Window {
    id: root

    anchors.fill: parent

    property string city: "Munich"

    function fahrenheit2celsius(f) {
        return ((f-32)*5/9.0).toFixed(0);
    }

//    function showCast(name) {
//        city=name;
//        weather.opacity=1.0;
//    }

    function fullWeekDay(name) {
        var map = {
            "Mon" : qsTr("MONDAY"),
            "Tue" : qsTr("TUESDAY"),
            "Wed" : qsTr("WEDNESDAY"),
            "Thu" : qsTr("THURSDAY"),
            "Fri" : qsTr("FRIDAY"),
            "Sat" : qsTr("SATURDAY"),
            "Sun" : qsTr("SUNDAY"),
    };
        return map[name];
    }

    function mapIcon(name) {
        var i = name.lastIndexOf("/")+1;
        var sn = "../../confluence/3rdparty/skin.confluence/media/weathericons/"+name.substr(i, name.length-i-4)+".png";
        return sn;
    }

    function stripLast5(string) {
        return (string.substr(0, string.length-5))
    }

    Row {
        id: weather
        anchors.centerIn: parent
        spacing: 40

        Rectangle {
            width: 300
            height: 400
            color: "#181818"
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 5

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    font.pointSize: 10
                    text: qsTr("CURRENT TEMP")
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    color: "white"
                    font.pointSize: 10
                    text: weatherModel.count > 0 ? weatherModel.get(0).city : ""
                }

                Text {
                    color: "grey"
                    font.pointSize: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: weatherModel.count > 0 ? "Last Updated - " + stripLast5(weatherModel.get(0).current_date_time) : ""
                }

                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width/1.3
                    height: 140
                    Text {
                        id: weatherDegree
                        color: "white"
                        font.pointSize: 48
                        text: weatherMeasurements.count > 0 ? weatherMeasurements.get(0).temp_c : "0"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                    }

                    Text {
                        text: qsTr("°C")
                        color: "white"
                        font.pointSize: 10
                        anchors.verticalCenter: weatherDegree.top
                        anchors.left: weatherDegree.right; anchors.leftMargin: 10
                    }

                    Image {
                        id: weatherIcon
                        width: 80
                        height: width
                        smooth: true
                        asynchronous: true
                        source: weatherMeasurements.count > 0 ? mapIcon(weatherMeasurements.get(0).icon) : ""
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    height: 70
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    font.pointSize: 10
                    text: weatherMeasurements.count > 0 ? weatherMeasurements.get(0).condition : ""
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    font.pointSize: 10
                    text: weatherMeasurements.count > 0 ? weatherMeasurements.get(0).humidity : ""
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    font.pointSize: 10
                    text: weatherMeasurements.count > 0 ? weatherMeasurements.get(0).wind_condition : ""
                }
            }
        }

        Rectangle {
            width: 300
            height: 400
            color: "#181818"
            radius: 8

            Column {
                anchors.fill: parent
                spacing: 30
                anchors.topMargin: 20
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    font.pointSize: 10
                    text: qsTr("WEATHER FORECAST")
                }

                ListView {
                    id: forecastListView
                    height: 360
                    width: parent.width
                    clip: true
                    model: weatherForecast
                    delegate: Item {
                        height: 80
                        width: forecastListView.width

                        Rectangle {
                            id: sep
                            width: forecastListView.width-20
                            height: 2
                            radius: 2
                            color: "#40FFFFFF"
                            anchors.topMargin: 5
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            id: dayofweek
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: sep.bottom; anchors.topMargin: 8
                            color: "white"
                            font.pointSize: 10
                            text: weatherForecast.count > 0 && weatherForecast.get(index) ? fullWeekDay(weatherForecast.get(index).day_of_week) : ""
                        }

                        Text {
                            id: hightemptext
                            anchors.top: dayofweek.bottom
                            smooth: true
                            font.pointSize: 10
                            color: "grey"
                            text: qsTr("High: ")
                        }
                        Text {
                            id: hightempvalue
                            anchors.top: dayofweek.bottom
                            anchors.left: hightemptext.right
                            font.weight: Font.Normal
                            color: "white"
                            font.pointSize: 10
                            text: weatherForecast.count > 0 && weatherForecast.get(index) ? root.fahrenheit2celsius(weatherForecast.get(index).high_f) + " °C" : ""
                        }

                        Text {
                            id: lowtemptext
                            anchors.top: dayofweek.bottom
                            anchors.left: hightempvalue.right; anchors.leftMargin: 25
                            smooth: true
                            font.pointSize: 10
                            color: "grey"
                            text: qsTr("Low: ")
                        }
                        Text {
                            anchors.left: lowtemptext.right;
                            anchors.top: dayofweek.bottom
                            font.weight: Font.Normal
                            color: "white"
                            font.pointSize: 10
                            text: weatherForecast.count > 0 && weatherForecast.get(index) ? root.fahrenheit2celsius(weatherForecast.get(index).low_f)  + " °C" : ""
                        }

                        Text {
                            id: condition
                            anchors.top: hightemptext.bottom
                            font.weight: Font.Normal
                            color: "white"
                            font.pointSize: 10
                            text: weatherForecast.count > 0 && weatherForecast.get(index) ? weatherForecast.get(index).condition : ""
                        }

                        Image {
                            width: parent.height/1.5
                            height: width
                            smooth: true
                            asynchronous: true
                            source: weatherForecast.count > 0 && weatherForecast.get(index) ? mapIcon(weatherForecast.get(index).icon) : ""
                            anchors.right: parent.right
                            anchors.bottom: condition.bottom
                        }
                    }
                }
            }
        }
    }

    XmlListModel {
        id: weatherModel
        source: "http://www.google.com/ig/api?weather=" + city
        query: "/xml_api_reply/weather/forecast_information"

        //forecast information
        XmlRole { name: "city"; query: "city/@data/string()" }
        XmlRole { name: "forecast_date"; query: "forecast_date/@data/string()" }
        XmlRole { name: "current_date_time"; query: "current_date_time/@data/string()" }
    }

    XmlListModel {
        id: weatherMeasurements
        source: "http://www.google.com/ig/api?weather=" + city
        query: "/xml_api_reply/weather/current_conditions"

        //current condition
        XmlRole { name: "condition"; query: "condition/@data/string()" }
        XmlRole { name: "temp_c"; query: "temp_c/@data/string()" }
        XmlRole { name: "humidity"; query: "humidity/@data/string()" }
        XmlRole { name: "icon"; query: "icon/@data/string()" }
        XmlRole { name: "wind_condition"; query: "wind_condition/@data/string()" }

    }

    XmlListModel {
        id: weatherForecast
        source: "http://www.google.com/ig/api?weather=" + city
        query: "/xml_api_reply/weather/forecast_conditions"

        XmlRole { name: "day_of_week"; query: "day_of_week/@data/string()" }
        XmlRole { name: "low_f"; query: "low/@data/string()" }
        XmlRole { name: "high_f"; query: "high/@data/string()" }
        XmlRole { name: "icon"; query: "icon/@data/string()" }
        XmlRole { name: "condition"; query: "condition/@data/string()" }

    }

//    ListModel {
//        id: cityList
//        ListElement { name: "Atlanta" }
//        ListElement { name: "Bangalore" }
//        ListElement { name: "Bangkok" }
//        ListElement { name: "Beijing" }
//        ListElement { name: "Berlin" }
//        ListElement { name: "Bogota" }
//        ListElement { name: "Boston" }
//        ListElement { name: "Cape Town" }
//        ListElement { name: "Casablanca" }
//        ListElement { name: "Durban" }
//        ListElement { name: "Helsinki" }
//        ListElement { name: "Juneau" }
//        ListElement { name: "Landshut" }
//        ListElement { name: "Lhasa" }
//        ListElement { name: "Lima" }
//        ListElement { name: "London" }
//        ListElement { name: "Manila" }
//        ListElement { name: "Munich" }
//        ListElement { name: "Moscow" }
//        ListElement { name: "New York" }
//        ListElement { name: "Nuuk" }
//        ListElement { name: "Paris" }
//        ListElement { name: "Rome" }
//        ListElement { name: "San Francisco" }
//        ListElement { name: "Sydney" }
//        ListElement { name: "Timbuktu" }
//        ListElement { name: "Tokyo" }
//        ListElement { name: "Ulm" }
//        ListElement { name: "Untermarchtal" }
//    }

    Engine { name: qsTr("Weather"); role: "weather"; visualElement: root }

}
