import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/app_shared.dart';
import 'package:flutter_application_1/components/back_btn.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/controllers/home_ctrl.dart';
import 'package:flutter_application_1/models/model.dart';
import 'package:flutter_application_1/services/data_service.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

Random random = Random();

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late final ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final HomeCtrl ctrl = Get.put(HomeCtrl());

  @override
  void initState() {
    super.initState();
    scr = ScrollController();
    scr.addListener(() {
      if (scr.position.pixels == scr.position.maxScrollExtent) {
        loadMore();
      }
    });
    load();
  }

  @override
  void dispose() {
    scr.removeListener(() { });
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.init();
      ctrl.setIsLoading(true);
      List<PhotoList> lx = await getPhotoList(ctrl.page, kPageSize);
      ctrl.setList(lx);
      ctrl.setIsLoading(false);
    }
    
    on DioError catch (_) {
      ctrl.setIsLoading(false);
    }
  }

  void loadMore() async {
    int p = ctrl.page + 1;
    try {
      if (ctrl.isLoadingMore) return;
      ctrl.setIsLoadingMore(true);
      List<PhotoList> lx = await getPhotoList(p, kPageSize);
      if (lx.isEmpty) {
        ctrl.setIsLoadingMore(false);
        return;
      }

      ctrl.setPage(p);
      ctrl.setList(lx);
      ctrl.setIsLoadingMore(false);
    }
    
    on DioError catch (_) {
      ctrl.setIsLoadingMore(false);
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  int get credit {
    int n = random.nextInt(101) + 10;
    return n;
  }

  Widget buildContent(PhotoList o) {
    int credit = this.credit;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withOpacity(0.3),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0), // Image border
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(48.0), // Image radius
                    child: Image.network(
                      o.downloadUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        o.author,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '$credit',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              int n = ctrl.credit;
                              if (n >= credit) {
                                ctrl.setCredit(n - credit);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5.0,
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(100.0, 32.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                            ),
                            child: Text(
                              'Purchase',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          IconButton(
                            onPressed: () {
                              
                            },
                            icon: Icon(
                              Icons.star,
                              color: Colors.red[500],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    return ListView.builder(
      controller: scr,
      shrinkWrap: true,
      itemCount: ctrl.list.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() =>
              Text(
                'My Credit: ${ctrl.credit}',
                style: kTextStyle1.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: kTextColor1,
                ),
              ),
            ),
          );
        }

        else if (index == ctrl.list.length + 1) {
          return Obx(() => ctrl.isLoadingMore ? const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
              child: AppLoadMoreIndicator(),
          ) : Container());
        }

        return buildContent(ctrl.list[index - 1]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        backgroundColor: kBgColor1,
        centerTitle: true,
        title: Text(
          'Home',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        elevation: 2.0,
      ),
      backgroundColor: kBgColor1,
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            progressIndicator: const AppActivityIndicator(),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: Scrollbar(
                child: buildList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}