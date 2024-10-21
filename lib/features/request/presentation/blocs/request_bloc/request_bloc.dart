import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modbus_app/injector.dart';
import 'package:modbus_app/resources/modbus_helpers/modbus_service.dart';

import '../../../../../core/state_error/custom_state_error.dart';
import '../../../../../resources/modbus_helpers/modbus_request.dart' as helper;

import '../../../../history/presentation/blocs/history_bloc.dart';
import '../../../../history/presentation/blocs/history_event.dart';
import '../../../../setup/presentation/blocs/setup_bloc/setup_bloc.dart';
import 'request_event.dart';
import 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  ModbusService? service;

  RequestBloc() : super(RequestState.initial()) {
    on<SetStaticParamsEvent>((event, emit) async {
      // Get the setup parameters from the setup bloc and set them in the state
      final setup = sl<SetupBloc>().state;

      service = ModbusService(port: setup.port!, slaveId: setup.slaveId!);
      emit(
        state.copyWith(
          port: setup.port,
          baudRate: setup.baudRate,
          slaveId: setup.slaveId,
        ),
      );
    });

    on<ReadRequestEvent>((event, emit) async {
      // Wait for any pending request to finish
      await Future.delayed(const Duration(milliseconds: 1000));
      emit(state.copyWith(
        isLoading: true,
        shouldResendRequest: true,
        request: event.request,
      ));

      while (state.shouldResendRequest) {
        final output = await service?.readModbusData(
          functionCode: event.request.functionCode,
          startAddress: event.request.startAddress,
          quantity: event.request.quantity,
        );

        emit(state.copyWith(response: output));
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Save the request to the history if required
      if (state.shouldSaveRequest) {
        sl<HistoryBloc>().add(SaveRequestEvent());
      } else {
        switch (state.saveRequestType) {
          case SaveRequestType.saveNew:
            sl<HistoryBloc>().add(SaveRequestEvent());
            break;
          case SaveRequestType.update:
            sl<HistoryBloc>().add(UpdateRequestEvent(event.request));
            break;
          default:
            break;
        }
      }

      // Set the loading state to false
      emit(state.copyWith(isLoading: false, shouldSaveRequest: false));
    });

    on<WriteRequestEvent>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        request: event.request,
      ));

      // Set the function code and quantity for the request helper
      helper.ModbusRequestHelper.functionCode = event.request.functionCode;
      helper.ModbusRequestHelper.quantity = event.request.quantity;

      // Write the data to the modbus device
      helper.ModbusRequestHelper.writeModbusData(
        port: state.port,
        slaveId: state.slaveId!,
        functionCode: event.request.functionCode,
        startAddress: event.request.startAddress,
        values: event.request.values,
      );

      // Save the request to the history if required
      if (state.shouldSaveRequest) {
        sl<HistoryBloc>().add(SaveRequestEvent());
      } else {
        switch (state.saveRequestType) {
          case SaveRequestType.saveNew:
            sl<HistoryBloc>().add(SaveRequestEvent());
            break;
          case SaveRequestType.update:
            sl<HistoryBloc>().add(UpdateRequestEvent(event.request));
            break;
          default:
            break;
        }
      }

      // Set the loading state to false
      emit(state.copyWith(isLoading: false, shouldSaveRequest: false));
    });

    on<SetRequestTag>((event, emit) {
      emit(state.copyWith(tag: event.tag));
    });

    on<SetFunctionCode>((event, emit) {
      // Set the required fields based on the function code
      if (event.functionCode <= 4 || event.functionCode == 23) {
        emit(state.copyWith(
          isDataTypeRequired: true,
          isGainRequired: true,
          isValuesRequired: false,
        ));
      } else {
        emit(state.copyWith(
          isDataTypeRequired: false,
          isGainRequired: false,
          isValuesRequired: true,
        ));
      }

      emit(state.copyWith(functionCode: event.functionCode));
    });

    on<SetStartAddress>((event, emit) {
      emit(state.copyWith(startAddress: event.startAddress));
    });

    on<SetQuantity>((event, emit) {
      emit(state.copyWith(quantity: event.quantity));
    });

    on<SetDataType>((event, emit) {
      emit(state.copyWith(dataType: event.dataType));
    });

    on<SetGain>((event, emit) {
      emit(state.copyWith(gain: event.gain));
    });

    on<SetValues>((event, emit) {
      emit(state.copyWith(values: event.values));
    });

    on<SetShouldSaveRequest>((event, emit) {
      emit(state.copyWith(shouldSaveRequest: event.value));
    });

    on<SetShouldResendRequestEvent>((event, emit) {
      emit(state.copyWith(shouldResendRequest: event.value));
    });

    on<SetSaveRequestTypeEvent>((event, emit) {
      emit(state.copyWith(saveRequestType: event.type));
    });

    on<SetPresentationTypeEvent>((event, emit) {
      emit(state.copyWith(presentationType: event.type));
    });

    on<TerminateSessionEvent>((evnet, emit) {
      service?.closePort();
      emit(state.copyWith(
        port: null,
        slaveId: null,
        baudRate: null,
        tag: "",
        functionCode: null,
        startAddress: null,
        quantity: null,
        dataType: null,
        gain: null,
        values: null,
        request: null,
        isDataTypeRequired: false,
        isGainRequired: false,
        isValuesRequired: false,
        shouldSaveRequest: false,
        shouldResendRequest: false,
        saveRequestType: SaveRequestType.doNothing,
        presentationType: PresentationType.table,
        requests: [],
        response: [],
        isLoading: false,
        error: const CustomStateError(hasError: false),
      ));
    });
  }
}
