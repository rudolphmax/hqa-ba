#import "../../utils/base.typ": base, subtitle, presentation
#import "../../utils/utils.typ": slide

#import "@preview/titleize:0.1.1": titlecase

#show: base
#show: presentation

#set list(marker: ([•], $->$))

#set document(
  title: "Automatic handwriting Quality Analysis",
  author: "Maximilian Rudolph"
)

#slide(first: true)[
  #v(1fr)

  #[
    #set par(spacing: 1em, leading: 0.65em, justify: false)

    #title()

    #text(26pt)[
      #titlecase("Data Strategy for Overcoming inconsistencies in Ground Truth")
    ]

    #v(1fr)

    #text(12pt)[
      Maximilian Rudolph, #datetime.today().display("[day].[month].[year]"), Technische Universität Berlin.\
      Supervised by Prof. Dr. Bettina Berendt.
    ]
  ]
]

#slide(heading: [
  = Introduction
  == Why Handwriting?
])[
  #columns(2)[
    - Key cultural technique of humanity, key for cultural development and knowledge

    - Skill is affected by increasing digitalization

    - Vital for the development of certain motor and intellectual skills in children @ibaibarriagaImpactHandwritingTyping2025

    - Important factor in learning for both children and adults @maranoNeuroscienceWritingHandwriting2025 @kieferWritingDigitalAge2016


    #colbreak()

    #figure(
      image("../assets/RosettaStone2022.jpg"),
      caption: [The Rosetta Stone @RosettaStone2022]
    )
  ]
]

#slide(heading: [
  = Introduction
  == What is Handwriting Quality Analysis?
])[
  #figure(
    grid(columns: 3, gutter: 20pt,
      image("../assets/majumdarVisualAestheticAnalysis2016_fig1.gif"),
      image("../assets/johnsonMeasuringQualityHandwriting1916.png"),
      image("../assets/fitjarAssessingHandwritingMethod2024_fig3.png"),
    ),
    caption: [Taken from @majumdarVisualAestheticAnalysis2016 @johnsonMeasuringQualityHandwriting1916 @fitjarAssessingHandwritingMethod2024 (ltr)]
  )
]

#slide(heading: [
  = Introduction
  == Current Problems
])[
  #set list(marker: $->$)

  + *Feature selection* (how to measure) is *inconsistent* and often not clearly motivated
    - We don't know, what does what and what matters

  + *Non-interpretability* #footnote[
    A feature or method is interpretable if its value is meaningful to a human without further processing.
    Evenness of line spacing is interpretable, for example. A highly abstract metric computed over an entire document or an AI model however, are not considered interpretable.
  ] in almost every approach, which is *undesirable and not critically examined*
    - Feedback on handwriting is not actionable

  + Ground truth (what defines quality) is acquired very differently
    - *Comparison of approaches is difficult*
]

#slide(heading: [
  = Method
  == Research Question
])[
  #v(1fr)

  #box(inset: (left: 3cm, right: 3cm))[
    #set align(center)
    #set text(24pt)

    _Which approaches to automatic handwriting quality analysis classify most accurately, and does feature interpretability constrain accuracy?_
  ]

  #v(1fr)

  Focus on:
  - Everyday adult handwriting
    - not documents produced in early learning stages, e.g. by children
    - not on purely aesthetic works, e.g. calligraphy
  - Only languages with Latin alphabets
]

#slide(heading: [
  = Method
  == Data this data That...
])[
  #figure(
    grid(columns: 3, gutter: (10pt, 10pt),
      grid.cell(rowspan: 3)[#image("../assets/majumdarVisualAestheticAnalysis2016_data.png")],
      image("../assets/adakLegibilityAestheticAnalysis2017_data.png"),
      grid.cell(x: 1, y: 1)[#image("../assets/kuleshHandwritingQualityEvaluation2001_data.png")],
      grid.cell(rowspan: 2)[#image("../assets/falkDevelopmentComputerbasedHandwriting2011a_data.png")],
      grid.cell(colspan: 2)[#image("../assets/koushikHQA2LFShandwritingQualityAssessment2026_data.png")],
    ),
    caption: [Different ground truths between approaches; Taken from @majumdarVisualAestheticAnalysis2016 @adakLegibilityAestheticAnalysis2017 @kuleshHandwritingQualityEvaluation2001 @falkDevelopmentComputerbasedHandwriting2011a @koushikHQA2LFShandwritingQualityAssessment2026 (ltr, ttb).]
  )
]

#slide(heading: [
  = Method
  == Let it be
])[
  #columns(2)[
    Ideally:
    - Implement all prominent approaches, compute an average score for some test data and evaluate features against that

      - No (additional) bias in terms of ground truth
      - Robust baseline

    #colbreak()
  ]
]

#slide(heading: [
  = Method
  == Let it be
])[
  #columns(2)[
    Ideally:
    - Implement all prominent approaches, compute an average score for some test data and evaluate features against that

      - No (additional) bias in terms of ground truth
      - Robust baseline

    #colbreak()

    Problem:
    - Many use CNNs #footnote[Convolutional Neural Networks] nowadays
      - Training needed, no guarantee for equal results
    - A lot of approaches exist
    - Vastly different implementation details
    - No code or weights available
  ]
]

#slide(heading: [
  = Method
  == Same Mistake, again?
])[
  #set list(marker: $->$)

  + Approaches will be categorized (\~3–4)
  + For each category, a representative is chosen and implemented (including AI training)

    - Makes implementation feasible, but:
    - Data is needed for training and evaluation
    - Baseline has to be chosen wisely, or we gain nothing
]

