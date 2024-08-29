# Network-on-Chip (NoC) Implementation and Verification

## Objective

This project implements a Network-on-Chip (NoC) design, focusing on packet generation, routing, and control. The NoC design is tested using a verification testbench that includes random packet generation, directed tests, and result monitoring.

### Key Modules

1. **TopModule**: Integrates the NoC components, including the Packet Generator, Router Input Port, and Control Unit.
2. **PacketGenerator**: Handles the creation of packets based on input signals.
3. **NoCRouterInputPort**: Manages the routing and storage of packets within the NoC.
4. **Control_Unit**: Controls the overall operation of the NoC, coordinating packet generation and routing.

## Top Module Pinout

| Signal Name      | Direction | Width   | Description                                               |
|------------------|-----------|---------|-----------------------------------------------------------|
| `clk`            | Input     | 1-bit   | System clock                                              |
| `reset`          | Input     | 1-bit   | Reset signal, active high                                 |
| `pkt_in`         | Input     | 13-bit  | Input packet to be processed                              |
| `src_valid`      | Input     | 1-bit   | Indicates that the source packet is valid                 |
| `packet`         | Output    | 13-bit  | Generated packet from the PacketGenerator                 |
| `packet_valid`   | Output    | 1-bit   | Indicates that a valid packet has been generated          |
| `dst_ready`      | Input     | 1-bit   | Indicates that the destination is ready to receive data   |
| `en_gen`         | Output    | 1-bit   | Enable signal for the packet generator                    |
| `dst_valid`      | Output    | 1-bit   | Indicates that the packet has been successfully routed    |
| `dst_addr`       | Output    | 2-bit   | Destination address for the packet                        |
| `pack_t`         | Output    | 2-bit   | Packet type (control/data)                                |
| `payload`        | Output    | 8-bit   | Payload of the packet                                     |
| `eop`            | Output    | 1-bit   | End of Packet signal                                      |
| `ack`            | Input     | 1-bit   | Acknowledge signal from the destination                   |

![Top Diagram](../images/top.png)


## State Diagram and Logic

The state diagram for the NoC implementation includes the following states:

1. **Idle**: The system waits for the `src_valid` signal to begin processing.
2. **Packet Generation**: The `PacketGenerator` creates a packet when `src_valid` is high.
3. **Routing**: The packet is routed through the `NoCRouterInputPort`, where it is stored and forwarded based on its destination address (`dst_addr`).
4. **Acknowledge**: The `Control_Unit` checks for acknowledgment (`ack`) from the destination and completes the packet transfer.

![State Diagram](../images/control_diagram.png)

## Definition of Network-on-Chip (NoC)

A Network-on-Chip (NoC) is an advanced communication subsystem implemented within a chip to handle the transfer of data between various components. NoCs typically replace traditional bus systems, providing scalable and efficient data transfer through packet-based communication. The NoC in this project is designed for a 2x2 mesh topology, where each node can send and receive packets.

## Testbench Verification Plan

The testbench is designed to verify the functionality of the NoC components by simulating different scenarios:

### Random Packet Generation
- The testbench generates random packets and sends them through the NoC.
- A scoreboard compares the expected destination and payload with the actual output, logging passes or failures.

### Directed Tests
- Specific test cases with predefined packet inputs are used to validate the routing and acknowledgment logic.
- This helps ensure that the NoC operates correctly under known conditions.

### Monitor and Scoreboard
- The monitor observes the behavior of the NoC during simulation, capturing packet generation and routing.
- The scoreboard checks the accuracy of the packet routing and data integrity, providing feedback on the test results.

### Simulation Commands
- The simulation runs 10,000 random tests and additional directed tests to comprehensively verify the NoC design.

## Running the Simulation

To run the simulation, execute the following command in your simulation environment:

```bash
vsim -c -do "run -all" TopModule_tb
```

The simulation output will display the results of the packet routing and verification checks.
