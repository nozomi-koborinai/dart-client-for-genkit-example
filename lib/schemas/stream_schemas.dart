import 'package:json_annotation/json_annotation.dart';

part 'stream_schemas.g.dart';

@JsonSerializable()
class StreamInput {
  final String prompt;

  StreamInput({required this.prompt});

  factory StreamInput.fromJson(Map<String, dynamic> json) =>
      _$StreamInputFromJson(json);
  Map<String, dynamic> toJson() => _$StreamInputToJson(this);
}

@JsonSerializable()
class StreamOutput {
  final String text;
  final String summary;

  StreamOutput({required this.text, required this.summary});

  factory StreamOutput.fromJson(Map<String, dynamic> json) =>
      _$StreamOutputFromJson(json);
  Map<String, dynamic> toJson() => _$StreamOutputToJson(this);
}
