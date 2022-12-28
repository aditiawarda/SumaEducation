// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/main.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_revision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;
String? NoRegProp = "";
String? NoProposal = "";
String? JudulProposal = "";
String? TglProposal = "0000-00-00";
String? TargetPemenuhan = "0000-00-00";
String? StatusProposal = "0";
String? NilaiPeluang = "0000000";
String? AlamatCustomer = "";
String? NilaiPembelian = "0000000";
String? StatusCustomer = "";
String? IdCustomer = "";

class ProposalDetailMain extends StatefulWidget {
  const ProposalDetailMain(
      {Key? key,
        this.mainScreenAnimationController,
        this.mainScreenAnimation,
        this.idProposal,
        this.noRegProposal,
        this.noProposal,
        this.judulProposal,
        this.tanggalProposal,
        this.targetPemenuhan,
        this.statusProposal,
        this.NoSP,
        this.NamaCustomer,
        this.TotalSP,
        this.JumlahParsial,
        this.Keterangan,
        this.JenisPekerjaan,
        this.Cabang,
        this.WilayahCustomer,
        this.NilaiPeluang,
        this.AlamatCustomer,
        this.NilaiPembelian,
        this.StatusCustomer,
        this.IdCustomer,

      })
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idProposal;
  final String? noRegProposal;
  final String? noProposal;
  final String? judulProposal;
  final String? tanggalProposal;
  final String? targetPemenuhan;
  final String? statusProposal;
  final String? NoSP;
  final String? NamaCustomer;
  final String? TotalSP;
  final String? JumlahParsial;
  final String? Keterangan;
  final String? JenisPekerjaan;
  final String? Cabang;
  final String? WilayahCustomer;
  final String? NilaiPeluang;
  final String? AlamatCustomer;
  final String? NilaiPembelian;
  final String? StatusCustomer;
  final String? IdCustomer;

  @override
  _ProposalDetailMainState createState() => _ProposalDetailMainState();
}

