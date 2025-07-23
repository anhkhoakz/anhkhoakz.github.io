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

{{<figure src="images/blogs/wtf-is-git/semver.webp" alt="Semantic Versioning"
caption="Semantic Versioning">}}

The three-part version number `MAJOR.MINOR.PATCH` is used by the software
versioning system known as Semantic Versioning (SemVer).  The meaning of each
component of the version number is distinct:

- **MAJOR** version is used for incompatible API modifications.

- **MINOR** version is used for backwards-compatible functionality additions.

- **PATCH** version is used for backwards-compatible bug fixes.

## Conventional Commits

A specification for creating consistent commit messages is called Conventional
Commits. It offers a set of guidelines for crafting readable and intelligible
commit messages. A standard commit message has the following structure:

```plaintext
<type>[optional scope]: <description>
[optional body]
[optional footer(s)]
```

- The change type (e.g., feat, fix, chore, documentation, style, refactor, perf,
test) is indicated by the **type** field.

- **optional scope**: A scope can be anything that indicates where the commit
modification was made, such as the file name or component.

- **description**: A brief explanation of the modification.

- **optional body**: If required, a more thorough explanation of the
modification.

 Additional information regarding the update, such as breaking changes or issues
resolved, may be included in the optional footer or footers.

 A commit message could resemble this, for instance:

- **optional footer**: Additional information that may be relevant to the
commit, such as links to related issues or pull requests.

## Git Branching Model

{{<figure src="images/blogs/wtf-is-git/git-flow.webp" alt="Git Branching Model"
caption="Git Branching Model">}}

A collection of rules for handling branches in a Git repository is known as the
Git Branching Model.  It offers an organized method for branching and merging,
which facilitates the management of code updates and releases.  There are
various kinds of branches in the model:

 The primary branch containing the code that is ready for production is called

- **master**: This branch ought to be deployable and stable at all times.

 The branch where development takes place is called

- **develop**:  Before being made public, features are merged into this branch.

- **feature**: New features have their own branches.  When finished, they are
integrated back into develop.

 The branches used to get ready for a new production release are referred to as
**release**.  They enable preparation and last-minute repairs.

- **hotfix**: Branches made to promptly fix production-related problems.  Both
master and develop have been integrated back into them.

- **bugfix**: Code bugs are fixed using branches.  When finished, they are
integrated back into develop.

- **chore**: Branches for standard operations that don't impact the operation of
the application.

## Tools

- **[Git](https://git-scm.com/)** (of course?): Git is a free and open source
distributed version control system designed to handle everything from small to
very large projects with speed and efficiency.

- **[petervanderdoes/gitflow-avh](https://github.com/petervanderdoes/gitflow-avh)**:
AVH Edition of the git extensions to provide high-level repository operations
for Vincent Driessen's branching model.

- **[lisawolderiksen/git-commit-template.md](https://gist.github.com/lisawolderiksen/a7b99d94c92c6671181611be1641c733)**:
A template for writing commit messages that follow the Conventional Commits
specification.

- **[semantic-release](https://semantic-release.gitbook.io/semantic-release/)**:
Semantic-release automates the whole package release workflow including:
determining the next version number, generating the release notes, and
publishing the package.

- **[actions/semantic-pull-request](https://github.com/marketplace/actions/semantic-pull-request)**:
This is a GitHub Action that ensures that your pull request titles match the
Conventional Commits spec. Typically, this is used in combination with a tool
like semantic-release to automate releases.

### Resources

Semantic Versioning 2.0.0 - [url](https://semver.org)

Conventional Commits - [url](https://www.conventionalcommits.org/en/v1.0.0/)

A successful Git branching model -
[url](https://nvie.com/posts/a-successful-git-branching-model/)

Using git-flow to automate your git branching workflow -
[url](https://jeffkreeftmeijer.com/git-flow/)

Gitflow workflow -
[url](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

---
