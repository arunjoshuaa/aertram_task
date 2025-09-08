import 'package:aetram_task/models/user_model.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio();

  /// Fetches a user profile from a remote API and returns a User object.
  Future<User?> fetchProfile() async {
    try {
      // Make the GET request to the API endpoint
      final response = await _dio.get("https://jsonplaceholder.typicode.com/users?id=3",
      options: Options(
        headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
        }
      )
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // The API returns a list, so we need to access the first element
        // and create a User object from the JSON data.
        final List<dynamic> userDataList = response.data;
        if (userDataList.isNotEmpty) {
          final userJson = userDataList.first as Map<String, dynamic>;
          final user = User.fromJson(userJson);
          print('Successfully fetched user: ${user.name}');
          return user;
        }
      }
      return null;
    } on DioException catch (e) {
      // Handle Dio-specific errors (e.g., network issues, bad status codes)
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
      return null;
    } catch (e) {
      // Handle other potential errors
      print('An unexpected error occurred: $e');
      return null;
    }
  }
}