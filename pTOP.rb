#!/usr/bin/ruby

require 'benchmark'
require 'optparse'
require 'socket'
require 'timeout'

def pTOP
	options = {}
	OptionParser.new { |opts|
		opts.banner = "\n Usage: ruby pTOP.rb [options] [arguments...]\n\n"+
		" Example: ruby pTOP.rb -u http://www.example.com -t 1"
		opts.separator ""
		opts.version = "0.1"
		opts.on('-u', '--url URL', 'URL or ip of target to scan.') { |url|
			options[:url] = url;}
		opts.on('-t', '--timeout nSECONDS', "Wait n seconds for ping timeout, default value is 3.\n\n") { |timeout|
			options[:timeout] = timeout;}
		begin
			opts.parse!
		rescue OptionParser::ParseError => error
			print "\n [!] #{error}\n [!] -h or --help to show valid options.\n\n"
			exit 1
		end
	}

	timeout = options[:timeout].to_i
	timeout = 3 if timeout == 0

	url = options[:url]
	if url == nil
		print "\n [!] -h or --help to show valid options.\n\n"
		exit 1
	end

	@ip = url
	hilos = []
	levantados = []
	caidos = []
	@sum = 0

	if @ip == nil
		print "\n [!] Usage example: ruby pTOP 192.168.0.1 \n\n"
		exit 1
	end

	print "\n Tool by Jonathan Burgos Saldivia >\n\n"

	puertos = { 20 => "FTP-data" ,  21 => "FTP" ,  22 => "SSH" ,  23 => "TELNET" ,  24 => "Private Mail System" , 
		25 => "SMTP" ,  53 => "DNS" ,  80 => "WWW-HTTP" , 110 => "POP3" ,  135 => "EPMAP" , 
		137 => "NETBIOS-NS" ,  443 => "HTTPS" ,  3389 => "RDP" }

	puertos.keys.each { |p|
		hilos << Thread.new(p) { |p|
			begin
				Timeout::timeout(timeout){TCPSocket.new(@ip, p)}
			rescue
				caidos << p
			else
				levantados << p
				@sum+= 1
			end
		}
	}

	hilos.each { |a| a.join}
	totalopen = levantados.count
	totalclose = caidos.count
	puts " PORT".ljust(8) + "STATE".ljust(8) +"SERVICE".ljust(23) if totalopen > 0 || totalclose > 0 
	open = levantados.sort
	open.each { |o| puts " #{o}".ljust(8) +"open".ljust(8) + "#{puertos[o]}".downcase }
	close = caidos.sort
	close.each { |o| puts " #{o}".ljust(8) +"close".ljust(8) + "#{puertos[o]}".downcase  }
	end
tiempo = Benchmark.realtime {pTOP}
crd = 13-@sum
print "\n 13 scanned ports in: #{tiempo.round(2)} seconds | #{@sum} open | #{crd} close | on #{@ip}.\n\n"