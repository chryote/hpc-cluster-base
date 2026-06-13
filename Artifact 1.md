[e1000 bug]

Running text parsing using synthetic file
    vagrant@master:/mnt/slurm_shared$ ls
    data  fastq_parser  generate_synthetic_file.sh  submit_local_job.sh
    vagrant@master:/mnt/slurm_shared$ nano submit_local_job.sh
    vagrant@master:/mnt/slurm_shared$ sbatch -N 2 submit_local_job.sh
    Submitted batch job 1

1. Node Drain
vagrant@master:/mnt/slurm_shared$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug*       up   infinite      1  drain worker1
debug*       up   infinite      1   idle worker

2. Check dmesg
vagrant@master:/mnt/slurm_shared$ sudo dmesg | grep -iE 'eth|enp|link|drop|tx|rx|fail'
[    1.307738] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    1.323502] audit: initializing netlink subsys (disabled)
[    1.688319] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    2.104795] ACPI: PCI: Interrupt link LNKA configured for IRQ 11
[    2.113100] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[    2.123957] ACPI: PCI: Interrupt link LNKC configured for IRQ 9
[    2.132061] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[    6.489019] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.359691] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 08:00:27:8d:c0:4d
[    7.368340] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    8.602121] e1000 0000:00:08.0 eth1: (PCI:33MHz:32-bit) 08:00:27:10:06:cc
[    8.610470] e1000 0000:00:08.0 eth1: Intel(R) PRO/1000 Network Connection
[   13.581009] [drm:vmw_host_printf [vmwgfx]] *ERROR* Failed to send host log message.
[   14.360109] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   14.369979] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   33.069575] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   33.069916] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   41.958286] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   41.970237] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

3. Check dmesg (really edge case!)
vagrant@master:/vagrant$ sudo dmesg | tail -n 60
[10108.257368]  watchdog_timer_fn+0x1a4/0x200
[10108.257371]  ? lockup_detector_update_enable+0x50/0x50
[10108.257374]  __hrtimer_run_queues+0x10f/0x2b0
[10108.257378]  hrtimer_interrupt+0xf4/0x210
[10108.257382]  __sysvec_apic_timer_interrupt+0x5a/0x110
[10108.257386]  sysvec_apic_timer_interrupt+0x69/0x90
[10108.257390]  </IRQ>
[10108.257390]  <TASK>
[10108.257391]  asm_sysvec_apic_timer_interrupt+0x16/0x20
[10108.257395] RIP: 0010:native_safe_halt+0xb/0x10
[10108.257399] Code: 80 48 02 20 48 8b 00 a8 08 75 c0 e9 7c ff ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d c9 50 5c 00 fb f4 <c3> cc cc cc cc eb 07 0f 00 2d b9 50 5c 00 f4 c3 cc cc cc cc cc 0f
[10108.257401] RSP: 0018:ffffffff97803e90 EFLAGS: 00010202
[10108.257403] RAX: ffffffff968444d0 RBX: ffffffff9781aa40 RCX: ffff8dc146999d60
[10108.257405] RDX: 4000000000000000 RSI: 0000000000000000 RDI: 0000000000a13e14
[10108.257406] RBP: 0000000000000000 R08: 00000cd0586319b3 R09: 0000000000000000
[10108.257407] R10: 00000000fffffffb R11: 0000000000000000 R12: 0000000000000000
[10108.257408] R13: 0000000000000000 R14: ffffffff9781a120 R15: 000000000008a000
[10108.257410]  ? __sched_text_end+0x6/0x6
[10108.257415]  default_idle+0xa/0x10
[10108.257419]  default_idle_call+0x38/0xf0
[10108.257420]  do_idle+0x21b/0x2a0
[10108.257424]  cpu_startup_entry+0x26/0x30
[10108.257428]  rest_init+0xca/0xd0
[10108.257432]  arch_call_rest_init+0xa/0x14
[10108.257436]  start_kernel+0x70a/0x733
[10108.257440]  secondary_startup_64_no_verify+0xe5/0xeb
[10108.257445]  </TASK>
[10108.258107] CPU: 1 PID: 57229 Comm: go Not tainted 6.1.0-29-amd64 #1  Debian 6.1.123-1
[10108.258282]  ? __sysvec_apic_timer_interrupt+0x5a/0x110
[10108.258877] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[10108.259442]  ? sysvec_apic_timer_interrupt+0x69/0x90
[10108.259971] RIP: 0033:0x40d513
[10108.259980] Code: b3 8a 05 00 48 8b 44 24 08 eb cc cc cc cc cc cc cc cc cc cc cc cc cc 49 3b 66 10 0f 86 82 00 00 00 48 83 ec 18 48 89 6c 24 10 <48> 8d 6c 24 10 31 c9 87 08 0f 1f 40 00 85 c9 74 56 83 f9 02 75 0a
[10108.259984] RSP: 002b:000000c000049770 EFLAGS: 00010202
[10108.260516]  </IRQ>
[10108.260518]  <TASK>
[10108.260520]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20

