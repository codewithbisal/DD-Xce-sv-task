# Digital Design and Verification Evaluation - System Verilog
## Evaluation Instructions

- **Duration**: You have 4 hours to complete this evaluation.
- **Start Time**: August 29th, 2024 11:00 AM PKT 
- **End Time**: August 29th, 2024 03:00 PM PKT

### Rules and Guidelines:

1. **Individual Work**: This is an individual assessment. Collaboration with others is strictly prohibited.

2. **Cheating**: Any form of cheating will result in immediate disqualification. This includes, but is not limited to:
   - Communicating with other participants during the evaluation
   - Sharing or receiving unauthorized assistance
   - Attempting to access unauthorized resources

3. **Resources**:
   - You may use your personal notes from the training sessions.
   - Use of textbooks and reference manuals related to SystemVerilog and digital design is allowed.
   - Access to basic tools for SystemVerilog design and simulation is permitted.

4. **Prohibited Tools**:
   - Use of AI-powered search engines or code generation tools (e.g., ChatGPT, Google Bard) is strictly forbidden.
   - Automated code completion beyond basic IDE features is not allowed.

5. **Submissions**:
   - Ensure all required files are submitted before the deadline.
   - Late submissions will not be accepted.

6. **Technical Issues**: If you encounter any technical problems during the evaluation, notify the manager immediately.

7. **Clarifications**: If you need clarification on any part of the task, you may ask your manager.

8. **Breaks**: You may take short breaks if needed, but the timer will continue to run.

Violation of any of these rules may result in disqualification from the evaluation. If you have any questions about these guidelines, please ask for clarification before the evaluation begins.

## Task Overview

Design and verify a simplified Network-on-Chip (NoC) router system consisting of two main components communicating via a ready-valid interface:

1. A Packet Generator (A Command Sender Unit)
2. A NoC Router with Input Port Module (A Multicycle Receiving Unit)

## Detailed Requirements

### 1. Packet Generator

Design a module that generates and sends network packets through a ready-valid interface.

- Packet structure:
  - 2-bit destination address
  - 2-bit packet type (e.g., 00: data, 01: control, 10: response, 11: reserved)
  - 8-bit payload
  - 1-bit end-of-packet (EOP) flag

- The module should be capable of generating a variety of packet sequences to test different scenarios.

### 2. NoC Router with Input Port Module

Design a simplified NoC router that focuses on the input port module. This module should:

- Receive packets via the ready-valid interface
- Decode the packet header (destination and type)
- Perform routing computation based on the destination address
- Buffer incoming packets (implement a small FIFO)
- Manage flow control

For simplicity, assume a 2x2 mesh topology with 4 possible destinations (00, 01, 10, 11).

### 3. Ready-Valid Interface

- Implement the ready-valid interface between the Packet Generator and the NoC Router's Input Port Module.
- Ensure proper handshaking and data transfer according to the ready-valid protocol.

### 4. Verification

Create a layered testbench to verify the entire system. Your testbench should include:

- A transaction-level model (TLM) of the network packets
- A sequence generator to create various test scenarios, including:
  - Single packets
  - Burst transfers
  - Different packet types
  - Packets to all possible destinations
- A driver to send packets to the DUT (Packet Generator)
- A monitor to observe the DUT's outputs (NoC Router Input Port Module)
- A scoreboard to check:
  - Correct packet routing based on destination address
  - Proper handling of different packet types
  - Maintenance of packet integrity
  - Correct operation of the ready-valid interface

## Evaluation Criteria

You will be evaluated on the following aspects:

1. Correct implementation of the ready-valid interface
2. Functionality and efficiency of the Packet Generator
3. Correct operation of the NoC Router Input Port Module
4. Completeness and effectiveness of the layered testbench
5. Code quality, readability, and adherence to SystemVerilog best practices
6. Demonstration of understanding of key concepts covered in the training, including:
   - Ready-valid protocol
   - Basic NoC concepts
   - Packet-based communication
   - Testbench architecture

## Submission Guidelines

- Fork this repo and Submit all SystemVerilog files (.sv) for your design and testbench placed in a folder via a pull request.
- Include a simple pinout and a state machine diagram of your NoC router architecture in your folder.
- Ensure your code is well-commented and follows consistent naming conventions.

Good luck!
