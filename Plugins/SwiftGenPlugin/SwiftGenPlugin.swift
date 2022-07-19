import Foundation
import PackagePlugin

@main
struct SwiftGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let tool = try context.tool(named: "swiftgen")
        
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        guard let swiftgenConfig = (target.sourceFiles.first { $0.path.lastComponent == "swiftgen.yml" }) else {
            throw Error.missingSwiftGenConfig
        }
        
        return [
            .buildCommand(
                displayName: "run swiftgen from plugin",
                executable: tool.path,
                arguments: CommandLine.arguments,
                inputFiles: [swiftgenConfig.path]
            )
        ]
    }
    
    enum Error: Swift.Error {
        case missingSwiftGenConfig
    }
}
