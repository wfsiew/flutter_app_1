import 'package:flutter_application_1/models/model.dart';
import 'package:get/get.dart';

class HomeCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _list = <PhotoList>[].obs;
  final _credit = 1000.obs;

  void init() {
    setPage(1);
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsLoadingMore(bool b) {
    _isLoadingMore.value = b;
  }

  void setPage(int i) {
    _page.value = i;
  }

  void setList(List<PhotoList> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  void setCredit(int n) {
    _credit.value = n;
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  int get credit => _credit.value;
  List<PhotoList> get list => [..._list];
}