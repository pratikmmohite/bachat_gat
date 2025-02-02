/*
 * Copyright (C) 2024-present Pratik Mohite - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
abstract class AppLocalization {
  Map<String, String> defaultLocalMap = {
    "appTitle": "Saving Group",
    "abAddLoan": "Add Loan",
    "abAddMember": "Add Member",
    "abRecordTransaction": "Record transaction",
    "abMemberList": "Members",
    "abLoanList": "Loan List",
    "abAddGroup": "Add Group",
    "abImportExport": "Import/Export Data",
    "mRecordedLoanPaymentSuccess": "Recorded loan payment successfully",
    "mRecordedSharePaymentSuccess": "Recorded share payment successfully",
    "mRecordedTrxPaymentSuccess": "Recorded transaction successfully",
    "mConfirmDeleteMsg": "Are you sure you want to delete this?",
    "mEmptyMemberDetails": "Add members to record transactions",
    "mSelectLoan": "Please select loan",
    "mEnterLoanAmount": "Please enter loan amount",
    "mEnterShareAmount": "Please enter share amount",
    "mAddGroupMsg": "Click + to add members",
    "mAddMemberMsg": "Click + to add groups",
    "bAddGroup": "Add Group",
    "bAddMember": "Add Member",
    "bImportFile": "Import Data",
    "bExportFile": "Export Data",
    "bSave": "Save",
    "bGiveLoan": "Give loan",
    "bRecord": "Record",
    "bAddShare": "Add Share",
    "bAddLoan": "Give new loan",
    "bShowLoans": "Show Loans",
    "bShowTransactions": "Show transactions",
    "bYes": "Yes",
    "bNo": "No",
    "tfEnterLoanAmt": "Enter loan amount",
    "tfEnterLoanInterest": "Enter loan interest",
    "tfEnterNote": "Enter note",
    "tfGroupName": "Group Name",
    "tfStartDate": "Start Date",
    "tfEndDate": "End Date",
    "tfAddress": "Address",
    "tfBankName": "Bank Name",
    "tfAccountNot": "Account No",
    "tfIfscCode": "IFSC Code",
    "tfAccountOpeningDt": "Account Opening Date",
    "tfGroupSettings": "Group Settings",
    "tfInstallmentAmt": "Installment Amount",
    "tfLoanAmt": "Loan Amount",
    "tfLoanInterest": "Loan Interest",
    "tfLateFee": "Late Fee",
    "tfShareAmount": "Share Amount",
    "tfSelectLoanToPay": "Select loan to pay",
    "tfMemberName": "Member Name",
    "tfMobileNo": "Mobile No",
    "tfAadherNo": "Aadhar No",
    "tfPanNo": "Pan No",
    "tfJoiningDate": "Joining Date",
    "lLoanAmt": "Loan Amount",
    "lLoanInterest": "Loan Interest",
    "lPaidLoan": "Paid Loan",
    "lPaidInterest": "Paid Interest",
    "lPaidShare": "Paid Share",
    "lPaidLateFee": "Paid Late Fee",
    "lLateFee": "Late Fee",
    "lShareAmount": "Share Amount",
    "lRmLoan": "Remaining Loan(-)",
    "lNote": "Note",
    "lBalance": "Balance",
    "lLoan": "Loan(+)",
    "lGivenLoan": "Given Loan",
    "lShare": "Share(+)",
    "lMember": "Member",
    "lTotal": "Total",
    "lRemaining": "Remaining",
    "lInterest": "Interest(+)",
    "lPenalty": "Penalty(+)",
    "lOthers": "Others(+)",
    "lActions": "Actions",
    "lDeposit": "Total Deposit (+)",
    "ltShares": "Total Shares (+)",
    "ltBankBalance": "Total Bank Balance",
    "ltExpenditures": "Other Expenditures",
    "ltOther": "Other Deposit",
    "ltGathered": "Total Gathered",
    "lPrm": "Previous Remaining Balance",
    "lTSaving": "Total Saving",
    "lMcount": "Member Count",
    "lmPortion": "Member Portion",
    "lmCollection": "Month Collection",
    "lgSummary": "Group Summary",
    "lgRecord": "Record Statement",
    "lgTransaction": "Group Transaction",
    "lmList": "Member List",
    "lRecord": "Reports",
    "lmReport": "Member Reports",
    "lMReport": "Monthly Reports",
    "lYReport": "Yearly Report",
    "to": "To",
    "period": "Period",
    "type": "Type",
    "ltcr": "Total Credit",
    "ltdr": "Total Debit",
    "sumr": "Totals",
    "cr": "Credit",
    "dr": "Debit",
    "lmonth": "Month",
    "ladd": "Added On",
    "lmcr": "Monthly credit",
    "lcb": "Monthly Closing balance",
    "lcrdr": "Total",
    "lMemberaName": "Member Name",
    "ttExpenditures": "Expenditure",
    "ttBankInterest": "Bank Interest",
    "ttBankDeposit": "BankDeposit",
    "ttBankCharges": "Bank Charges",
  };

  List<String> get months => [
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

  Map<String, String> get languageSpecificMap;

  String getValue(String k) {
    return languageSpecificMap[k] ?? defaultLocalMap[k] ?? k;
  }

  String getHumanTrxPeriod(DateTime dt) {
    return "${months[dt.month - 1]}-${dt.year}";
  }

  // App Titles
  String get appTitle => getValue("appTitle");
  // AppBar Titles
  String get abAddMember => getValue("abAddMember");
  String get abAddLoan => getValue("abAddLoan");
  String get abRecordTransaction => getValue("abRecordTransaction");
  String get abMemberList => getValue("abMemberList");
  String get abLoanList => getValue("abLoanList");
  String get abAddGroup => getValue("abAddGroup");

  String get abImportExport => getValue("abImportExport");
  // Messages
  String get mAddMemberMsg => getValue("mAddMemberMsg");
  String get mAddGroupMsg => getValue("mAddGroupMsg");
  String get mLoanSuccess => getValue("mLoanSuccess");
  String get mRecordedLoanPaymentSuccess =>
      getValue("mRecordedLoanPaymentSuccess");
  String get mRecordedSharePaymentSuccess =>
      getValue("mRecordedSharePaymentSuccess");
  String get mRecordedTrxPaymentSuccess =>
      getValue("mRecordedTrxPaymentSuccess");
  String get mSelectLoan => getValue("mSelectLoan");
  String get mEnterLoanAmount => getValue("mEnterLoanAmount");
  String get mEnterShareAmount => getValue("mEnterShareAmount");
  String get mConfirmDeleteMsg => getValue("mConfirmDeleteMsg");
  String get mEmptyMemberDetails => getValue("mEmptyMemberDetails");
  // Buttons
  String get bAddGroup => getValue("bAddGroup");
  String get bAddMember => getValue("bAddMember");
  String get bGiveLoan => getValue("bGiveLoan");
  String get bImportFile => getValue("bImportFile");
  String get bExportFile => getValue("bExportFile");
  String get bSave => getValue("bSave");
  String get bRecord => getValue("bRecord");
  String get bAddShare => getValue("bAddShare");
  String get bAddLoan => getValue("bAddLoan");
  String get bShowLoans => getValue("bShowLoans");
  String get bShowTransactions => getValue("bShowTransactions");
  String get bYes => getValue("bYes");
  String get bNo => getValue("bNo");
  // Input Fields
  String get tfEnterLoanAmt => getValue("tfEnterLoanAmt");
  String get tfEnterLoanInterest => getValue("tfEnterLoanInterest");
  String get tfEnterNote => getValue("tfEnterNote");
  String get tfGroupName => getValue("tfGroupName");
  String get tfStartDate => getValue("tfStartDate");
  String get tfEndDate => getValue("tfEndDate");
  String get tfAddress => getValue("tfAddress");
  String get tfBankName => getValue("tfBankName");
  String get tfAccountNot => getValue("tfAccountNot");
  String get tfIfscCode => getValue("tfIfscCode");
  String get tfAccountOpeningDt => getValue("tfAccountOpeningDt");
  String get tfGroupSettings => getValue("tfGroupSettings");
  String get tfInstallmentAmt => getValue("tfInstallmentAmt");
  String get tfLoanAmt => getValue("tfLoanAmt");
  String get tfLoanInterest => getValue("tfLoanInterest");
  String get tfLateFee => getValue("tfLateFee");
  String get tfShareAmount => getValue("tfShareAmount");
  String get tfSelectLoanToPay => getValue("tfSelectLoanToPay");
  String get tfMemberName => getValue("tfMemberName");
  String get tfMobileNo => getValue("tfMobileNo");
  String get tfAadherNo => getValue("tfAadherNo");
  String get tfPanNo => getValue("tfPanNo");
  String get tfJoiningDate => getValue("tfJoiningDate");
  // Labels
  String get lBalance => getValue("lBalance");
  String get lLoan => getValue("lLoan");
  String get lGivenLoan => getValue("lGivenLoan");
  String get lShare => getValue("lShare");
  String get lMember => getValue("lMember");
  String get lTotal => getValue("lTotal");
  String get lInterest => getValue("lInterest");
  String get lPenalty => getValue("lPenalty");
  String get lOthers => getValue("lOthers");
  String get lActions => getValue("lActions");
  String get lLoanAmt => getValue("lLoanAmt");
  String get lLoanInterest => getValue("lLoanInterest");
  String get lPaidLoan => getValue("lPaidLoan");
  String get lPaidInterest => getValue("lPaidInterest");
  String get lPaidLateFee => getValue("lPaidLateFee");
  String get lPaidShare => getValue("lPaidShare");
  String get lLateFee => getValue("lLateFee");
  String get lShareAmount => getValue("lShareAmount");
  String get lRmLoan => getValue("lRmLoan");
  String get lNote => getValue("lNote");
  String get lDeposit => getValue("lDeposit");
  String get ltShares => getValue("ltShares");
  String get ltBankBalance => getValue("ltBankBalance");
  String get ltExpenditures => getValue("ltExpenditures");
  String get ltOther => getValue("ltOther");
  String get ltGathered => getValue("ltGathered");
  String get lPrm => getValue("lPrm");
  String get lTSaving => getValue("lTSaving");
  String get lMcount => getValue("lMcount");
  String get lmPortion => getValue("lmPortion");
  String get lmCollecton => getValue("lmCollection");
  String get lgSummary => getValue("lgSummary");
  String get lgRecord => getValue("lgRecord");
  String get lgTransaction => getValue("lgTransaction");
  String get lmList => getValue("lmList");
  String get lRecord => getValue("lRecord");
  String get lmReport => getValue("lmReport");
  String get lMReport => getValue("lMReport");
  String get lYReport => getValue("lYReport");
  String get to => getValue("to");
  String get period => getValue("period");
  String get type => getValue("type");
  String get ltcr => getValue("ltcr");
  String get ltdr => getValue("ltdr");
  String get sumr => getValue("sumr");
  String get cr => getValue("cr");
  String get dr => getValue("dr");
  String get lmonth => getValue("lmonth");
  String get ladd => getValue("ladd");
  String get lmcr => getValue("lmcr");
  String get lcb => getValue("lcb");
  String get lcrdr => getValue("lcrdr");
  String get lMemberName => getValue("lMemberaName");
  String get ttBankInterest => getValue("ttBankInterest");
  String get ttExpenditures => getValue("ttExpenditures");
  String get ttBankDeposit => getValue("ttBankDeposit");
  String get ttBankCharges => getValue("ttBankCharges");
}

class EnAppLocalization extends AppLocalization {
  @override
  Map<String, String> get languageSpecificMap => {};
}

class MrAppLocalization extends AppLocalization {
  @override
  Map<String, String> get languageSpecificMap => {
        "appTitle": "बचत गट",
        "abAddLoan": "कर्ज जोडा",
        "abAddMember": "सदस्य जोडा",
        "abRecordTransaction": "जमा-खर्च नोंदणी करा",
        "abMemberList": "सदस्य",
        "abLoanList": "कर्ज",
        "abAddGroup": "समूह जोडा",
        "abImportExport": "आयात/निर्यात डेटा",
        "mRecordedLoanPaymentSuccess": "कर्ज वसूली नोंदणी केली",
        "mRecordedSharePaymentSuccess": "बचत नोंदणी केली",
        "mSelectLoan": "कृपया कर्ज निवडा",
        "mEnterLoanAmount": "कृपया कर्ज रक्कम प्रविष्ट करा",
        "mEnterShareAmount": "कृपया शेअर रक्कम प्रविष्ट करा",
        "mAddGroupMsg": "गट जोडण्यासाठी + वर क्लिक करा",
        "mAddMemberMsg": "सदस्य जोडण्यासाठी + वर क्लिक करा",
        "mConfirmDeleteMsg": 'तुमची खात्री आहे की तुम्ही हे हटवू इच्छिता?',
        "mEmptyMemberDetails": "व्यवहार रेकॉर्ड करण्यासाठी सदस्य जोडा",
        "bAddGroup": "समूह जोडा",
        "bAddMember": "सदस्य जोडा",
        "bImportFile": "डेटा आयात करा",
        "bExportFile": "डेटा निर्यात करा",
        "bSave": "सेव्ह",
        "bGiveLoan": "कर्ज द्या",
        "bRecord": "नोंदणी करा",
        "bAddShare": "शेअर जोडा",
        "bAddLoan": "कर्ज जोडा",
        "bShowLoans": "कर्ज दाखवा",
        "bYes": "होय",
        "bNo": "नाही",
        "tfEnterLoanAmt": "कर्ज रक्कम प्रविष्ट करा",
        "tfEnterLoanInterest": "कर्ज व्याज प्रविष्ट करा",
        "tfEnterNote": "टीप प्रविष्ट करा",
        "tfGroupName": "समूहाचे नाव",
        "tfStartDate": "सुरूवातीची तारीख",
        "tfEndDate": "शेवटची तारीख",
        "tfAddress": "पत्ता",
        "tfBankName": "बँकचे नाव",
        "tfAccountNot": "खाते क्रमांक",
        "tfIfscCode": "IFSC कोड",
        "tfAccountOpeningDt": "खाते उघडण्याची तारीख",
        "tfGroupSettings": "समूह सेटिंग्ज",
        "tfInstallmentAmt": "किशोर रक्कम",
        "tfLoanAmt": "कर्ज रक्कम",
        "tfLoanInterest": "कर्ज व्याज",
        "tfLateFee": "उशिर शुल्क",
        "tfShareAmount": "शेअर रक्कम",
        "tfSelectLoanToPay": " वसुलीसाठी कर्ज निवडा",
        "tfMemberName": "सदस्याचे नाव",
        "tfMobileNo": "मोबाइल नंबर",
        "tfAadherNo": "आधार नंबर",
        "tfPanNo": "पॅन नंबर",
        "tfJoiningDate": "सामील होण्याची तारीख",
        "lLoanAmt": "कर्ज रक्कम",
        "lLoanInterest": "कर्ज व्याज",
        "lPaidLoan": "अंतर्गत कर्ज वसूली",
        "lPaidInterest": "वसुली केलेला व्याज",
        "lLateFee": "उशिर शुल्क",
        "lShareAmount": "शेअर रक्कम",
        "lRmLoan": "बाकी कर्ज (-)",
        "lNote": "टिप",
        "lBalance": "शिल्लक",
        "lLoan": "कर्ज",
        "lPaidShare": "बचत जमा",
        "lPaidLateFee": "दंड",
        "lShare": "शेअर",
        "lMember": "सदस्य",
        "lTotal": "एकूण",
        "lRemaining": "शेष",
        "lInterest": "व्याज",
        "lPenalty": "दंड",
        "lOthers": "इतर",
        "lActions": "क्रिया",
        "lGivenLoan": "दिलेले कर्ज",
        "lDeposit": "एकूण ठेव (+)",
        "ltShares": "एकूण शेअर(+)",
        "ltBankBalance": "आज अखेर  शिल्लक रक्कम",
        "ltExpenditures": "इतर खर्च",
        "ltOther": "इतर जमा",
        "ltGathered": "एकूण जमा",
        "lPrm": "मागील शिल्लक",
        "lTSaving": "एकूण बचत",
        "lMcount": "एकूण सदस्य",
        "lmPortion": "सदस्य भाग",
        "lmCollection": "महिन्याचा संग्रह",
        "lgSummary": "गट सारांश",
        "lgRecord": "माहेवार'जमापत्रक",
        "lgTransaction": "गट व्यवहार",
        "lmList": "सदस्य सूची",
        "lRecord": "बचत अहवाल",
        "lmReport": "सदस्य अहवाल",
        "lMReport": "मासिक अहवाल",
        "lYReport": "वार्षिक अहवाल",
        "to": "ते",
        "period": "कालावधी",
        "type": "प्रकार",
        "ltcr": "एकूण जमा",
        "ltdr": "एकूण खर्च ",
        "sumr": "सारांश",
        "cr": "जमा",
        "dr": "खर्च",
        "lmonth": "महिना",
        "ladd": "दिनांक",
        "lmcr": "मासिक जमा",
        "lcb": "चालू महिन्यातील शिल्लक",
        "lcrdr": "एकूण ",
        "lMemberaName": "सदस्याचे नाव",
        "ttExpenditures": "खर्च",
        "ttBankInterest": "बँक मधील व्याज",
        "ttBankDeposit": "बँक जमा",
        "ttBankCharges": "बँक शुल्क",
      };

  @override
  List<String> get months => [
        "जानेवारी",
        "फेब्रुवारी",
        "मार्च",
        "एप्रिल",
        "मे",
        "जून",
        "जुलै",
        "ऑगस्ट",
        "सप्टेंबर",
        "ऑक्टोबर",
        "नोव्हेंबर",
        "डिसेंबर"
      ];

  @override
  String getHumanTrxPeriod(DateTime dt) {
    return "${months[dt.month - 1]}-${dt.year}";
  }
}
