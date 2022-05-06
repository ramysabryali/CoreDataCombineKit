//
//  FileManager.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 03/05/2022.
//

import Foundation

final class FileManager {
    static let shared: FileManager = .init()
    
    private init() { }
    
    func getFile(
        _ fileName: String,
        withExtension fileExtension: FileExtension,
        from bundle: Bundle = Bundle.main
    ) -> URL? {
        bundle.url(
            forResource: fileName,
            withExtension: fileExtension.rawValue
        )
    }
}

extension FileManager {
    enum FileExtension: String {
        case careData = "momd"
    }
}
