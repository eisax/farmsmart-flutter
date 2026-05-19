import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmsmart_flutter/model/repositories/repository_provider.dart';

class AuthDialog extends StatefulWidget {
  @override
  _AuthDialogState createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _tryCreate() async {
    setState(() => _loading = true);
    final repo = Provider.of<RepositoryProvider>(context, listen: false)
        .getAccountRepository();
    try {
      await repo.create(_emailCtrl.text.trim(), _passwordCtrl.text);
      Navigator.of(context).pop(true);
    } catch (e) {
      final msg = e is StateError ? e.message : e.toString();
      _showMessage('Create failed: $msg');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _tryLogin() async {
    setState(() => _loading = true);
    final repo = Provider.of<RepositoryProvider>(context, listen: false)
        .getAccountRepository();
    try {
      await repo.authorize(_emailCtrl.text.trim(), _passwordCtrl.text);
      Navigator.of(context).pop(true);
    } catch (e) {
      final msg = e is StateError ? e.message : e.toString();
      if (msg == 'mfa_required') {
        // Prompt for code
        final code = await showDialog<String>(
            context: context,
            builder: (ctx) {
              final ctrl = TextEditingController();
              return AlertDialog(
                title: Text('Enter MFA code'),
                content: TextField(
                  controller: ctrl,
                  decoration: InputDecoration(hintText: 'Code'),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(ctrl.text),
                      child: Text('Submit'))
                ],
              );
            });
        if (code != null && code.isNotEmpty) {
          try {
            await repo.authorize(
                _emailCtrl.text.trim(), _passwordCtrl.text + ':' + code);
            Navigator.of(context).pop(true);
            return;
          } catch (e2) {
            _showMessage('MFA verify failed');
          }
        }
      } else {
        _showMessage('Login failed: $msg');
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sign in / Register'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailCtrl,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordCtrl,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: _loading ? null : _tryLogin, child: Text('Login')),
        TextButton(
            onPressed: _loading ? null : _tryCreate, child: Text('Register')),
      ],
    );
  }
}
