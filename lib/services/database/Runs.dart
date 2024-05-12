import 'package:drift/drift.dart';

@DataClassName('Run')
class Runs extends Table {
  // Assuming id is an auto-incrementing integer primary key
  IntColumn get id => integer().autoIncrement()();

  // String fields for name and description
  TextColumn get name => text()();
  TextColumn get description => text()();

  // Foreign key, assumed to be an integer
  IntColumn get userId => integer().nullable()();

  // Unsigned tiny integer, mapped as a regular integer
  IntColumn get type => integer()();

  // Automatic handling of created_at and updated_at timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

}
