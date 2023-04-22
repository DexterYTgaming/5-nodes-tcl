# Create a simulator object
set ns [new Simulator]
 
# Define different colors for different data flows
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
 
# Open a trace file and define finish procedure set tf [open out.tr w]
$ns trace-all $tf proc finish {} {
global ns tf
$ns flush-trace close $tf
exit 0
}
 
# Create nodes set n1 [$ns node] set n2 [$ns node] set n3 [$ns node] set n4 [$ns node] set n5 [$ns node]
 
# Create links between nodes
$ns duplex-link $n1 $n2 1Mbps 10ms DropTail

$ns duplex-link $n2 $n3 1Mbps 10ms DropTail
$ns duplex-link $n3 $n4 1Mbps 10ms DropTail
$ns duplex-link $n4 $n2 1Mbps 10ms DropTail
$ns duplex-link $n2 $n5 1Mbps 10ms DropTail
 
# Set up TCP/FTP connections between nodes 1 and 3, and UDP/CBR at node 5
set ftp1 [new Application/FTP] set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
$ns attach-agent $n1 $ftp1
$ns connect $tcp1 $n2 0.5Mb
$tcp1 set class_ 2
$ftp1 attach-agent $tcp1
 
set ftp3 [new Application/FTP] set tcp3 [new Agent/TCP]
$ns attach-agent $n3 $tcp3
$ns attach-agent $n3 $ftp3
$ns connect $tcp3 $n2 0.5Mb
$tcp3 set class_ 2
$ftp3 attach-agent $tcp3
 
set cbr5 [new Application/Traffic/CBR] set udp5 [new Agent/UDP]
$ns attach-agent $n5 $udp5
$ns attach-agent $n5 $cbr5
$ns connect $udp5 $n2 0.5Mb
$cbr5 set class_ 3
$cbr5 attach-agent $udp5
$cbr5 set packetSize_ 1000
$cbr5 set interval_ 0.1

 
# Schedule events and run the simulation
$ns at 0.1 "$ftp1 start"
$ns at 0.2 "$ftp3 start"
$ns at 0.3 "$cbr5 start"
$ns at 10.0 "finish"
$ns run Answer - 2
# Create a simulator object set ns [new Simulator]
 
# Define different colors for different data flows
$ns color 1 Blue
$ns color 2 Red
 
# Open a nam trace file and define finish procedure then close the trace file, and execute nam on trace file
set nf [open out.nam w]
$ns namtrace-all $nf proc finish {} {
global ns nf
$ns flush-trace close $nf
exec nam out.nam & exit 0
}
 
# Create five nodes that forms a network numbered from 0 to 4 set n0 [$ns node]
set n1 [$ns node]

set n2 [$ns node] set n3 [$ns node] set n4 [$ns node]
 
# Create duplex links between the nodes and add Orientation to the nodes for setting a LAN topology
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n0 1Mb 10ms DropTail
$ns queue-limit $n0 $n1 50
$ns queue-limit $n1 $n2 50
$ns queue-limit $n2 $n3 50
$ns queue-limit $n3 $n4 50
$ns queue-limit $n4 $n0 50
 
# Setup TCP Connection between n(1) and n(3) set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink
 
# Apply CBR Traffic over TCP
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 1000
$cbr set interval_ 0.01
$cbr set random_ false
$cbr attach-agent $tcp
$ns at 0.1 "$cbr start"

# Schedule events and run the program
$ns at 10.0 "finish"
$ns run Answer - 3
# Create a new simulation object set ns [new Simulator]
 
# Set simulation time to 10 seconds set simtime 10.0
 
# Create nodes set n0 [$ns node] set n1 [$ns node] set n2 [$ns node] set n3 [$ns node] set n4 [$ns node]
 
# Create links between nodes
$ns duplex-link $n0 $n4 5Mbps 2ms DropTail
$ns duplex-link $n4 $n3 5Mbps 2ms DropTail
$ns duplex-link $n1 $n4 1Mbps 10ms DropTail
$ns duplex-link $n2 $n4 1Mbps 10ms DropTail
 
# Set queue size for links
$ns queue-limit $n0 $n4 10
$ns queue-limit $n4 $n3 10
$ns queue-limit $n1 $n4 10
$ns queue-limit $n2 $n4 10
 
# Install the internet protocol stack on all nodes

$ns rtproto Static
$ns install-queue DropTail
 
# Assign IP addresses to nodes
$ns node-config -addressType hierarchical
$ns addr $n0 10.1.1.1
$ns addr $n4 10.1.1.2
$ns addr $n3 10.1.1.3
$ns addr $n1 10.1.2.1
$ns addr $n2 10.1.2.2
 
# Create a TCP source at n0 sending packets to n3 through n4 set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set packetSize_ 1000
$tcp set maxpkts_ 10000 set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 0.1 "$ftp start"
$ns at $simtime "$ftp stop"
 
# Create a UDP source at n1 sending packets to n2 through n4 set udp [new Agent/UDP]
$ns attach-agent $n1 $udp set null [new Agent/Null]
$ns attach-agent $n2 $null
$ns connect $udp $null
$udp set packetSize_ 1000

$udp set rate_ 1Mbps
$udp set maxpkts_ 10000
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set interval_ 0.01
$cbr set random_ false
$cbr set maxpkts_ 10000
$ns at 0.2 "$cbr start"
$ns at $simtime "$cbr stop"
 
# Set trace output file name set traceFile [open out.tr w]
$ns trace-all $traceFile
 
# Run simulation
$ns run

