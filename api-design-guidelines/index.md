---
layout: page
title: API Design Guidelines
official_url: https://swift.org/documentation/api-design-guidelines/
redirect_from: /documentation/api-design-guidelines.html
---
{% comment %}
# The width of pre elements on this page is carefully regulated, so we
# can afford to drop the scrollbar boxes.
{% endcomment %}

<style>
article pre {
    overflow: visible;
}
</style>

{% comment %}
# Define some variables that help us build expanding detail sections
# without too much boilerplate.  We use checkboxes instead of 
# <details>...</details> because it allows us to:
#
#   * Write CSS ensuring that details aren't hidden when printing.
#   * Add a button that expands or collapses all sections at once.
{% endcomment %}

{% capture expand %}{::nomarkdown}
<input type="checkbox" class="detail">
{:/nomarkdown}{% endcapture %}
{% assign detail = '<div class="more" markdown="1">' %}
{% assign enddetail = '</div>' %}


<div class="info screenonly" markdown="1">
To facilitate use as a quick reference, the details of many guidelines
can be expanded individually. Details are never hidden when this page
is printed.
<input type="button" id="toggle" value="Expand all details now" onClick="show_or_hide_all()" />
</div>

## Table of Contents
{:.no_toc}

* TOC
{:toc}

## Fundamentals

