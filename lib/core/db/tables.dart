import 'package:drift/drift.dart';

/// 대화 1건. `conversationId` 는 백엔드 `done` 이벤트가 도착해야 채워진다.
@DataClassName('ConversationRow')
class Conversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text()();
  TextColumn get conversationId => text().nullable()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get lastPreview => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 메시지 1건. `citationsJson` 은 인용 청크 배열 JSON.
@DataClassName('MessageRow')
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get conversationLocalId =>
      integer().references(Conversations, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get citationsJson => text().withDefault(const Constant('[]'))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// 신고서 (로컬 mock — Stage 3 단계에서 백엔드 미구현).
/// `receiptNo` 는 R-yyyy-mmdd-nnnn 형식의 사용자 노출 식별자.
@DataClassName('ReportRow')
class Reports extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get receiptNo => text().unique()();
  TextColumn get role => text()();
  TextColumn get gradeBand => text()();
  TextColumn get typesJson => text().withDefault(const Constant('[]'))();
  TextColumn get whenLabel => text()();
  TextColumn get whereLabel => text()();
  TextColumn get body => text().withDefault(const Constant(''))();
  BoolColumn get anonymous => boolean().withDefault(const Constant(true))();

  /// received | investigating | review | concluded
  TextColumn get statusCode => text().withDefault(const Constant('received'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 알림 인박스 — FCM 수신 + 진행 변화로 누적.
/// `kind`: milestone | event | guide
@DataClassName('InboxRow')
class InboxItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  TextColumn get title => text()();
  TextColumn get detail => text().withDefault(const Constant(''))();
  TextColumn get receiptNo => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
