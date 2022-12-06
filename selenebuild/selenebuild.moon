-- Selene Build Script
require("lfs")

ERR = 1
OK = 0

class DirectoryTraversal 
    new: (func) =>
        -- Instantiate a new DirectoryTraversal that will apply a function to file paths
        -- recursively

        @func = func

    traverse: (path) =>
        -- Traverse a directory recursively and apply a function to files found

        traverse_stack = [ "#{path}/#{entry}" for entry in lfs.dir(path) ]
        seen = {}
        rv = OK

        while #traverse_stack > 0
            entry = table.remove(traverse_stack)

            filename = entry\match("([^/]+)$")

            -- Skip builtin traversals
            if filename == "." or filename == ".."                
                continue

            -- If we have seen this entry before, skip it
            if #[e for _, e in ipairs seen when e == entry] != 0
                continue


            table.insert(seen, entry)

            -- Recurse on directories and call the callback on files
            if lfs.attributes(entry, "mode") == "directory"
                for sentry in lfs.dir(entry)
                    table.insert(traverse_stack, "#{entry}/#{sentry}")
            else
                    if not @func(entry)
                        rv = ERR

        return rv

class SeleneBuild
    new: (src) =>
        -- Instantiate a new build of the directory
        -- given in src

        @src = src

    build_file: (path) =>
        -- Build a .moon file. Called as a callback by the
        -- directory traversal. Returns OK on success, ERR on failure
        rv = OK
        if path\match("^.+%.moon$")
            fd = io.popen("moonc #{path}")
            output = fd\read("*a")

            status = fd\close()
            if not status 
                print "Error building #{path}"
                print output
                rv = ERR
        return rv

    clean_file: (path) =>
        -- Clean a .lua file. Called as a callback by the
        -- directory traversal. Returns OK on success, and cannot fail
        if path\match("^.+%.lua$")
            os.remove(path)
            print "Removed #{path}"

        return OK

    dist_file: (path) =>
        -- Clean a .moon file. Called as a callback by the
        -- directory traversal. Returns OK on success, and cannot fail

        if path\match("^.+%.moon$")
            os.remove(path)
            print "Removed #{path}"

        return OK

    build: () =>
        -- Run the build. Returns the status of the build

        traversal = DirectoryTraversal(@build_file)
        return traversal\traverse(@src)

    clean: () =>
        -- Clean the source directory of build files. Returns the status of the clean

        traversal = DirectoryTraversal(@clean_file)
        return traversal\traverse(@src)

    dist: (yes) =>
        -- Build for distribution by building lua files and removing moonscript files.

        rv = OK

        -- Prompt for y/n, this is a dangerous operation

        git_status = io.popen("git status -s")
        if git_status\read("*a") != "" and not yes
            print "Git tree is dirty. Commit your changes or use the --yes flag"
            rv = ERR
        git_status\close()

        rv = @\build!

        if rv == ERR
            print "Build errors occured. Aborting."
            return rv


        if yes
            answer = "y"
        else
            io.write "Building distribution. Are you want to remove all moonscript files? (y/n) "
            answer = io.read()

        if answer == "y" or yes
            traversal = DirectoryTraversal(@dist_file)
            rv = traversal\traverse(@src)

            conffile = io.open("conf.lua", "r")
            conf = conffile\read("*a")
            conffile\close()
            conf\gsub("require(\"lib.moonscript\")", "")
            confi\gsub("package.path.*$", "")
            conffile = io.open("conf.lua", "w")
            conffile\write(conf)
            conffile\close()
        else
            print "Aborting: '#{answer}' is not y"
            rv = ERR
        
        return rv

    test: (patterns) =>
        rv = OK
        for _, pattern in ipairs patterns
            print("Running tests with pattern #{pattern}")
            result = io.popen("busted -p #{pattern} #{@src}")
            output = result\read("*a")
            status = result\close!
            if not status
                rv = ERR
                print(output)

        if rv == ERR
            print("Tests failed")
        else
            print("All tests passed")

        return rv


main = (arg) ->
    -- Create and run the build
    argparse = require("argparse")
    parser = argparse("selenebuild", "Build a Selene project")
    parser\argument("src", "Source directory")
    parser\flag("-c --clean", "Clean the build directory (remove lua build files)")\args("?")
    parser\flag("-d --dist", "Build a distribution and remove all moonscript files after building")\args("?")
    parser\flag("-y --yes", "Answer yes to all prompts. THIS MAY BE DANGEROUS!")\args("?")
    parser\flag("-t --test", "Run tests")\args("?")
    parser\option("-p --pattern", "Pattern(s) to use to search for test files")\args("+")\default("Test.+%.moon")\defmode("u")
    args = parser\parse(arg)

    if #arg < 1
        print "Usage: selene <srcdir>"
        return

    build = SeleneBuild(args["src"])

    rv = OK

    if args["test"]
        rv = build\test(args["pattern"])
    elseif args["clean"]
        rv = build\clean!
    elseif args["dist"]
        rv = build\dist(args["yes"])
    else
        rv = build\build!

    return rv

os.exit(main(arg))