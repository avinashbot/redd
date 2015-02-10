### Naming:

**Special**:
```
Base#get_hot
Base#get_new
```

**Object from attribute**:
```
Base#user_from_name
Base#subreddit_from_name
Base#submission_from_fname
```

**None of the above, but special to user**:
```
Base#my_friends
Base#my_subreddits()
```

**Permanent actions**:
```
Editable#edit!(...)
Editable#hide!
Editable#delete!
```

**Models**:
```
User#created => 1230120884.0
User#get_created => #<Time:...>

Submission#subreddit => "picturegame"
Submission#get_subreddit => #<Redd::Objects::Subreddit:...>
```