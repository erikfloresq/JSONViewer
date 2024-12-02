//
//  JSONNode.swift
//  JSONViewer
//
//  Created by Erik Flores on 1/12/24.
//

import SwiftUI

class JSONNode: Identifiable, ObservableObject {
    let id = UUID()
    let key: String?
    let value: Any
    let type: NodeType
    @Published var isExpanded: Bool = true
    @Published var isMatchingSearch: Bool = true
    var children: [JSONNode] = []
    
    enum NodeType {
        case object
        case array
        case value
    }
    
    init(key: String? = nil, value: Any) {
        self.key = key
        self.value = value
        
        if let dictionary = value as? [String: Any] {
            type = .object
            children = dictionary.map { JSONNode(key: $0.key, value: $0.value) }
        } else if let array = value as? [Any] {
            type = .array
            children = array.map { JSONNode(value: $0) }
        } else {
            type = .value
        }
    }
    
    @discardableResult
    func updateVisibility(for searchText: String) -> Bool {
        var matches = false

        if searchText.isEmpty {
            matches = true
        } else {
            // Verificar si la clave o el valor coinciden con la búsqueda
            if let key = key, key.localizedCaseInsensitiveContains(searchText) {
                matches = true
            } else if let stringValue = value as? String, stringValue.localizedCaseInsensitiveContains(searchText) {
                matches = true
            } else if let numberValue = value as? NSNumber, "\(numberValue)".contains(searchText) {
                matches = true
            }

            // Verificar si algún hijo coincide
            if !matches && !children.isEmpty {
                for child in children {
                    if child.updateVisibility(for: searchText) {
                        matches = true
                    }
                }
            }
        }

        self.isMatchingSearch = matches
        // Si el nodo coincide, expandirlo
        if matches && !children.isEmpty {
            self.isExpanded = true
        }

        return matches
    }
}
