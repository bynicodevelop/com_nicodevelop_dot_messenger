import "package:com_nicodevelop_dotmessenger/services/auth/delete_account/delete_account_bloc.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

class DeleteAccountButtonComponent extends StatelessWidget {
  final Function()? onDeleted;

  const DeleteAccountButtonComponent({
    super.key,
    this.onDeleted,
  });

  Widget _deleteAccountConfirm(BuildContext context) =>
      BlocListener<DeleteAccountBloc, DeleteAccountState>(
        listener: (context, state) async {
          Navigator.pop(context);

          onDeleted?.call();
        },
        child: AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () => context.read<DeleteAccountBloc>().add(
                    OnDeleteAccountEvent(),
                  ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40.0,
      child: ElevatedButton(
        onPressed: () async => showDialog(
            context: context,
            builder: (context) => _deleteAccountConfirm(context)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Text(
          "Supprimer mon compte",
        ),
      ),
    );
  }
}
