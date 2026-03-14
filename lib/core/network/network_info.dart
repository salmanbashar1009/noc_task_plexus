import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> results = await connectivity.checkConnectivity();
    // In newer versions of connectivity_plus, it returns a List.
    // We check if any of the results are not 'none'.
    return results.any((result) => result != ConnectivityResult.none);
  }
}
