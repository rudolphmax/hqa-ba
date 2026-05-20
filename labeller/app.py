import csv
from pathlib import Path

import pandas as pd
import streamlit as st
from streamlit.delta_generator import DeltaGenerator

from utils import prepare_label_csv

cols = ["Num", "Filename", "Reader", "Spelling", "Effort", "Layout", "Letter Formation", "Alteration"]

if not Path("data/validation_set.csv").is_file():
  raise Exception("No validation dataset csv found.")

samples = pd.read_csv("data/validation_set.csv")

if not Path("data/validation_labels.csv").is_file():
  prepare_label_csv(cols)

labels = pd.read_csv("data/validation_labels.csv", sep=",")
start_index = 0
num_documents = samples.shape[0]

if labels.shape[0] > 0:
  start_index = labels.shape[0]

if "index" not in st.session_state:
    st.session_state["index"] = start_index

if "reader" not in st.session_state:
    st.session_state["reader"] = labels.iloc[start_index-1]["Reader"]

def next_doc(values: dict) -> None:
  sample = samples.iloc[st.session_state.index]

  row = [
    sample["Num"],
    sample["Filename"],
    values["reader"],
    values["legibility"],
    values["effort"],
    values["layout"],
    values["letter-formation"],
    values["alteration"],
  ]

  with Path("data/validation_labels.csv").open("a", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(row)

  st.session_state.index += 1

def question(container: DeltaGenerator, name: str, desc: str, key: str) -> int:
  left, right = container.columns([2, 3])
  left.markdown("###### " + name)

  return right.slider(desc, 1, 5, 1, key=key)

st.set_page_config(layout="wide")

left_column, right_column = st.columns(2, gap="large")

with left_column:
  sample = samples.iloc[st.session_state.index]

  info = st.container(horizontal=True, horizontal_alignment="distribute")
  info.text("Doc: " + str(sample["Num"]))
  info.text(str(st.session_state.index + 1) + "/" + str(samples.shape[0]))

  st.image(sample["Filename"])

  st.session_state.reader = st.text_input("Reader", labels.iloc[start_index-1]["Reader"], width=100)

with right_column:
  st.space("medium")
  c = st.container(gap="medium")

  q = c.container(gap="medium")
  legibility = question(q, "Legibility", "Overall, how legible is the text when first reading?", "legibility")
  effort = question(
    q,
    "Effort",
    "How much effort is required for you to read the document overall?",
    "effort",
  )
  layout = question(
    q,
    "Layout",
    """An overall impression of the layout of writing
    on the page. Well organised handwriting is consistent, with elements
    appropriately positioned in relation to each other (e.g. the position of the margin,
    placement of letters on the baseline, spaces within and between words).""",
    "layout",
  )
  letter_formation = question(
    q,
    "Letter Formation",
    """An overall impression of letter formation. Well formed letters are appropriately shaped,
    contain all necessary elements, neat letter closures and are consistent in size and slope.""",
    "letter-formation",
  )
  alteration = question(
    q,
    "Alteration",
    """An overall impression of the attempts made to rectify letters within words. Includes the
    addition of elements, re-tracing  or re-writing of letters.""",
    "alteration",
  )

  button_container = c.container(horizontal=True, horizontal_alignment="right")
  button_container.button(
    "Next",
    on_click=next_doc,
    args=[{
      "reader": st.session_state.reader,
      "legibility": legibility,
      "effort": effort,
      "layout": layout,
      "letter-formation": letter_formation,
      "alteration": alteration,
    }]
  )
