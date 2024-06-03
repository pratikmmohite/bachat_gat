/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';

class AppConstants {
  static const String version = "1.0.0";

  static const String imgAppIcon = "assets/images/app_icon.png";
  // Trx Types
  // Credit
  static const String ttShare = "Share";
  static const String ttLateFee = "LateFee";
  static const String ttLoanInterest = "LoanInterest";
  static const String ttOtherDeposit = "OtherDeposit";
  static const String ttBankInterest = "BankInterest";
  // Debit
  static const String ttBankFee = "BankFee";
  static const String ttExpenditures = "Expenditures";
  static const String ttBankCharges = "BankCharges";
  // BOTH CR + DR
  static const String ttLoan = "Loan";
  // Special for filtering
  static const String ttBankDeposit = "BankDeposit";
  static const String ttOpeningBalance = "Opening Balance";
  static const String ttClosingBalance = "Closing Balance";

  static String dbCreditFilter = "('${[
    ttShare,
    ttLateFee,
    ttLoanInterest,
    ttOtherDeposit,
    ttBankInterest
  ].join("','")}')";
  static String dbDebitFilter = "('${[
    ttBankFee,
    ttExpenditures,
  ].join("','")}')";

  //UI only filters
  static List<String> uiCrGroupTrxTypes = [
    ttBankInterest,
    ttOtherDeposit,
    ttBankDeposit
  ];

  static List<String> uidrGroupTrxTypes = [
    ttExpenditures,
    ttBankCharges,
  ];
  // Loan status
  static const String lsActive = "Active";
  static const String lsComplete = "Complete";

  // Transaction Dialog Mode
  static const String tmPayment = "Payment";
  static const String tmBoth = "Record Payment";
  static const String tmLoan = "Loan Payment";

  // TrxSources
  static const String sLoan = "Loan";
  static const String sUser = "User";

  static const String sfViewMode = "sfViewMode";
  static const String sfLanguage = "sfLanguage";

  static const List<String> cEnMonthsStr = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec",
  ];
  //GroupSummary Filter type
  static const fMonthly = "monthly";
  static const fRange = "range";

  static List<CustomDropDownOption<String>> otherTrxTypeOptions = [
    CustomDropDownOption<String>(
        ttBankInterest, ttBankInterest, ttBankInterest),
    CustomDropDownOption<String>(
        ttExpenditures, ttExpenditures, ttExpenditures),
    CustomDropDownOption<String>(
        ttOtherDeposit, ttOtherDeposit, ttOtherDeposit),
    CustomDropDownOption<String>(ttBankDeposit, ttBankDeposit, ttBankDeposit),
    CustomDropDownOption<String>(ttBankCharges, ttBankCharges, ttBankCharges),
  ];
}
