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
    ListElement { name: "Banana"; cost: 5 }
    ListElement { name: "Apple";  cost: 9 }
    ListElement { name: "Orange"; cost: 3 }

    onDataChanged: {
      console.warn("Data changed!", topLeft, bottomRight)
    }
  }

  SortFilterProxyModel {
    id: filteredModel
    sourceModel: fruitModel

    sorters: [
      StringSorter {
        id: sorter
        sortOrder: Qt.AscendingOrder
        roleName: "name"
      }
    ]
  }

  property int currentIndex: -1

  function setCurrentIndex(row) {
    const baseModelRowIndex = filteredModel.mapToSource(row)
    currentIndex = baseModelRowIndex
  }

  function setModelData(index, changes) {
    const baseModelRowIndex = filteredModel.mapToSource(index)
    fruitModel.set(baseModelRowIndex, changes )
  }

  TableModel {
    id: tableModel
    rows: filteredModel.rows
    TableModelColumn { display: "name" }
    TableModelColumn { display: "cost" }
  }

  ColumnLayout {
    anchors.fill: parent
    Row {
      spacing: 10
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

    Text { text: "TableView"; font.bold: true }

    Row {
      id: row
      Layout.fillHeight: true
      width: window.width *.8

      Column {
        Repeater {
          model: filteredModel
          delegate: RadioButton {
            enabled: false
            checked: (currentIndex > -1) ? filteredModel.mapFromSource(currentIndex) === index : false
          }
        }
      }

      TableView {
        id: tableView
        clip: true
        columnSpacing: 1
        width: row.width * 0.9
        height: row.height

        property var currentRowName: ""

        model: tableModel

        delegate: DelegateChooser {
          DelegateChoice {
            column: 0
            delegate: TextField {
              id: nameEdit
              implicitWidth: 140
              font.capitalization: Font.AllUppercase
              text: model.display
              onActiveFocusChanged: {
                if (activeFocus) {
                  setCurrentIndex(model.row)
                }
              }
              onEditingFinished: {
                const changes = { "name" : nameEdit.text }
                setModelData(model.row, changes)
              }
            }
          }
          DelegateChoice {
            column: 1
            delegate: SpinBox {
              id: costSpinBox
              width: 100
              from: 0
              to: 100
              stepSize: 1
              value: model.display
              onValueModified: {
                const changes = { "cost" : costSpinBox.value }
                setModelData(model.row, changes)
                setCurrentIndex(model.row)
              }
              onActiveFocusChanged: {
                if (activeFocus) {
                  setCurrentIndex(model.row)
                }
              }
            }
          }
        }
      }
    }
  }
}

