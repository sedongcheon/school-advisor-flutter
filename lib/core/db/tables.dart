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
