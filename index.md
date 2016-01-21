---
layout: page
title: API Design Guidelines
---

<div class="warning" markdown="1">
These are draft API guidelines being developed as part of the [Swift 3.0 effort](https://github.com/apple/swift-evolution).
</div>

## Table of Contents

* [Fundamentals](#fundamentals)
  * [Clarity at the point of use](#clarity-at-the-point-of-use)
  * [Clarity is more important than brevity](#clarity-over-brevity)
  * [Write a documentation comment](#write-doc-comment)
* [Naming](#naming)
  * [Promote clear usage](#promote-clear-usage)
  * [Be grammatical](#be-grammatical)
  * [Use terminology well](#use-terminology-well)
* [Conventions](#conventions)
  * [General conventions](#general-conventions)
  * [Parameters](#parameters)
* [Special instructions](#special-instructions)

{% include_relative _fundamentals.md %}
{% include_relative _naming.md %}
{% include_relative _conventions.md %}
{% include_relative _special-instructions.md %}

<script>
var elements = document.querySelectorAll("pre code");
for (i in elements) {
    var element = elements[i];
    if (element.textContent) {
        element.innerHTML = element.textContent.replace(/\*\*([^\*]+)\*\*/g, "<strong>$1</strong>");
    }
}
</script>
