
<div class="info screenonly" markdown="1">
To facilitate use as a quick reference, the details of many guidelines
can be expanded individually. Details are never hidden when this page
is printed.
<input type="button" id="toggle" value="Expand all details now" onClick="show_or_hide_all()" />
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
