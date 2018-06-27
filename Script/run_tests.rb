#!/usr/local/bin/ruby -w
Dir.chdir '..'

command = "set -o pipefail && xcodebuild test -scheme MazeKit -destination 'name=iPhone X' | xcpretty"
exec command
