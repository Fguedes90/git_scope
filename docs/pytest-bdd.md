# pytest-bdd: BDD Framework for pytest

pytest-bdd implements Gherkin language for automating project requirements testing and facilitating behavior-driven development. Unlike other BDD tools, it integrates directly with pytest, enabling unified unit and functional tests.

## Key Features

- Direct pytest integration
- Reusable pytest fixtures
- No separate test runner needed
- Supports scenario outlines and examples
- Powerful step parametrization

## Basic Example

```gherkin
# publish_article.feature
Feature: Blog
    A site where you can publish articles.

    Scenario: Publishing the article
        Given I'm an author user
        And I have an article
        When I go to the article page
        And I press the publish button
        Then I should not see the error message
        And the article should be published
```

```python
# test_publish_article.py
from pytest_bdd import scenario, given, when, then

@scenario('publish_article.feature', 'Publishing the article')
def test_publish():
    pass

@given("I'm an author user")
def author_user(auth, author):
    auth['user'] = author.user

@given("I have an article", target_fixture="article")
def article(author):
    return create_test_article(author=author)

@when("I go to the article page")
def go_to_article(article, browser):
    browser.visit(urljoin(browser.url, f'/manage/articles/{article.id}/'))

@when("I press the publish button")
def publish_article(browser):
    browser.find_by_css('button[name=publish]').first.click()

@then("I should not see the error message")
def no_error_message(browser):
    with pytest.raises(ElementDoesNotExist):
        browser.find_by_css('.message.error').first

@then("the article should be published")
def article_is_published(article):
    article.refresh()
    assert article.is_published
```

## Project Structure

A recommended way to organize your BDD tests is by semantic groups. Here's an example structure:

```
project/
├── features/
│   ├── frontend/
│   │   └── auth/
│   │       └── login.feature
│   └── backend/
│       └── auth/
│           └── login.feature
└── tests/
    └── functional/
        └── test_auth.py
```

The test files can be organized differently from the feature files. For example:

```python
# tests/functional/test_auth.py
from pytest_bdd import scenario

@scenario('frontend/auth/login.feature')
def test_logging_in_frontend():
    pass

@scenario('backend/auth/login.feature')
def test_logging_in_backend():
    pass
```

You can also use `conftest.py` to share common step definitions:

```python
# tests/functional/conftest.py
from pytest_bdd import given, then

@given("I have a test user")
def test_user():
    return create_test_user()

@then("the operation should succeed")
def operation_succeeded():
    assert True
```

## Step Arguments

pytest-bdd supports multiple parsers for step arguments:

1. **string** (default) - Exact string matching
2. **parse** - Simple parser using `{param:Type}` syntax
3. **cfparse** - Extended parser with cardinality support
4. **re** - Regular expressions with named groups

Example:

```gherkin
Feature: Step arguments
    Scenario: Arguments for given, when, then
        Given there are 5 cucumbers
        When I eat 3 cucumbers
        Then I should have 2 cucumbers
```

```python
from pytest_bdd import parsers

@given(parsers.parse("there are {start:d} cucumbers"), target_fixture="cucumbers")
def given_cucumbers(start):
    return {"start": start, "eat": 0}

@when(parsers.parse("I eat {eat:d} cucumbers"))
def eat_cucumbers(cucumbers, eat):
    cucumbers["eat"] += eat

@then(parsers.parse("I should have {left:d} cucumbers"))
def should_have_left_cucumbers(cucumbers, left):
    assert cucumbers["start"] - cucumbers["eat"] == left
```

## Fixtures and Dependencies

pytest-bdd leverages pytest's fixture system for test setup:

```python
@pytest.fixture
def article():
    return Article()

@given("I have a beautiful article")
def i_have_an_article(article):
    """Reuse the article fixture"""
```

## Backgrounds

Use backgrounds for common setup across scenarios:

```gherkin
Feature: Multiple site support
    Background:
        Given a global administrator named "Greg"
        And a blog named "Greg's blog"

    Scenario: Greg posts to his blog
        When I log in as Greg
        And I create a post
        Then I should see "Post created"
```

## Tags and Filtering

Use tags to categorize and filter scenarios:

```gherkin
@login @backend
Feature: Login
    @successful
    Scenario: Successful login
```

Run specific tags:
```bash
pytest -m "backend and login and successful"
```

## Reporting

Generate Cucumber JSON reports:
```bash
pytest --cucumberjson=report.json
```

Enable Gherkin terminal output:
```bash
pytest -v --gherkin-terminal-reporter
```

## Code Generation

Generate test code from feature files:
```bash
pytest-bdd generate features/some.feature > tests/test_some.py
```

Generate missing test code:
```bash
pytest --generate-missing --feature features tests/functional
```

## Best Practices

1. Organize features in semantic groups
2. Use backgrounds for common setup
3. Keep scenarios focused and atomic
4. Leverage pytest fixtures for reusable setup
5. Use tags for test organization and filtering
6. Implement clear step definitions
7. Maintain consistent naming conventions
8. Keep feature files close to related test files
9. Use conftest.py for shared step definitions
10. Follow a clear directory structure

For more details, visit the [official documentation](https://pytest-bdd.readthedocs.io/)

