from __future__ import annotations

import csv
import io
from pathlib import Path

import PIL.Image
import PySimpleGUI as sg


# Create a csv file for storing labels
def prepare_label_csv(cols: list[str]) -> None:
  p = Path("data/validation_labels.csv")

  with p.open("w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(cols)


img_max_width = 750
img_max_height = 900

def load_image(file: str, rotate: int | None = None) -> sg.Image:
  img = PIL.Image.open(file)
  ratio = (img.size[1] / img.size[0])

  if (int(img_max_width * ratio) > img_max_height):
    new_size = (int(img_max_height * (1/ratio)), img_max_height)
  else:
    new_size = (img_max_width, int(img_max_width * ratio))

  img = img.resize(new_size)

  if rotate is not None:
    img = img.rotate(rotate, expand=True)

  with io.BytesIO() as bio:
    img.save(bio, format="PNG")
    del img
    return sg.Image(data=bio.getvalue())


def question(
  i: int,
  name: str,
  desc: str,
  lLabel: str | None = None,
  rLabel: str | None = None,
  minVal: int = 1,
  maxVal: int = 5,
) -> list:
  return [
    sg.Column(
      [
        sg.vtop(
          [
            sg.Column([[sg.Text(name, font="20")]]),
            sg.Column(
              [
                [sg.Text(desc, font="12")],
                sg.vbottom(
                  [
                    sg.Text(lLabel, visible=bool(lLabel)),
                    sg.Slider(
                      (minVal, maxVal),
                      expand_x=True,
                      orientation="horizontal",
                      key=("-" + name.upper().replace(" ", "-") + "-", i),
                    ),
                    sg.Text(rLabel, visible=bool(rLabel)),
                  ],
                ),
              ],
              expand_x=True,
            ),
          ],
        ),
      ],
      expand_x=True,
    ),
  ]


def make_view(image_filename: str, i: int, rotate: int | None = None) -> list:
  return [
    sg.pin(
      sg.Column(
        [
          sg.vtop(
            [
              sg.Frame(
                "Document",
                [
                  [
                    sg.Button("Rotate (L)", key="-RotateCCW-"),
                    sg.Button("Rotate (R)", key="-RotateCW-"),
                  ],
                  [sg.Sizer(img_max_width, 0)],
                  [sg.Sizer(0, img_max_height), load_image(image_filename, rotate)],
                ],
                key="-Document-",
              ),
              sg.Column(
                [
                  [
                    sg.Frame(
                      "Questionnaire",
                      [
                        question(
                          i,
                          "Spelling",
                          "Are there comparatively many spelling errors?",
                          "Yes",
                          "No",
                          1,
                          0,
                        ),
                        [sg.HorizontalSeparator()],
                        [sg.Text("For the first three questions, consider your overall impression of the document.")],
                        question(
                          i,
                          "Legibility",
                          "Overall, how legible is the text when first reading?",
                          "All w. legible",
                          "Few w. legible",
                        ),
                        question(
                          i,
                          "Effort",
                          "How much effort is required for you to read the document overall?",
                          "No effort",
                          "Extreme effort",
                        ),
                        question(
                          i,
                          "Layout",
                          """An overall impression of the layout of writing\n
                          on the page. Well organised handwriting is consistent, with elements\n
                          appropriately positioned in relation to each other (e.g. the position\nof the margin,
                          placement of letters on the baseline, spaces within\nand between words).""",
                          "Good layout",
                          "Bad layout",
                        ),
                        [sg.HorizontalSeparator()],
                        [sg.Text("Now focus on individual letters / words in more detail.")],
                        question(
                          i,
                          "Letter Formation",
                          """An overall impression of letter formation.\nWell formed letters are appropriately
                           shaped, contain all necessary\nelements, neat letter closures and are consistent
                           in size and slope.""",
                          "All well-formed",
                          "Most poorly formed",
                        ),
                        question(
                          i,
                          "Alteration",
                          """An overall impression of the attempts made to rectify\nletters within words. Includes the
                           addition of elements, re-tracing\n or re-writing of letters.""",
                          "None",
                          "Most words",
                        ),
                        [sg.VPush()],
                      ],
                      key="-Questionnaire-",
                    ),
                  ],
                  [sg.VPush()],
                  [sg.Button("Next", key=("-Next-", i))],
                ],
                key="-ContentCol-",
              ),
            ],
          ),
        ],
        k=("-ROW-", i),
      ),
    ),
  ]
