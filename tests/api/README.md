# API test suite

`booking_api.robot` exercises the [restful-booker](https://restful-booker.herokuapp.com)
API, a public REST practice service that models a hotel's booking system with
token-based authentication on write operations. Keywords live in
[`resources/api/restful_booker.resource`](../../resources/api/restful_booker.resource).

## Endpoints covered

| Method | Path            | Auth required | Covered by                                                     |
| ------ | --------------- | ------------- | ---------------------------------------------------------------- |
| GET    | `/ping`         | No            | Health check test                                                 |
| POST   | `/auth`         | No            | Valid and invalid credential tests                                |
| POST   | `/booking`      | No            | Create tests, and as setup for most other tests                   |
| GET    | `/booking`      | No            | Name-filter test                                                  |
| GET    | `/booking/{id}` | No            | Get-by-id, not-found, and post-write verification tests           |
| PUT    | `/booking/{id}` | Yes           | Update-with-token and update-without-token (rejected) tests       |
| PATCH  | `/booking/{id}` | Yes           | Partial-update test                                                |
| DELETE | `/booking/{id}` | Yes           | Delete-with-token and delete-without-token (rejected) tests       |

## Authentication

`POST /auth` with `{"username": "admin", "password": "password123"}` returns
`{"token": "<token>"}`. Write operations (`PUT`, `PATCH`, `DELETE`) require
that token to be sent as a `Cookie: token=<token>` header — restful-booker
does not accept it as a bearer token or query parameter.

## Documented API quirks the tests account for

These aren't bugs in the test suite — they're genuine, confirmed behaviors of
the live service that a naive implementation would get wrong:

- `GET /ping` returns **201**, not 200, for a successful health check.
- `POST /auth` always returns **200**, even with wrong credentials. A failed
  login is signaled by the response body (`{"reason": "Bad credentials"}`),
  not the status code.
- `POST /booking` (create) returns **200**, not the more conventional 201.
- `DELETE /booking/{id}` returns **201** on success, not 200 or 204.
- Write operations without a valid token return **403 Forbidden**.

## Test data hygiene

restful-booker is a shared public server, not a sandboxed instance per test
run. Every test that creates a booking deletes it again before finishing
(directly, or via the `Delete Booking Using Fresh Token` keyword), so
repeated CI runs don't leave orphaned bookings behind.

## Meaningful assertions

Beyond status codes, each test verifies the API's actual effect:

- **Create** asserts every submitted field is echoed back exactly.
- **Get after create** re-fetches the booking independently to confirm the
  data was genuinely persisted server-side, not just echoed once.
- **Update** asserts the new details via a follow-up `GET`, not just the
  update call's own response.
- **Partial update** asserts the targeted field changed *and* every other
  field stayed exactly as it was.
- **Delete** asserts a follow-up `GET` returns 404, confirming genuine
  removal.
- **Unauthorized write attempts** assert the resource is unchanged
  afterwards, not just that the attempt itself was rejected.
