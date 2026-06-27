# EVA Data Validator

Laravel-like validation service for the [EVA](https://github.com/eva-ics/eva4) system.

## RPC method

`validate` — validates a batch of records against a named schema from service config.

Parameters:
- `name` (`String`) — validation schema name
- `data` (`list`) — list of records (`dict` per item)

Success response:
```json
{"valid": true, "data": [{"field": "value"}]}
```

Validation failure:
```json
{"valid": false, "errors": {"0.field": ["The 0 field field is required."]}}
```

## Local run

```bash
dart run bin/eva_data_validator.dart --local
```

## Config

See [example-config.yaml](example-config.yaml).

Rules use Laravel pipe syntax, for example: `required|integer|min:1|max:100`.
