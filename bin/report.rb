#!/usr/bin/env ruby

require 'report'

if ARGV.count == 0
    $stderr.puts "please put in a command: start or stop"
    exit 1
end

unless ['start', 'stop'].include?(ARGV[0])
    $stderr.puts "command must be start or stop"
    exit 1
end

command = ARGV[0]
tmp_file = '/tmp/projalytics-report.pid'

if command == 'start'
    Process.daemon(true, true)

    pid = Process.pid
    File.open(tmp_file, 'w') {|f| f.write(pid)}

    app = Report::App.new
    app.listen
else
    unless File.exists?(tmp_file)
        $stderr.puts "no running process detected. Pid file does not exist"
    end

    pid = File.read(tmp_file)

    Process.kill('TERM', pid.to_i)
    File.delete(tmp_file)
end

