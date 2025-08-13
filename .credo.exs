%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "web/", "apps/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Design.TagTODO, [exit_status: 0]},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 120},
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Refactor.Nesting, false},
        {Credo.Check.Refactor.PipeChainStart, false}
      ]
    }
  ]
}
