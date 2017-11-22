#!/usr/bin/ruby

require 'thwait'
require 'socket'
require 'timeout'

ip = ARGV[0]
threads = []
sum = 0

puts ""
puts "Tool by Jonathan Burgos Saldivia >"
puts ""
p1, p2 , p3 , p4 , p5, p6, p7, p8, p9, p10, p11, p12, p13 = [[ 20, "FTP-data" ], [ 21, "FTP"], [ 22, "SSH"], [ 23, "TELNET"], 
[ 24, "Private Mail System" ], [ 25,"SMTP" ], [ 53, "DNS" ], [ 80, "WWW-HTTP" ], [ 110, "POP3" ], [ 135, "EPMAP" ], [ 137, "NETBIOS-NS" ], [ 443, "HTTPS" ], [ 3389, "RDP" ]]
puertos = [p1, p2 , p3 , p4 , p5, p6, p7, p8, p9, p10, p11, p12, p13]

for p in puertos
	begin
		Timeout::timeout(1){TCPSocket.new(ip, p[0])}
	rescue
		next
	else
		print "[+] Host #{ip} | Open port #{p[0]}\t| Service #{p[1]}\n"
		sum+= 1
	end
end

puts ""
puts "[!] Done! | Target: #{ip} | Total open ports: #{sum}."