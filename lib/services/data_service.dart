import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/model.dart';

import 'api_helper.dart';

Future<List<PhotoList>> getPhotoList(num page, num limit) async {
  List<PhotoList> lx;

  try {
    final q = {
      'page': page,
      'limit': limit
    };
    final res = await ApiHelper.dio.get('$kServerUrl/v2/list', queryParameters: q);
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    final ls = res.data as List? ?? [];
    lx = ls.map((x) => PhotoList.fromJson(x)).toList();
  }

  catch (_) {
    rethrow;
  }

  return lx;
}