import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../home_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  final bool initialMode;
  const LoginRegisterScreen({super.key, this.initialMode = true});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isLogin;
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.initialMode;
  }

  String _name = '';
  String _email = '';
  String _password = '';
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? l10n.login : l10n.register)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated && _hasSubmitted) {
            if (!_isLogin) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const LoginRegisterScreen(initialMode: true)));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            }
          } else if (state is AuthUnauthenticated && state.message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_isLogin)
                    TextFormField(
                      decoration: InputDecoration(labelText: l10n.name),
                      onChanged: (v) => _name = v,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? l10n.required : null,
                    ),
                  TextFormField(
                    decoration: InputDecoration(labelText: l10n.email),
                    onChanged: (v) => _email = v,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? l10n.required : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() {
                          _showPassword = !_showPassword;
                        }),
                      ),
                    ),
                    obscureText: !_showPassword,
                    onChanged: (v) => _password = v,
                    validator: (v) =>
                        (v == null || v.length < 6) ? l10n.minChars : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: loading
                              ? null
                              : () {
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  _hasSubmitted = true;
                                  if (_isLogin) {
                                    context.read<AuthBloc>().add(
                                        AuthLoginSubmitted(_email, _password));
                                  } else {
                                    context.read<AuthBloc>().add(
                                        AuthRegisterSubmitted(
                                            _name, _email, _password));
                                  }
                                },
                          child: Text(loading
                              ? l10n.pleaseWait
                              : (_isLogin ? l10n.login : l10n.register)),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () => setState(() => _isLogin = !_isLogin),
                    child:
                        Text(_isLogin ? l10n.createAccount : l10n.haveAccount),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

