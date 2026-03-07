import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/connectivity_provider.dart';

/// Un indicateur visuel plus explicite avec icône et texte.
class ConnectivityStatusIndicator extends ConsumerWidget {
  const ConnectivityStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    
    return connectivityAsync.when(
      data: (status) {
        final isOnline = status == ConnectivityStatus.online;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isOnline 
                ? Colors.green.withAlpha(30) 
                : Colors.red.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isOnline ? Colors.green : Colors.red,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (isOnline)
                      BoxShadow(
                        color: Colors.green.withAlpha(100),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isOnline ? 'EN LIGNE' : 'HORS-LIGNE',
                style: TextStyle(
                  color: isOnline ? Colors.green[800] : Colors.red[800],
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: const Text(
          'VÉRIFICATION...',
          style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
      // En cas d'erreur de stream (ex: sur Web), on affiche qu'on est en ligne par défaut pour ne pas effrayer l'utilisateur
      error: (err, __) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green, width: 1),
          ),
          child: const Text(
            'EN LIGNE',
            style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
    );
  }
}
