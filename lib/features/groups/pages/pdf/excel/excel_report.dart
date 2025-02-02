/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

import '../../../dao/dao_index.dart';

class ExcelExample {
  static Future<void> saveAsExcel(String fileName, Uint8List bytes) async {
    await AppUtils.saveAsBytes(fileName, "xlsx", bytes);
  }

  static Future<void> createAndSaveExcel(String groupId, String groupName,
      DateTime startDate, DateTime endDate) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    final dao = GroupsDao();
    GroupSummaryFilter filter = GroupSummaryFilter(groupId);
    filter.sdt = startDate;
    filter.edt = endDate;

    var balances = await dao.getBalances(filter);

    filter.type = AppConstants.fRange;
    var summary = await dao.getGroupSummary(filter);

    double totalExpenditures = 0;
    double totalBankInterest = 0;

    double previousYearBalance = balances[0].totalCr - balances[0].totalDr;

    for (var s in summary) {
      switch (s.trxType) {
        case AppConstants.ttExpenditures:
          totalExpenditures += s.totalDr;
          break;
        case AppConstants.ttBankInterest:
          totalBankInterest += s.totalCr;
          break;
      }
    }

    double totalGivenLoan = 0;
    sheetObject.merge(
        CellIndex.indexByString('A1'), CellIndex.indexByString('I1'),
        customValue: TextCellValue(
            'जमाखर्च पुस्तक  कालावधी (${AppUtils.getHumanReadableDt(startDate)} -${AppUtils.getHumanReadableDt(endDate)})'));
    List<double> loanTillToday = await dao.getLoanTakenTillToday(
        groupId, AppUtils.getTrxPeriodFromDt(endDate));
    sheetObject.merge(
        CellIndex.indexByString('A2'), CellIndex.indexByString('A3'),
        customValue: TextCellValue("अ. क्र."));

    sheetObject.merge(
        CellIndex.indexByString('B2'), CellIndex.indexByString('B3'),
        customValue: TextCellValue("सभासदाचे नाव"));

    sheetObject.merge(
        CellIndex.indexByString('C2'), CellIndex.indexByString('C3'),
        customValue: TextCellValue('बचत जमा (शेअर्स )'));

    sheetObject.merge(
        CellIndex.indexByString('D2'), CellIndex.indexByString('D3'),
        customValue: TextCellValue('व्याज '));

    sheetObject.merge(
        CellIndex.indexByString('E2'), CellIndex.indexByString('E3'),
        customValue: TextCellValue('दंड'));

    sheetObject.merge(
        CellIndex.indexByString('F2'), CellIndex.indexByString('F3'),
        customValue: TextCellValue('इतर जमा'));

    sheetObject.merge(
        CellIndex.indexByString('G2'), CellIndex.indexByString('G3'),
        customValue: TextCellValue('एकूण जमा'));

    sheetObject.merge(
        CellIndex.indexByString('H2'), CellIndex.indexByString('H3'),
        customValue: TextCellValue('आज अखेर घेतलेले कर्ज'));

    sheetObject.merge(
        CellIndex.indexByString('I2'), CellIndex.indexByString('I3'),
        customValue: TextCellValue('परतफेड कर्ज'));

    sheetObject.merge(
        CellIndex.indexByString('J2'), CellIndex.indexByString('J3'),
        customValue: TextCellValue('शिल्लक कर्ज'));

