import Foundation

func organizeFilesByExtension(in folderPath: String) throws {
    let fileManager = FileManager.default
    let folderURL = URL(fileURLWithPath: folderPath)
    let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
    
    for fileURL in contents {
        // Skip directories and hidden files
        guard fileManager.fileExists(atPath: fileURL.path) && !fileURL.hasDirectoryPath,
              fileURL.lastPathComponent.first != "." else { continue }
        
        let ext = fileURL.pathExtension.isEmpty ? "unknown" : fileURL.pathExtension
        let targetFolderURL = folderURL.appendingPathComponent(ext)
        try fileManager.createDirectory(at: targetFolderURL, withIntermediateDirectories: true, attributes: nil)
        let targetFileURL = targetFolderURL.appendingPathComponent(fileURL.lastPathComponent)
        
        // Move the file
        try fileManager.moveItem(at: fileURL, to: targetFileURL)
        print("Moved: \(fileURL.lastPathComponent) → \(ext)/")
    }
    print("Files organized by extension!")
}

do {
    let args = CommandLine.arguments
    let folderPath = args.count > 1 ? args[1] : "../messy-files"
    try organizeFilesByExtension(in: folderPath)
} catch {
    print("Error: \(error)")
}
