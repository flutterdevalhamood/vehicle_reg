// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';
// import 'package:sample/src/constants/api_constants.dart';
//
// var dio = Dio();
// var restApi = RestClient(dio);
//
// @RestApi(baseUrl: apiEndPoint)
// abstract class RestClient {
//   factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
//
//   @GET('/metadata')
//   Future<dynamic> getMetaData();
//
//   // @POST('/login')
//   // Future<dynamic> login({
//   //   @Field("type") String? type,
//   //   @Field("email") String? email,
//   //   @Field("password") String? password,
//   //   @Field("mobile_number") String? mobileNumber,
//   // });
//
//   // @FormUrlEncoded()
//   // @POST('/update-info')
//   // Future<dynamic> updateCandidateProfile({
//   //   @Part(name: "type") String? type,
//   //   @Part(name: "uid") String? uid,
//   //   @Part(name: "full_name") String? fullName,
//   //   @Part(name: "email") String? email,
//   //   @Part(name: "image") File? image,
//   //   @Part(name: "resume") File? resume,
//   //   @Part(name: "mobile_number") String? mobileNumber,
//   //   @Part(name: "linkedin_profile") String? linkedinProfile,
//   //   @Part(name: "district") String? district,
//   //   @Part(name: "qualification") String? qualification,
//   //   @Part(name: "experience") String? experience,
//   //   @Part(name: "area_of_expertise[]") List<String>? areaOfExpertise,
//   // });
//
//   // @GET('/total-openings')
//   // Future<dynamic> getTotalOpenings();
// }
