import 'package:flutter/material.dart';

class CommonLoader {
  static final CommonLoader _i = CommonLoader._();
  CommonLoader._();
  factory CommonLoader() {
    return _i;
  }
  bool isLoaderVisible = false;
  DialogRoute? dialogRoute;

  void showLoader(BuildContext context) async {
    if (isLoaderVisible) return;
    isLoaderVisible = true;
    dialogRoute = null;

    dialogRoute = DialogRoute(
      context: context,
      barrierDismissible: false,
      barrierColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      builder: (context) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    await Navigator.push(context, dialogRoute!);
    isLoaderVisible = false;
  }

  void hideLoader(BuildContext context) {
    if (isLoaderVisible && dialogRoute != null) {
      Navigator.removeRoute(context, dialogRoute!);
    }
    isLoaderVisible = false;
    dialogRoute = null;
  }
}
