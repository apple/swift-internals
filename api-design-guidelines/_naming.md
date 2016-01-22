## Naming

### Promote Clear Usage

* **Include all the words needed to avoid ambiguity** for a person
  reading code where the name is used.

<details markdown="1">
  <summary></summary>
For example, consider a method that removes the element at a
given position within a collection.

<figure class="good" markdown="1">
~~~ swift
public mutating func removeAt(position: Index) -> Element
~~~
</figure>

used as follows:

<figure class="good" markdown="1">
~~~ swift
employees.removeAt(x)
~~~
</figure>

If we were to omit the word `At` from the method name, it could
imply to the reader that the method searches for and removes an
element equal to `x`, rather than using `x` to indicate the
position of the element to remove.

<figure class="bad" markdown="1">
~~~ swift
employees.remove(x) // unclear: are we removing x?
~~~
</figure>

</details>

* <a name="omit-needless-words">**Omit needless words.**</a>  Every word in a name should convey salient
  information at the use site.

<details markdown="1">
  <summary></summary>
More words may be needed to clarify intent or disambiguate
meaning, but those that are redundant with information the reader
already possesses should be omitted. In particular, omit words that
*merely repeat* type information.

<figure class="bad" markdown="1">
~~~ swift
public mutating func removeElement(member: Element) -> Element?

allViews.removeElement(cancelButton)
~~~
</figure>

In this case, the word `Element` adds nothing salient at the call
site. This API would be better:

<figure class="good" markdown="1">
~~~ swift
public mutating func remove(member: Element) -> Element?

allViews.remove(cancelButton) // clearer
~~~
</figure>

Occasionally, repeating type information is necessary to avoid
ambiguity, but in general it is better to use a word that
describes a parameter's *role* rather than its type. See the next
item for details.
</details>

* <a name="weak-type-information">**Compensate for weak type information**</a> as needed to clarify a
  parameter's **role**.

<details markdown="1">
  <summary></summary>
Especially when a parameter type is `NSObject`, `Any`, `AnyObject`,
or a fundamental type such `Int` or `String`, type information and
context at the point of use may not fully convey intent. In this
example, the declaration may be clear, but the use site is vague.

<figure class="bad" markdown="1">
~~~ swift
func add(observer: NSObject, for keyPath: String)

grid.add(self, for: graphics) // vague
~~~
</figure>

To restore clarity, **precede each weakly typed parameter with a
noun describing its role**:

<figure class="good" markdown="1">
~~~ swift
func add**Observer**(_ observer: NSObject, for**KeyPath** path: String)
grid.addObserver(self, forKeyPath: graphics) // clear
~~~
</figure>
</details>


### Be Grammatical

* Uses of **mutating methods should read as imperative verb phrases**,
  e.g., `x.reverse()`, `x.sort()`, `x.append(y)`.

* Uses of **nonmutating methods should read as noun phrases** when
  possible, e.g. `x.distanceTo(y)`, `i.successor()`.

<details markdown="1">
  <summary></summary>
Imperative verbs are acceptable when there is no good alternative that
reads as a noun phrase:

~~~ swift
let firstAndLast = fullName.split() // acceptable
~~~
</details>

* When **a mutating method is described by a verb, name its
  nonmutating counterpart** according to the **“ed/ing” rule**,
  e.g. the nonmutating versions of `x.sort()` and `x.append(y)` are
  `x.sorted()` and `x.appending(y)`.

<details markdown="1">
  <summary></summary>
Often, a mutating method will have a nonmutating variant returning
the same, or a similar, type as the receiver.

* Prefer to name the nonmutating variant using the verb's past
 tense (usually appending “ed”):

~~~ swift
/// Reverses `self` in-place.
mutating func reverse()

/// Returns a reversed copy of `self`.
func revers**ed**() -> Self
...
x.reverse()
let y = x.reversed()
~~~

* When adding “ed” is not grammatical because the verb has a
 direct object, name the nonmutating variant using the verb's
 gerund form (usually appending “ing”):

~~~ swift
/// Strips all the newlines from \`self\`
mutating func stripNewlines()

/// Returns a copy of \`self\` with all the newlines stripped.
func strip**ping**Newlines() -> String
...
s.stripNewlines()
let oneLine = t.strippingNewlines()
~~~

</details>

* <a name="boolean-assertions">Uses</a> of nonmutating **Boolean
  methods and properties should read as assertions about the
  receiver**, e.g. `x.isEmpty`, `line1.intersects(line2)`.

* **Protocols** that describe what something **is** should read as
  nouns (e.g. `Collection`). Protocols that describe a **capability**
  should be named using the suffixes `able`, `ible`, or `ing`
  (e.g. `Equatable`, `ProgressReporting`).

* The names of other **types, properties, variables, and constants
  should read as nouns.**

### Use Terminology Well

**Term of Art**
: *noun* - a word or phrase that has a precise, specialized meaning within a particular field or profession.

* **Avoid obscure terms** if a more common word conveys meaning just
  as well.  Don't say “epidermis” if “skin” will serve your purpose.
  Terms of art are an essential communication tool, but should only be
  used to capture crucial meaning that would otherwise be lost.

* **Stick to the established meaning** if you do use a term of art.

<details markdown="1">
  <summary></summary>
The only reason to use a technical term rather than a more common
word is that it *precisely* expresses something that would
otherwise be ambiguous or unclear.  Therefore, an API should use
the term strictly in accordance with its accepted meaning.

* **Don't surprise an expert**: anyone already familiar with the term
  will be surprised and probably angered if we appear to have
  invented a new meaning for it.

* **Don't confuse a beginner**: anyone trying to learn the term is
  likely to do a web search and find its traditional meaning.
</details>

* **Avoid abbreviations.** Abbreviations, especially non-standard
  ones, are effectively terms-of-art, because understanding depends on
  correctly translating them into their non-abbreviated forms.

  > The intended meaning for any abbreviation you use should be
  > easily found by a web search.

* **Embrace precedent.** Don't optimize terms for the total beginner
  at the expense of conformance to existing culture.

<details markdown="1">
  <summary></summary>
It is better to name a contiguous data structure `Array` than to
use a simplified term such as `List`, even though a beginner
might grasp of the meaning of `List` more easily.  Arrays are
fundamental in modern computing, so every programmer knows—or
will soon learn—what an array is.  Use a term that most
programmers are familiar with, and their web searches and
questions will be rewarded.

Within a particular programming *domain*, such as mathematics, a
widely precedented term such as `sin(x)` is preferable to an
explanatory phrase such as
`verticalPositionOnUnitCircleAtOriginOfEndOfRadiusWithAngle(x)`.
Note that in this case, precedent outweighs the guideline to
avoid abbreviations: although the complete word is `sine`,
“sin(*x*)” has been in common use among programmers for decades,
and among mathematicians for centuries.
</details>
