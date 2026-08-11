import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(SignInEmailRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is Authenticated) {
            context.go('/matches');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F1419), Color(0xFF1A1F2E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E8B47), Color(0xFF1A5F2A)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1A5F2A).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.sports_soccer, size: 40, color: Colors.white),
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 40),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue predicting',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF8B95A5),
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF8B95A5)),
                        filled: true,
                        fillColor: const Color(0xFF252B3B),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Color(0xFF5A6578)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        if (!value.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF8B95A5)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF8B95A5),
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF252B3B),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Color(0xFF5A6578)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        if (value.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF00B4D8))),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A5F2A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                        ),
                        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _SocialButton(
                            icon: Icons.g_mobiledata,
                            label: 'Google',
                            color: Colors.red,
                            onTap: () => context.read<AuthBloc>().add(SignInGoogleRequested()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SocialButton(
                            icon: Icons.apple,
                            label: 'Apple',
                            color: Colors.white,
                            onTap: () => context.read<AuthBloc>().add(SignInAppleRequested()),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                    const SizedBox(height: 32),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/register'),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.white.withOpacity(0.5)),
                            children: const [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Color(0xFF00B4D8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF252B3B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