[10108.261693]  ? __sched_text_end+0x6/0x6
[10108.262188] RAX: 0000000000e3b160 RBX: 000000c00004c800 RCX: 0000000080000001
[10108.262721]  ? native_safe_halt+0xb/0x10
[10108.263738] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
[10108.264245]  default_idle+0xa/0x10
[10108.264778] RBP: 000000c0000497b8 R08: 0000000000000034 R09: 0000000000000030
[10108.265283]  default_idle_call+0x38/0xf0
[10108.265777] R10: 0000000000001018 R11: 000080c0004cbfff R12: 00007f8f86a81ce0
[10108.266272]  do_idle+0x21b/0x2a0
[10108.266802] R13: 0000000000000003 R14: 000000c000007040 R15: 0000000000def9c0
[10108.266807] FS:  00007f8f86a826c0 GS:  0000000000000000
[10108.333500]  cpu_startup_entry+0x26/0x30
[10108.333970]  rest_init+0xca/0xd0
[10108.334428]  arch_call_rest_init+0xa/0x14
[10108.334890]  start_kernel+0x70a/0x733
[10108.335403]  secondary_startup_64_no_verify+0xe5/0xeb
[10108.335876]  </TASK>
[10108.338714] clocksource: Long readout interval, skipping watchdog check: cs_nsec: 56707865155 wd_nsec: 56707842538
[10108.391556] ceph: mds0 caps stale
[10108.394339] libceph: mon0 (1)192.168.56.20:6789 session lost, hunting for new mon
[10108.500285] ceph: mds0 caps renewed
[10108.562918] libceph: mon0 (1)192.168.56.20:6789 session established

vagrant@master:/vagrant$ sudo ethtool -S eth1
NIC statistics:
     rx_packets: 39730
     tx_packets: 53471
     rx_bytes: 6896827
     tx_bytes: 1117490793
     rx_broadcast: 22
     tx_broadcast: 6
     rx_multicast: 0
     tx_multicast: 19
     rx_errors: 0
     tx_errors: 0
     tx_dropped: 0
     multicast: 0
     collisions: 0
     rx_length_errors: 0
     rx_over_errors: 0
     rx_crc_errors: 0
     rx_frame_errors: 0
     rx_no_buffer_count: 0
     rx_missed_errors: 0
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
     tx_window_errors: 0
     tx_abort_late_coll: 0
     tx_deferred_ok: 0
     tx_single_coll_ok: 0
     tx_multi_coll_ok: 0
     tx_timeout_count: 0
     tx_restart_queue: 0
     rx_long_length_errors: 0
     rx_short_length_errors: 0
     rx_align_errors: 0
     tx_tcp_seg_good: 24993
     tx_tcp_seg_failed: 0
     rx_flow_control_xon: 0
     rx_flow_control_xoff: 0
     tx_flow_control_xon: 0
     tx_flow_control_xoff: 0
     rx_long_byte_count: 6896827
     rx_csum_offload_good: 0
     rx_csum_offload_errors: 0
     alloc_rx_buff_failed: 0
     tx_smbus: 0
     rx_smbus: 0
     dropped_smbus: 0

