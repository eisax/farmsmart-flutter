class DeepLink {
  final String deepLinkParameter;
  final Function(String) action;

  DeepLink({
    required this.deepLinkParameter,
    required this.action,
  });
}

class DeepLinkHelper {
  final List<DeepLink> deepLinks;

  DeepLinkHelper({
    required this.deepLinks,
  });

  void init() {
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    // Mock implementation - no Firebase Dynamic Links
    print('Mock Deep Link Helper: Waiting for deep links...');
  }

  void _saveDynamicLink() {
    //TODO: we need to implement this to be able to support opening deep links on very first open (no account created)
  }

  void runPendingDynamicLink() {
    //TODO Implement run pending dynamic link (saved on the disk
  }

  void _parseDeepLink(Uri deepLink) {
    final decodedDynamicLink = Uri.decodeComponent(deepLink.toString());
    final stringURLtoURI = Uri.parse(decodedDynamicLink);

    final deepLinkCatch = deepLinks.firstWhere(
      (deepLink) => stringURLtoURI.queryParameters
          .containsKey(deepLink.deepLinkParameter),
      orElse: () => throw StateError('No matching deep link'),
    );

    final deepLinkValue =
        stringURLtoURI.queryParameters[deepLinkCatch.deepLinkParameter];
    if (deepLinkValue != null) {
      deepLinkCatch.action(deepLinkValue);
    }
  }
}
