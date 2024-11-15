This project packages the (Unison Code Manager)[https://unison-lang.org/] for the Debian and Debian-based distributions, such as Ubuntu.

## When a new UCM version is released

edit Makefile and increment the version numbers at the two two lines of a file. The "UNISON_NEXT_RELEASE" variable should always just be a minor version bump from the "UNISON_CURRENT_RELEASE" variable. The "UNISON_NEXT_RELEASE" variable is used to caculate the versions of the nightly builds. If the "UNISON_NEXT_RELEASE=1.2.3" then the nightly versions will be in the form "1.2.3~20240101". In debian the "~" character is used to indicate prelrelease versions. So when we eventually release a 1.2.3 version, it will be considered newer than any version that is 1.2.3~anything.

