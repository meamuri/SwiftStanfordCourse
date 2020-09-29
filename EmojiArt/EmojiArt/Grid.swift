//
//  Grid.swift
//  Memorize
//
//  Created by Roman Dronov on 10.09.2020.
//  Copyright © 2020 Roman Dronov. All rights reserved.
//

import SwiftUI

struct Grid<Item, ID, ItemView>: View where ItemView: View, ID: Hashable {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    private var id: KeyPath<Item, ID>
    
    init(_ items: [Item], id: KeyPath<Item, ID>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        ForEach(items, id: id) { item in
            self.body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View  {
        let index = self.items.firstIndex(where: { item[keyPath: id] == $0[keyPath: id] })
        return Group {
            if index != nil {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index!))
            }
        }
    }
}

extension Grid where Item: Identifiable, Item.ID == ID {
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.init(items, id: \Item.id, viewForItem: viewForItem)
    }
}

