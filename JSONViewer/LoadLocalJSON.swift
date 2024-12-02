//
//  LoadLocalJSON.swift
//  JSONViewer
//
//  Created by Erik Flores on 1/12/24.
//

import Foundation

func loadLocalJSON(fileName: String) -> Any? {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return nil }
    let url = URL(fileURLWithPath: path)
    do {
        let data = try Data(contentsOf: url)
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    } catch {
        print("Error al cargar JSON: \(error)")
        return nil
    }
}