class _ProposalDetailMainState extends State<ProposalDetailMain>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    print("hello "+widget.noProposal!);
    super.initState();
  }

  Future<String> getUser() async {
    prefs = await _prefs;
    print(prefs!.getString('IdUser'));
    return 'true';
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final width = fullWidth * 0.5 / 2;
    int number = 20000;
    int decimalDigit = 2;
    return
      FadeInUp(
          delay : Duration(milliseconds: 500),
          child : AnimatedBuilder(
            animation: widget.mainScreenAnimationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.mainScreenAnimation!,
                child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 32, bottom: 15),
                    child:
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          if(widget.statusProposal=='3')...{
                            HexColor("#24a831"),
                            HexColor("#8adb92"),
                          } else if(widget.statusProposal=='2') ...{
                            HexColor("#FA7D82"),
                            HexColor("#FFB295"),
                          } else if(widget.statusProposal=='1') ...{
                            HexColor("#bc83ef"),
                            HexColor("#c1a5d9"),
                          } else if(widget.statusProposal=='0') ...{
                            HexColor("#187cb4"),
                            HexColor("#7cc5ee"),
                          } else if(widget.statusProposal=='6') ...{
                            HexColor("#c5a427"),
                            HexColor("#e7d388"),
                          } else if(widget.statusProposal=='5') ...{
                            HexColor("#827a78"),
                            HexColor("#bab7b5"),
                          }
                        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(50.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.3),
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 3.0),
                        ],
                      ),
                      child:
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                  child: Text(
                                    'No Reg',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                      AppTheme.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1, left: 7, right: 7, bottom: 7),
                                  child: Text(
                                    widget.noRegProposal!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                  child: Text(
                                    'No Proposal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                      AppTheme.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                  child: Text(
                                    widget.noProposal!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
                                  child: Text(
                                    'Judul',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                      AppTheme.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 7, right: 7, bottom: 5),
                                  child: Text(widget.judulProposal!,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 19,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 6, top: 8, bottom: 5),
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7, right: 7, top: 2, bottom: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                'Cabang',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  AppTheme.white.withOpacity(0.5),
                                                ),
                                              ),
                                            ),

                                            if(widget.Cabang=="JKT")...{
                                              Text(
                                                widget.Cabang!+"  |  "+widget.WilayahCustomer!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            } else ...{
                                              Text(
                                                widget.Cabang!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            }

                                          ],
                                        ) ,
                                      ),
                                      Container(
                                        width: width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                'Tanggal Pengajuan',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: AppTheme.white
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              widget.tanggalProposal!.substring(8,10)+"/"+widget.tanggalProposal!.substring(5,7)+"/"+widget.tanggalProposal!.substring(0,4),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                letterSpacing: -0.2,
                                                color: AppTheme.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 6, top: 5, bottom: 5),
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7, right: 7, top: 2, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                'Tipe Pengajuan',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  AppTheme.white.withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            //dani
                                            if(widget.JenisPekerjaan=='1')...{
                                              Text(
                                                'PROMOSI',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            } else if(widget.JenisPekerjaan=='2')...{
                                              Text(
                                                'DISKON',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            } else if(widget.JenisPekerjaan=='3')...{
                                              Text(
                                                'INSENTIF',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            } else if(widget.JenisPekerjaan=='4')...{
                                              Text(
                                                'NEGO HARGA',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            } else if(widget.JenisPekerjaan=='5')...{
                                              Text(
                                                'NEGO JADWAL PENGIRIMAN',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            }

                                          ],
                                        ) ,
                                      ),
                                      Container(
                                        width: width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                'Kategori',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: AppTheme.white
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),

                                            if(widget.StatusCustomer=='1')...{
                                              Text(
                                                'Customer Lama',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            } else if(widget.StatusCustomer=='2')...{
                                              Text(
                                                'Calon Customer',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            } else ...{
                                              Text(
                                                '-',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            }

                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 6, top: 2, bottom: 5),
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                  child: Text(
                                    'Nama Customer',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                      AppTheme.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                  child: Text(
                                    widget.NamaCustomer!,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                                  child: Text(
                                    'Alamat Customer',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                      AppTheme.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                  child: Text(
                                    widget.AlamatCustomer!,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),

                                if(widget.IdCustomer!='-')...{
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                                    child: Text(
                                      'Id Customer',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                        AppTheme.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                    child: Text(
                                      widget.IdCustomer!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                },

                                if(widget.NilaiPembelian!="0")...{
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                                    child: Text(
                                      'Nilai Pembelian',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                        AppTheme.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                    child: Text(
                                      'Rp. '+NumberFormat.currency(locale: 'eu').format(int.parse(widget.NilaiPembelian!)).substring(0, NumberFormat.currency(locale: 'eu').format(int.parse(widget.NilaiPembelian!)).length-7),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                },

                                if(widget.StatusCustomer=='1')...{
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6, right: 6, top: 10, bottom: 5),
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: AppTheme.background.withOpacity(0.5),
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                    child: Text(
                                      'No SP',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                        AppTheme.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  if(widget.NoSP=="")...{
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                      child: Text(
                                        "-",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ),
                                  }else...{
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                      child: Text(
                                        widget.NoSP!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ),
                                  },
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, left: 7, right: 7),
                                    child: Text(
                                      'Total Rupiah SP',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                        AppTheme.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3, left: 7, right: 7),
                                    child: Column(
                                      children: [
                                        if(widget.TotalSP=="0"||widget.TotalSP==""||widget.TotalSP==null||widget.TotalSP=="null")...{
                                          Text(
                                            "-",
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        } else ...{
                                          Text(
                                            'Rp. '+widget.TotalSP!,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        },
                                      ],
                                    ),
                                  ),
                                },

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 6, top: 10, bottom: 5),
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7, right: 7, top: 2, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                'Nilai Peluang',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: AppTheme.white
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            if(widget.NilaiPeluang=="0"||widget.NilaiPeluang==""||widget.NilaiPeluang==null||widget.NilaiPeluang=="null")...{
                                              Text(
                                                "-",
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            } else ...{
                                              Text(
                                                'Rp. '+widget.NilaiPeluang!,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            },
                                          ],
                                        ) ,
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                'Tarhet Pemenuhan',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  AppTheme.white.withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              widget.targetPemenuhan!.substring(8,10)+"/"+widget.targetPemenuhan!.substring(5,7)+"/"+widget.targetPemenuhan!.substring(0,4),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                letterSpacing: -0.2,
                                                color: AppTheme.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 6, top: 10, bottom: 5),
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4, left: 7, right: 7),
                                  child: Text(
                                    'Keterangan',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                      AppTheme.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                  child: Text(
                                    widget.Keterangan!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          if(widget.statusProposal=='3')...{
                            Positioned(
                              top: 20,
                              right: 20,
                              child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child:
                                  Stack(
                                    children: [
                                      Image.asset('assets/suma_education/approved_2.png'),
                                    ],
                                  )
                              ),
                            ),
                          } else if(widget.statusProposal=='5')...{
                            Positioned(
                              top: 20,
                              right: 20,
                              child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child:
                                  Stack(
                                    children: [
                                      Image.asset('assets/suma_education/rejected_2.png'),
                                    ],
                                  )
                              ),
                            ),
                          }
                        ],
                      )
                    ),
                  ),
                ),
              );
            },
          )
      );
  }
}