* **Clarity at the point of use** is your most important goal.
  Entities such as methods and properties are declared only once, but
  *used* repeatedly.  Design APIs to make those uses clear and
  concise.  When evaluating a design, reading a declaration is seldom
  sufficient; always examine a use case to make sure it looks
  clear in context.
  {:#clarity-at-the-point-of-use}
  
* **Clarity is more important than brevity.**  Although Swift
  code can be compact, it is a *non-goal*
  to enable the smallest possible code with the fewest characters.
  Brevity in Swift code, where it occurs, is a side-effect of the
  strong type system and features that naturally reduce boilerplate.
  {:#clarity-over-brevity}

* **Write a documentation comment**
  for every declaration. Insights gained by writing documentation can
  have a profound impact on your design, so don't put it off.
  {:#write-doc-comment}

  <div class="warning" markdown="1">
  If you are having trouble describing your API's
  functionality in simple terms, **you may have designed the wrong API.**
  </div>
  
  {{expand}}
  {{detail}}
  {% assign ref = 'https://developer.apple.com/library/prerelease/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/' %}
  {% capture SymbolDoc %}{{ref}}SymbolDocumentation.html#//apple_ref/doc/uid/TP40016497-CH51-{% endcapture %}

  * **Use Swift's [dialect of Markdown]({{ref}}).**

  * **Begin with a summary** that describes the entity being declared.
    Often, an API can be completely understood from its declaration and
    its summary.

    ~~~ swift
    /// **Returns a "view" of `self` containing the same elements in**
    /// **reverse order.**
    func reversed() -> ReverseCollection<Self>
    ~~~

    {{expand}}
    {{detail}}

    * **Focus on the summary**; it's the most important part. Many
      excellent documentation comments consist of nothing more than a
      great summary.

    * **Use a single sentence fragment** if possible, ending with a
      period.  Do not use a complete sentence.

    * **Describe what a function or method *does* and what it
      *returns***, omitting null effects and `Void` returns:

      ~~~ swift
      /// **Inserts** `newHead` at the beginning of `self`.
      mutating func prepend(newHead: Int)

      /// **Returns** a `List` containing `head` followed by the elements
      /// of `self`.
      func prepending(head: Element) -> List

      /// **Removes and returns** the first element of `self` if non-empty;
      /// returns `nil` otherwise.
      mutating func popFirst() -> Element?
      ~~~

      Note: in rare cases like `popFirst` above, the summary is formed
      of multiple sentence fragments separated by semicolons.

    * **Describe what a subscript *accesses***:

      ~~~ swift
      /// **Accesses** the `index`th element.
      subscript(index: Int) -> Element { get set }
      ~~~

    * **Describe what an initializer *creates***:

      ~~~ swift
      /// **Creates** an instance containing `n` repetitions of `x`.
      init(count n: Int, repeatedElement x: Element)
      ~~~

    * For all other declarations, **describe what the declared entity *is***.

      ~~~ swift
      /// **A collection that** supports equally efficient insertion/removal
      /// at any position.
      struct List {

        /// **The element at the beginning** of `self`, or `nil` if self is
        /// empty.
        var first: Element?
        ...
      ~~~

    {{enddetail}}

  * **Optionally, continue** with one or more paragraphs and bullet
    items.  Paragraphs are separated by blank lines and use complete
    sentences.

    ~~~ swift
    /// Writes the textual representation of each    <span class="graphic">←</span><span class="commentary"> Summary</span>
    /// element of `items` to the standard output.
    ///                                              <span class="graphic">←</span><span class="commentary"> Blank line</span>
    /// The textual representation for each item `x` <span class="graphic">←</span><span class="commentary"> Additional discussion</span>
    /// is generated by the expression `String(x)`.
    ///
    /// - **Parameter separator**: text to be printed    <span class="graphic">⎫</span>
    ///   between items.                             <span class="graphic">⎟</span>
    /// - **Parameter terminator**: text to be printed   <span class="graphic">⎬</span><span class="commentary"> <a href="{{SymbolDoc}}SW14">Parameters section</a></span>
    ///   at the end.                                <span class="graphic">⎟</span>
    ///                                              <span class="graphic">⎭</span>
    /// - **Note**: To print without a trailing          <span class="graphic">⎫</span>
    ///   newline, pass `terminator: ""`             <span class="graphic">⎟</span>
    ///                                              <span class="graphic">⎬</span><span class="commentary"> <a href="{{SymbolDoc}}SW13">Symbol commands</a></span>
    /// - **SeeAlso**: `CustomDebugStringConvertible`,   <span class="graphic">⎟</span>
    ///   `CustomStringConvertible`, `debugPrint`.   <span class="graphic">⎭</span>
    public func print<Target: OutputStreamType>(
      items: Any..., separator: String = " ", terminator: String = "\n")
    ~~~

    {{expand}}
    {{detail}}

    * **Use recognized
      [symbol documentation markup]({{SymbolDoc}}SW1)
      elements** to add information beyond the summary, whenever
      appropriate.

    * **Know and use recognized bullet items with
      [symbol command syntax]({{SymbolDoc}}SW13).** Popular development
      tools such as Xcode give special treatment to bullet items that
      start with the following keywords:

      | [Attention]({{ref}}Attention.html) | [Author]({{ref}}Author.html) | [Authors]({{ref}}Authors.html) | [Bug]({{ref}}Bug.html) |
      | [Complexity]({{ref}}Complexity.html) | [Copyright]({{ref}}Copyright.html) | [Date]({{ref}}Date.html) | [Experiment]({{ref}}Experiment.html) |
      | [Important]({{ref}}Important.html) | [Invariant]({{ref}}Invariant.html) | [Note]({{ref}}Note.html) | [Parameter]({{ref}}Parameter.html) |
      | [Parameters]({{ref}}Parameters.html) | [Postcondition]({{ref}}Postcondition.html) | [Precondition]({{ref}}Precondition.html) | [Remark]({{ref}}Remark.html) |
      | [Requires]({{ref}}Requires.html) | [Returns]({{ref}}Returns.html) | [SeeAlso]({{ref}}SeeAlso.html) | [Since]({{ref}}Since.html) |
      | [Throws]({{ref}}Throws.html) | [Todo]({{ref}}Todo.html) | [Version]({{ref}}Version.html) | [Warning]({{ref}}Warning.html) |

    {{enddetail}}

  {{enddetail}}

## Naming

### Promote Clear Usage

* **Include all the words needed to avoid ambiguity** for a person
  reading code where the name is used.

  {{expand}}
  {{detail}}
  For example, consider a method that removes the element at a
  given position within a collection.

  ~~~ swift
  extension List {
    public mutating func removeAt(position: Index) -> Element
  }
  employees.removeAt(x)
  ~~~
  {:.good}

  If we were to omit the word `At` from the method name, it could
  imply to the reader that the method searches for and removes an
  element equal to `x`, rather than using `x` to indicate the
  position of the element to remove.

  ~~~ swift
  employees.remove(x) // unclear: are we removing x?
  ~~~
  {:.bad}

  {{enddetail}}

* **Omit needless words.** Every word in a name should convey salient
  information at the use site.
  {:#omit-needless-words}

  {{expand}}
  {{detail}}
  More words may be needed to clarify intent or disambiguate
  meaning, but those that are redundant with information the reader
  already possesses should be omitted. In particular, omit words that
  *merely repeat* type information.

  ~~~ swift
  public mutating func removeElement(member: Element) -> Element?

  allViews.removeElement(cancelButton)
  ~~~
  {:.bad}

  In this case, the word `Element` adds nothing salient at the call
  site. This API would be better:

  ~~~ swift
  public mutating func remove(member: Element) -> Element?

  allViews.remove(cancelButton) // clearer
  ~~~
  {:.good}

  Occasionally, repeating type information is necessary to avoid
  ambiguity, but in general it is better to use a word that
  describes a parameter's *role* rather than its type. See the next
  item for details.
  {{enddetail}}

* **Compensate for weak type information** as needed to **clarify a
  parameter's role**.
  {:#weak-type-information}

  {{expand}}
  {{detail}}
  Especially when a parameter type is `NSObject`, `Any`, `AnyObject`,
  or a fundamental type such `Int` or `String`, type information and
  context at the point of use may not fully convey intent. In this
  example, the declaration may be clear, but the use site is vague.

  ~~~ swift
  func add(observer: NSObject, for keyPath: String)

  grid.add(self, for: graphics) // vague
  ~~~
  {:.bad}

  To restore clarity, **precede each weakly typed parameter with a
  noun describing its role**:

  ~~~ swift
  func add**Observer**(_ observer: NSObject, for**KeyPath** path: String)
  grid.addObserver(self, forKeyPath: graphics) // clear
  ~~~
  {:.good}
  {{enddetail}}


### Strive for Fluent Usage

* Prefer to **name methods and functions so that, when used, they form
  grammatical English phrases**
  {:#methods-and-functions-read-as-phrases}
  
  {{expand}}
  {{detail}}
  ~~~swift
  x.insert(y, at: z)
  x.subViews(havingColor: y)
  x.capitalizingNouns()
  ~~~
  
  It is acceptable for fluency to degrade after the first argument or
  two when those arguments are not central to the call's meaning:
  
  ~~~swift
  AudioUnit.instantiate(
    with description, 
    **options: [.inProcess], completionHandler: stopProgressBar**)
  ~~~
  
  {{enddetail}}
  
* Uses of **functions and methods without side-effects should read as
  noun phrases**, e.g. `x.distanceTo(y)`, `i.successor()`.

* Uses of **functions and methods with side-effects should read as
  imperative verb phrases**, e.g., `print(x)`, `x.sort()`,
  `x.append(y)`.

* Name the **nonmutating counterpart of a mutating method** according
  to the **“ed/ing” rule**, e.g. `x.sort()`/`x.sorted()` and
  `x.append(y)`/`x.appending(y)`.

  {{expand}}
  {{detail}}
  Often, a mutating method will have a nonmutating variant returning
  the same, or a similar, type as the receiver.

  * Prefer to name the nonmutating variant using the verb's past
    [participle](https://en.wikipedia.org/wiki/Participle) (usually
    appending “ed”):

    ~~~ swift
    /// Reverses `self` in-place.
    mutating func reverse()

    /// Returns a reversed copy of `self`.
    func revers**ed**() -> Self
    ...
    x.reverse()
    let y = x.reversed()
    ~~~

  * When adding “ed” is not grammatical because the verb has a direct
    object, name the nonmutating variant using the verb's present
    [participle](https://en.wikipedia.org/wiki/Participle), by
    appending “ing.”

    ~~~ swift
    /// Strips all the newlines from \`self\`
    mutating func stripNewlines()

    /// Returns a copy of \`self\` with all the newlines stripped.
    func strip**ping**Newlines() -> String
    ...
    s.stripNewlines()
    let oneLine = t.strippingNewlines()
    ~~~

  {{enddetail}}

* Uses of nonmutating **Boolean
  methods and properties should read as assertions about the
  receiver**, e.g. `x.isEmpty`, `line1.intersects(line2)`.
  {:#boolean-assertions}

* **Protocols** that describe what something **is** should read as
  nouns (e.g. `Collection`). Protocols that describe a **capability**
  should be named using the suffixes `able`, `ible`, or `ing`
  (e.g. `Equatable`, `ProgressReporting`).

* The names of other **types, properties, variables, and constants
  should read as nouns.**

### Use Terminology Well

**Term of Art**
: *noun* - a word or phrase that has a precise, specialized meaning
  within a particular field or profession.

* **Avoid obscure terms** if a more common word conveys meaning just
  as well.  Don't say “epidermis” if “skin” will serve your purpose.
  Terms of art are an essential communication tool, but should only be
  used to capture crucial meaning that would otherwise be lost.

* **Stick to the established meaning** if you do use a term of art.

  {{expand}}
  {{detail}}
  The only reason to use a technical term rather than a more common
  word is that it *precisely* expresses something that would
  otherwise be ambiguous or unclear.  Therefore, an API should use
  the term strictly in accordance with its accepted meaning.

  * **Don't surprise an expert**: anyone already familiar with the term
    will be surprised and probably angered if we appear to have
    invented a new meaning for it.

  * **Don't confuse a beginner**: anyone trying to learn the term is
    likely to do a web search and find its traditional meaning.
  {{enddetail}}

* **Avoid abbreviations.** Abbreviations, especially non-standard
  ones, are effectively terms-of-art, because understanding depends on
  correctly translating them into their non-abbreviated forms.

  > The intended meaning for any abbreviation you use should be
  > easily found by a web search.

* **Embrace precedent.** Don't optimize terms for the total beginner
  at the expense of conformance to existing culture.

  {{expand}}
  {{detail}}
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
  {{enddetail}}

## Conventions

### General Conventions

* **Document the complexity of any computed property that is not
  O(1).**  People often assume that property access involves no
  significant computation, because they have stored properties as a
  mental model. Be sure to alert them when that assumption may be
  violated.

* **Prefer methods and properties to free functions.**  Free functions
  are used only in special cases:

  {{expand}}
  {{detail}}

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

  {{enddetail}}

* **Follow case conventions.** Names of types and protocols are
  `UpperCamelCase`.  Everything else is `lowerCamelCase`.

  {{expand}}
  {{detail}}

  [Acronyms and initialisms](https://en.wikipedia.org/wiki/Acronym)
  that commonly appear as all upper case in American English should be
  uniformly up- or down-cased according to case conventions:
  
  ~~~swift
  var **utf8**Bytes: [**UTF8**.CodeUnit];
  var isRepresentableAs**ASCII** = true;
  var user**SMTP**Server: Secure**SMTP**Server;
  ~~~
  
  Other acronyms should be treated as ordinary words:
  
  ~~~swift
  var **radar**Detector: **Radar**Scanner;
  var enjoys**Scuba**Diving = true;
  ~~~
  {{enddetail}}

  
{% comment %}
* **Be conscious of grammatical ambiguity**. Many words can act as
   either a noun or a verb, e.g. “insert,” “record,” “contract,” and
   “drink.”  Consider how these dual roles may affect the clarity of
   your API.
{% endcomment %}

* **Methods can share a base name** when they share the same basic meaning
  but operate on different types, or when they are in different domains.

  {{expand}}
  {{detail}}
  For example, the following is encouraged, since the methods do essentially
  the same things:

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
  {:.good}

  And since geometric types and collections are separate domains,
  this is also fine in the same program:

  ~~~ swift
  extension Collection where Element : Equatable {
    /// Returns `true` iff `self` contains an element equal to
    /// `sought`.
    func **contains**(sought: Element) -> Bool { ... }
  }
  ~~~
  {:.good}

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
  {:.bad}

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
  {:.bad}

  {{enddetail}}

### Parameters

* **Choose parameter names to serve documentation**.

  ~~~ swift
  /// Invoke `**body**` repeatedly, passing values from `**start**` through 
  /// `**finish - 1**`.
  func count(from **start**: Int, to **finish**: Int, **body**: (Int)->()) {
    for i in **start**..<**finish** { **body**(i) }
  }
  ~~~

  {{expand}}
  {{detail}}
  
  Even though parameter names do not appear at a function or method's
  point of use, they play an important explanatory role in any API.
  Choose these names to make documentation easy to read.  For example,

  ~~~swift
     /// Return an `Array` containing the elements of `self`
     /// that satisfy `**predicate**`.
     func filter(_ **predicate**: (Element) -> Bool) -> [Generator.Element]

     /// Replace the given `**subRange**` of elements with `**newElements**`.
     mutating func replaceRange(_ **subRange**: Range<Index>, with **newElements**: [E])
  ~~~
  {:.good}

  ~~~swift
     /// Return an `Array` containing the elements of `self`
     /// that satisfy `**includedInResult**`.
     func filter(_ **includedInResult**: (Element) -> Bool) -> [Generator.Element]

     /// Replace the **range of elements indicated by `r`** with
     /// the contents of `**with**`.
     mutating func replaceRange(_ **r**: Range<Index>, **with**: [E])
  ~~~
  {:.bad}

  {{enddetail}}

* **Take advantage of defaulted arguments** when it simplifies common
  uses.  Any parameter with a single commonly-used value is a
  candidate for defaulting.

  {{expand}}
  {{detail}}
  Default arguments improve readability by
  hiding irrelevant information.  For example:

  ~~~ swift
  let order = lastName.compare(
    royalFamilyName**, options: [], range: nil, locale: nil**)
  ~~~
  {:.bad}

  can become the much simpler:

  ~~~ swift
  let order = lastName.**compare(royalFamilyName)**
  ~~~
  {:.good}

  Default arguments are generally preferable to the use of method
  families, because they impose a lower cognitive burden on anyone
  trying to understand the API.

  ~~~ swift
  extension String {
    /// *...description...*
    public func compare(
       other: String, options: CompareOptions **= []**,
       range: Range<Index>? **= nil**, locale: Locale? **= nil**
    ) -> Ordering
  }
  ~~~
  {:.good}

  The above may not be simple, but it is much simpler than:

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
  {:.bad}

  Every member of a method family needs to be separately documented
  and understood by users. To decide among them, a user needs to
  understand all of them, and occasional surprising relationships—for
  example, `fooWithBar(nil)` and `foo()` aren't always synonyms—make
  this a tedious process of ferreting out minor differences in
  mostly identical documentation.  Using a single method with
  defaults provides a vastly superior programmer experience.
  {{enddetail}}

* **Prefer to locate parameters with defaults toward the end** of the
  parameter list.  Parameters without defaults are usually more
  essential to the semantics of a method, and provide a stable initial
  pattern of use where methods are invoked.

### Argument Labels

* **Omit all labels when arguments can't be usefully distinguished**,
  e.g. `min(number1, number2)`, `zip(sequence1, sequence2)`.
  
* **In initializers that perform full-width type conversions, omit the
  first argument label**, e.g. `Int64(someUInt32)`

  {{expand}}
  {{detail}}
  The first argument should always be the source of the conversion.

  ~~~
  extension String {
    // Convert `x` into its textual representation in the given radix
    init(**_** x: BigInt, radix: Int = 10)   <span class="commentary">← Note the initial underscore</span>
  }

  text = "The value is: "
  text += **String(veryLargeNumber)**
  text += " and in hexadecimal, it's"
  text += **String(veryLargeNumber, radix: 16)**
  ~~~

  In “narrowing” type conversions, though, a label that describes
  the narrowing is recommended.

  ~~~ swift
  extension UInt32 {
    /// Creates an instance having the specified `value`.
    init(**_** value: Int16)            <span class="commentary">← Widening, so no label</span>
    /// Creates an instance having the lowest 32 bits of `source`.
    init(**truncating** source: UInt64)
    /// Creates an instance having the nearest representable
    /// approximation of `valueToApproximate`.
    init(**saturating** valueToApproximate: UInt64)
  }
  ~~~
  {{enddetail}}

* **When the first argument forms part of a
  [prepositional phrase](https://en.wikipedia.org/wiki/Adpositional_phrase#Prepositional_phrases),
  give it an argument label**.  The argument label should normally begin at the
  [preposition](https://en.wikipedia.org/wiki/Preposition),
  e.g. <code>x.removeBoxes(havingLength: 12). 
  
  {{expand}}
  {{detail}}
  An exception arises when the first two arguments represent parts of
  a single abstraction.
  
  ~~~swift
  a.move(**toX:** b, **y:** c)
  a.fade(**fromRed:** b, **green:** c, **blue:** d)
  ~~~
  {:.bad}

  In such cases, begin the argument label *after* the preposition, to
  keep the abstraction clear.
  
  ~~~swift
  a.moveTo(**x:** b, **y:** c)
  a.fadeFrom(**red:** b, **green:** c, **blue:** d)
  ~~~
  {:.good}
  {{enddetail}}
  
* **Otherwise, if the first argument forms part of a grammatical
  phrase, omit its label**, appending any preceding words to the base
  name, e.g. `x.addSubview(y)`

  {{expand}}
  {{detail}}
  This guideline implies that if the first argument *doesn't* form
  part of a grammatical phrase, it should have a label.

  ~~~swift
  view.dismiss(**animated:** false)
  let text = words.split(**maxSplits:** 12)
  let studentsByName = students.sorted(**isOrderedBefore:** Student.namePrecedes)
  ~~~
  {:.good}

  Note that it's important that the phrase convey the correct meaning.
  The following would be grammatical but would express the wrong
  thing.

  ~~~swift
  view.dismiss(false)   <span class="commentary">Don't dismiss? Dismiss a Bool?</span>
  words.split(12)       <span class="commentary">Split the number 12?</span>
  ~~~
  {:.bad}

  Note also that arguments with default values can be omitted, and
  in that case do not form part of a grammatical phrase, so they
  should always have labels.
  {{enddetail}}

* **Label all other arguments**.

## Special Instructions

* **Take extra care with unconstrained polymorphism** (e.g. `Any`,
  `AnyObject`, and unconstrained generic parameters) to avoid
  ambiguities in overload sets.

  {{expand}}
  {{detail}}
  For example, consider this overload set:

  ~~~ swift
  struct Array<Element> {
    /// Inserts `newElement` at `self.endIndex`.
    public mutating func append(newElement: Element)

    /// Inserts the contents of `newElements`, in order, at
    /// `self.endIndex`.
    public mutating func append<
      S : SequenceType where S.Generator.Element == Element
    >(newElements: S)
  }
  ~~~
  {:.bad}

  These methods form a semantic family, and the argument types
  appear at first to be sharply distinct.  However, when `Element`
  is `Any`, a single element can have the same type as a sequence of
  elements.

  ~~~ swift
  var values: [Any] = [1, "a"]
  values.append([2, 3, 4]) // [1, "a", [2, 3, 4]] or [1, "a", 2, 3, 4]?
  ~~~
  {:.bad}

  To eliminate the ambiguity, name the second overload more
  explicitly.

  ~~~ swift
  struct Array {
    /// Inserts `newElement` at `self.endIndex`.
    public mutating func append(newElement: Element)

    /// Inserts the contents of `newElements`, in order, at
    /// `self.endIndex`.
    public mutating func appendContentsOf<
      S : SequenceType where S.Generator.Element == Element
    >(newElements: S)
  }
  ~~~
  {:.good}

  Notice how the new name better matches the documentation comment.
  In this case, the act of writing the documentation comment
  actually brought the issue to the API author's attention.
  {{enddetail}}


<script>
var elements = document.querySelectorAll("pre code");
for (i in elements) {
    var element = elements[i];
    if (element.textContent) {
        element.innerHTML = element.textContent
            .replace(/\*\*([^\*]+)\*\*/g, "<strong>$1</strong>")
            .replace(/\*([^\*]+)\*/g, "<em>$1</em>");
    }
}
function show_or_hide_all(){
    var checkboxes = document.getElementsByClassName('detail');
    var button = document.getElementById('toggle');

    if(button.value == 'Expand all details now'){
        for (var i in checkboxes){
            checkboxes[i].checked = 'FALSE';
        }
        button.value = 'Collapse all details now'
    }else{
        for (var i in checkboxes){
            checkboxes[i].checked = '';
        }
        button.value = 'Expand all details now';
    }
}
</script>


