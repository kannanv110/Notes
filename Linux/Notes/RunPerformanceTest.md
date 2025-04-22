## CPU Load Testing
**stress:** A tool that generates a specified amount of load on the CPU.

*Example:* stress -c 4 -t 60 (generates load on 4 CPUs for 60 seconds)

**sysbench:** A tool that generates a specified amount of load on the CPU.

*Example:* sysbench --test=cpu --cpu-max-prime=10000 run (generates load on the CPU)

**cpuburn:** A tool that generates a high load on the CPU.

*Example:* cpuburn -t 60 (generates high load on the CPU for 60 seconds)

## Memory Load Testing

**stress:** Can also generate load on memory.

*Example:* stress -m 4 -t 60 (generates load on 4GB of memory for 60 seconds)

**memtester:** A tool that tests memory by generating a specified amount of load.

*Example:* memtester 1024M 10 (tests 1GB of memory for 10 iterations)

## Disk I/O Load Testing

**fio:** A tool that generates a specified amount of load on disk I/O.

*Example:* fio -name=randwrite -ioengine=libaio -bs=4k -size=1G -numjobs=4 -runtime=60 (generates load on disk I/O)

**dd:** A tool that generates a specified amount of load on disk I/O.

*Example:* dd if=/dev/zero of=/dev/null bs=1M count=1000 (generates load on disk I/O)

## Network Load Testing

**iperf:** A tool that generates a specified amount of load on network bandwidth.

*Example:* iperf -c <server_IP> -t 60 (generates load on network bandwidth)

**netperf:** A tool that generates a specified amount of load on network bandwidth.

*Example:* netperf -H <server_IP> -t TCP_STREAM -l 60 (generates load on network bandwidth)

## Monitoring Load

**top:** A tool that displays real-time information about running processes and system load.

**htop:** A tool that displays real-time information about running processes and system load.

**mpstat:** A tool that displays CPU utilization statistics.

**vmstat:** A tool that displays virtual memory statistics.

**iostat:** A tool that displays disk I/O statistics.