import QtQuick 2.14
import QtQuick.Window 2.12
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import Qt.labs.qmlmodels 1.0
import SortFilterProxyModel 0.2


ApplicationWindow {
  id: window
  visible: true
  width: 450
  height: 400

  ListModel {
    id: fruitModel
    ListElement { name: "Banana"; cost: 1.95 }
    ListElement { name: "Apple";  cost: 2.45 }
    ListElement { name: "Orange"; cost: 3.25 }
  }

  Column {
    anchors {
      right: parent.right
      top: parent.top
    }

    Button {
      text: "Change order"
      onClicked: {
        if (sorter.sortOrder === Qt.AscendingOrder) {
          sorter.sortOrder = Qt.DescendingOrder
        } else {
          sorter.sortOrder = Qt.AscendingOrder
        }
      }
    }

    Button {
      text: "Add new item"
      property var fruits: [ 'Pineapple', 'Watermelon', 'Melon', 'Kiwi', 'Cucumber', 'Tomato' ]
      onClicked: {
        const randomNumber = Math.floor(Math.random() * fruits.length)
        const randomCost = Math.floor((Math.random() * 10) * 100)/100
        const randomFruit = {
          "name": fruits[randomNumber],
          "cost": randomCost
        }

        fruitModel.append( randomFruit )
      }
    }
  }

  SortFilterProxyModel {
    id: filteredModel
    sourceModel: fruitModel

    sorters: [ StringSorter {
        id: sorter
        sortOrder: Qt.AscendingOrder
        roleName: "name"
      } ]
  }

  TableModel {
    id: tableModel
    rows: filteredModel.rows
    TableModelColumn { display: "name" }
    TableModelColumn { display: "cost" }
  }

  ColumnLayout {
    anchors.fill: parent

    Text { text: "TableView"; font.bold: true }

    TableView {
      id: tableView
      clip: true
      Layout.fillHeight: true
      width: window.width *.8

      property var currentRowName: ""

      model: tableModel

      delegate: DelegateChooser {
        DelegateChoice {
          column: 0
          delegate: TextField {
            implicitWidth: 140
            font.capitalization: Font.AllUppercase
            text: model.display
            readOnly: true
            onActiveFocusChanged: {
              if (activeFocus) {
                console.error("Focused", model.display, model.row)
                tableView.currentRowName = model.display
              }
            }
          }
        }
        DelegateChoice {
          column: 1
          delegate: TextField {
            implicitWidth: 70
            font.capitalization: Font.AllUppercase
            text: model.display
            readOnly: true
            font.underline: true
            horizontalAlignment: Qt.AlignRight
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

