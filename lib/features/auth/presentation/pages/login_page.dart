import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/theme/presentation/bloc/theme_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacementNamed('/dashboard');
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 48),
                        _buildEmailField(context),
                        const SizedBox(height: 16),
                        _buildPasswordField(context),
                        const SizedBox(height: 32),
                        _buildLoginButton(context, state),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: theme.brightness == Brightness.light
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Icon(
            Icons.wifi_tethering,
            size: 48,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Plexus NOC",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Network Operations Center",
          style: TextStyle(
            fontSize: 14,
            color: theme.brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: emailController,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: _inputDecoration(context, 'Email Address', Icons.email_outlined),
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

  InputDecoration _inputDecoration(BuildContext context, String hint, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600]),
      prefixIcon: Icon(icon, color: isDark ? Colors.grey[500] : Colors.grey[600]),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: isDark ? BorderSide.none : BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: isDark ? BorderSide.none : BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthState state) {
    final theme = Theme.of(context);
    return MaterialButton(
      onPressed: state is AuthLoading
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
      color: theme.colorScheme.primary,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: state is AuthLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'LOGIN',
              style: TextStyle(
                color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    );
  }
}
