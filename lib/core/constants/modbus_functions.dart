sealed class ModbusFunction {
  final int code;
  final String name;

  ModbusFunction(this.code, this.name);
}

class ReadCoilsFunction extends ModbusFunction {
  ReadCoilsFunction() : super(1, 'Read Coils');
}

class ReadDiscreteInputsFunction extends ModbusFunction {
  ReadDiscreteInputsFunction() : super(2, 'Read Discrete Inputs');
}

class ReadHoldingRegistersFunction extends ModbusFunction {
  ReadHoldingRegistersFunction() : super(3, 'Read Holding Registers');
}

class ReadInputRegistersFunction extends ModbusFunction {
  ReadInputRegistersFunction() : super(4, 'Read Input Registers');
}

class WriteSingleCoilFunction extends ModbusFunction {
  WriteSingleCoilFunction() : super(5, 'Write Single Coil');
}

class WriteSingleRegisterFunction extends ModbusFunction {
  WriteSingleRegisterFunction() : super(6, 'Write Single Register');
}

class WriteMultipleCoilsFunction extends ModbusFunction {
  WriteMultipleCoilsFunction() : super(15, 'Write Multiple Coils');
}

class WriteMultipleRegistersFunction extends ModbusFunction {
  WriteMultipleRegistersFunction() : super(16, 'Write Multiple Registers');
}

class ReadWriteMultipleRegistersFunction extends ModbusFunction {
  ReadWriteMultipleRegistersFunction()
      : super(23, 'Read Write Multiple Registers');
}

class ModbusFunctions {
  static final List<ModbusFunction> functions = [
    ReadCoilsFunction(),
    ReadDiscreteInputsFunction(),
    ReadHoldingRegistersFunction(),
    ReadInputRegistersFunction(),
    WriteSingleCoilFunction(),
    WriteSingleRegisterFunction(),
    WriteMultipleCoilsFunction(),
    WriteMultipleRegistersFunction(),
    ReadWriteMultipleRegistersFunction(),
  ];
}
