/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'dart:async';

import 'package:bachat_gat/common/constants.dart';
import 'package:bachat_gat/common/utils.dart';

import '../../../common/db_service.dart';
import '../models/models_index.dart';

class GroupsDao {
  var dbService = DbService();
  String groupTableName = "groups";
  String memberTableName = "members";
  String transactionTableName = "transactions";
  String loanTableName = "loans";

  Future<int> addGroup(Group group) async {
    var row = await dbService.insert(groupTableName, group.toJson());
    return row;
  }

  Future<int> updateGroup(Group group) async {
    var row = await dbService.update(groupTableName, group.toJson(),
        where: "id = ?", whereArgs: [group.id]);
    return row;
  }

  Future<int> deleteGroup(Group group) async {
    var row = await dbService
        .delete(loanTableName, where: "groupId = ?", whereArgs: [group.id]);
    row += await dbService.delete(transactionTableName,
        where: "groupId = ?", whereArgs: [group.id]);
    row += await dbService
        .delete(memberTableName, where: "id = ?", whereArgs: [group.id]);
    row += await dbService
        .delete(groupTableName, where: "id = ?", whereArgs: [group.id]);
    return row;
  }

  Future<List<Group>> getGroups() async {
    var rows = await dbService.read("select * from $groupTableName");
    var groups = rows.map((e) => Group.fromJson(e)).toList();
    return groups;
  }

  // Future<List<MemberList>?> getMemberList() async {
  //   var query = await dbService.read("select * from $memberTableName");
  //   var members = query.map((e) => MemberList.fromJson(e)).toList();
  //   return members;
  // }

  Future<int> addGroupMember(GroupMember member) async {
    var row = await dbService.insert(memberTableName, member.toJson());
    return row;
  }

  Future<int> updateGroupMember(GroupMember member) async {
    var row = await dbService.update(memberTableName, member.toJson(),
        where: "id = ?", whereArgs: [member.id]);
    return row;
  }

  Future<List<Transaction>> getTransactions(
      String groupId, String memberId) async {
    String query = "select * from $transactionTableName "
        "where groupId = ? and memberId = ? "
        "order by trxDt desc";
    List<String> pars = [groupId, memberId];
    var rows = await dbService.read(query, pars);
    var transactions = rows.map((e) => Transaction.fromJson(e)).toList();
    return transactions;
  }

  Future<List<TransactionList>> getTransactionList() async {
    var rows = await dbService.read("select * from $transactionTableName");
    var tranasctions = rows.map((e) => TransactionList.fromJson(e)).toList();
    return tranasctions;
  }

  Future<int> addTransaction(Transaction trx) async {
    var row = await dbService.insert(transactionTableName, trx.toJson());
    if (trx.trxType == AppConstants.ttLoan ||
        trx.trxType == AppConstants.ttLoanInterest) {
      recalculateLoanAmounts(trx.sourceId);
    }
    return row;
  }

  Future<int> deleteTransaction(Transaction trx) async {
    var row = await dbService.delete(
      transactionTableName,
      where: "id = ?",
      whereArgs: [trx.id],
    );
    if (trx.trxType == AppConstants.ttLoan ||
        trx.trxType == AppConstants.ttLoanInterest) {
      recalculateLoanAmounts(trx.sourceId);
    }
    return row;
  }

  Future<int> deleteLoan(Loan loan) async {
    var row = await dbService.delete(
      loanTableName,
      where: "id = ?",
      whereArgs: [loan.id],
    );
    await dbService.delete(
      transactionTableName,
      where: "trxType in (?, ?) and sourceId = ? and sourceType = ?",
      whereArgs: [
        AppConstants.ttLoan,
        AppConstants.ttLoanInterest,
        loan.id,
        AppConstants.sLoan,
      ],
    );
    return row;
  }

