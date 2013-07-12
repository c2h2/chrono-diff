require 'socket'
require 'thread'

$recv_server="10.0.1.49"
$recv_port="7780"


def precise_time
  Time.now.tv_sec * 1000000 + Time.now.tv_usec
end

def run_recv
   $th2= Thread.new do
     sender = UDPSocket.new
     recv = UDPSocket.new
     puts "receive on port: #{$recv_port}"
     recv.bind("0.0.0.0",$recv_port);
     puts "bind success: #{$recv_port}"
     count=0
     while true
       	msg = recv.recvfrom(1000)
    	t1 = precise_time
	sender.send("#{t1},#{msg[0]}",0,$recv_server,$recv_port)
        t0 = msg[0].to_i
        count+=1
        puts "send back: #{$recv_server} #{$recv_port}, client msg=#{msg[0]}, t1-t0=#{(t1 - t0)/1000.0}ms." #if count % 100 == 0
     end
   end
end

run_recv
$th2.join
