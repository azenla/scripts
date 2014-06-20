#!/usr/bin/env groovy

def file = new File(args[0])

def execute = { String cmdline, File inside = new File(".") ->
    def b = new ProcessBuilder(cmdline.split(" "))
    b.directory(inside)
    b.inheritIO()
    def returned = b.start().waitFor()
    if (returned != 0) {
        System.exit(returned)
    }
}

def currentDir = new File(".")

file.eachLine { line ->
    (url, directory) = line.split(" => ")
    execute("git init ${directory}")
    execute("hg clone ${url} tmp/")
    execute("hg-fast-export --force -r ${new File(currentDir, "tmp")}", new File(directory))
}