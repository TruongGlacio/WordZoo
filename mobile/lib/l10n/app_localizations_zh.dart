// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'WordZoo';

  @override
  String get welcome => '欢迎来到 WordZoo';

  @override
  String get subtitle => '通过趣味学习英语';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get guestMode => '以访客身份继续';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get displayName => '显示名称';

  @override
  String get signUp => '注册';

  @override
  String get signIn => '登录';

  @override
  String get signOut => '登出';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get noAccount => '还没有账户？';

  @override
  String get alreadyHaveAccount => '已有账户？';

  @override
  String get passwordMismatch => '密码不匹配';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get emailRequired => '邮箱为必填项';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordRequired => '密码为必填项';

  @override
  String get displayNameRequired => '显示名称为必填项';

  @override
  String get loginSuccess => '登录成功';

  @override
  String get registerSuccess => '注册成功';

  @override
  String get loginFailed => '登录失败';

  @override
  String get registerFailed => '注册失败';

  @override
  String get guestLogin => '已以访客身份登录';

  @override
  String get loading => '加载中...';

  @override
  String get retry => '重试';

  @override
  String get error => '错误';

  @override
  String get ok => '确定';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get close => '关闭';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get finish => '完成';

  @override
  String get home => '首页';

  @override
  String get categories => '分类';

  @override
  String get favorites => '收藏';

  @override
  String get progress => '进度';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get premium => '高级版';

  @override
  String get upgrade => '升级';

  @override
  String get premiumLocked => '🔒 升级高级版以解锁';

  @override
  String get learned => '已学习';

  @override
  String get favorite => '收藏';

  @override
  String get notFavorite => '未收藏';

  @override
  String get markAsLearned => '标记为已学习';

  @override
  String get unmarkAsLearned => '取消已学习标记';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get audio => '音频';

  @override
  String get soundEffect => '音效';

  @override
  String get difficulty => '难度';

  @override
  String get easy => '简单';

  @override
  String get medium => '中等';

  @override
  String get hard => '困难';

  @override
  String get search => '搜索...';

  @override
  String get noResults => '未找到结果';

  @override
  String get noData => '暂无数据';

  @override
  String get syncing => '同步中...';

  @override
  String get syncComplete => '同步完成';

  @override
  String get syncFailed => '同步失败';

  @override
  String get offline => '离线';

  @override
  String get online => '在线';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get unknownError => '未知错误';

  @override
  String get networkError => '网络错误';

  @override
  String get serverError => '服务器错误';

  @override
  String get validationError => '验证错误';

  @override
  String get pleaseWait => '请稍候...';

  @override
  String get loadingData => '加载数据中...';

  @override
  String get loadingCategories => '加载分类中...';

  @override
  String get loadingEntities => '加载实体中...';

  @override
  String get vietnamese => '越南语';

  @override
  String get english => '英语';

  @override
  String get chinese => '中文';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get preferences => '偏好设置';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get contactUs => '联系我们';

  @override
  String get help => '帮助';

  @override
  String get feedback => '反馈';

  @override
  String get rateUs => '评价应用';

  @override
  String get shareApp => '分享应用';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String helloUser(Object name) {
    return '你好，$name！';
  }

  @override
  String get todayIsNewDay => '今天学什么？😊';

  @override
  String get continueLearning => '继续学习';

  @override
  String get startLearning => '开始学习';

  @override
  String get animals => '动物';

  @override
  String get plants => '植物';

  @override
  String get vehicles => '车辆';

  @override
  String get humanRelations => '人际关系';

  @override
  String get selectCategory => '选择分类';

  @override
  String get selectSubcategory => '选择子分类';

  @override
  String get entityList => '实体列表';

  @override
  String get entityDetail => '实体详情';

  @override
  String get practice => '练习';

  @override
  String get quiz => '测验';

  @override
  String get flashcard => '闪卡';

  @override
  String get dailyStreak => '连续天数';

  @override
  String streakDays(Object count) {
    return '$count 天连续';
  }

  @override
  String streakDays_plural(Object count) {
    return '$count 天连续';
  }

  @override
  String get points => '积分';

  @override
  String get level => '等级';

  @override
  String get rank => '排名';

  @override
  String get achievement => '成就';

  @override
  String get achievements => '成就';

  @override
  String get badge => '徽章';

  @override
  String get badges => '徽章';

  @override
  String get completed => '已完成';

  @override
  String get inProgress => '进行中';

  @override
  String get notStarted => '未开始';

  @override
  String get timeSpent => '用时';

  @override
  String get entitiesLearned => '已学习实体';

  @override
  String get accuracy => '准确率';

  @override
  String get correct => '正确';

  @override
  String get wrong => '错误';

  @override
  String get skip => '跳过';

  @override
  String get submit => '提交';

  @override
  String get answer => '答案';

  @override
  String get answers => '答案';

  @override
  String get question => '问题';

  @override
  String get questions => '问题';

  @override
  String get result => '结果';

  @override
  String get results => '结果';

  @override
  String get score => '分数';

  @override
  String get totalScore => '总分';

  @override
  String get percentage => '百分比';

  @override
  String get pass => '通过';

  @override
  String get fail => '未通过';

  @override
  String get excellent => '太棒了！';

  @override
  String get great => '做得好！';

  @override
  String get good => '很好！';

  @override
  String get keepTrying => '继续努力！';

  @override
  String get congratulations => '恭喜！';

  @override
  String get wellDone => '做得好！';

  @override
  String get dailyGoal => '每日目标';

  @override
  String get goalReached => '已达目标！';

  @override
  String get goalNotReached => '未达目标';

  @override
  String get streak => '连续';

  @override
  String get longestStreak => '最长连续';

  @override
  String get currentStreak => '当前连续';

  @override
  String get bestScore => '最高分';

  @override
  String get lastPlayed => '上次游戏';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String daysAgo(Object count) {
    return '$count 天前';
  }

  @override
  String hoursAgo(Object count) {
    return '$count 小时前';
  }

  @override
  String minutesAgo(Object count) {
    return '$count 分钟前';
  }

  @override
  String get justNow => '刚刚';

  @override
  String get noInternet => '无网络连接';

  @override
  String get checkingConnection => '检查连接中...';

  @override
  String get retryNow => '立即重试';

  @override
  String get goToSettings => '前往设置';

  @override
  String get enableNetwork => '请启用网络连接';

  @override
  String get premiumFeature => '高级版功能';

  @override
  String get premiumDescription => '升级高级版解锁所有功能';

  @override
  String get premiumMonthly => '高级版月度';

  @override
  String get premiumYearly => '高级版年度';

  @override
  String get premiumBenefits => '高级版权益';

  @override
  String get benefit1 => '无广告体验';

  @override
  String get benefit2 => '无限实体';

  @override
  String get benefit3 => '高级分析';

  @override
  String get benefit4 => '优先支持';

  @override
  String get benefit5 => '独家内容';

  @override
  String get subscribe => '订阅';

  @override
  String get subscribed => '已订阅';

  @override
  String get notSubscribed => '未订阅';

  @override
  String get paymentSuccessful => '支付成功！';

  @override
  String get paymentFailed => '支付失败';

  @override
  String get paymentCancelled => '支付已取消';

  @override
  String get processingPayment => '处理支付中...';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get purchased => '已购买';

  @override
  String get notPurchased => '未购买';

  @override
  String get consumed => '已消耗';

  @override
  String get notConsumed => '未消耗';

  @override
  String get rewardedAd => '观看广告获得奖励';

  @override
  String get rewardedAdGranted => '已获得奖励！';

  @override
  String get rewardedAdFailed => '未获得奖励';

  @override
  String get adNotAvailable => '暂无广告';

  @override
  String get loadingAd => '加载广告中...';

  @override
  String get dataSync => '数据同步';

  @override
  String get syncNow => '立即同步';

  @override
  String get autoSync => '自动同步';

  @override
  String get lastSync => '上次同步';

  @override
  String get never => '从未';

  @override
  String get dataVersion => '数据版本';

  @override
  String get dataUpdated => '数据更新成功';

  @override
  String get dataUpdateFailed => '数据更新失败';

  @override
  String get downloadingData => '下载数据中...';

  @override
  String get dataReady => '数据已就绪';

  @override
  String get noNewData => '无新数据';

  @override
  String get cacheCleared => '缓存已清除';

  @override
  String get cacheClearFailed => '清除缓存失败';

  @override
  String get storageFull => '存储空间已满';

  @override
  String get storageWarning => '设备存储空间不足';

  @override
  String get appUpdated => '应用已更新';

  @override
  String get newVersionAvailable => '有新版本可用';

  @override
  String get latestVersion => '您使用的是最新版本';

  @override
  String get checkUpdate => '检查更新';

  @override
  String get notification => '通知';

  @override
  String get notifications => '通知';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get notificationEnabled => '通知已启用';

  @override
  String get notificationDisabled => '通知已禁用';

  @override
  String get permissionDenied => '权限被拒绝';

  @override
  String get permissionRequired => '此功能需要权限';

  @override
  String get grantPermission => '授予权限';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get settingsReset => '设置已重置';

  @override
  String get resetSettings => '重置设置';

  @override
  String get confirmReset => '确定要重置所有设置吗？';

  @override
  String get logout => '登出';

  @override
  String get confirmLogout => '确定要登出吗？';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get confirmDeleteAccount => '确定要删除账户吗？此操作不可撤销。';

  @override
  String get accountDeleted => '账户已删除';

  @override
  String get accountDeleteFailed => '删除账户失败';

  @override
  String get reportIssue => '报告问题';

  @override
  String get sendFeedback => '发送反馈';

  @override
  String get feedbackSent => '反馈已发送';

  @override
  String get feedbackFailed => '发送反馈失败';

  @override
  String get share => '分享';

  @override
  String get copyLink => '复制链接';

  @override
  String get linkCopied => '链接已复制';

  @override
  String get rateThisApp => '评价此应用';

  @override
  String get thanksForRating => '感谢评价！';

  @override
  String get noRatingGiven => '未评价';

  @override
  String get openInStore => '在商店中打开';

  @override
  String get writeReview => '撰写评论';

  @override
  String get reviewSent => '评论已发送';

  @override
  String get reviewFailed => '发送评论失败';

  @override
  String get helpCenter => '帮助中心';

  @override
  String get faq => '常见问题';

  @override
  String get contactSupport => '联系支持';

  @override
  String get supportEmail => 'support@wordzoo.com';

  @override
  String get socialMedia => '社交媒体';

  @override
  String get followUs => '关注我们';

  @override
  String get copyright => '© 2026 WordZoo。保留所有权利。';

  @override
  String get madeWithLove => '为孩子们用心制作 ❤️';

  @override
  String get developer => '开发者';

  @override
  String get company => 'WordZoo Inc.';

  @override
  String get tagline => '学英语，一起玩';

  @override
  String get selectEntityToViewDetails => '选择一个实体查看详情';

  @override
  String errorWithMessage(Object message) {
    return '错误：$message';
  }

  @override
  String englishLabel(Object text) {
    return '英文：$text';
  }

  @override
  String chineseLabel(Object text) {
    return '中文：$text';
  }
}
