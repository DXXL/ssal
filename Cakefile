# Inspired by http://productive.me/blog/cakefile-to-combinecompile-and-minify-sets-of-coffeescript-files

input = ['ssal']

fs = require 'fs'
{exec} = require 'child_process'

option '-o', '--output [PATH]', 'Output path'
option '-n', '--name [PATH]', 'Output file name'
task 'build', 'Build single application file from source files', (options) ->
    compile = (out, appFiles) ->
        appContents = new Array remaining = appFiles.length
        for file, index in appFiles then do (file, index) ->
            fileContents = fs.readFileSync "#{file}.coffee", 'utf8'
            appContents[index] = fileContents
            process out, appContents if --remaining is 0

    process = (out, appContents) ->
        fs.writeFileSync "#{out}.raw.coffee", appContents.join('\n\n'), 'utf8'
        exec "coffee --compile #{out}.raw.coffee", (err, stdout, stderr) ->
            if err
                throw err
                console.log stdout + stderr
            fs.unlink "#{out}.raw.coffee", (err) ->
                throw err if err
            exec "uglifyjs -o #{out}.min.js #{out}.raw.js", (err, stdout, stderr) ->
                if err
                    throw err
                    console.log stdout + stderr
                fs.unlink "#{out}.raw.js", (err) ->
                    throw err if err
                    console.log "#{out}.min.js compiled and minified."

    output = options['output'] + '/' + options['name']
    compile output, input
