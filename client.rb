require 'socket'
require 'thread'

$send_server="10.0.1.114"
$send_port="7780"

$recv_server="10.0.1.49"
$recv_port="7780"


$data_padding = ""

def precise_time
    Time.now.tv_sec * 1000000 + Time.now.tv_usec
end


def run_sender()
    $th1 = Thread.new do
      sender = UDPSocket.new
      while true
	$t0=precise_time
        sender.send(precise_time.to_s+$data_padding,0,$send_server,$send_port)
        sleep 0.1
      end
    end
end

def run_recv()
    $th2=Thread.new do
      rece = UDPSocket.new
      rece.bind("0.0.0.0",$recv_port);
      sender = UDPSocket.new
      count=0
      while true
        msg = rece.recvfrom(1000)
	t2 = precise_time.to_i
	msgs = msg[0].split(",")
	t0 = msgs[1].to_i
	t1 = msgs[0].to_i
        count += 1
	clock_diff_us = t1 - t0 - (t2 - t0) / 2
	puts "t0=#{t2}, sent=#{msg}, round_trip_latency=#{t2 - t1}us. single=#{t1 - t0}us; clocks skew=#{clock_diff_us/1000.0}ms" 
      end
    end
end


run_sender()
run_recv()

$th1.join
$th2.join
