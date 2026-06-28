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
{"valid": false, "errors": {"0.field": ["The field field is required."]}}
```

## Local run

```bash
dart run bin/eva_data_validator.dart --local
```

## Config

See [example-config.yaml](example-config.yaml).

- `locale` — error message language (`en` by default, `ru` for Russian)
- `validations` — named validation schemas

Rules use Laravel pipe syntax, for example: `required|integer|min:1|max:100`.

Unique values are checked via `eva-generic-db-service`, for example: `unique:db.dictionary.product,barcode`.
