# Contributing to nolotiro.org

## For internal contributors (with push privileges to alabs/nolotiro.org)

### Development workflow

We follow some conventions in order to allow fast and reliable releases of our
master branch, and to keep everyone involved in the development.

- Never commit directly to master. Always create and hotfix/feature branch and
  open a PR. Our master is protected so you won't be able to do it anyways.

- The master branch is considered always stable and deployable so the review
  process when opening a PR is a very important step in the development.

- Your PR must be approved by at least one other contributor and by CI before
  being merged. Once you get a green check from Travis and a :+1: symbol (or
  github :+1: reaction) from at least one other contributor, you can merge your
  own PR. The original creator of a PR should feel confortable with her code
  being added to master, so only her should merge the PR.

- Once you're done addressing feedback about your PR, you can post the :recycle:
  symbol to let the other contributors know it is ready to be reviewed again.

- If a branch needs/wants to be tested in staging before being merged, it can be
  deployed to staging using `bin/cap staging deploy` and writing down the
  branch name when asked for it. Just remember that once the code is merged into
  master, it can (and should) be deployed any time.

- If your PR fixes a github issue, you can include the issue number in the PR
  description branch name to better communicate this. Also, if you include the
  words "Fixes", "Fix", "Closes" or "Close" followed by the issue number, Github
  will automatically close the issue once the PR is merged. This is probably
  better than specifying it in the commit message itself, since in the case a
  mention to the issue will be generated every time a rebase is made, cluttering
  the issue history.

- After merging your PR, make sure you delete the merged branch.
