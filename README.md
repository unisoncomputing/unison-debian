This project packages the (Unison Code Manager)[https://unison-lang.org/] for the Debian and Debian-based distributions, such as Ubuntu.

## Releaseing a new version


1. Update the version in the `debian/changelog` file. The easiest way to do this is to use the `dch` command from the `devscripts` package. For example:

```
EMAIL=stew@unison.cloud dch -v 0.51.0-1 "New upstream release"
```

which will create a new entry in debian/changelog that starts with something like this:

```
unisonweb (0.5.20~trunk+2024041702) unstable; urgency=low
```

This version string previx should be the same as the unison release number. A trunk or unreleased version should use the next version as the version number and a tilde, as above to add some version information to differentiate it from other prerelease versions.

Details about how debian sorts version numbers can be found in (The Debian Policy Manual)[https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-version].

You can use dpkg to verify that two versions compare they way you expect with some command like:

```
dpkg --compare-versions 0.5.20~trunk+2024041702 lt 0.5.20 && echo "true" || echo "false"
```

or 

```
dpkg --compare-versions 0.5.20~trunk+2024041702 '<' 0.5.20 && echo "true" || echo "false"
````

2. Commit the changes to either the unstable or stable branch and push to github.
