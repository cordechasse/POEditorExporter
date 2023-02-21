import ArgumentParser

@main
public struct POEditor : AsyncParsableCommand {
    
    public static let configuration = CommandConfiguration(
      abstract: "POEditor command-line tool",
      version: "2.0.0",
      subcommands: [
          FetchTranslationsCommand.self,
      ]
    )

    public init() {
    }
    
}
