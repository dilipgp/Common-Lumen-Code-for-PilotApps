#!/usr/bin/expect -f
set timeout -1
set passcode [lindex $argv 0]
set server [lindex $argv 1]
set user [lindex $argv 2]
set ctrl_socket [lindex $argv 3]

puts "Passcode: $passcode"
puts "Server: $server"
puts "User: $user"

if { $passcode == "" || $server == "" || $user == "" } {
    puts "Error: passcode, server, and user must not be empty."
    exit 1
}
if {[file exists $ctrl_socket]} {
    file delete -force $ctrl_socket
}

spawn ssh -M -S "$ctrl_socket" -o PreferredAuthentications=keyboard-interactive -o KbdInteractiveAuthentication=yes -f -N "$user@$server"
expect -re ".*PASSCODE:"
send -- "$passcode\r"
expect eof
