//
//  JSONNodeView.swift
//  JSONViewer
//
//  Created by Erik Flores on 1/12/24.
//

import SwiftUI

struct JSONNodeView: View {
    @ObservedObject var node: JSONNode
    var indentLevel: Int = 0
    var searchText: String

    var body: some View {
        if node.isMatchingSearch {
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .top) {
                    // Indentación
                    Rectangle()
                        .frame(width: CGFloat(indentLevel) * 16)
                        .foregroundColor(.clear)

                    // Indicador de expandir/colapsar
                    if node.type != .value {
                        Button(action: {
                            withAnimation {
                                node.isExpanded.toggle()
                            }
                        }) {
                            Image(systemName: node.isExpanded ? "chevron.down" : "chevron.right")
                                .font(.system(size: 12))
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Spacer().frame(width: 12)
                    }

                    // Clave y valor
                    Group {
                        if let key = node.key {
                            Text("\"\(key)\"")
                                .foregroundColor(.blue)
                                .background(keyMatchesSearch ? Color.yellow.opacity(0.5) : Color.clear)
                            Text(":")
                                .foregroundColor(.gray)
                        }

                        if node.type == .value {
                            Text(formatValue(node.value))
                                .foregroundColor(colorForValue(node.value))
                                .background(valueMatchesSearch ? Color.yellow.opacity(0.5) : Color.clear)
                        } else {
                            Text(node.type == .object ? "{" : "[")
                                .foregroundColor(.gray)
                        }
                    }
                    .font(.system(size: 14, weight: .regular, design: .monospaced))

                    Spacer()
                }

                // Mostrar hijos si está expandido
                if node.isExpanded && node.type != .value {
                    ForEach(node.children) { child in
                        JSONNodeView(node: child, indentLevel: self.indentLevel + 1, searchText: searchText)
                    }
                    HStack {
                        Rectangle()
                            .frame(width: CGFloat(indentLevel) * 16)
                            .foregroundColor(.clear)
                        Text(node.type == .object ? "}" : "]")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // Funciones auxiliares
    func formatValue(_ value: Any) -> String {
        if let string = value as? String {
            return "\"\(string)\""
        } else if value is NSNull {
            return "null"
        } else {
            return "\(value)"
        }
    }

    func colorForValue(_ value: Any) -> Color {
        if value is String {
            return .green
        } else if value is NSNumber {
            return .orange
        } else if value is NSNull {
            return .red
        } else if value is Bool {
            return .purple
        } else {
            return .primary
        }
    }

    var keyMatchesSearch: Bool {
        guard let key = node.key, !searchText.isEmpty else { return false }
        return key.localizedCaseInsensitiveContains(searchText)
    }

    var valueMatchesSearch: Bool {
        guard !searchText.isEmpty else { return false }
        if let stringValue = node.value as? String {
            return stringValue.localizedCaseInsensitiveContains(searchText)
        } else if let numberValue = node.value as? NSNumber {
            return "\(numberValue)".contains(searchText)
        }
        return false
    }
}
