import REPL.Frontend
import REPL.Lean.InfoTree.ToJson
-- import REPL.TreeParser
-- import Mathlib.Data.String.Defs
-- import Mathlib.Lean.CoreM
-- import Batteries.Lean.Util.Path
-- import Batteries.Data.String.Basic
-- import Mathlib.Tactic.Change
-- import ImportGraph.RequiredModules
import REPL.Util.Range
open Lean Elab Term Command Frontend Parser

open Lean Elab IO Meta
open System


def DeclIdMap := HashMap String (List Json)

def addToMap (map : DeclIdMap) (declId : String) (jsonObj : Json) : DeclIdMap :=
  match map.find? declId with
  | some jsonList => map.insert declId (jsonObj :: jsonList)
  | none => map.insert declId [jsonObj]

def groupByDecl (idJsons : List (String × Json)) : IO DeclIdMap := do
  let mut map : DeclIdMap := HashMap.empty
  for ⟨declId, json⟩ in idJsons do
    map := addToMap map declId json
  return map

def mapToJson (map : DeclIdMap) : List Json :=
  let entries := map.toList
  let jsonEntries : List Json := entries.map fun (declId, jsonList) =>
    Json.mkObj [
      ("declId", declId),
      ("tacticExamples", Json.arr jsonList.toArray)
    ]
  jsonEntries

def findCommandInfo (t : InfoTree) : List (CommandInfo × ContextInfo) :=
  let infos := t.findAllInfo none fun i => match i with
    | .ofCommandInfo _ => true
    | _ => false
  infos.filterMap fun p => match p with
  | (.ofCommandInfo i, some ctx) => (i, ctx)
  | _ => none

def ppCommandInfo (info : CommandInfo) : String :=
  info.stx.prettyPrint.pretty


def ppDeclWithoutProof (info: CommandInfo) : IO String := do
    let ppDecl := ppCommandInfo info
    let decl := (ppDecl.splitOn ":=").headD ""
    return decl


def ElabDeclInfo := (Range × CommandInfo)

def getElabDeclInfo (trees : List InfoTree) : IO (List (ElabDeclInfo × InfoTree)) := do
    let mut out  := []
    for tree in trees do
      let infos := findCommandInfo tree
      for ⟨cmdInfo, ctxInfo⟩ in infos do
        out := ((FileMap.stxRange ctxInfo.fileMap cmdInfo.stx, cmdInfo), tree) :: out
    return out
