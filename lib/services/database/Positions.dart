import 'package:drift/drift.dart';

@DataClassName('Position')
class Positions extends Table {
  // Assuming id is an auto-incrementing integer primary key
  IntColumn get id => integer()();

  // Storing location as text, you might need a custom converter
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get altitude => real().nullable()();

  // Nullable unsigned tiny integer, mapped as a regular integer and nullable
  IntColumn get heading => integer().nullable()();

  // Nullable floats
  RealColumn get speed => real().nullable()();
  RealColumn get accuracy => real().nullable()();

  // Date time column for timestamp
  DateTimeColumn get timestamp => dateTime()();

  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();

  // Foreign keys, assuming they are just integers
  IntColumn get userId => integer().nullable()();
  IntColumn get runId => integer()();

}
