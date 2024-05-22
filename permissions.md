# Permissions

## Files

- Any attempt to access a file's data requires read permission.
- Any attempt to modify a file's data requires write permission.
- Any attempt to execute a file (a program or a script) requires execute permission.

  
## Directories

- An attempt to list the files in a directory requires read permission for the directory, but not on the files within.
- Execute permission is needed on a directory to be able to `cd` into it (make a directory the current working directory) and to access the inode (permissions, size, time, ...) of the files within it.
- An attempt to add a file to a directory, delete a file from a directory or rename a file requires write permission for the directory, but not for the files within. You don't have to be the owner of a file or have write permission on it to rename or delete it, you only need write permission on the directory that contains the file. But write permission on the directory is not enough, also execute permission on the directory is needed, that's because any change requires the access to the inode.


## Permissions for user, group, others and special modes

When a process tries to open a file:

1. If the file's owning user is the process's effective UID, then the `user` permission bits are used.
2. Otherwise, if the file's owning group is the process's effective GID, then the `group` permission bits are used.
3. Otherwise, the `others` permission bits are used.

→ only one set of `rwx` bits are ever used, `user` takes precedence over `group` which takes precedence over `others`.

A. Octal mode, any omitted left digit is assumed to be zero:

```bash
 u=user
 |g=group      4(r=read) 2(w=write) 1(x=execute) 
 ||o=others
 |||
0644 
|
4(s=setuid) 2(s=setgid) 1(t=sticky bit)

chmod 644  file       # typical file perm
chmod 755  dir        # typical dir perm
chmod 1777 /tmp       # set sticky bit
chmod 2755 a.sh       # set group ID
chmod 4755 a.sh       # set user ID
```

B. Symbolic mode where `+`/`-`/`=` are to add/remove/assign permissions, commas to separate and `a` is the abbreviation of `ugo` (user+group+others):

```bash
chmod g=rw,o= file    # add group rw perm and deny access to others
chmod a-x     file    # remove exec perm for all
chmod u+xs    a.sh    # add user ID (user must also have exec perm)
chmod g+xs    a.sh    # add group ID (group must also have exec perm)
chmod +t      dir     # add sticky bit
```

Special modes:

- **setuid** runs an executable with the privileges of the owner of the file.
- **setgid** runs an executable with the privileges of the group of the file.
- A directory whose **sticky bit** is set, becomes an append-only directory. A file in a sticky directory may only be deleted by the owner or the superuser (usually applied to /tmp).


## List

Find files/directories not having a given permission:

```bash
find . -type f ! -perm 644 -print
find . -type d ! -perm 755 -print
```

or together:

```bash
find . \( -type d ! -perm 755 -o -type f ! -perm 644 \) -print
```

Find files/directories not having a given user/group:

```bash
find . ! -user john -print
find . ! -group psacln -print
```


## Change

- To `chown` you must be the superuser. This restriction is because giving away a file to another user can lead to bad things, for example:
  
  1. If a system has disk quotas enabled, a malicious user could create a world-writable file under one of its directories, and then run `chown` to make that file owned by another user. The file would then count under the other user's quota.

  2. If a malicious user gives away a file to another user, there is no trace that the other user did not create that file. This can cause problems if the file contains illegal or compromising data.

- To `chgrp` you must be the superuser or if you are the owner of the file/directory you can change it to any group which you are a member of.

- To `chmod` you must be the superuser or the owner of the file/directory.

Batch permissions change for files:

```bash
find . -type f ! -perm 644 -exec chmod 644 {} +
```

Batch permissions change for directories:

```bash
find . ! -path . -type d ! -perm 755 -exec chmod 755 {} +
```