    sheetObject.merge(
        CellIndex.indexByString('J2'), CellIndex.indexByString('J3'),
        customValue: TextCellValue('दिलेले शेअर्स'));
    String str = AppUtils.getTrxPeriodFromDt(startDate);
    String end = AppUtils.getTrxPeriodFromDt(endDate);
    List<MemberTransactionSummary> yearlyData =
        await dao.getYearlySummary(groupId, str, end);
    List<double> totalDeposit = List<double>.filled(yearlyData.length, 0.0);
    double totalcredit = 0.0;
    for (int i = 0; i < yearlyData.length; i++) {
      totalDeposit[i] = (yearlyData[i].totalSharesDeposit.toDouble() +
          yearlyData[i].totalLoanInterest.toDouble() +
          yearlyData[i].totalPenalty.toDouble() +
          yearlyData[i].otherDeposit.toDouble());
      totalcredit += totalDeposit[i];
      totalGivenLoan += loanTillToday[i];
    }
    double totalShares = 0.0;
    double totalInterest = 0.0;
    double totalPenalty = 0.0;
    double totalOthers = 0.0;
    double totalLoanReturn = 0.0;
    double remainingLoan = 0.0;
    for (int i = 0; i < yearlyData.length; i++) {
      MemberTransactionSummary member = yearlyData[i];
      List<CellValue> rowCells = [
        IntCellValue(i + 1),
        TextCellValue(member.name),
        DoubleCellValue(member.totalSharesDeposit),
        DoubleCellValue(member.totalLoanInterest),
        DoubleCellValue(member.totalPenalty),
        DoubleCellValue(member.otherDeposit),
        DoubleCellValue(totalDeposit[i]),
        DoubleCellValue((loanTillToday[i])),
        DoubleCellValue(member.loanReturn),
        DoubleCellValue((member.loanTakenTillDate - member.loanReturn)),
      ];
      totalShares += member.totalSharesDeposit;
      totalInterest += member.totalLoanInterest;
      totalPenalty += member.totalPenalty;
      totalOthers += member.otherDeposit;
      totalLoanReturn += member.loanReturn;
      remainingLoan += (member.loanTakenTillDate - member.loanReturn);

      sheetObject.insertRowIterables(
          rowCells, 4 + i); // Start appending data after 4th row
    }
    List<CellValue?> rowCell = [
      TextCellValue((yearlyData.length + 1).toString()),
      TextCellValue("एकूण"),
      DoubleCellValue(totalShares),
      DoubleCellValue(totalInterest),
      DoubleCellValue(totalPenalty),
      DoubleCellValue(totalOthers),
      DoubleCellValue(totalcredit),
      DoubleCellValue(totalGivenLoan),
      DoubleCellValue(totalLoanReturn),
      DoubleCellValue(remainingLoan),
    ];
    sheetObject.insertRowIterables(rowCell, 4 + yearlyData.length);
    var count = 4 + yearlyData.length + 4;
    //for displaying the previous remaining amount in savings group
    var rowNumber = count;
    sheetObject.cell(CellIndex.indexByString('B$rowNumber')).value =
        TextCellValue('मागील शिल्लक');
    sheetObject.cell(CellIndex.indexByString('C$rowNumber')).value =
        DoubleCellValue(previousYearBalance);

    sheetObject.cell(CellIndex.indexByString('E$rowNumber')).value =
        TextCellValue('दिलेले कर्ज');
    sheetObject.cell(CellIndex.indexByString('F$rowNumber')).value =
        DoubleCellValue(totalGivenLoan);
    rowNumber++;
    sheetObject.cell(CellIndex.indexByString('B$rowNumber')).value =
        TextCellValue('आज अखेर जमा');

    sheetObject.cell(CellIndex.indexByString('C$rowNumber')).value =
        DoubleCellValue(totalcredit);

    //for displaying the expenditures of savings group
    sheetObject.cell(CellIndex.indexByString('E$rowNumber')).value =
        TextCellValue('इतर खर्च');
    sheetObject.cell(CellIndex.indexByString('F$rowNumber')).value =
        DoubleCellValue(totalExpenditures);
    rowNumber++;
    //displays the total bank interest deposited by bank
    sheetObject.cell(CellIndex.indexByString('B$rowNumber')).value =
        TextCellValue("बँक मधून मिळालेले व्याज");

    sheetObject.cell(CellIndex.indexByString('C$rowNumber')).value =
        DoubleCellValue(totalBankInterest);
    //display total given loan till date
    double totalsum = previousYearBalance + totalcredit + totalBankInterest;
    sheetObject.cell(CellIndex.indexByString('E$rowNumber')).value =
        TextCellValue("अखेरची शिल्लक");
    sheetObject.cell(CellIndex.indexByString('F$rowNumber')).value =
        DoubleCellValue(totalsum - totalGivenLoan - totalExpenditures);
    rowNumber++;
    sheetObject.cell(CellIndex.indexByString('B$rowNumber')).value =
        TextCellValue("एकूण जमा");

    sheetObject.cell(CellIndex.indexByString('C$rowNumber')).value =
        DoubleCellValue(totalsum);

    sheetObject.cell(CellIndex.indexByString('E$rowNumber')).value =
        TextCellValue("एकूण खर्च");
    sheetObject.cell(CellIndex.indexByString('F$rowNumber')).value =
        DoubleCellValue(totalsum);

    final fileBytes = excel.save();
    if (fileBytes != null) {
      AppUtils.saveAndOpenFile(fileBytes);
    }

    // saveAsExcel(groupName, fileBytes);
    // await previewExcel(fileBytes);
    // saveFile("YearReport.xlsx", fileBytes!);
  }
}
