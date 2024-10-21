import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../injector.dart';
import '../../../../resources/size_config/size_config.dart';
import '../../../history/presentation/blocs/history_bloc.dart';
import '../../../history/presentation/blocs/history_event.dart';
import '../../../history/presentation/blocs/history_state.dart';
import '../../../history/presentation/pages/history_screen.dart';
import '../../../setup/presentation/widgets/custom_toggle_buttons.dart';
import '../blocs/request_bloc/request_bloc.dart';
import '../blocs/request_bloc/request_event.dart';
import '../blocs/request_bloc/request_state.dart';
import '../widgets/add_request_dialog.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/data_table.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestBloc>().add(const SetStaticParamsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryBloc, HistoryState>(
      listener: (context, state) {
        if (state.error.hasError) {
          // show snack bar with error message
          Get.snackbar(
            "Error",
            "Please fill all fields",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(10),
            animationDuration: const Duration(milliseconds: 0),
            duration: const Duration(milliseconds: 2000),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Modbus Request',
            style: TextStyle(
              fontSize: getHeight(16),
              color: Colors.white,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              sl<RequestBloc>().add(
                const TerminateSessionEvent(),
              );
              Get.back();
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                context.read<HistoryBloc>().add(FetchRequestsEvent());
                Get.to(() => const HistoryScreen());
              },
            ),
          ],
        ),
        body: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: getHeight(30)),
                    // Presentation Toggle
                    Center(
                      child: CustomToggleButtons(
                        PresentationType.values,
                        state.presentationType.index,
                        width: getWidth(180),
                        height: getHeight(35),
                        onChanged: (index) {
                          context.read<RequestBloc>().add(
                                SetPresentationTypeEvent(
                                  type: PresentationType.values[index],
                                ),
                              );
                        },
                      ),
                    ),
                    SizedBox(height: getHeight(30)),
                    // Data Table or Chart, Height: 500
                    state.presentationType == PresentationType.table
                        ? TableChart<int>(values: state.response)
                        : BarChartWidget(
                            values: state.response,
                            gain: state.request?.gain ?? 1,
                          ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: getHeight(80),
                  width: getWidth(300),
                  padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: state.request == null
                      ? Center(
                          child: Text(
                            "Make a request to see the parameters",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: getHeight(15),
                                ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Slave Id: ${state.slaveId}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: getHeight(15),
                                      ),
                                ),
                                Text(
                                  "Baud Rate: ${state.baudRate}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: getHeight(15),
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tag: ${state.request?.tag}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: getHeight(15),
                                      ),
                                ),
                                Text(
                                  "Function Code: ${state.request?.functionCode}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: getHeight(15),
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Gain: ${state.request?.gain}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: getHeight(15),
                                      ),
                                ),
                                Text(
                                  "Poll: 500 ms",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: getHeight(15),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                SizedBox(height: getHeight(5)),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AddRequestDialog(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
