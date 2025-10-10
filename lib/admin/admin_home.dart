import 'dart:developer' as developer;

import 'package:diary/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableModel {
  final String name; // actual DB table name
  final String label; // user-friendly label
  final IconData icon; // icon to display in the NavigationRail
  final List<String> columns; // list of column names (fallback)
  final List<PlutoColumn>? plutoColumns; // optional: rich PlutoGrid columns
  final String primaryKey; // primary key column used for updates
  final String description; // optional: for tooltips or help text

  const TableModel({
    required this.name,
    required this.label,
    required this.icon,
    required this.columns,
    this.plutoColumns,
    this.primaryKey = 'id',
    this.description = '',
  });

  /// Build PlutoColumns if not explicitly provided, from simple column names.
  List<PlutoColumn> buildPlutoColumns() {
    if (plutoColumns != null && plutoColumns!.isNotEmpty) return plutoColumns!;
    return columns
        .map(
          (c) => PlutoColumn(
            title: c,
            field: c,
            type: PlutoColumnType.text(),
            readOnly: c == primaryKey,
            enableRowDrag: false,
            enableDropToResize: true,
            enableEditingMode: c != primaryKey,
            frozen: c == primaryKey
                ? PlutoColumnFrozen.start
                : PlutoColumnFrozen.none,
            width: c == primaryKey ? 140 : 180,
          ),
        )
        .toList();
  }
}

