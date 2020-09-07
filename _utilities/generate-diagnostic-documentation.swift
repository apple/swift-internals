#!/usr/bin/swift
/// This script can be used to regenerate the diagnostic documentation for swift-internals
/// based on the content of the userdocs/diagnostics folder in the main Swift repository.
import Foundation

guard CommandLine.arguments.count == 2 else {
	print("Must pass the path to the userdocs/diagnostics folder in the main Swift repo.")
	exit(1)
}
let docsPath = URL(fileURLWithPath: CommandLine.arguments[1])
let outputPath: URL = {
	var url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
	while url.lastPathComponent != "swift-internals" {
		url.deleteLastPathComponent()
		if url.path.isEmpty {
			print("Tool must be run from inside the swift-internals repository.")
			exit(1)
		}
	}
	return url.appendingPathComponent("diagnostic-documentation")
}()

print(outputPath)

for educationalNote in try FileManager.default.contentsOfDirectory(at: docsPath, includingPropertiesForKeys: nil) {
	guard educationalNote.pathExtension == "md" else { continue }
	print("Generating documentation from \(educationalNote.path)")
	let contents = try String(contentsOf: educationalNote, encoding: .utf8)
	let lines = contents.split(separator: "\n")
	let sitePathComponent = educationalNote.deletingPathExtension().lastPathComponent
	let title = lines.first!.trimmingCharacters(in: .init(charactersIn: " #"))
	let docContents = """
	---
	layout: page
	title: "\(title)"
	official_url: https://swift.org/documentation/diagnostic-documentation/\(sitePathComponent)/
	redirect_from: /documentation/diagnostic-documentation/\(sitePathComponent).html
	is_diagnostic_documentation: true
	---
	\(lines.dropFirst().joined(separator: "\n"))
	"""
	try docContents.write(to: outputPath.appendingPathComponent(educationalNote.lastPathComponent), atomically: false, encoding: .utf8)
}