#slide(heading: [
  = Method
  == A closer look at quality
])[
  #figure(
    [
      #set text(12pt)
      #set par(leading: 0.5em)

      #show table.cell.where(y: 0): strong
      #show table.cell.where(y: 0): set text(11pt)

      #let redCell(body) = table.cell(fill: red.transparentize(20%), body)
      #let yellowCell(body) = table.cell(fill: yellow.transparentize(20%), body)
      #let brightYellowCell(body) = table.cell(fill: yellow.transparentize(75%), body)

      #table(
        inset: 8pt,
        align: left + horizon,
        columns: 4,
        table.header(
          table.cell(colspan: 2)[Factor], [Description], [Prominent Sources]
        ),

        table.cell(rowspan: 11)[*Legibility  *], brightYellowCell[Global Legibility], brightYellowCell[Whether the document is legible on the first read.], brightYellowCell[@barnettDevelopmentHandwritingLegibility2018a],

        [Letter Recognizability], [], [@reismanDevelopmentReliabilityResearch1993],

        yellowCell[Size], yellowCell[Uniformity and adequacy of letter and sentence size.], yellowCell[@johnsonMeasuringQualityHandwriting1916 @zivianiEvaluationHandwritingPerformance1984 @reismanDevelopmentReliabilityResearch1993 @fitjarAssessingHandwritingMethod2024 @stefanssonFormativeEvaluationHandwriting2003a],

        yellowCell[Letter Shape], yellowCell[Whether letters are normatively well-formed.], yellowCell[@zivianiEvaluationHandwritingPerformance1984 @reismanDevelopmentReliabilityResearch1993 @fitjarAssessingHandwritingMethod2024 @stefanssonFormativeEvaluationHandwriting2003a],

        yellowCell[Letters and word spacing], yellowCell[Uniformity of letter and word spacing.], yellowCell[@johnsonMeasuringQualityHandwriting1916 @zivianiEvaluationHandwritingPerformance1984 @reismanDevelopmentReliabilityResearch1993 @stefanssonFormativeEvaluationHandwriting2003a],

        yellowCell[Line adherence], yellowCell[Uniformity of letter placement within lines of text.], yellowCell[@johnsonMeasuringQualityHandwriting1916 @zivianiEvaluationHandwritingPerformance1984 @fitjarAssessingHandwritingMethod2024 @stefanssonFormativeEvaluationHandwriting2003a],

        brightYellowCell[Layout], brightYellowCell[Uniformity of document margins.], brightYellowCell[@barnettDevelopmentHandwritingLegibility2018a],

        brightYellowCell[Effort to read], brightYellowCell[How easy a document feels to read.], brightYellowCell[@barnettDevelopmentHandwritingLegibility2018a],

        brightYellowCell[Alterations], brightYellowCell[Amount of alterations such as strikeouts, re-tracing of letters, etc.], brightYellowCell[@barnettDevelopmentHandwritingLegibility2018a],

        [Colour of line], [], [@johnsonMeasuringQualityHandwriting1916],

        [Slant], [Uniformity and angle of slant.], [@johnsonMeasuringQualityHandwriting1916],

        redCell[*Speed*], redCell[], redCell[Time to write a reference text.], redCell[@zivianiEvaluationHandwritingPerformance1984 @stefanssonFormativeEvaluationHandwriting2003a @fitjarAssessingHandwritingMethod2024 @peverlyImportanceHandwritingSpeed2006],

        redCell[*Fluency*], redCell[], redCell[Changes in speed over time.], redCell[@fitjarAssessingHandwritingMethod2024],
      )
    ],
    caption: [Prominent factors impacting general handwriting quality from an initial exploratory literature review.]
  )<quality-factors>
]

// #slide()[
//   #figure(
//     image("../assets/zivianiEvaluationHandwritingPerformance1984_table2.png"),
//     caption: [The letter shape correctness criteria from @zivianiEvaluationHandwritingPerformance1984.]
//   )
// ]

#slide()[
  #figure(
    grid(columns: 2, gutter: 20pt,
      image("../assets/HLS01.png"),
      image("../assets/HLS02.png"),
    ),
    caption: [The Handwriting Legibility Scale @barnettDevelopmentHandwritingLegibility2018a]
  )
]

#slide(heading: [
  = Method
  == Data Acquisition
])[
  - Combining multiple datasets of handwritten documents
  - Mostly from text recognition related competitions
  - > 2500 samples total

  #figure(
    grid(columns: 3, gutter: 20pt,
      image("../assets/ICDAR2024HWD.jpg"),
      image("../assets/Lee2021.jpg"),
    ),
    caption: [Taken from @ICDAR2024HWD @Lee2021 (ltr)]
  )
]

#slide(heading: [
  = Method
  == Acquiring Ground Truth Labels
])[
  - Automatic Labelling by aggregation of
    + multiple approaches with available source-code, or
    + multiple LLMs / classification models

  - Automatic approach is first validated on 50–100 samples (human vs. automatic labels)

  - When correlation is good, all >2500 samples can be automatically labelled

    - *Notion of quality is grounded in literature*
    - *Ground Truth is reproducible*
]

#slide(heading: [
  = Outlook
  == What comes next
])[
  1. Finalize the dataset
  2. Validate and perform automatic labelling
  3. Categorize approaches and implement representatives
  4. Evaluate
]

#slide(heading: [= Sources])[
  #set text(10pt)
  #bibliography("/refs.bib", title: none)
]
