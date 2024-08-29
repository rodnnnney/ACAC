import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:ACAC/features/scanner/scannerV3.dart';
import 'package:ACAC/features/user_auth/data/cache_user.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CenterNavWidget extends StatelessWidget {
  const CenterNavWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final userObject = ref.watch(currentUserProvider);

    return GestureDetector(
      onTap: () async {
        switch (userObject) {
          case AsyncData(value: final user):
            {
              if (user.id == dotenv.get('GUEST_ID') && context.mounted) {
                const ResponsePopUp(
                  response: 'Guest can\'t access membership',
                  location: DelightSnackbarPosition.top,
                  icon: Icons.error_outline,
                  color: Colors.redAccent,
                ).showToast(context);
                return;
              }
            }
        }
        if (ref.watch(userPageCounter).counter != 1) {
          ref.read(userPageCounter).setCounter(1);
          Navigator.pushNamed(context, App.id);
        }
      },
      child: SizedBox(
        width: 65,
        height: 65,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff8CC084),
            borderRadius: BorderRadius.circular(35),
          ),
          child: const FittedBox(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
