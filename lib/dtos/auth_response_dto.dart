import 'package:jwt_decoder/jwt_decoder.dart';

class AuthResponseDto {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String userId;
  final String name;
  final String email;

  AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.userId,
    required this.name,
    required this.email,
  });


  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final String token = json['access_token'];
    

    Map<String, dynamic> payload = JwtDecoder.decode(token);

    return AuthResponseDto(
      accessToken: token,
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
      userId: payload['sub'] ?? "",
      name: payload['name'] ?? "Usuário",
      email: payload['email'] ?? "",
    );
  }
}