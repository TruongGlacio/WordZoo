import 'package:flutter/material.dart';
import 'blocs/iap_bloc.dart';

/// Premium Status Widget - Hiển thị trạng thái Premium
class PremiumStatusWidget extends StatelessWidget {
  final IAPState state;
  final VoidCallback? onUpgrade;
  final String? message;

  const PremiumStatusWidget({
    Key? key,
    required this.state,
    this.onUpgrade,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state.runtimeType) {
      case IapLoading:
        return const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case PremiumActive:
        return _buildPremiumBadge();
      case PremiumInactive:
        return ElevatedButton.icon(
          onPressed: onUpgrade,
          icon: const Icon(Icons.star, size: 16),
          label: message != null ? Text(message??'') : const Text('Premium'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// Hiển thị badge Premium
  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[600],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            'Premium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading Widget cho IAP
class IAPLoadingWidget extends StatelessWidget {
  final String? message;
  final double size;

  const IAPLoadingWidget({
    Key? key,
    this.message,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(strokeWidth: size / 5),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error Widget cho IAP
class IAPErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const IAPErrorWidget({
    Key? key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}