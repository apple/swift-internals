## Conventions

### General Conventions

* **Document the complexity of any computed property that is not
  O(1).**  People often assume that property access involves no
  significant computation, because they have stored properties as a
  mental model. Be sure to alert them when that assumption may be
  violated.

* **Prefer methods and properties to free functions.**  Free functions
  are used only in special cases:

  <details markdown="1">
  <summary></summary>

  1. When there's no obvious `self`:

     ~~~
     min(x, y, z)
     ~~~

  2. When the function is an unconstrained generic:

     ~~~
     print(x)
     ~~~

  3. When function syntax is part of the established domain notation:

     ~~~
     sin(x)
     ~~~
  </details>

* **Follow case conventions.**  Names of types, protocols and enum
  cases are `UpperCamelCase`.  Everything else is `lowerCamelCase`.

{% comment %}
* **Be conscious of grammatical ambiguity**. Many words can act as
   either a noun or a verb, e.g. “insert,” “record,” “contract,” and
   “drink.”  Consider how these dual roles may affect the clarity of
   your API.
{% endcomment %}

* **Methods can share a base name when they share the same basic meaning**
  but operate on different types or are in different domains.

  <details markdown="1">
  <summary></summary>
  For example, the following is encouraged, since the methods do essentially
  the same things:

  <figure class="good" markdown="1">
  ~~~ swift
  extension Shape {
    /// Returns `true` iff `other` is within the area of `self`.
    func **contains**(other: **Point**) -> Bool { ... }

    /// Returns `true` iff `other` is entirely within the area of `self`.
    func **contains**(other: **Shape**) -> Bool { ... }

    /// Returns `true` iff `other` is within the area of `self`.
    func **contains**(other: **LineSegment**) -> Bool { ... }
  }
  ~~~

  And since geometric types and collections are separate domains,
  this is also fine in the same program:

  ~~~ swift
  extension Collection where Element : Equatable {
    /// Returns `true` iff `self` contains an element equal to
    /// `sought`.
    func **contains**(sought: Element) -> Bool { ... }
  }
  ~~~
  </figure>

  <figure class="bad" markdown="1">
  However, these `index` methods have different semantics, and should
  have been named differently:

  ~~~ swift
  extension Database {
    /// Rebuilds the database's search index
    func **index**() { ... }

    /// Returns the `n`th row in the given table.
    func **index**(n: Int, inTable: TableID) -> TableRow { ... }
  }
  ~~~

  Lastly, avoid “overloading on return type” because it causes
  ambiguities in the presence of type inference.

  ~~~ swift
  extension Box {
    /// Returns the `Int` stored in `self`, if any, and
    /// `nil` otherwise.
    func **value**() -> Int? { ... }

    /// Returns the `String` stored in `self`, if any, and
    /// `nil` otherwise.
    func **value**() -> String? { ... }
  }
  ~~~
  </figure>
  </details>

### Parameters

* **Take advantage of defaulted arguments** when it simplifies common
  uses.  Any parameter with a single commonly-used value is a
  candidate for defaulting.

  <details markdown="1">
  <summary></summary>
  Default arguments improve readability by
  hiding irrelevant information.  For example:

  <figure class="bad" markdown="1">
  ~~~ swift
  let order = lastName.compare(
    royalFamilyName**, options: [], range: nil, locale: nil**)
  ~~~
  </figure>

  can become the much simpler:

  <figure class="good" markdown="1">
  ~~~ swift
  let order = lastName.**compare(royalFamilyName)**
  ~~~
  </figure>

  Default arguments are generally preferable to the use of method
  families, because they impose a lower cognitive burden on anyone
  trying to understand the API.

  <figure class="good" markdown="1">
  ~~~ swift
  extension String {
    /// *...description...*
    public func compare(
       other: String, options: CompareOptions **= []**,
       range: Range<Index>? **= nil**, locale: Locale? **= nil**
    ) -> Ordering
  }
  ~~~
  </figure>

  The above may not be simple, but it is much simpler than:

  <figure class="bad" markdown="1">
  ~~~ swift
  extension String {
    /// *...description 1...*
    public func **compare**(other: String) -> Ordering
    /// *...description 2...*
    public func **compare**(other: String, options: CompareOptions) -> Ordering
    /// *...description 3...*
    public func **compare**(
       other: String, options: CompareOptions, range: Range<Index>) -> Ordering
    /// *...description 4...*
    public func **compare**(
       other: String, options: StringCompareOptions,
       range: Range<Index>, locale: Locale) -> Ordering
  }
  ~~~
  </figure>

  Every member of a method family needs to be separately documented
  and understood by users. To decide among them, a user needs to
  understand all of them, and occasional surprising relationships—for
  example, `fooWithBar(nil)` and `foo()` aren't always synonyms—make
  this a tedious process of ferreting out minor differences in
  mostly-identical documentation.  Using a single method with
  defaults provides a vastly superior programmer experience.
  </details>

