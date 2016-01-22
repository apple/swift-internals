# Swift Internals

This is the source for the
[Swift Internals](http://apple.github.io/swift-internals) website,
which hosts internal documentation for the Swift compiler and
standard library, as well as the development version of the
[Swift API Guidelines](https://swift.org/documentation/api-design-guidelines.html).

## To develop/test locally, 

1. Have Ruby >= 2.0.0 installed.
2. `gem install bundler`—this command must normally be run with
   sudo/root/admin privileges.
3. `bundle install`—run this command as a regular, unprivileged user.
4. `LC_ALL=en_us.UTF-8 bundle exec jekyll serve --baseurl /swift-internals`
5. Visit [localhost:4000/swift-internals](localhost:4000/swift-internals).
6. Make edits to the source, refresh your browser, lather, rinse, repeat.

Notes: 

* Changes to `_config.yml` require restarting the local server (step 4
  above).
* If you make changes to `_config.yml` specifically in order to serve
  these pages from an address other than
  http://apple.github.io/swift-internals, please make sure those
  changes are not included in any pull requests, so we don't
  inadvertently break the main site.