  Future<int> recalculateLoanAmounts(String loanId) async {
    String trxQuery = "select ifnull(sum(cr), 0) from $transactionTableName t "
        "where t.trxType = ? and t.sourceType = ? and t.sourceId = ?";
    String query = "update $loanTableName set "
        "paidLoanAmount = ($trxQuery), "
        "paidInterestAmount = ($trxQuery) "
        "where id = ?";

    List<String> pars = [
      AppConstants.ttLoan,
      AppConstants.sLoan,
      loanId,
      AppConstants.ttLoanInterest,
      AppConstants.sLoan,
      loanId,
      loanId
    ];

    var row = await dbService.write(query, pars);

    var updateStatus = "update $loanTableName set "
        " status = case when paidLoanAmount >= loanAmount then '${AppConstants.lsComplete}' else '${AppConstants.lsActive}' end "
        " where id= ? ";

    var row1 = await dbService.write(updateStatus, [loanId]);

    return row;
  }

  Future<int> addLoan(Loan loan) async {
    var row = await dbService.insert(loanTableName, loan.toJson());
    var trxPeriod = AppUtils.getTrxPeriodFromDt(loan.loanDate);
    var trx = Transaction(
      memberId: loan.memberId,
      groupId: loan.groupId,
      trxType: AppConstants.ttLoan,
      trxPeriod: trxPeriod,
      cr: 0,
      dr: loan.loanAmount,
      sourceType: AppConstants.sLoan,
      sourceId: loan.id,
      addedBy: loan.addedBy,
      note: loan.note,
    );
    addTransaction(trx);
    return row;
  }

  Future<int> updateLoanPaid(Loan loan) async {
    String updateQuery = "update loans set "
        "note = ?, "
        "paidInterestAmount = paidInterestAmount + ?, "
        "status = case when paidLoanAmount+?>=loanAmount then ${AppConstants.lsComplete} else ${AppConstants.lsActive} end "
        "where id = ?";

    var row = await dbService.write(
      updateQuery,
      [
        loan.paidLoanAmount,
        loan.paidInterestAmount,
        loan.paidLoanAmount,
        loan.id,
      ],
    );
    return row;
  }

  Future<int> deleteGroupMember(GroupMember member) async {
    var row = await dbService
        .delete(loanTableName, where: "memberId = ?", whereArgs: [member.id]);
    row = await dbService.delete(transactionTableName,
        where: "memberId = ?", whereArgs: [member.id]);
    row = await dbService
        .delete(memberTableName, where: "id = ?", whereArgs: [member.id]);
    return row;
  }

  Future<List<GroupMember>> getMembers(MemberFilter filter) async {
    var rows = await dbService.read(
      "select * from $memberTableName "
      "where groupId = ?",
      [filter.groupId],
    );
    var members = rows.map((e) => GroupMember.fromJson(e)).toList();
    return members;
  }

  Future<List<Loan>> getLoans() async {
    var rows = await dbService.read("select * from ${loanTableName};");
    var loans = rows.map((e) => Loan.fromJson(e)).toList();
    return loans;
  }

  Future<List<Loan>> getMemberLoans(MemberLoanFilter filter) async {
    String selectClause = "select * "
        "from $loanTableName ";
    List<Object?> pars = [
      filter.memberId,
      filter.groupId,
    ];
    String whereClause = "where memberId = ? "
        "and groupId = ? ";
    if (filter.status.isNotEmpty) {
      whereClause += "and status = ? ";
      pars.add(filter.status);
    }
    String query = selectClause + whereClause;
    var rows = await dbService.read(query, pars);
    var loans = rows.map((e) => Loan.fromJson(e)).toList();
    return loans;
  }

  Future<List<GroupMemberDetails>> getGroupMembersWithBalance(
      MemberBalanceFilter filter) async {
    String balanceAmount = "(select ifnull(sum(t.cr-t.dr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        ") as balance ";

    String paidShareAmount =
        "(${getAmountQuery(AppConstants.ttShare, filter.trxPeriod)}) as paidShareAmount ";
    String paidLoanAmount =
        "(${getAmountQuery(AppConstants.ttLoan, filter.trxPeriod)}) as paidLoanAmount ";
    String paidLateFee =
        "(${getAmountQuery(AppConstants.ttLateFee, filter.trxPeriod)}) as paidLateFee ";
    String paidOtherAmount =
        "(${getAmountQuery(AppConstants.ttOtherDeposit, filter.trxPeriod)}) as paidOtherAmount ";
    String paidLoanInterestAmount =
        "(${getAmountQuery(AppConstants.ttLoanInterest, filter.trxPeriod)}) as paidLoanInterestAmount ";
    String givenLoanAmount =
        "(${getAmountQuery(AppConstants.ttLoan, filter.trxPeriod, "dr")}) as lendLoan ";