vagrant@master:/vagrant$ sudo journalctl -u systemd-journald -n 30 --no-pager
Jun 13 03:49:05 bookworm systemd-journald[210]: Journal started
Jun 13 03:49:05 bookworm systemd-journald[210]: Runtime Journal (/run/log/journal/dc8bc2e1a2744f4bb38c57d340fb2560) is 1.2M, max 9.6M, 8.4M free.
Jun 13 03:49:05 bookworm systemd-journald[210]: Time spent on flushing to /var/log/journal/dc8bc2e1a2744f4bb38c57d340fb2560 is 9.101ms for 471 entries.
Jun 13 03:49:05 bookworm systemd-journald[210]: System Journal (/var/log/journal/dc8bc2e1a2744f4bb38c57d340fb2560) is 8.0M, max 4.0G, 3.9G free.
Jun 13 03:49:05 bookworm systemd-journald[210]: Received client request to flush runtime journal.
Jun 13 06:38:22 master systemd-journald[210]: Received SIGTERM from PID 1 (systemd).
Jun 13 06:38:22 master systemd-journald[210]: Journal stopped
Jun 13 06:38:22 master systemd-journald[60799]: Journal started
Jun 13 06:38:22 master systemd-journald[60799]: System Journal (/var/log/journal/dc8bc2e1a2744f4bb38c57d340fb2560) is 16.0M, max 4.0G, 3.9G free.

vagrant@master:/vagrant$ go build -o /mnt/slurm_shared/fastq_parser main.go

Message from syslogd@master at Jun 13 06:37:23 ...
 kernel:[10108.231566] watchdog: BUG: soft lockup - CPU#0 stuck for 56s! [swapper/0:0]

4. NAPI overwhelm edge case

================ PHASE 1 ===================
[10551.378771]  run_ksoftirqd+0x2d/0x40
[10551.376884]  net_rx_action+0x2a0/0x350
[10551.376153]  __napi_poll+0x28/0x160
[10551.374494]  e1000_clean_rx_irq+0x310/0x500 [e1000]
[10551.372171]  ? e1000_alloc_rx_buffers+0x289/0x370 [e1000]

    1. run_ksoftirqd: High volumes of biological sequencing data were streaming across the network into this node. The hardware generated thousands of hardware interrupt requests (IRQs). To keep the OS from freezing, the kernel delegated packet processing to a background software interrupt daemon (ksoftirqd).

    2. __napi_poll & e1000_clean_rx_irq: The Linux kernel used its New API (NAPI) subsystem to poll the emulated network card buffer and clear the incoming packets out of the network card's memory queue (RX ring buffer).

    3. The Bottleneck: Because the e1000 driver is an emulated legacy driver, every single packet processed required the VM guest kernel to exit out to VirtualBox on your host machine, translate the legacy register states, and pass it to your host machine's hardware interface. This adds massive execution latency.

================ PHASE 2 ===================

While the network driver loop was spinning as fast as it could to clear the queue, it starved the rest of the CPU core. Look at the <IRQ> block that intercepted it:

[10551.365698]  ? watchdog_timer_fn+0x1a4/0x200
[10551.366771]  ? __hrtimer_run_queues+0x10f/0x2b0
[10551.371633]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20

    1. Linux kernels have a safety mechanism called a Watchdog Timer. A high-priority hardware timer (watchdog_timer_fn) continuously fires via APM/APIC interrupts to ensure the operating system hasn't frozen.

    2. If a single thread stays trapped inside a kernel task (like e1000_clean_rx_irq) for more than 20 seconds without yielding the CPU to other tasks, the Watchdog panics. It realizes a "Hard Lockup" has occurred because background system tasks are completely starved.

