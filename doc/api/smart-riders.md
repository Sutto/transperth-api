# SmartRiders

## Getting a smart rider information

This accepts a smartrider number and attempts to return available information about
said number in the form of the remaining balance, the type of smart rider and any
discounts applicable.

If the smart rider number is invalid or unprocessible, it will instead return a 404
status code with `not_found` in the standard error body form.

```http
GET /1/smart_riders/123456789 HTTP/1.1
```

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "response": {
    "autoload": true,
    "balance": 29.69,
    "concession_expires": "N\\A",
    "concession_type": "Standard"
  }
}
```