
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}/// Base class for authentication states

class AuthInitial extends AuthState {} /// Initial state when the app starts

class AuthLoading extends AuthState {}/// State when authentication is in progress

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}/// State when the user is authenticated

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}/// State when there is an error during authentication
