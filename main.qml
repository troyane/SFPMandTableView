import QtQuick 2.14
import QtQuick.Window 2.12
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import Qt.labs.qmlmodels 1.0
import SortFilterProxyModel 0.2


ApplicationWindow {
  visible: true
  width: 400
  height: 300

  ListModel {
    id: fruitModel
    ListElement { name: "Banana"; cost: 1.95 }
    ListElement { name: "Apple";  cost: 2.45 }
    ListElement { name: "Orange"; cost: 3.25 }
  }

  SortFilterProxyModel {
    id: filteredModel
    sourceModel: fruitModel

    sorters: [ StringSorter { roleName: "name" } ]
  }

  ColumnLayout {
    anchors.fill: parent

    Text { text: "TableView"; font.bold: true }

    TableView {
      clip: true
      Layout.fillHeight: true
      Layout.fillWidth: true

      model: filteredModel

      delegate: DelegateChooser {
        DelegateChoice {
          column: 0
          delegate: TextField {
            implicitWidth: 140
            font.capitalization: Font.AllUppercase
            // You can access "cost" value
            text: name // + " / " + cost
            readOnly: true
          }
        }
        // But Column 1 not working...
        DelegateChoice {
          column: 1
          delegate: TextField {
            implicitWidth: 70
            font.capitalization: Font.AllUppercase
            text: cost
            readOnly: true
          }
        }
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 2
      color: "salmon"
    }

    Text { text: "ListView"; font.bold: true }

    ListView {
      clip: true
      Layout.fillHeight: true
      Layout.fillWidth: true
      model: filteredModel
      delegate: Text {
        text: "Fruit " + name + " for $" + cost
      }
    }
  }
}

