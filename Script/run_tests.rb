#!/usr/local/bin/ruby -w

scheme = 'MazeKit'
destination_name = 'iPhone 6'

command = "set -o pipefail && xcodebuild -toolchain swift -scheme #{scheme} -destination 'name=#{destination_name}' test | xcpretty"
exec command
