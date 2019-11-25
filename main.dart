import 'dart:typed_data';

/// Defines the memory size.
const int MEMORY_SIZE = 20;

enum OpcodeKind { loadi, addi, compare, jump, branch, exit }

/// Represents an opcode.
class Opcode {
  /// Determines the kind of the opcode.
  final OpcodeKind kind;

  /// Determines the first operand.
  final int op1;

  /// Determines the second operand.
  final int op2;

  /// Determines the third operand.
  final int op3;

  /// Creates a new instance of an opcode.
  const Opcode(this.kind, [this.op1 = 0, this.op2 = 0, this.op3 = 0]);
}

/// Entry point.
void main() {
  // Program memory.
  final memory = Int32List(MEMORY_SIZE);
  // Program code to execute.
  const code = const [
    Opcode(OpcodeKind.loadi, 0, 1000000000), // r0 = 1000000000;
    Opcode(OpcodeKind.loadi, 1, 0), // r1 = 0;
    Opcode(OpcodeKind.compare, 2, 0, 1), // r2 = r0 == r1;
    Opcode(OpcodeKind.branch, 2, 2), // if (r2 == 0) goto +2;
    Opcode(OpcodeKind.addi, 1, 1, 1), // r0 = r0 + 1;
    Opcode(OpcodeKind.jump, -4), // goto -4;
    Opcode(OpcodeKind.exit)
  ];
  // Program counter.
  int pc = 0;
  bool running = true;
  while (running) {
    final Opcode op = code[pc];
    switch (op.kind) {
      case OpcodeKind.loadi:
        {
          memory[op.op1] = op.op2;
          break;
        }
      case OpcodeKind.addi:
        {
          memory[op.op1] = memory[op.op2] + op.op3;
          break;
        }
      case OpcodeKind.compare:
        {
          memory[op.op1] = (memory[op.op2] == memory[op.op3]) ? 1 : 0;
          break;
        }
      case OpcodeKind.jump:
        {
          pc += op.op1;
          break;
        }
      case OpcodeKind.branch:
        {
          if (memory[op.op1] != 0) pc += op.op1;
          break;
        }
      case OpcodeKind.exit:
        {
          running = false;
          break;
        }
    }
    pc++;
  }
  print('Result: ${memory[1]}');
}
