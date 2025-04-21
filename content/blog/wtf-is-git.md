+++
title = 'WTF Is Git'
description = ""
date = 2025-04-21T22:26:11+07:00
draft = false
tags = []
author = "anhkhoakz"
+++

---

## Semantic Versioning

Semantic Versioning (SemVer) is a versioning scheme for software that uses a three-part version number: `MAJOR.MINOR.PATCH`. Each part of the version number has a specific meaning:
- **MAJOR** version when you make incompatible API changes,
- **MINOR** version when you add functionality in a backwards-compatible manner, and
- **PATCH** version when you make backwards-compatible bug fixes.

## Conventional Commits

Conventional Commits is a specification for writing standardized commit messages. It provides a set of rules for writing commit messages that are easy to read and understand. The format of a conventional commit message is as follows:

```
<type>[optional scope]: <description>
[optional body]
[optional footer(s)]
```
Where:
- **type**: The type of change being made (e.g., feat, fix, chore, docs, style, refactor, perf, test).
- **optional scope**: A scope can be anything specifying the place of the commit change (e.g., component or file name).
- **description**: A short description of the change.
- **optional body**: A longer description of the change, if necessary.
- **optional footer(s)**: Additional information about the change, such as breaking changes or issues closed.
For example, a commit message might look like this:

```
feat(auth): add login functionality
Add login functionality to the authentication module, allowing users to log in with their email and password.
BREAKING CHANGE: The login endpoint has changed from /api/login to /api/auth/login.
```
This commit message indicates that a new feature (login functionality) has been added to the authentication module, and it also includes a breaking change (the login endpoint has changed).

## Git Branching Model

{{<figure src="images/blogs/wtf-is-git/git-flow.png" alt="Git Branching Model" caption="Git Branching Model">}}

The Git Branching Model is a set of guidelines for managing branches in a Git repository. It provides a structured approach to branching and merging, making it easier to manage code changes and releases. The model consists of several types of branches:
- **master**: The main branch that contains the production-ready code. This branch should always be stable and deployable.
- **develop**: The branch where development happens. Features are merged into this branch before being released.
- **feature**: Branches created for new features. They are merged back into develop when complete.
- **release**: Branches used to prepare for a new production release. They allow for last-minute fixes and preparation.
- **hotfix**: Branches created to quickly address issues in production. They are merged back into both master and develop.
- **bugfix**: Branches created to fix bugs in the code. They are merged back into develop when complete.
- **chore**: Branches for routine tasks that do not affect the application’s functionality.


## Tools

- **[Git](https://git-scm.com/)** (of course?): A version control system that allows you to track changes in your code and collaborate with others.
- **[nvie/gitflow](https://github.com/nvie)**: A set of Git extensions to provide high-level repository operations for Vincent Driessen's branching model.
- **[git message template]()**: A template for writing commit messages that follow the Conventional Commits specification.
- **[semantic-release](https://semantic-release.gitbook.io/semantic-release/)**: A tool to automate versioning and package publishing based on the commits in your repository.


### Resources

Semantic Versioning 2.0.0 - [url](https://semver.org)

Conventional Commits - [url](https://www.conventionalcommits.org/en/v1.0.0/)

A successful Git branching model - [url](https://nvie.com/posts/a-successful-git-branching-model/)

---
