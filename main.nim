import options
import std/os
import results
import strutils
import std/strformat
import fusion/matching

{.experimental: "caseStmtMacros".}

let eprint = proc (s: string) = stderr.writeLine(s)

proc openFileCase(path: string): Result[File, string] =
    let filename = splitPath(path).tail
    if fileExists(path):
        ok open(path, FileMode.fmReadWriteExisting)
    elif dirExists(path):
        err(filename & " is a directory")
    else:
        err(filename & " does not exist")


proc main(path: string, output: Option[string], spaces: Natural) =
    let result = openFileCase(path)
    if not result.isOk:
        echo result.error
    else:
        let file = result[]
        let contents = file.readAll
        var newContents = newString contents.len

        var replaced = 0;
        var i = 0
        for char in contents:
            if char == '\t':
                inc replaced
                newContents &= ' '.repeat 4
            else:
                newContents &= char
            inc i

        if replaced != 0:
            let (head, tail) = splitPath(path)
            let filename = case output:
                of Some(@str): str
                else: tail
            debugEcho "Writing to: " & joinPath(head, filename)
            writeFile(joinPath(head, filename), newContents)

        echo "replaced " & $replaced & " characters."


# parse arguments
# defaults
let usage = fmt"""usage: {splitPath(getAppFilename()).tail} <file> [spaces per tab] [output file]"""

let args = commandLineParams()
var infile = 
    try: args[0]
    except:
        echo usage
        quit(0)
var spaces: Natural =
    try: args[1].parseInt()
    except: 4
var outfile =
    try: some(args[2])
    except: none(string)

case paramCount():
of 1..3: main(infile, outfile, spaces)
else: eprint("Too many arguments"); echo usage
