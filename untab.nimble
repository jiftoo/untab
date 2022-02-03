# Package

version       = "1.0.0"
author        = "Dan Kov"
description   = "Replace tabs with spaces"
license       = "MIT"
srcDir        = "src"
bin           = @["untab"]
skipFiles     = @["test1.nim"]

# Dependencies

requires "nim >= 1.6.2"
requires "fusion"
requires "result"

from system/io import readFile
task make, "Build project":
    exec "nim c  --outDir:build src/untab.nim"
    withDir "build":
        echo "Stripping"
        let kbBeforeStrip = float(readFile("untab.exe").len) / 1024.0
        exec "strip untab.exe"
        echo $kbBeforeStrip & " -> " & $(float(readFile("untab.exe").len) / 1024.0)
