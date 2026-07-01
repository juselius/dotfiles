return {
  cmd = {
    "fsautocomplete",
    "--adaptive-lsp-server-enabled",
    "--project-graph-enabled",
    "--use-fcs-transparent-compiler",
  },
  filetypes = { "fsharp" },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
  root_markers = { { "*.sln", "*.slnx", "*.fsproj", ".git" } },
  cmd_env = {
    FCS_ParallelReferenceResolution = "true",
    DOTNET_GCServer = "1",
    DOTNET_GCHeapCount = "c",
  },
  -- this recommended settings values taken from  https://github.com/ionide/FsAutoComplete?tab=readme-ov-file#settings
  -- Taken from neovim/nvim-lspconfig
  settings = {
    FSharp = {
      keywordsAutocomplete = true,
      ExternalAutocomplete = false,
      Linter = true,
      UnionCaseStubGeneration = true,
      UnionCaseStubGenerationBody = 'failwith "Not Implemented"',
      RecordStubGeneration = true,
      RecordStubGenerationBody = 'failwith "Not Implemented"',
      InterfaceStubGeneration = true,
      InterfaceStubGenerationObjectIdentifier = 'this',
      InterfaceStubGenerationMethodBody = 'failwith "Not Implemented"',
      UnusedOpensAnalyzer = true,
      UnusedDeclarationsAnalyzer = true,
      UseSdkScripts = true,
      SimplifyNameAnalyzer = true,
      ResolveNamespaces = true,
      EnableReferenceCodeLens = true,
      TooltipShowDocumentationLink = false,
    },
  },
}
