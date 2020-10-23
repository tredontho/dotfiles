### `sync_here.sh`
This will try to find existing files in the filesystem which match the paths of
files tracked here, and update the working copy in this git repo.

It's probably a good idea to make sure there are no changes in your working
copy before running this, they will be lost.  A simple way to add a new file to
track is to just `touch` it.  I haven't tried this, but it sounds like it'd
work.

### Misc

* The `.gitignore_global` is useful for things like system-wide things you'd
  never want to commit to git.  Editor metadata (vim backups, IntelliJ/Eclipse
  project info, etc.)
* The OpenVPN conf file should be generated using whtaever is recommended by
  your VPN provider.  You can store a username/password in a text file and
  reference it with `auth-user-pass /path-to-file/credentials.txt`