final List<TableModel> databaseTables = [
  TableModel(
    name: 'profiles',
    label: 'Profiles',
    icon: Icons.person,
    columns: ['id', 'username', 'role'],
    primaryKey: 'id',
    description: 'User profiles and roles for admin access!',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        // readOnly: true,
        // frozen: PlutoColumnFrozen.start,
        width: 160,
      ),
      PlutoColumn(
        title: 'Username',
        field: 'username',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Role',
        field: 'role',
        type: PlutoColumnType.select(['admin', 'editor', 'user']),
      ),
    ],
  ),
  TableModel(
    name: 'academy_deanfaculty',
    label: 'Dean Faculty',
    icon: Icons.school,
    columns: ['id', 'faculty', 'department'],
    primaryKey: 'id',
    description: 'Dean faculties and departments',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.select(<String>[
          'কম্পিউটার সায়েন্স এন্ড ইঞ্জিনিয়ারিং',
          'এগ্রিকালচার',
          'বিজনেস এডমিনিস্ট্রেশন',
          'এনিমাল সায়েন্স এন্ড ভেটেরিনারি মেডিসিন',
          'ফিশারিজ',
          'এনভায়রনমেন্টাল সায়েন্স এন্ড ডিজাস্টার ম্যানজমেন্ট',
          'নিউট্রেশন এন্ড ফুড সায়েন্স',
          'ল এন্ড ল্যান্ড এডমিনিস্ট্রেশন',
          'পোস্টগ্র্যাজুয়েট স্টাডিজ',
        ]),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.select(<String>['ডিন অফিস', 'ডিন']),
      ),
    ],
  ),
  TableModel(
    name: 'academy_deanoffice',
    label: 'Dean Office',
    icon: Icons.account_balance,
    columns: [
      'id',
      'name',
      'phone_number',
      'email',
      'designation',
      'faculty',
      'priority',
      'department_id',
    ],
    primaryKey: 'id',
    description: 'Dean office contacts',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Phone',
        field: 'phone_number',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.select(<String>[
          'সেকশন অফিসার',
          'সহকারী রেজিস্ট্রার',
          'উপ-পরিচালক',
          'ডেপুটি রেজিস্ট্রার',
          'ডিন',
        ]),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.select(<String>[
          'কম্পিউটার সায়েন্স এন্ড ইঞ্জিনিয়ারিং',
          'এগ্রিকালচার',
          'বিজনেস এডমিনিস্ট্রেশন',
          'এনিমাল সায়েন্স এন্ড ভেটেরিনারি মেডিসিন',
          'ফিশারিজ',
          'এনভায়রনমেন্টাল সায়েন্স এন্ড ডিজাস্টার ম্যানজমেন্ট',
          'নিউট্রেশন এন্ড ফুড সায়েন্স',
          'ল এন্ড ল্যান্ড এডমিনিস্ট্রেশন',
          'পোস্টগ্র্যাজুয়েট স্টাডিজ',
        ]),
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
    ],
  ),
  TableModel(
    name: 'academy_department',
    label: 'Academy Departments',
    icon: Icons.apartment,
    columns: ['id', 'faculty', 'department'],
    primaryKey: 'id',
    description: 'Departments under academic faculties',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.select(<String>[
          'কম্পিউটার সায়েন্স এন্ড ইঞ্জিনিয়ারিং',
          'এগ্রিকালচার',
          'বিজনেস এডমিনিস্ট্রেশন',
          'এনিমাল সায়েন্স এন্ড ভেটেরিনারি মেডিসিন',
          'ফিশারিজ',
          'এনভায়রনমেন্টাল সায়েন্স এন্ড ডিজাস্টার ম্যানজমেন্ট',
          'নিউট্রেশন এন্ড ফুড সায়েন্স',
          'ল এন্ড ল্যান্ড এডমিনিস্ট্রেশন',
          'পোস্টগ্র্যাজুয়েট স্টাডিজ',
        ]),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.select(<String>[
          'জিওমেটিক্স',
          'ফুুড টেকনোলজি এন্ড ইঞ্জিনিয়ারিং',
          'সয়েল সায়েন্স',
          'কম্পিউটার এন্ড কমিউনিকেশন ইঞ্জিনিয়ারিং',
          'ফিশারিজ ম্যানেজমেন্ট',
          'ফিজিওলজি এন্ড ফার্মাকোলজি বিভাগ',
          'ডিজাস্টার রেজিলিয়েন্স এন্ড ইন্জিনিয়ারিং ',
          'মেরিন ফিশারিজ এন্ড ওসানোগ্রাফি',
          'মেডিসিন, সার্জারি এন্ড অবস্টেট্রিক্স',
          'বায়োকেমিস্ট্রি এন্ড ফুড এনালাইসিস',
          'স্ট্যাটিসটিক্স',
          'প্লান্ট প্যাথলজি',
          'বায়োটেকনোলজি',
          'এনাটমি এন্ড হিস্টোলজি',
          'ডিজাস্টার রিস্ক ম্যানজমেন্ট',
          'ম্যানেজমেন্ট স্টাডিজ',
          'হিউম্যান নিউট্রিশন এন্ড ডাইটেটিক্স',
          'ফিজিক্স এন্ড মেকানিক্যাল ইঞ্জিনিয়ারিং',
          'এগ্রোনমি',
          'ক্লাইমেট স্মার্ট এগ্রিকালচার',
          'ইকোনোমিক্স এন্ড সোসিওলজি',
          'ফুড মাইক্রোবায়োলজি',
          'জিও ইনফরমেশন সায়েন্স এন্ড আর্থ অবজারভেশন',
          'ফিশারিজ টেকনোলজি',
          'ল্যান্ড পলিসি এন্ড ল',
          'এগ্রিকালচারাল কেমিস্ট্রি',
          'ভেটেরেনারি ক্লিনিক',
          'ডেইরি সায়েন্স',
          'প্যাথলজি এন্ড প্যারাসাইটোলজি',
          'ল\' এন্ড ল্যান্ড এডমিনিস্ট্রেশন',
          'ফিশারিজ বায়োলজি এন্ড জেনেটিক্স',
          'ম্যাথমেটিক্স',
          'ফিন্যান্স এন্ড ব্যাংকিং',
          'জেনেটিক্স এন্ড এনিমাল ব্রিডিং',
          'এনভায়রনমেন্টাল স্যানিটেশন',
          'মার্কেটিং',
          'এগ্রিকালচারাল বোটানি',
          'ল্যান্ড রেকর্ড এন্ড ট্রান্সফরমেশন',
          'ল্যান্ড এডমিনিস্ট্রেশন',
          'জেনারেল এনিমাল সায়েন্স এন্ড এনিমাল নিউট্রিশন',
          'মাইক্রোবায়োলজি এন্ড পাবলিক হেলথ',
          'জেনেটিক্স এন্ড প্লান্ট ব্রিডিং ',
          'এনভায়রনমেন্টাল সায়ন্স',
          'এ্যানিমাল সায়েন্স',
          'একাউন্টিং এন্ড ইনফরমেশন সিস্টেমস',
          'এগ্রিকালচারাল এক্সটেনশন এন্ড রুবাল ডেভেলপমেন্ট',
          'হর্টিকালচার',
          'এন্টোমলজি',
          'একুয়াকালচার',
          'কমিউনিটি হেলথ এন্ড হাইজিন',
          'এনিমাল প্রোডাক্টস এন্ড বাই প্রোডাক্টস টেকনোলজি',
          'জিওডেসি',
          'এগ্রিকালচারাল ইঞ্জিনিয়ারিং',
          'ইমার্জেন্সি ম্যানজমেন্ট',
          'এগ্রোফরেস্ট্রি',
          'পোল্ট্রি সায়েন্স',
          'ল্যাংগুয়েজ এন্ড কমিউনিকেশন',
          'বেসিক সায়েন্স',
          'পোস্ট হারভেস্ট টেকনোলজি এন্ড মার্কেটিং',
          'ইলেকট্রিক্যাল এন্ড ইলেকট্রনিক্স ইঞ্জিনিয়ারিং',
          'কম্পিউটার সায়েন্স এন্ড ইনফরমেশন টেকনোলজি',
        ]),
      ),
    ],
  ),
  TableModel(
    name: 'academy_teacher',
    label: 'Teachers',
    icon: Icons.school_outlined,
    columns: [
      'id',
      'name',
      'phone_number',
      'profile_pic',
      'email',
      'designation',
      'faculty_name',
      'priority',
      'department_id',
    ],
    primaryKey: 'id',
    description: 'Teachers directory',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Phone',
        field: 'phone_number',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Profile Pic',
        field: 'profile_pic',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.select(<String>[
          'সেকশন অফিসার',
          'অফিসার ইনচার্জ',
          'সহযোগী অধ্যাপক',
          'অধ্যাপক',
          'প্রশাষনিক কর্মকর্তা',
          'সহকারী অধ্যাপক',
          'উপ-সহকারী খামার তত্ত্বাবধায়ক',
          'উপ-খামার তত্ত্বাবধায়ক',
          'প্রভাষক',
          'চেয়ারম্যান',
        ]),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty_name',
        type: PlutoColumnType.select(<String>[
          'কম্পিউটার সায়েন্স এন্ড ইঞ্জিনিয়ারিং',
          'এগ্রিকালচার',
          'বিজনেস এডমিনিস্ট্রেশন',
          'এনিমাল সায়েন্স এন্ড ভেটেরিনারি মেডিসিন',
          'ফিশারিজ',
          'এনভায়রনমেন্টাল সায়েন্স এন্ড ডিজাস্টার ম্যানজমেন্ট',
          'নিউট্রেশন এন্ড ফুড সায়েন্স',
          'ল এন্ড ল্যান্ড এডমিনিস্ট্রেশন',
          'পোস্টগ্র্যাজুয়েট স্টাডিজ',
        ]),
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
    ],
  ),
  TableModel(
    name: 'academy_staffdepartment',
    label: 'Academy Staff Departments',
    icon: Icons.domain,
    columns: ['id', 'faculty', 'department'],
    primaryKey: 'id',
    description: 'Staff departments under academic faculties',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.select(<String>[
          'কম্পিউটার সায়েন্স এন্ড ইঞ্জিনিয়ারিং',
          'এগ্রিকালচার',
          'বিজনেস এডমিনিস্ট্রেশন',
          'এনিমাল সায়েন্স এন্ড ভেটেরিনারি মেডিসিন',
          'ফিশারিজ',
          'এনভায়রনমেন্টাল সায়েন্স এন্ড ডিজাস্টার ম্যানজমেন্ট',
          'নিউট্রেশন এন্ড ফুড সায়েন্স',
          'ল এন্ড ল্যান্ড এডমিনিস্ট্রেশন',
          'পোস্টগ্র্যাজুয়েট স্টাডিজ',
        ]),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'academy_staff',
    label: 'Academy Staff',
    icon: Icons.people_alt,
    columns: [
      'id',
      'name',
      'phone_number',
      'email',
      'designation',
      'faculty',
      'priority',
      'department_id',
    ],
    primaryKey: 'id',
    description: 'Academic staff directory',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Phone',
        field: 'phone_number',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
    ],
  ),
  TableModel(
    name: 'administration_administrationdepartment',
    label: 'Admin Departments',
    icon: Icons.domain,
    columns: ['id', 'faculty', 'department'],
    primaryKey: 'id',
    description: 'Administration departments',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.select(<String>[
          'ভাইস-চ্যান্সেলর কার্যালয়',
          'আরটিসি',
          'আইসিটি সেল',
          'রেজিস্ট্রার',
          'অর্থ ও হিসাব বিভাগ',
          'কেন্দ্রীয় গ্রন্থাগার',
          'ভাইস-চ্যান্সেলর কার্যালয় ',
          'পরিকল্পনা,উন্নয়ন ও ওয়ার্কস বিভাগ',
          'প্রকৌশল বিভাগ',
          'মাননীয় ভাইস চ্যান্সেলর মহোদয়',
          'রেজিস্ট্রার অফিস',
          'কৃষি খামার',
          'কেন্দ্রীয় গবেষনাগার',
          'পরীক্ষা নিয়ন্ত্রক শাখা',
          'আইকিউএসি',
        ]),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.select(<String>[
          'ক্যাশ ফান্ড এন্ড পেনশন সেকশন',
          'ভাইস-চ্যান্সেলর কার্যালয়',
          'জনসংযোগ ও প্রকাশনা বিভাগ',
          'অডিট সেকশন',
          'প্রকিউরমেন্ট এন্ড স্টোর শাখা',
          'আইসিটি সেল',
          'অর্থ ও হিসাব বিভাগ',
          'প্রো-ভাইস চ্যান্সেলর',
          'সেন্টার ফর রিসার্চ এন্ড ট্রেনিং',
          'তথ্য প্রদান ইউনিট',
          'কেন্দ্রীয় গ্রন্থাগার',
          'শিক্ষা ও বৃত্তি শাখা',
          'একাউন্টস বিল এন্ড সেলারি সেকশন',
          'প্রো-ভাইস চ্যান্সেলর কার্যালয়',
          'পরিকল্পনা,উন্নয়ন ও ওয়ার্কস বিভাগ',
          'বাজেট সেকশন',
          'কৃষি খামার বিভাগ',
          'আইটি সেন্টার',
          'প্রকৌশল বিভাগ',
          'কাউন্সিল এ্যাফেয়ার্স শাখা',
          'ভাইস-চ্যান্সেলর',
          'রেজিস্ট্রার অফিস',
          'ইনস্টিটিউশনাল কোয়ালিটি এসুরেন্স সেল',
          'কেন্দ্রীয় গবেষনাগার',
          'সংস্থাপন শাখা',
          'পরীক্ষা নিয়ন্ত্রক শাখা',
        ]),
      ),
    ],
  ),
  TableModel(
    name: 'administration_administration',
    label: 'Administration',
    icon: Icons.admin_panel_settings,
    columns: [
      'id',
      'name',
      'phone_number',
      'email',
      'designation',
      'faculty_name',
      'priority',
      'department_id',
      'profile_pic',
    ],
    primaryKey: 'id',
    description: 'Administration contacts',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Phone',
        field: 'phone_number',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.select(<String>[
          'পরিচালক(চুক্তি ভিত্তিক)',
          'সহকারী রেজিস্ট্রার',
          'ডেপুটি রেজিস্ট্রার',
          'সহকারী প্রকৌশলী(সিভিল)',
          'নির্বাহী প্রকৌশলী(সিভিল)',
          'সহকারী নেটওয়ার্ক ইঞ্জিনিয়ার',
          'ডেপুটি রেজিস্ট্রার(সান্ধ্য অফিস)',
          'ভাইস-চ্যান্সেলর',
          'সেকশন অফিসার',
          'পরীক্ষা নিয়ন্ত্রক (অ.দা)',
          'পরিচালক(ভারপ্রাপ্ত)',
          'অফিসার ইন-চার্জ',
          'উপ-পরীক্ষা নিয়ন্ত্রক',
          'গ্রন্থাগারিক(অ.দা)',
          'অডিট এন্ড একাউন্টস অফিসার',
          'প্রশাসনিক কর্মকর্তা',
          'উপ-খামার তত্তাবধায়ক',
          'নেটওয়ার্ক এডমিনিস্ট্রেটর',
          'সিনিয়ার রিসার্চ অফিসার',
          'সহকারী প্রকৌশলী (সিভিল)',
          'পরিচালক',
          'রেজিস্ট্রার (অ. দা. )',
          'অতিরিক্ত পরিচালক',
          'নির্বাহী প্রকৌশলী(ইলেকট্রিক্যাল)',
          'উপ-গ্রন্থাগারিক',
          'ডকুমেন্টেশন অফিসার',
          'প্রধান খামার তত্তাবধায়ক(অ.দা.)',
          'ডাটাবেস এডমিনিস্ট্রেটর',
          'উপ-পরিচালক',
          'সহকারী প্রকৌশলী (বিদ্যুৎ)',
          'সহকারী গ্রন্থাগার',
          'একান্ত সচিব',
          'সহকারী প্রকৌশলী(ইলেকট্রিক্যাল)',
          'সহকারী পরিচালক',
          'দায়িত্বপ্রাপ্ত কর্মকর্তা(অ.দা)',
          'কম্পিউটার প্রোগ্রামার',
          'তত্ত্বাবধায়ক প্রকৌশলী',
          'উপ পরিচালক',
          'নেটওয়ার্ক ইঞ্জিনিয়ার',
          'উপ-খামার তত্তাবধায়ক(সিনিয়ার স্কেল)',
          'হিসাবরক্ষন কর্মকর্তা',
          'নির্বাহী প্রকৌশলী (ইলেকট্রিক্যাল)',
        ]),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty_name',
        type: PlutoColumnType.select(<String>[
          'ভাইস-চ্যান্সেলর কার্যালয়',
          'আরটিসি',
          'আইসিটি সেল',
          'রেজিস্ট্রার',
          'অর্থ ও হিসাব বিভাগ',
          'কেন্দ্রীয় গ্রন্থাগার',
          'ভাইস-চ্যান্সেলর কার্যালয় ',
          'পরিকল্পনা,উন্নয়ন ও ওয়ার্কস বিভাগ',
          'প্রকৌশল বিভাগ',
          'মাননীয় ভাইস চ্যান্সেলর মহোদয়',
          'রেজিস্ট্রার অফিস',
          'কৃষি খামার',
          'কেন্দ্রীয় গবেষনাগার',
          'পরীক্ষা নিয়ন্ত্রক শাখা',
          'আইকিউএসি',
        ]),
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Profile Pic',
        field: 'profile_pic',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'administration_servicedepartment',
    label: 'Service Departments',
    icon: Icons.design_services,
    columns: ['id', 'faculty_name', 'department'],
    primaryKey: 'id',
    description: 'Service departments',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty_name',
        type: PlutoColumnType.select(<String>[
          'সাধারন সেবা',
          'ইনোভেশন ডেসিমিনেশন সেন্টার',
          'অন্যান্য',
          'লিগ্যাল এডভাইজরি শাখা',
          'জরুরী সেবা',
          'পরিবহন',
          'ক্লাব সমূহ',
          'মসজিদ সমূহ',
          'অধিকতর উন্নয়ন প্রকল্প',
          'হল সমূহহল সমূহ ',
          'সাধারন সেবা',
          'ইনোভেশন ডেসিমিনেশন সেন্টার',
          'অন্যান্য',
          'লিগ্যাল এডভাইজরি শাখা',
          'জরুরী সেবা',
          'পরিবহন',
          'ক্লাব সমূহ',
          'মসজিদ সমূহ',
          'অধিকতর উন্নয়ন প্রকল্প',
          'হল সমূহ',
        ]),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'administration_services',
    label: 'Services',
    icon: Icons.home_repair_service,
    columns: [
      'id',
      'name',
      'phone',
      'designation',
      'email',
      'priority',
      'department_id',
    ],
    primaryKey: 'id',
    description: 'Administration services',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Phone', field: 'phone', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.select(<String>[
          'ফিটার',
          'প্রভোস্ট ',
          'সেকশন অফিসার',
          'জরুরি প্রয়োজন',
          'সহকারী প্রক্টর',
          'সহকারী পরিবহন কর্মকর্তা (বাবুগঞ্জ)',
          'অফিস সহকারী',
          'বাস হেলপার(ANSVM)',
          'ডেপুটি চীফ মেডিকেল অফিসার',
          'সহাকারী রেজিস্ট্রার',
          'গাড়ী চালক',
          'হিসাবরক্ষক কর্মকর্তা',
          'ওয়েল্ডার (স্টোর কিপার দাঃপ্রাঃ)',
          'গাড়ী চালক (এম্বুলেন্স)',
          'সহকারী প্রক্টর (বাবুগঞ্জ)',
          'ছাত্র বিষয়ক উপদেষ্টা',
          'সভাপতি',
          'ইমাম',
          'অফিস সহায়ক',
          'প্রভোস্ট',
          'প্রক্টর',
          'সহকারী মেডিকেল অফিসার (বাবুগঞ্জ)',
          'সদস্য সচিব',
          'পিইউও, নেভাল উইং',
          'দায়িত্বপ্রাপ্ত কর্মকর্তা',
          'চীফ মেডিকেল অফিসার ',
          'সহকারী পরিবহন কর্মকর্তা',
          'সহকারী ছাত্র বিষয়ক উপদেষ্টা',
          'গাড়ী চালক (ANSVM)',
          'সহকারী রেজিস্ট্রার',
          'ডেপুটি রেজিস্ট্রার',
          'সিনিয়র সহকারী',
          'পরিবহন কর্মকর্তা',
          'ইমাম (শের-ই-বাংলা হল-২)',
          'সাধারন সম্পাদক',
          'উপ-পরিচালক (বাবুগঞ্জ)',
          'জরুরী প্রয়োজনে',
          'গাড়ী চালক (মাস্টার রোল)',
          'সহকারী নিরাপত্তা কর্মকর্তা ',
          'গাড়ী চালক (দায়িত্ব প্রাপ্ত)',
          'সহকারী প্রভোস্ট',
          'বাস হেলপার',
          'সাভাপতি',
          'ম্যানেজিং এডিটর ',
          'সাধারণ সম্পাদক',
          'পরিচালক',
          'নার্স',
          'হেলপার (বদলা হিসেবে)',
          'হেল্পার',
          'উপ-পরিচালক',
          'সিনিয়র পেশ ইমাম',
          'চিফ এডিটর',
          'সহকারী পরিচালক',
          'ইমাম (শের-ই-বাংলা হল-১)',
          'তত্ত্বাবধায়ক প্রকৌশলী',
          'ছাত্র বিষয়ক উপ-উপদেষ্টা',
          'প্রধান প্রকৌশলী',
          'পেশ ইমাম',
        ]),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
    ],
  ),
  TableModel(
    name: 'course_course',
    label: 'Courses',
    icon: Icons.menu_book,
    columns: [
      'id',
      'course_title',
      'course_code',
      'credit_hour',
      'faculty',
      'semester',
    ],
    primaryKey: 'id',
    description: 'Courses catalog',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Course Title',
        field: 'course_title',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Course Code',
        field: 'course_code',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Credit Hour',
        field: 'credit_hour',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Semester',
        field: 'semester',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
];

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (supabase.auth.currentSession == null) {
        context.go('/signup');
      } else {
        _checkRole();
      }
    });
  }

  Future<void> _checkRole() async {
    try {
      final role = await supabase
          .from('profiles')
          .select('role')
          .eq('id', supabase.auth.currentSession!.user.id)
          .single();

      developer.log('role: $role');
      if (role['role'] != 'admin') {
        if (!mounted) return;
        context.go('/no-access');
      }
    } catch (e) {
      developer.log('Error fetching role: $e');
      if (!mounted) return;
      context.go('/no-access');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tables = databaseTables;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1200;
        final labelType = isWide
            ? NavigationRailLabelType.none
            : NavigationRailLabelType.selected;
        if (!isWide) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final messenger = ScaffoldMessenger.maybeOf(context);
            if (messenger == null) return;
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(
              const SnackBar(
                content: Text(
                  'For admin panel, Desktop mode is preferred for a better experience!',
                ),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
              ),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Panel'),
            actions: [
              IconButton(
                tooltip: 'Sign out',
                onPressed: () async {
                  await supabase.auth.signOut();
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  context.go('/signup');
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Row(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      selectedIndex: _selectedIndex,
                      labelType: labelType,
                      extended: isWide,
                      destinations: [
                        for (final t in tables)
                          NavigationRailDestination(
                            icon: Icon(t.icon),
                            label: Text(t.label),
                          ),
                      ],
                      onDestinationSelected: (i) {
                        setState(() => _selectedIndex = i);
                      },
                    ),
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _AdminTableView(
                  key: ValueKey('table-${tables[_selectedIndex].name}'),
                  table: tables[_selectedIndex],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdminTableView extends StatefulWidget {
  final TableModel table;
  const _AdminTableView({super.key, required this.table});

  @override
  State<_AdminTableView> createState() => _AdminTableViewState();
}

class _AdminTableViewState extends State<_AdminTableView> {
  late List<PlutoColumn> _columns;
  List<PlutoRow> _rows = const [];
  PlutoGridStateManager? _stateManager;
  bool _loading = true;
  String? _error;
  static const String _checkField = '_checked';

  @override
  void initState() {
    super.initState();
    _columns = [
      PlutoColumn(
        title: '',
        field: _checkField,
        type: PlutoColumnType.text(),
        enableRowChecked: true,
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 60,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      ...widget.table.buildPlutoColumns(),
    ];
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Fetch up to 200 rows to keep UI snappy
      // TODO: pagination
      final data = await supabase.from(widget.table.name).select().limit(200);
      final dataFields = _columns
          .where((c) => c.field != _checkField)
          .map((c) => c.field)
          .toList(growable: false);
      final rows = (data as List)
          .cast<Map<String, dynamic>>()
          .map(
            (m) => PlutoRow(
              cells: {
                _checkField: PlutoCell(value: false),
                for (final f in dataFields) f: PlutoCell(value: m[f]),
              },
            ),
          )
          .toList();
      setState(() {
        _rows = rows;
        _loading = false;
      });
      _stateManager?.removeAllRows();
      if (rows.isNotEmpty) {
        _stateManager?.appendRows(rows);
      }
    } catch (e, st) {
      developer.log(
        'Failed to fetch ${widget.table.name}',
        error: e,
        stackTrace: st,
      );
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  Future<void> _updateCell(PlutoGridOnChangedEvent e) async {
    if (e.column.field == _checkField) return; // ignore checkbox toggles
    final pk = widget.table.primaryKey;
    final row = e.row;
    final pkVal = row.cells[pk]?.value;
    if (pkVal == null) return;

    try {
      await supabase
          .from(widget.table.name)
          .update({e.column.field: e.value})
          .eq(pk, pkVal);
      // Optionally show a small feedback
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved'),
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    } catch (err, st) {
      developer.log('Failed to update cell', error: err, stackTrace: st);
      // Revert value in grid
      e.row.cells[e.column.field]!.value = e.oldValue;
      _stateManager?.notifyListeners();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $err')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(
                  widget.table.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: widget.table.description,
                  child: const Icon(Icons.info_outline, size: 18),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _onAddPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _onDeletePressed,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _fetchData,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlutoGrid(
                    columns: _columns,
                    rows: _rows,
                    mode: PlutoGridMode.normal,
                    onLoaded: (event) {
                      _stateManager = event.stateManager;
                      // Fit columns initially
                      _stateManager!.setShowColumnFilter(true);
                    },
                    onChanged: _updateCell,
                    configuration: PlutoGridConfiguration(
                      style: Theme.of(context).brightness == Brightness.dark
                          ? PlutoGridStyleConfig.dark()
                          : PlutoGridStyleConfig(),
                    ),
                    onRowChecked: (event) {},
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _onAddPressed() async {
    if (_stateManager == null) return;
    final editableColumns = _columns
        .where((c) => c.field != _checkField && !c.readOnly)
        .toList(growable: false);

    final controllers = {
      for (final c in editableColumns) c.field: TextEditingController(text: ''),
    };
    String? error;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            return AlertDialog(
              title: Text(
                'Add to ${widget.table.label}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final col in editableColumns)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Builder(
                            builder: (context) {
                              final type = col.type;
                              // If column is a select, render a dropdown with the provided items.
                              if (type is PlutoColumnTypeSelect) {
                                final List<dynamic> rawItems = type.items;
                                final items = rawItems
                                    .map((e) => e?.toString() ?? '')
                                    .where((s) => s.isNotEmpty)
                                    .toList();
                                final currentText = controllers[col.field]!.text
                                    .trim();
                                final currentValue =
                                    currentText.isEmpty ||
                                        !items.contains(currentText)
                                    ? null
                                    : currentText;
                                return DropdownButtonFormField<String>(
                                  initialValue: currentValue,
                                  items: items
                                      .map(
                                        (e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) {
                                    setS(
                                      () => controllers[col.field]!.text =
                                          val ?? '',
                                    );
                                  },
                                  decoration: InputDecoration(
                                    labelText: col.title,
                                    border: const OutlineInputBorder(),
                                  ),
                                );
                              }

                              // Fallback: regular text field for non-select types.
                              return TextFormField(
                                controller: controllers[col.field],
                                keyboardType: type is PlutoColumnTypeNumber
                                    ? const TextInputType.numberWithOptions(
                                        decimal: true,
                                      )
                                    : null,
                                decoration: InputDecoration(
                                  labelText: col.title,
                                  border: const OutlineInputBorder(),
                                ),
                              );
                            },
                          ),
                        ),
                      if (error != null) ...[
                        const SizedBox(height: 8),
                        Text(error!, style: const TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(null),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final data = <String, dynamic>{};
                    for (final col in editableColumns) {
                      final v = controllers[col.field]!.text;
                      data[col.field] = v.isEmpty ? null : v;
                    }
                    try {
                      final inserted = await supabase
                          .from(widget.table.name)
                          .insert(data)
                          .select()
                          .single();
                      if (context.mounted) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(ctx).pop(inserted);
                      }
                    } catch (e) {
                      setS(() => error = '$e');
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      final newRow = PlutoRow(
        cells: {
          _checkField: PlutoCell(value: false),
          for (final c in _columns.where((c) => c.field != _checkField))
            c.field: PlutoCell(value: result[c.field]),
        },
      );
      _stateManager!.prependRows([newRow]);
      _stateManager!.setCurrentCell(newRow.cells.values.first, 0);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Row created')));
    }
  }

  Future<void> _onDeletePressed() async {
    if (_stateManager == null) return;
    final checked = _stateManager!.checkedRows;
    if (checked.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No rows selected')));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete selected'),
        content: Text('Delete ${checked.length} selected row(s)?'),
        actions: [
          TextButton(
            // ignore: use_build_context_synchronously
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            // ignore: use_build_context_synchronously
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final pk = widget.table.primaryKey;
    final ids = checked
        .map((r) => r.cells[pk]?.value)
        .where((v) => v != null)
        .toList();
    if (ids.isEmpty) return;

    try {
      await supabase.from(widget.table.name).delete().inFilter(pk, ids);

      _stateManager!.removeRows(checked);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted ${ids.length} row(s)')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }
}
