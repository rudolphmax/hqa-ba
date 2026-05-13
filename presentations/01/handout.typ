#import "../../utils/base.typ": base, subtitle, footer
#import "../../utils/utils.typ": slide

#import "@preview/titleize:0.1.1": titlecase

#show: (doc) => base(dense: true, doc)

#set figure(placement: none)
#set list(marker: ([•], $->$))
#show title: set text(25pt)

#set document(
  title: "Automatic handwriting Quality Analysis",
  author: "Maximilian Rudolph"
)

#set page(
  footer: footer(numbered: true, [
    Maximilian Rudolph
  ])
)

#title()
#text(18pt)[
  #set par(leading: 0.65em, justify: false)
  Data Strategy for Overcoming inconsistencies in Ground Truth
]

#v(20pt)

= Introduction
== Motivation

Handwriting is...
- a key cultural technique of humanity, key for cultural development and knowledge,
- vital for the development of certain motor and intellectual skills in children, and
- an important factor in learning for both children and adults.

For assessment, supporting initial learning and the improvement of writing,
- an objective measure for the "quality" of handwritten documents is needed.
- Manual scales exist but are laborious and prone to subjectivity.

== Current Problems of automatic approaches

#[
  #set list(marker: $->$)

  + *Feature selection is inconsistent* and often not clearly motivated.
    - We don't know, what does what and what matters
  + Widespread *non-interpretability*, which is undesirable.
    - *Feedback on handwriting is not actionable*
  + Ground truth (what defines quality) is acquired very differently
    - *Comparison of approaches is difficult*
]

// Because
// - a lot of approaches exist,
// - the implementation details are very different,
// - many use CNNs #footnote[Convolutional Neural Networks],
// - and there is often no code or weights available,
//
// Implementation of all approaches for an aggregate score as a baseline is not feasible.

#v(5pt)
Research Question:

#box(inset: (left: 0.5cm, right: 0.5cm))[
  #set align(center)
  #set text(14pt)

  _Which approaches to automatic handwriting quality analysis classify most accurately, and does feature interpretability constrain accuracy?_
]
#v(5pt)

#pagebreak()

= Comparing approaches

Multiple datasets of handwritten documents are combined for >2500 samples total.

+ Approaches will be *categorized* (expecting \~3–4 categories)
+ For each category, a *representative is chosen and implemented*
+ *Representatives are evaluated* against a test-portion of the dataset

== Acquiring Ground Truth Labels

- *Automatic Labelling* by aggregation of
  + multiple approaches with available source-code, or
  + multiple LLMs / classification models.
- The *automatic labelling is first validated* on a subset of the data (50–100 samples) *against two human readers*.
- Human readers grade with *standardized scales assessing the most important criteria* from literature (@quality-factors).
- When correlation is good, all >2500 samples can be automatically labelled
  - *Notion of quality is grounded in literature*
  - *Ground Truth is reproducible*

#v(1fr)

#figure(
  [
    #set text(8pt)
    #set par(leading: 0.5em)

    #show table.cell.where(y: 0): strong
    #show table.cell.where(y: 0): set text(11pt)

    #let redCell(body) = table.cell(fill: red.transparentize(20%), body)
    #let yellowCell(body) = table.cell(fill: yellow.transparentize(20%), body)
    #let brightYellowCell(body) = table.cell(fill: yellow.transparentize(75%), body)

    #table(
      align: left + horizon,
      columns: 3,
      table.header(
        table.cell(colspan: 2)[Factor], [Description]
      ),

      table.cell(rowspan: 11)[*Legibility  *], brightYellowCell[Global Legibility], brightYellowCell[Whether the document is legible on the first read.],

      [Letter Recognizability], [],

      yellowCell[Size], yellowCell[Uniformity and adequacy of letter and sentence size.],

      yellowCell[Letter Shape], yellowCell[Whether letters are normatively well-formed.],

      yellowCell[Letters and word spacing], yellowCell[Uniformity of letter and word spacing.],

      yellowCell[Line adherence], yellowCell[Uniformity of letter placement within lines of text.],

      brightYellowCell[Layout], brightYellowCell[Uniformity of document margins.],

      brightYellowCell[Effort to read], brightYellowCell[How easy a document feels to read.],

      brightYellowCell[Alterations], brightYellowCell[Amount of alterations such as strikeouts, re-tracing of letters, etc.],

      [Colour of line], [],

      [Slant], [Uniformity and angle of slant.],

      redCell[*Speed*], redCell[], redCell[Time to write a reference text.],

      redCell[*Fluency*], redCell[], redCell[Changes in speed over time.],
    )
  ],
  caption: [Prominent factors impacting general handwriting quality from an initial exploratory literature review.]
)<quality-factors>

#v(1fr)

// #[
//   #set heading(numbering: none)

//   = Sources

//   #set text(8pt)
//   #bibliography("/refs.bib", title: none)
// ]