* **Prefer to locate parameters with defaults towards the end** of the
  parameter list.  Parameters without defaults are usually more
  essential to the semantics of a method, and provide a stable initial
  pattern of use where methods are invoked.

* **Prefer to follow the language's defaults for the presence of
  argument labels.**

  <details markdown="1">
  <summary></summary>
  In other words, usually:

  - First parameters to methods and functions should *not*
    have required argument labels
  - Other parameters to methods and functions *should* have required
    argument labels.
  - All parameters to initializers should have required argument
    labels.

  The above corresponds to where the language would require argument
  labels if each parameter was declared with the form:

  ~~~
  **identifier**: **Type**
  ~~~
  </details>

  There are only a few exceptions:

  * **In initializers that should be seen as “full-width type
    conversions,”** the initial argument should be the source of the
    conversion, and should be unlabelled.

    <details markdown="1">
    <summary></summary>
    <figure class="good" markdown="1">
    ~~~
    extension String {
      // Convert `x` into its textual representation in the given radix
      init(**_** x: BigInt, radix: Int = 10) // Note the initial separate underscore
    }

    text = "The value is: "
    text += **String(veryLargeNumber)**
    text += " and in hexadecimal, it's"
    text += **String(veryLargeNumber, radix: 16)**
    ~~~
    </figure>

    In “narrowing” type conversions, though, a label that describes
    the narrowing is recommended.

    ~~~ swift
    extension UInt32 {
      init(**_** value: Int16)            // widening, so no label
      init(**truncating** bits: UInt64)
      init(**saturating** value: UInt64)
    }
    ~~~
    </details>

  * **When all parameters are peers that can't be usefully
    distinguished**, none should be labelled.  Well-known examples
    include `min(number1, number2)` and `zip(sequence1, sequence2)`.

  * <a name="first-argument-label">**When the first argument is
    defaulted, it should have a distinct argument label**</a>.

    <details markdown="1">
    <summary></summary>

    <figure class="good" markdown="1">
    ~~~ swift
    extension Document {
      func close(**completionHandler** completion: ((Bool) -> Void)? **= nil**)
    }
    doc1.close()
    doc2.close(completionHandler: app.quit)
    ~~~
    </figure>

     As you can see, this practice makes calls read correctly regardless
     of whether the argument is passed explicitly.  If instead you
     *omit* the parameter description, the call may incorrectly imply
     the argument is the direct object of the “sentence.”

    <figure class="bad" markdown="1">
    ~~~ swift
    extension Document {
      func close(completion: ((Bool) -> Void)? **= nil**)
    }
    doc.**close(app.quit)**              // Closing the quit function?
    ~~~
    </figure>

     If you attach the parameter description to the function's base
     name, it will “dangle” when the default is used.

    <figure class="bad" markdown="1">
    ~~~ swift
    extension Document {
      func close**WithCompletionHandler**(completion: ((Bool) -> Void)? **= nil**)
    }
    doc.**closeWithCompletionHandler()**   // What completion handler?
    ~~~
    </figure>

    </details>
