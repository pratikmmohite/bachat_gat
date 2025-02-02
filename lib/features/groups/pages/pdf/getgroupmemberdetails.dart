/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';

class GroupMemberDetailsService {
  static Future<List<GroupMemberDetails>> getGroupMemberDetails(
      {required Group group, required DateTime trxPeriodDt}) async {
    List<GroupMemberDetails> groupMemberDetails = [];
    GroupsDao groupDao = GroupsDao();

    var filter =
        MemberBalanceFilter(group.id, AppUtils.getTrxPeriodFromDt(trxPeriodDt));

    try {
      groupMemberDetails = await groupDao.getGroupMembersWithBalance(filter);
    } catch (e) {
      // Handle error appropriately, such as logging or displaying an error message
    }

    return groupMemberDetails;
  }
}
