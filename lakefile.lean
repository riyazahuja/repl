import Lake
open Lake DSL

package REPL {
  -- add package configuration options here
}

lean_lib REPL {
  -- add library configuration options here
}

require mathlib from git
    "https://github.com/leanprover-community/mathlib4.git" @ "v4.9.0"

@[default_target]
lean_exe repl where
  root := `REPL.Main
  supportInterpreter := true
