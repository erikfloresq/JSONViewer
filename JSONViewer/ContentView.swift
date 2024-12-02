//
//  ContentView.swift
//  JSONViewer
//
//  Created by Erik Flores on 30/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var rootNode: JSONNode?
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            if let rootNode = rootNode {
                ScrollView(.vertical) {
                    JSONNodeView(node: rootNode, searchText: searchText)
                        .padding()
                }
                .searchable(text: $searchText)
                .onChange(of: searchText, { _, newValue in
                    rootNode.updateVisibility(for: newValue)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarTitle("Visualizador de JSON", displayMode: .inline)
            } else {
                ProgressView("Cargando JSON...")
                    .onAppear {
                        if let loadedJSON = loadLocalJSON(fileName: "sample") {
                            self.rootNode = JSONNode(value: loadedJSON)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
