# Seattle.Rb Elixir Study Group

## Study Schedule

week | chapters   | pages | comments
-----|------------|-------|---------
3/2  | 1          | 12    | install elixir, github repo, mailing list
3/9  | 2, 3, 4    | 20    |
3/16 | 5\*        | 10    |
3/23 | 6\*        | 18    |
3/30 | 7\*        | 14    |
4/6  | 8, 9       | 14    |
4/13 | 10\*       | 18    |
4/20 | 11, 12     | 24    |
4/27 | 13         | 34    | long homework in this chapter
5/4  | 14\*, 15   | 22    |
5/11 | 16\*, 17\* | 24    |
5/18 | 18, 19     | 22    |
5/25 | 20\*, 21   | 24    |
6/1  | 22\*, 23   | 22    |
6/8  | A1, A2     | 18    | wrap-up

Starred chapters include the most important concepts that we should spend time on

Some options to shorten things:

- Combine weeks 3,4 (i.e. spend 2 rather than 3 weeks on ch 5-7)
- Combine weeks 6,7

## Rebase, Don't Merge

Please put this in your `~/.gitconfig` (or `.git/config` local to your
cloned repo if you don't want to set it globally) to avoid creating
merge commits on top of others work:

```
[branch]
	autosetuprebase = always
[pull]
	rebase = preserve
```
