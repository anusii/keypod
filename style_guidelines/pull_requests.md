# Creating Pull Requests

## 1. Ensure corresponding issue is open
Every pull request should have a corresponding issue. If there is no issue, create one. If there is an issue, ensure that it is open and that it is linked to the pull request.

## 2. Keep pull requests small
Pull requests should be small and focused. If you are working on a large feature, break it down into smaller pieces and create a pull request for each piece. This makes it easier to review and merge your code.

In cases where a pull request is too large, ensure that reviewers are aware of this and are prepared to spend more time reviewing it.

## 3. Ensure pull request is up to date
Before creating a pull request, ensure that your branch is up to date with the latest changes from the `main` branch. This can be done by running `git pull origin main` on your branch.

## 4. Pull request title
The title of a pull request should be short and descriptive. .  This will be helpful if we move to sqaush and merge in the future.

## 5. Pull request description
The description of a pull request should be short and descriptive. It should include the following:
- A link to the corresponding issue
- A description of the changes made
- A description of how to test the changes
- A description of any known issues

## 6. TODO in pull request
If TODOs are left in the code, they should be included in the pull request description and corresponding issue should be created. This will ensure that they are not forgotten.

# Reviewing Pull Requests

## 1. Ensure pull request is up to date
Before reviewing a pull request, ensure that your branch is up to date with the latest changes from the `main` branch. This can be done by running `git pull origin main` on your branch.

## 2. Review pull request
When reviewing a pull request, ensure that the following is done:
- The code is tested and works as expected
- The code is well documented
- The code is well formatted (refer to flutter style guidelines)

