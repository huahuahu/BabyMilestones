import ArgumentParser

struct DevTools: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "devtools",
    abstract: "BabyMilestones development toolbox",
    subcommands: [Lint.self, Env.self],
    defaultSubcommand: Lint.self
  )
}

DevTools.main()
