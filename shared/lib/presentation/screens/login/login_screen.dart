import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/presentation/blocs/authentication_bloc/authentication_bloc.dart';

import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is LoggedIn) {
          // Navigate to "/home" after login (for both apps)
          context.go('/home');
        } else if (state is LoginFailed) {
          // Show error message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: ModalScreen(
        title: 'Welcome!',
        subtitle: 'Sign in to continue',
        isLogin: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationBloc>().add(LogIn());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E1C36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sign in',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Or sign in with', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navigate to SignUp
              },
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                  color: Color(0xFF00B9AE),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
