# test-robotframework

A Robot Framework test automation portfolio combining UI and API test suites,
built around the Page Object pattern and structured for maintainability and
CI execution.

- **UI suite** — drives the [Tricentis sample insurance application](https://sampleapp.tricentis.com/)
  with `SeleniumLibrary`, exercising the vehicle, insurant and product data steps of
  the car insurance quote wizard (see "Known limitations" below for what's out of
  scope).
- **API suite** — exercises the [JSONPlaceholder](https://jsonplaceholder.typicode.com)
  REST API with `RequestsLibrary`.
- **UI Testing Playground suite** — covers every challenge page listed on
  [uitestingplayground.com](http://www.uitestingplayground.com/)'s homepage
  (Inflectra's UI Test Automation Playground: dynamic attributes, timing,
  visibility, Shadow DOM, alerts, frames, and more), one test case per page.

## Project structure

```
resources/
├── common.resource          # Browser lifecycle, failure diagnostics & shared assertions
├── variables.resource       # Global configuration (URL, browser, timeouts)
├── pages/                   # One resource file per wizard step (Page Object Model)
│   ├── home_page.resource
│   ├── vehicle_data_page.resource
│   ├── insurant_data_page.resource
│   ├── product_data_page.resource
│   └── playground_page.resource    # Locators & keywords for every Playground page
├── data/
│   ├── car_insurance_test_data.resource    # Named vehicle/insurant test profiles
│   └── sample_upload.txt                   # Fixture for the File Upload challenge
└── api/
    └── jsonplaceholder.resource

tests/
├── car_insurance_quote.robot    # End-to-end UI regression suite
├── insurance_navigation.robot   # UI smoke tests for the landing page
├── api/
│   └── posts_api.robot          # API regression suite
└── playground/
    └── ui_testing_playground.robot    # One test case per playground challenge page
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

Run only the UI Testing Playground suite, headless:

```bash
robot --outputdir results --variable BROWSER:headlesschrome tests/playground
```

Run by tag (e.g. the fast smoke subset):

```bash
robot --outputdir results --include smoke tests
```

Available tags: `smoke`, `regression`, `navigation`, `api`, `car-insurance`,
`playground`.

Run results (`log.html`, `report.html`, `output.xml`, screenshots) are
written to `results/` and are not committed to version control.

## Continuous integration

`.github/workflows/tests.yml` runs three independent jobs on every push and
pull request — the UI smoke suite, the API suite, and the UI Testing
Playground suite (all headless Chrome where applicable) — and publishes
each job's Robot Framework logs as workflow artifacts.

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
  be exercised with multiple data sets (vehicle profiles, user ids). Reusable
  vehicle/insurant profiles live as named dictionaries in
  `resources/data/car_insurance_test_data.resource` and are passed into
  keywords via Robot's `&{dict}` argument-unpacking syntax, rather than
  duplicating literals inline in each test case.
- **Isolation** — `Test Setup`/`Test Teardown` reset state between tests and
  capture a screenshot on UI failures for debugging.
- **Meaningful assertions** — each wizard step verifies it was genuinely
  accepted (the previous panel is gone, the next one has taken its place,
  and no client-side validation errors are showing) rather than only
  asserting that no exception was raised.

## Known limitations

The UI suite targets a third-party public demo application. If Tricentis
updates the markup of `sampleapp.tricentis.com`, only the affected file(s)
under `resources/pages/` need to be updated — the test cases themselves
should remain unchanged.

Price selection and quote submission (the steps after product data) are not
covered. The wizard's price-plan step depends on an asynchronous request
that was observed to hang indefinitely under headless automation in CI,
independent of input validity — submitted product data was accepted (no
validation errors, and the product-data panel correctly closed) but the
subsequent price-plan panel never loaded even after 45+ seconds. Extending
coverage to price selection and quote submission is a reasonable follow-up
once that step's reliability under automation can be confirmed.

The UI Testing Playground suite also targets a third-party public site,
under `resources/pages/playground_page.resource`; the same
markup-drift caveat applies there. Its locators and assertions were derived
by driving the live site from CI and inspecting its real DOM and behavior,
rather than assumed from the site's name — several pages turned out to have
markup or interaction mechanics quite different from what a generic "UI
testing playground" might suggest (e.g. Sample App's fields use dynamically
generated ids with no stable attribute but their `type`, and the Visibility
page's seven hiding techniques only take effect after a button click, not
on page load).

## License

Apache License 2.0, see [LICENSE](LICENSE).