================= PHASE 3 ===================
Because the network loop was frozen processing those buffers and fighting the watchdog, the machine went completely deaf to the rest of your sandbox cluster for a few seconds. Look at what happened immediately next in the logs:

[10551.390990] ceph: mds0 caps stale 
[10551.391514] libceph: mon0 (1)192.168.56.20:6789 session lost, hunting for new mon in kernel logs.

    1. session lost, hunting for new mon: Because the kernel was locked up in the e1000 polling cycle, it missed its network heartbeat check-ins with your Ceph Storage Node (192.168.56.20). Ceph dropped the connection, and the node lost its cryptographic capabilities (caps stale), instantly dropping the /mnt/slurm_shared mount.

    2. systemd-journald killed / result 'watchdog': Systemd’s local logging engine (systemd-journald) tried to write logs to disk, but because the kernel interface was locked, it missed its own systemd software watchdog ping. Systemd mercilessly executed it with a SIGABRT (code=killed, status=6/ABRT).

    3. journal corrupted... renaming and replacing: When the node finally un-froze and regained its network session (session established), it realized systemd-journald had died mid-write, completely corrupting your binary .journal system log files on disk.

5. Check card limit

vagrant@master:/mnt/slurm_shared$ sudo ethtool -g eth1
Ring parameters for eth1:
Pre-set maximums:
RX:             4096
RX Mini:        n/a
RX Jumbo:       n/a
TX:             4096
Current hardware settings:
RX:             256
RX Mini:        n/a
RX Jumbo:       n/a
TX:             256
RX Buf Len:             n/a
CQE Size:               n/a
TX Push:        off
TCP data split: n/a

We can still add more ring buffer on the interface

6. Increase RX and TX queue limit on all nodes

```bash
vagrant@master:/mnt/slurm_shared$ sudo ethtool -G eth1 rx 4096 tx 4096

ansible -i inventory.ini workers,storage_nodes -m command -a "sudo apt update"

ansible -i inventory.ini workers,storage_nodes -m command -a "sudo apt install ethtool"

ansible -i inventory.ini workers,storage_nodes -m command -a "sudo ethtool -g eth1"

ansible -i inventory.ini workers,storage_nodes -m command -a "sudo ethtool -G eth1 rx 4096 tx 4096"
```

7. Increase packets allowed in kernel queue & maximum OS buffer allocation

Kernel Queue Size :
(Default is often 1000)
```bash
sudo sysctl -w net.core.netdev_max_backlog=10000
```

OS Buffer Memory Alloc :
(allow up to 16MB buffers)
```bash
sudo sysctl -w net.core.rmem_max=16777216
sudo sysctl -w net.core.wmem_max=16777216
```

8. Tool fine tuning

main.go
```bash
// Fine-tune the tool: Upgrade from a generic 4KB reader to an optimized 16MB page buffer
	scanner := bufio.NewReaderSize(os.Stdin, 16*1024*1024)

```
submit_local_job.sh
```bash
if [ "$PROC_ID" -eq 0 ]; then
    # Worker 1: Tuned 128k block streaming
    dd if="$TARGET_FILE" bs=128k count=$((CHUNK_SIZE / 131072)) 2>/dev/null | \
        /mnt/slurm_shared/fastq_parser > /mnt/slurm_shared/result_local_worker_${PROC_ID}.txt
else
    # Worker 2: TUNED high-throughput 1MB blocks to protect legacy drivers from context death
    BLOCK_SIZE=$((1024 * 1024)) # 1MB blocks
    SKIP_BLOCKS=$((START_BYTE / BLOCK_SIZE))
    COUNT_BLOCKS=$((CHUNK_SIZE / BLOCK_SIZE))

    # Fast page alignment loop
    dd if="$TARGET_FILE" bs=$BLOCK_SIZE skip=$SKIP_BLOCKS count=$COUNT_BLOCKS 2>/dev/null | \
        /mnt/slurm_shared/fastq_parser > /mnt/slurm_shared/result_local_worker_${PROC_ID}.txt
fi
```
