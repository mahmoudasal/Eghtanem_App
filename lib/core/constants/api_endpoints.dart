class ApiEndpoints {
  static const baseUrl = 'https://eghtanem.testworks.top/public/api/';

  static const register = '$baseUrl/register';
  static const login = '$baseUrl/login';
  static const logout = '$baseUrl/logout';
  static const videos = '$baseUrl/videos';
  static String videoDetails(int id) => '$baseUrl/videos/$id';
  static String videoComments(int id) => '$baseUrl/videos/$id/comments';
  static String videoLikes(int id) => '$baseUrl/videos/$id/like';
}
