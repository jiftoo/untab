import unittest
import results
import untab
import os
import strutils

test "always pass":
    check true

test "open file":
    let result = openFileCase("tests/blank.txt")
    check result.isOk

test "open directory":
    let result = openFileCase("tests")
    check result.error == "tests is a directory"

test "open a nonexisting file":
    let result = openFileCase("idontexist")
    check result.error == "idontexist does not exist"

# const filepath = "tests/tmp.txt"
# test "process a file":
#     writeFile(filepath, "\t\t")
#     test1param(filepath)
#     check readFile(filepath) == " ".repeat(2 * 4)

# test "process a file with custom space number":
#     writeFile(filepath, "\t\t")
#     test2param(filepath, 12)
#     check readFile(filepath) == " ".repeat(2 * 12)

# test "process a file with custom space number and output file":
#     let customout = "tests/out.txt"
#     writeFile(filepath, "\t\t")
#     test3param(filepath, 2, customout)
#     check readFile(customout) == " ".repeat(8)
