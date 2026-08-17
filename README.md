# test-robotframework

A Robot Framework test automation portfolio combining UI and API test suites,
built around the Page Object pattern and structured for maintainability and
CI execution.

- **UI suite** — drives the [Tricentis sample insurance application](https://sampleapp.tricentis.com/)
  with `SeleniumLibrary`, exercising the car insurance quote wizard end to end.
- **API suite** — exercises the [JSONPlaceholder](https://jsonplaceholder.typicode.com)
  REST API with `RequestsLibrary`.

## Project structure

```
resources/
├── common.resource          # Browser lifecycle & failure diagnostics
├── variables.resource       # Global configuration (URL, browser, timeouts)
├── pages/                   # One resource file per wizard step (Page Object Model)
│   ├── home_page.resource
│   ├── vehicle_data_page.resource
│   ├── insurant_data_page.resource
│   ├── product_data_page.resource
│   ├── price_option_page.resource
│   └── confirmation_page.resource
└── api/
    └── jsonplaceholder.resource

tests/
├── car_insurance_quote.robot    # End-to-end UI regression suite
├── insurance_navigation.robot   # UI smoke tests for the landing page
└── api/
    └── posts_api.robot          # API regression suite
```

Each page resource owns its own locators and keywords, so a markup change on
one wizard step only requires an edit in one file. Test suites orchestrate
page keywords; they never contain raw locators.

## Prerequisites

- Python 3.9+
- Google Chrome (for the UI suite)

## Setup

```bash
python -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Selenium's built-in driver manager resolves the matching ChromeDriver
automatically, so no separate driver installation is required.

## Running the tests

Run everything:

```bash
robot --outputdir results tests
```

Run only the UI suites, headless:

```bash
robot --outputdir results --variable BROWSER:headlesschrome \
    tests/car_insurance_quote.robot tests/insurance_navigation.robot
```

Run only the API suite:

```bash
robot --outputdir results tests/api
```

Run by tag (e.g. the fast smoke subset):

```bash
robot --outputdir results --include smoke tests
```

Available tags: `smoke`, `regression`, `e2e`, `navigation`, `api`,
`car-insurance`.

Run results (`log.html`, `report.html`, `output.xml`, screenshots) are
written to `results/` and are not committed to version control.

## Continuous integration

`.github/workflows/tests.yml` runs the UI smoke suite (headless Chrome) and
the full API suite on every push and pull request, and publishes the Robot
Framework logs as workflow artifacts.

## Development tooling

Optional linting and formatting tools are listed in `requirements-dev.txt`:

```bash
pip install -r requirements-dev.txt

# Static analysis (rule thresholds tuned in robocop.toml)
robocop check tests resources

# Auto-formatting
robocop format tests resources
```

## Conventions

- **Page Object Model** — locators live in `resources/pages/*.resource`,
  never inline in test cases.
- **Explicit waits only** — every navigation is followed by
  `Wait Until Element Is Visible` (or an equivalent explicit wait); no
  `Sleep` calls.
- **Tagging** — every test case carries at least one tag so suites can be
  sliced by CI stage (`smoke` for fast feedback, `regression` for full
  coverage).
- **Data-driven cases** — `[Template]` is used where the same flow needs to
  be exercised with multiple data sets (vehicle profiles, user ids).
- **Isolation** — `Test Setup`/`Test Teardown` reset state between tests and
  capture a screenshot on UI failures for debugging.

## Known limitations

The UI suite targets a third-party public demo application. If Tricentis
updates the markup of `sampleapp.tricentis.com`, only the affected file(s)
under `resources/pages/` need to be updated — the test cases themselves
should remain unchanged.

## License

Apache License 2.0, see [LICENSE](LICENSE).
