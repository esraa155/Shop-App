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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Required Fields Section
                    if (!_isLogin) ...[
                      Text(
                        'Basic Information',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: l10n.name,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (v) => _name = v,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? l10n.required : null,
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => _email = v,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? l10n.required : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
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
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: l10n.confirmPassword,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
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
                    
                    // Optional Fields Section (Collapsible)
                    if (!_isLogin) ...[
                      const SizedBox(height: 24),
                      ExpansionTile(
                        title: Text(
                          'Additional Information (Optional)',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text('Phone, Address, Date of Birth, etc.'),
                        leading: const Icon(Icons.info_outline),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: l10n.phone,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (v) => _phone = v,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: l10n.address,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.home),
                                  ),
                                  maxLines: 2,
                                  onChanged: (v) => _address = v,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: l10n.dateOfBirth,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.calendar_today),
                                  ),
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
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: l10n.city,
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(Icons.location_city),
                                        ),
                                        onChanged: (v) => _city = v,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: l10n.country,
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(Icons.public),
                                        ),
                                        onChanged: (v) => _country = v,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    FilledButton(
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
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _isLogin ? l10n.login : l10n.register,
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: loading
                          ? null
                          : () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin ? l10n.createAccount : l10n.haveAccount),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

