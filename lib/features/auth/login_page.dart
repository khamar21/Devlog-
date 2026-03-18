import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_service.dart';
import '../dashboard/dashboard_page.dart';
import 'signup_page.dart';

@immutable
class LoginFormState {
  const LoginFormState({
    this.loading = false,
    this.showPassword = false,
    this.emailError,
    this.passError,
  });

  final bool loading;
  final bool showPassword;
  final String? emailError;
  final String? passError;

  LoginFormState copyWith({
    bool? loading,
    bool? showPassword,
    String? emailError,
    String? passError,
    bool clearEmailError = false,
    bool clearPassError = false,
  }) {
    return LoginFormState(
      loading: loading ?? this.loading,
      showPassword: showPassword ?? this.showPassword,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passError: clearPassError ? null : (passError ?? this.passError),
    );
  }
}

class LoginFormController extends StateNotifier<LoginFormState> {
  LoginFormController() : super(const LoginFormState());

  void toggleShowPassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void setLoading(bool loading) {
    state = state.copyWith(loading: loading);
  }

  void clearErrors() {
    state = state.copyWith(clearEmailError: true, clearPassError: true);
  }

  bool validate(String email, String password) {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    final emailError = trimmedEmail.isEmpty ? 'Please enter your email' : null;
    final passError =
        trimmedPassword.isEmpty ? 'Please enter your password' : null;

    state = state.copyWith(emailError: emailError, passError: passError);
    return emailError == null && passError == null;
  }
}

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormController, LoginFormState>(
  (ref) => LoginFormController(),
);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Prefill demo credentials for faster testing (remove if not needed)
    emailCtrl.text = 'test@local';
    passCtrl.text = 'Password123!';
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final controller = ref.read(loginFormProvider.notifier);
    if (!controller.validate(emailCtrl.text, passCtrl.text)) {
      return;
    }

    controller.setLoading(true);
    try {
      await ApiService.login(emailCtrl.text.trim(), passCtrl.text.trim());
      if (!mounted) return;

      // Success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful")),
      );

      // Navigate without relying on named routes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        controller.setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider);
    final controller = ref.read(loginFormProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.code, size: 80, color: Color(0xFFFFB300)),
                const SizedBox(height: 16),
                Text(
                  "Welcome, DevLog!",
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign in to access your dashboard",
                  style:
                      textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Email Field
                TextField(
                  controller: emailCtrl,
                  enabled: !formState.loading,
                  onChanged: (_) => controller.clearErrors(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email or Username",
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorText: formState.emailError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: passCtrl,
                  enabled: !formState.loading,
                  onChanged: (_) => controller.clearErrors(),
                  obscureText: !formState.showPassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(formState.showPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: controller.toggleShowPassword,
                    ),
                    errorText: formState.passError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: formState.loading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB300),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: formState.loading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("Login",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 12),

                // Demo Login shortcut
                TextButton(
                  onPressed: formState.loading
                      ? null
                      : () {
                          emailCtrl.text = 'test@local';
                          passCtrl.text = 'Password123!';
                          login();
                        },
                  child:
                      const Text("Use demo login (test@local / Password123!)"),
                ),
                const SizedBox(height: 16),

                // Forgot Password (optional)
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),

                // Signup Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color(0xFFFFB300),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
