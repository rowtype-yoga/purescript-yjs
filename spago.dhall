{ name = "yjs"
, dependencies =
  [ "console"
  , "effect"
  , "foreign"
  , "functions"
  , "newtype"
  , "prelude"
  , "web-dom"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
