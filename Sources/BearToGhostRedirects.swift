import ArgumentParser
import Foundation
import SwiftCSV
import Yams

extension FileHandle: @retroactive TextOutputStream {
    public func write(_ string: String) {
        let data = Data(string.utf8)
        self.write(data)
    }
}

struct Redirects {
    var permanent: Dictionary<String, String> = [:]

    var temporary: Dictionary<String, String> = [:]
}

extension Redirects: Codable {
    enum CodingKeys: String, CodingKey {
        case permanent = "301"
        case temporary = "302"
    }
}

@main
struct BearToGhostRedirects: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(abstract: "Convert aliases from an export from bearblog.dev to the Ghost redirect format.")

    @Argument(help: "The path to the source file to read Bear aliases from.")
    var source: String

    mutating func run() throws {
        var stderr: FileHandle = FileHandle.standardError

        do {
            if !FileManager.default.fileExists(atPath: source) {
                print("Source file does not exist at path: \(source)", to: &stderr)

                throw ExitCode.failure
            }

            let csvFile: CSV = try CSV<Named>(url: URL(fileURLWithPath: source))

            var redirects: Redirects = Redirects()

            try csvFile.enumerateAsDict { row in
                if let alias = row["alias"], let slug = row["slug"], !alias.isEmpty, !slug.isEmpty {
                    redirects.permanent["/\(alias)"] = "/\(slug)"
                }
            }

            let encoder: YAMLEncoder = YAMLEncoder()
            let encodedYAML: String = try encoder.encode(redirects)

            print(encodedYAML)
        } catch let exitCode as ExitCode {
            throw exitCode
        } catch let parseError as CSVParseError {
            print("Error parsing CSV export from Bear: \(parseError)", to: &stderr)

            throw ExitCode.failure
        } catch {
            print("Error loading file: \(error)", to: &stderr)

            throw ExitCode.failure
        }
    }
}
