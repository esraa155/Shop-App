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
  String _passwordConfirmation = '';
  String _phone = '';
  String _address = '';
  String? _dateOfBirth;
  String _city = '';
  String _country = '';
  bool _showPassword = false;
  bool _showPasswordConfirmation = false;

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
                  if (!_isLogin) ...[
                    TextFormField(
                      decoration: InputDecoration(labelText: l10n.name),
                      onChanged: (v) => _name = v,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? l10n.required : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: l10n.phone),
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => _phone = v,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: l10n.address),
                      maxLines: 2,
                      onChanged: (v) => _address = v,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: l10n.dateOfBirth),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _dateOfBirth = date.toIso8601String().split('T')[0];
                          });
                        }
                      },
                      controller: TextEditingController(
                        text: _dateOfBirth != null
                            ? DateTime.parse(_dateOfBirth!).toString().split(' ')[0]
                            : '',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: l10n.city),
                      onChanged: (v) => _city = v,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: l10n.country),
                      onChanged: (v) => _country = v,
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextFormField(
                    decoration: InputDecoration(labelText: l10n.email),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) => _email = v,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? l10n.required : null,
                  ),
                  const SizedBox(height: 8),
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
                        (v == null || v.length < 8) ? l10n.passwordTooShort : null,
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: l10n.confirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPasswordConfirmation
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() {
                            _showPasswordConfirmation = !_showPasswordConfirmation;
                          }),
                        ),
                      ),
                      obscureText: !_showPasswordConfirmation,
                      onChanged: (v) => _passwordConfirmation = v,
                      validator: (v) => (v == null || v != _password)
                          ? l10n.passwordMismatch
                          : null,
                    ),
                  ],
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
                                            _name, _email, _password,
                                            phone: _phone.isEmpty ? null : _phone,
                                            address: _address.isEmpty ? null : _address,
                                            dateOfBirth: _dateOfBirth,
                                            city: _city.isEmpty ? null : _city,
                                            country: _country.isEmpty ? null : _country,
                                        ));
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

