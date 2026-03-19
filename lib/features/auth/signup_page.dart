import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_service.dart';
import '../dashboard/dashboard_page.dart';

@immutable
class SignupFormState {
  const SignupFormState({
    this.loading = false,
    this.hidePassword = true,
    this.hideConfirmPassword = true,
    this.nameError,
    this.emailError,
    this.passError,
    this.confirmPassError,
  });

  final bool loading;
  final bool hidePassword;
  final bool hideConfirmPassword;
  final String? nameError;
  final String? emailError;
  final String? passError;
  final String? confirmPassError;

  SignupFormState copyWith({
    bool? loading,
    bool? hidePassword,
    bool? hideConfirmPassword,
    String? nameError,
    String? emailError,
    String? passError,
    String? confirmPassError,
    bool clearNameError = false,
    bool clearEmailError = false,
    bool clearPassError = false,
    bool clearConfirmPassError = false,
  }) {
    return SignupFormState(
      loading: loading ?? this.loading,
      hidePassword: hidePassword ?? this.hidePassword,
      hideConfirmPassword: hideConfirmPassword ?? this.hideConfirmPassword,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passError: clearPassError ? null : (passError ?? this.passError),
      confirmPassError: clearConfirmPassError
          ? null
          : (confirmPassError ?? this.confirmPassError),
    );
  }
}

class SignupFormController extends StateNotifier<SignupFormState> {
  SignupFormController() : super(const SignupFormState());

  void togglePasswordVisibility() {
    state = state.copyWith(hidePassword: !state.hidePassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(hideConfirmPassword: !state.hideConfirmPassword);
  }

  bool validate({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedConfirmPassword = confirmPassword.trim();

    final nameError = trimmedName.isEmpty ? 'Name is required' : null;
    final emailError = trimmedEmail.isEmpty
        ? 'Email is required'
        : !_validateEmail(trimmedEmail)
            ? 'Invalid email format'
            : null;
    final passError = trimmedPassword.isEmpty
        ? 'Password is required'
        : !_validatePassword(trimmedPassword)
            ? 'Min 8 chars, 1 A-Z, 1 a-z, 1 number'
            : null;
    final confirmPassError = trimmedConfirmPassword.isEmpty
        ? 'Confirm password is required'
        : trimmedPassword != trimmedConfirmPassword
            ? 'Passwords do not match'
            : null;

    state = state.copyWith(
      nameError: nameError,
      emailError: emailError,
      passError: passError,
      confirmPassError: confirmPassError,
    );

    return nameError == null &&
        emailError == null &&
        passError == null &&
        confirmPassError == null;
  }

  void setLoading(bool loading) {
    state = state.copyWith(loading: loading);
  }

  void clearErrors() {
    state = state.copyWith(
      clearNameError: true,
      clearEmailError: true,
      clearPassError: true,
      clearConfirmPassError: true,
    );
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String pass) {
    return pass.length >= 8 &&
        pass.contains(RegExp(r'[A-Z]')) &&
        pass.contains(RegExp(r'[a-z]')) &&
        pass.contains(RegExp(r'[0-9]'));
  }
}

final signupFormProvider =
    StateNotifierProvider.autoDispose<SignupFormController, SignupFormState>(
  (ref) => SignupFormController(),
);

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});
  static const routeName = '/signup';

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final controller = ref.read(signupFormProvider.notifier);
    final isValid = controller.validate(
      name: nameCtrl.text,
      email: emailCtrl.text,
      password: passCtrl.text,
      confirmPassword: confirmPassCtrl.text,
    );
    if (!isValid) {
      return;
    }

    controller.setLoading(true);
    try {
      await ApiService.signup(
        nameCtrl.text.trim(),
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Signup successful! Redirecting..."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Signup failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        controller.setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signupFormProvider);
    final controller = ref.read(signupFormProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create account'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add,
                    size: 72, color: Color(0xFFFFB300)),
                const SizedBox(height: 12),
                Text(
                  'Create your DevLog account',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Name
                TextField(
                  controller: nameCtrl,
                  enabled: !formState.loading,
                  onChanged: (_) => controller.clearErrors(),
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: const Icon(Icons.person_outline),
                    errorText: formState.nameError,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: emailCtrl,
                  enabled: !formState.loading,
                  onChanged: (_) => controller.clearErrors(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorText: formState.emailError,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: passCtrl,
                  enabled: !formState.loading,
                  onChanged: (_) => controller.clearErrors(),
                  obscureText: formState.hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        formState.hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    errorText: formState.passError,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    helperText: formState.passError == null
                        ? 'Min 8 chars, 1 uppercase, 1 lowercase, 1 number'
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextField(
                  controller: confirmPassCtrl,
                  enabled: !formState.loading,
                  onChanged: (_) => controller.clearErrors(),
                  obscureText: formState.hideConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        formState.hideConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                    errorText: formState.confirmPassError,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: formState.loading ? null : signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB300),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: formState.loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : const Text('Sign up',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                ),

                const SizedBox(height: 12),
                TextButton(
                  onPressed:
                      formState.loading ? null : () => Navigator.pop(context),
                  child: const Text('Back to login',
                      style: TextStyle(color: Colors.black54)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
