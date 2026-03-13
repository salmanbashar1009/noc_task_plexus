import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noc_task_plexus/presentation/sharedwidget/primary_button.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  final AuthState state;

  const LoginForm({super.key, required this.state});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmailField(context),
          const SizedBox(height: 16),
          _buildPasswordField(context),
          const SizedBox(height: 32),
          PrimaryButton(
            onPressed: widget.state is AuthLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<AuthBloc>(context).add(
                        LoginButtonPressed(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ),
                      );
                    }
                  },
            isLoading: widget.state is AuthLoading,
            text: 'LOGIN',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: emailController,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: _inputDecoration(
        context,
        'Email Address',
        Icons.email_outlined,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter email';
        if (!value.contains('@')) return 'Please enter a valid email';
        return null;
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: _inputDecoration(context, 'Password', Icons.lock_outline),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter password';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String hint,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600]),
      prefixIcon: Icon(
        icon,
        color: isDark ? Colors.grey[500] : Colors.grey[600],
      ),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: isDark
            ? BorderSide.none
            : BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: isDark
            ? BorderSide.none
            : BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
    );
  }
}