    String pendingLoanAmount = "(select ifnull(sum(t.dr-t.cr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        "and t.trxPeriod <= '${filter.trxPeriod}' "
        "and t.trxType = '${AppConstants.ttLoan}' ) as pendingLoanAmount ";

    String selectQuery = "select m.name "
        ",m.groupId "
        ",m.id as memberId "
        ",$paidShareAmount "
        ",$paidLoanAmount "
        ",$paidLateFee "
        ",$paidLoanInterestAmount "
        ",$paidOtherAmount "
        ",$balanceAmount "
        ",$givenLoanAmount "
        ",$pendingLoanAmount "
        "from $memberTableName m ";

    String whereClause = "where m.groupId = ? ";
    List<Object?> pars = [filter.groupId];
    if (filter.memberId.isNotEmpty) {
      whereClause += "and m.id = ? ";
      pars.add(filter.memberId);
    }
    String query = selectQuery + whereClause;
    var rows = await dbService.read(query, pars);
    var members = rows.map((e) => GroupMemberDetails.fromJson(e)).toList();
    return members;
  }

  Future<List<GroupSummary>> getGroupSummary(GroupSummaryFilter filter) async {
    String whereClause = "where trx.groupId = ? ";
    List<Object?> pars = [
      filter.groupId,
    ];

    if (filter.dateMode == "trxPeriod") {
      whereClause += "and trx.trxPeriod >= ? "
          "and trx.trxPeriod <= ? ";
      pars.add(AppUtils.getTrxPeriodFromDt(filter.sdt));
      pars.add(AppUtils.getTrxPeriodFromDt(filter.edt));
    } else if (filter.dateMode == "trxDt") {
      whereClause += "and trx.trxDt >= ? "
          "and trx.trxDt <= ? ";
      pars.add(filter.sdt.toIso8601String());
      pars.add(filter.edt.toIso8601String());
    }
    String groupBy = "group by trx.groupId,trx.trxType ";
    String orderColumns = "trx.trxType ";
    String selectColumns = "trx.groupId "
        ",trx.trxType "
        ",sum(trx.cr) as totalCr "
        ",sum(trx.dr) as totalDr ";
    if (filter.type == AppConstants.fMonthly) {
      groupBy += ",trx.trxPeriod ";
      orderColumns = "trx.trxPeriod ";
      selectColumns += ",trx.trxPeriod ";
    } else if (filter.type == AppConstants.fRange) {
      groupBy += "";
      selectColumns += ",'' as trxPeriod ";
      orderColumns = "trx.trxType ";
    }
    String selectQuery = "select $selectColumns "
        "from $transactionTableName trx ";
    String orderBy = "order by $orderColumns ";
    String query = selectQuery + whereClause + groupBy + orderBy;
    var rows = await dbService.read(query, pars);
    var balances = await getBalances(filter);
    var summary = rows.map((e) => GroupSummary.fromJson(e)).toList();
    var openingBalance = balances.first;
    var closingBalance = balances.last;
    summary.insert(0, openingBalance);
    summary.add(closingBalance);
    return summary;
  }

  Future<List<GroupSummary>> getBalances(GroupSummaryFilter filter) async {
    String selectQuery = "select "
        "? as groupId, "
        "? as trxType, "
        "? as trxPeriod, "
        "ifnull(sum(trx.cr), 0) as totalCr, "
        "ifnull(sum(trx.dr), 0) as totalDr "
        "from $transactionTableName trx ";
    String whereClause = "where trx.groupId = ? ";
    String trxPeriodSdt = AppUtils.getTrxPeriodFromDt(filter.sdt);
    String trxPeriodEdt = AppUtils.getTrxPeriodFromDt(filter.edt);
    List<Object?> openingPars = [
      filter.groupId,
      AppConstants.ttOpeningBalance,
      trxPeriodSdt,
      filter.groupId,
      trxPeriodSdt
    ];
    List<Object?> closingPars = [
      filter.groupId,
      AppConstants.ttClosingBalance,
      trxPeriodEdt,
      filter.groupId,
      trxPeriodEdt
    ];
    String openingBalance = "$selectQuery $whereClause and trx.trxPeriod < ? ";
    String closingBalance = "$selectQuery $whereClause and trx.trxPeriod <= ? ";
    String query = "$openingBalance union $closingBalance";

    var rows = await dbService.read(query, [
      ...openingPars,
      ...closingPars,
    ]);
    var summary = rows.map((e) => GroupSummary.fromJson(e)).toList();
    return summary.reversed.toList();
  }

  Future<GroupTotal> getTotalBalances(GroupTotalFilter filter) async {
    String balanceQuery = "select "
        "sum(trx.cr - trx.dr) as balance "
        "from $transactionTableName trx "
        "where trx.groupId = ? ";
    String memberCountQuery = "select "
        "count(1) as memberCount "
        "from $memberTableName m "
        "where m.groupId = ? ";
//sum(trx.cr + iif(trx.trxType = '${AppConstants.ttExpenditures}', -1, 1) * trx.dr) as totalSaving
    String totalGroupAmountQuery = "select "
        "SUM(trx.cr +CASE WHEN trx.trxType = '${AppConstants.ttExpenditures}' THEN -1 * trx.dr ELSE trx.dr END) AS totalSaving "
        "from $transactionTableName trx "
        "where trx.groupId = ? "
        "and (trx.trxType in ${AppConstants.dbCreditFilter} "
        "or trx.trxType in ('${AppConstants.ttExpenditures}' )) ";

    String query = "select ifnull(($balanceQuery), 0) as balance, "
        "ifnull(($memberCountQuery), 0) as memberCount, "
        "ifnull(($totalGroupAmountQuery), 0) as totalSaving, "
        "0 as perMemberShare ";
    var rows = await dbService
        .read(query, [filter.groupId, filter.groupId, filter.groupId]);
    var totals = rows.map((e) => GroupTotal.fromJson(e)).toList();
    var total = totals.isEmpty ? GroupTotal() : totals[0];
    if (total.memberCount != 0) {
      total.perMemberShare = total.totalSaving / total.memberCount;
    }
    return total;
  }

  Future<double?> getCurrentMonthBalance(GroupTotalFilter filter) async {
    DateTime currentMonth = DateTime.now();
    String date = AppUtils.getTrxPeriodFromDt(currentMonth);
    var query = """SELECT IFNULL(SUM(t.cr), 0.0) AS total
   FROM transactions t
    WHERE t.groupId = ?
    AND t.trxPeriod =?;
  """;
    var result = await dbService.read(query, [filter.groupId, date]);
    if (result.isNotEmpty) {
      final total = (result.first["total"] as num?)?.toDouble();
      return total;
    }

    return 0.0; // Default value if no result
  }

  Future<String?> getLastLoanInterestDate(GroupMemberDetails filter) async {
    var query = """
          SELECT trxPeriod from transactions where memberId=? and groupId=? order by trxPeriod desc limit 1 ;
    """;
    var result = await dbService.read(query, [filter.memberId, filter.groupId]);
    DateTime currentMonth = DateTime.now();
    String date = AppUtils.getTrxPeriodFromDt(currentMonth);
    if (result.isNotEmpty) {
      String? dateFinal = (result.first["trxPeriod"] as String?)?.toString();
      return dateFinal;
    }
    return date;
  }

  String getAmountQuery(String trxType, String trxPeriod,
      [String mode = "cr"]) {
    String column = "t.cr";
    if (mode == "dr") {
      column = "t.dr";
    } else if (mode == "both") {
      column = "t.cr - t.dr";
    }
    return "select ifnull(sum($column), 0.0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        "and t.trxPeriod = '$trxPeriod' "
        "and t.trxType = '$trxType' ";
  }

  Future<List<MemberTransactionDetails>> getMemberDetailsByMemberId(
      String memberId, String groupId, String startDate, String endDate) async {
    String remainingLoanQuery = """
    SELECT IFNULL(SUM(t2.dr-t2.cr), 0) AS remainingLoan
    FROM transactions t2
    WHERE t2.groupId = ? 
    AND t2.memberId= t.memberId 
    AND t2.trxType='${AppConstants.ttLoan}'
    AND t2.trxPeriod <= t.trxPeriod
  """;
    String query = """
     SELECT
      memberId,
      trxPeriod,
      SUM(CASE WHEN trxType='Share' THEN cr ELSE 0 END) AS Paid_Shares,
      SUM(CASE WHEN trxType='Loan' AND dr > 0 THEN dr ELSE 0 END) AS Lend_Loan,
      SUM(CASE WHEN trxType='LoanInterest' THEN cr ELSE 0 END) AS Paid_Interest,
      SUM(CASE WHEN trxType='Loan' AND cr > 0 THEN cr ELSE 0 END) AS Paid_Loan,
      ($remainingLoanQuery) AS Remaining_Loan,
      sum(case when trxType='LateFee' then cr else 0 end) as Paid_LateFee,
      sum(case when trxType='Others' then cr else 0 end) as Others
    FROM
      transactions t
    WHERE
      memberId =? and groupId=? and trxPeriod>=? and trxPeriod<=?
    GROUP BY
      memberId, trxPeriod;
    """;

    var rows = await dbService
        .read(query, [groupId, memberId, groupId, startDate, endDate]);

    if (rows.isNotEmpty) {
      return rows.map((e) => MemberTransactionDetails.fromJson(e)).toList();
    } else {
      return []; // Return an empty list if no member details found
    }
  }

  Future<List<double>> getLoanTakenTillToday(
      String groupId, String currentDate) async {
    var query = """
    SELECT
      SUM(CASE WHEN t.trxType = 'Loan' THEN t.dr ELSE 0 END) as LoanTakenTillToday
    FROM  transactions t WHERE
      t.groupId = ? AND t.trxPeriod <= ?
    GROUP BY
      t.memberId;
  """;

    var result = await dbService.read(query, [groupId, currentDate]);

    if (result.isNotEmpty) {
      return result
          .map((e) => (e["LoanTakenTillToday"] as int).toDouble())
          .toList();
    }

    return []; // Return an empty list if no result
  }

  Future<List<MemberTransactionSummary>> getYearlySummary(
      String groupId, String startDate, String endDate) async {
    var query = """
    SELECT 
       m.name,
       sum(case when t.trxType='Share' then t.cr else 0 end) as TotalSharesDeposit,
       sum(case when t.trxType='LoanInterest' then t.cr else 0 end) as TotalLoanInterest,
       sum(case when t.trxType='LateFee' then t.cr else 0 end) as TotalPenalty,
       sum(case when t.trxType='Others' then t.cr else 0 end) as OtherDeposit,
       sum(case when t.trxType='Loan' then t.dr else 0 end) as LoanTakenTillDate,
       sum(case when t.trxType='Loan' then t.cr else 0 end) as LoanReturn,
       sum(case when t.trxType='Share' then t.dr else 0 end) as SharesGivenByGroup
    FROM transactions t 
    JOIN members m 
      ON t.memberId = m.id 
    WHERE t.groupId = ?  
      and t.trxPeriod >= ?  
      and t.trxPeriod <= ?
    GROUP BY 
      t.memberId;
     """;
    var rows = await dbService.read(query, [groupId, startDate, endDate]);

    if (rows.isNotEmpty) {
      return rows.map((e) => MemberTransactionSummary.fromJson(e)).toList();
    } else {
      return []; // Return an empty list if no member details found
    }
  }

  Future<GroupBalanceSummary> getBalanceSummary(
      String groupId, String startDate, String endDate) async {
    var remainingLoan = """
    SELECT 
      (SUM(CASE WHEN t2.trxType = 'Loan' THEN t2.dr ELSE 0.0 END) - SUM(CASE WHEN t2.trxType = 'Loan' THEN t2.cr ELSE 0.0 END))
    FROM transactions t2
    WHERE t2.groupId = ?
    AND t2.trxPeriod <= ?""";
    var query = """
   SELECT 
    (SELECT IFNULL(SUM(t1.cr - t1.dr), 0.0) 
     FROM transactions t1 
     WHERE t1.groupId = ? 
     AND t1.trxPeriod < ?) AS previousRemaining,
	  Sum(case when t.trxType = '${AppConstants.ttLoan}' then t.cr else 0 end) as paidLoan,
    SUM(CASE WHEN t.trxType = '${AppConstants.ttBankDeposit}' THEN t.cr ELSE 0.0 END) AS deposit,
    SUM(CASE WHEN t.trxType = '${AppConstants.ttShare}' THEN t.cr ELSE 0 END) AS shares,
    SUM(CASE WHEN t.trxType = '${AppConstants.ttLoanInterest}' THEN t.cr ELSE 0.0 END) AS loanInterest,
    SUM(CASE WHEN t.trxType = '${AppConstants.ttLateFee}' THEN t.cr ELSE 0.0 END) AS penalty,
    SUM(CASE WHEN t.trxType = '${AppConstants.ttOtherDeposit}' OR t.trxType = 'BankInterest' THEN t.cr ELSE 0.0 END) AS otherDeposit,
    SUM(CASE WHEN t.trxType = '${AppConstants.ttExpenditures}' THEN t.dr ELSE 0 END) AS expenditures,
	  SUM(case when t.trxType = '${AppConstants.ttLoan}' then t.dr else 0.0 end) as givenLoan,
    ($remainingLoan) AS remainingLoan
   FROM transactions t  

  WHERE t.groupId =? 
  AND (t.trxPeriod >= ? AND t.trxPeriod <= ?);
  """;

    var result = await dbService.read(query,
        [groupId, startDate, groupId, endDate, groupId, startDate, endDate]);

    if (result.isNotEmpty) {
      return GroupBalanceSummary.fromSqlResults(result.first);
    }
    return GroupBalanceSummary(
      deposit: 0.0,
      shares: 0.0,
      loanInterest: 0.0,
      penalty: 0.0,
      otherDeposit: 0.0,
      expenditures: 0.0,
      remainingLoan: 0.0,
      paidLoan: 0.0,
      previousRemaining: 0.0,
      givenLoan: 0.0,
    );
  }

  Future<CalculatedMonthlySummary> getMonthlySummary(
      String groupId, String startDate) async {
    var query = """
   SELECT
  SUM(CASE WHEN t.trxType = 'Deposit' THEN t.cr ELSE 0.0 END) AS totalDeposit,
  SUM(CASE WHEN t.trxType = 'Share' THEN t.cr ELSE 0.0 END) AS totalShares,
  SUM(CASE WHEN t.trxType = 'LoanInterest' THEN t.cr ELSE 0.0 END) AS TotalLoanInterest,
  SUM(CASE WHEN t.trxType = 'LateFee' THEN t.cr ELSE 0.0 END) AS TotalPenalty,
  SUM(CASE WHEN (t.trxType = 'Others' OR t.trxType='BankInterest') THEN t.cr ELSE 0 END) AS OtherDeposit,
  SUM(CASE WHEN t.trxType = 'Expenditures' THEN t.dr ELSE 0.0 END) AS totalExpenditures,
  (SELECT (SUM(CASE WHEN t1.trxType='Loan' THEN t1.dr ELSE 0.0 END) - SUM(CASE WHEN t1.trxType='Loan' THEN t1.cr ELSE 0.0 END)) AS Loan 
   FROM transactions t1 
   WHERE t1.groupId=? AND t1.trxPeriod <=?) AS remainingLoan,
  SUM(CASE WHEN t.trxType='Loan' THEN t.dr ELSE 0.0 END) AS givenLoan,
  (SELECT SUM(t2.cr - t2.dr) 
   FROM transactions t2 
   WHERE t2.groupId=? AND t2.trxPeriod <?) AS previousRemainingBalance,
  SUM(CASE WHEN t.trxType='Loan' THEN t.cr ELSE 0.0 END) AS paidLoan
FROM transactions t
WHERE
  t.groupId = ? AND
  t.trxPeriod = ?;
  """;

    var result = await dbService.read(
        query, [groupId, startDate, groupId, startDate, groupId, startDate]);

    var response = MonthlyBalanceSummary(
        givenLoan: 0.0,
        peviousRemainigBalance: 0.0,
        paidLoan: 0.0,
        totalDeposit: 0.0,
        totalShares: 0.0,
        totalLoanInterest: 0.0,
        totalPenalty: 0.0,
        otherDeposit: 0.0,
        totalExpenditures: 0.0,
        remainingLoan: 0.0);

    if (result.isNotEmpty) {
      response = MonthlyBalanceSummary.fromSqlResults(result.first);
    }
    return CalculatedMonthlySummary(response);
  }
}
