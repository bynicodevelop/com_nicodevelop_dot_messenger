import "package:com_nicodevelop_dotmessenger/services/generic_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class EmptyWrapperComponent<B extends StateStreamable<S>, S>
    extends StatelessWidget {
  final Widget child;
  final String? message;

  const EmptyWrapperComponent({
    super.key,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        if (state is GenericLoadedState) {
          final List<Map<String, dynamic>> results = state.results;

          if (results.isEmpty) {
            return Center(
              child: Text(
                message ?? "No data found",
              ),
            );
          }
        }

        return child;
      },
    );
  }
}
