---
layout: page
title: Diagnostic Documentation
official_url: https://swift.org/documentation/diagnostic-documentation/
redirect_from: /documentation/diagnostic-documentation.html
---
This page collects diagnostic documentation resources shipped with the Swift compiler toolchain. To view documentation relevant to compiler errors locally, include the `-print-educational-notes` flag when compiling code with Swift 5.3 and later.

## Educational Notes
{% assign sorted_pages = site.pages | sort: "path" %}
{% for sub_page in sorted_pages %}
{% if sub_page.is_diagnostic_documentation %}
<li>
<a href="{{ site.baseurl }}{{ sub_page.url }}">{{ sub_page.title }}</a>
</li>
{% endif %}
{% endfor %}
