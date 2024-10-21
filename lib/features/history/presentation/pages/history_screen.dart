import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modbus_app/features/history/presentation/blocs/history_bloc.dart';
import 'package:modbus_app/features/history/presentation/blocs/history_state.dart';
import 'package:modbus_app/features/history/presentation/widgets/request_widget.dart';
import 'package:modbus_app/resources/size_config/size_config.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Request History',
          style: TextStyle(
            fontSize: getHeight(16),
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.requests.isEmpty) {
            return Center(
              child: Text(
                "No requests found",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: getHeight(18), fontWeight: FontWeight.w400),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: getHeight(20),
            ),
            itemCount: state.requests.length,
            itemBuilder: (context, index) {
              final request = state.requests[index];
              return RequestWidget(request: request);
            },
          );
        },
      ),
    );
  }
}
