# My Git stuff

Some miscellaneous git utilities of dubious usefulness.
I didn't write all of the scripts, but the ones I didn't should be clear.
Everything by me in this repo is in the public domain.

I load all this stuff with:

    source ~/path/to/git-stuff/bashrc

in my `.bashrc`.

## Example

I am often in the middle of working on something, and I need to stop and do something else.
I'm not ready to commit, so I use `git cp` (I know git stash does the same thing, but I don't like it):

    git cp # save my work
    mp # back to up-to-date master
    b fix-something-else # create a new branch from master
    # work-work-work
    pr # open pull-request
    c- # back to my previous branch - note that `c -` would go to master
    uncommit # remove the checkpoint commit
    # work-work-work

    