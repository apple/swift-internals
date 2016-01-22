## Special Instructions

* **Take extra care with unconstrained polymorphism** (e.g. `Any`,
  `AnyObject`, and unconstrained generic parameters) to avoid
  ambiguities in overload sets.

<details markdown="1">
  <summary></summary>
For example, consider this overload set:

<figure class="bad" markdown="1">
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
</figure>

These methods form a semantic family, and the argument types
appear at first to be sharply distinct.  However, when `Element`
is `Any`, a single element can have the same type as a sequence of
elements:

<figure class="bad" markdown="1">
~~~ swift
var values: [Any] = [1, "a"]
values.append([2, 3, 4]) // [1, "a", [2, 3, 4]] or [1, "a", 2, 3, 4]?
~~~
</figure>

To eliminate the ambiguity, name the second overload more
explicitly:

<figure class="good" markdown="1">
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
</figure>

Notice how the new name better matches the documentation comment.
In this case, the act of writing the documentation comment
actually brought the issue to the API author's attention.
</details>

