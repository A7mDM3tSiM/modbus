import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:modbus_app/features/setup/domain/usecases/setup_usecase.dart';

import '../../../../../core/state_error/custom_state_error.dart';
import '../../../../../resources/datastate/datastate.dart';
import '../../../../request/presentation/pages/request_screen.dart';
import 'setup_event.dart';
import 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final SetupUsecase setupUsecase;
  SetupBloc(this.setupUsecase) : super(SetupState.initial()) {
    on<ChangeConnectionMode>((event, emit) {
      emit(state.copyWith(connectionMode: event.connectionMode.index));
    });

    on<ChangeBaudRate>((event, emit) {
      emit(state.copyWith(baudRate: event.baudRate));
    });

    on<ChangeDataBits>((event, emit) {
      emit(state.copyWith(dataBits: event.dataBits));
    });

    on<ChangeParity>((event, emit) {
      emit(state.copyWith(parity: event.parity.index));
    });

    on<ChangeStopBits>((event, emit) {
      emit(state.copyWith(stopBits: event.stopBits.index.toDouble()));
    });

    on<ChangeSlaveId>((event, emit) {
      emit(state.copyWith(slaveId: event.slaveId));
    });

    on<ChangeAlias>((event, emit) {
      emit(state.copyWith(alias: event.alias));
    });

    on<Setup>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      // Send the setup parameters to the device
      final dataState = await setupUsecase(
          params: SetupParams(
        baudRate: state.baudRate!,
        dataBits: state.dataBits!,
        parity: state.parity!,
        stopBits: state.stopBits!,
        slaveId: state.slaveId!,
        alias: state.alias ?? "",
      ));

      if (dataState is SuccessState) {
        // Navigate to the request screen
        g.Get.to(() => const RequestScreen(), transition: g.Transition.fade);

        emit(state.copyWith(
          port: dataState.data,
          isConnected: true,
        ));
      }

      if (dataState is FailedState) {
        // !!! COMMENT THIS LINE When the actual device is connected
        // /*
        // final context = g.Get.context!;
        // if (context.mounted) {
        //   g.Get.to(() => const RequestScreen(), transition: g.Transition.fade);
        // }
        // */

        emit(
          state.copyWith(
            error: const CustomStateError(
              hasError: true,
              message: "An error occurred while communicating with the device",
            ),
          ),
        );
      }
    });
  }
}
