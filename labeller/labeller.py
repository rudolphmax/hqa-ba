from __future__ import annotations

import argparse
import csv
from pathlib import Path

import pandas as pd
import PySimpleGUI as sg

from utils import make_view, prepare_label_csv

parser = argparse.ArgumentParser(
                    prog="A-HQA Labeller",
                    description="Labelling quality of handwritten documents along two standadized scales.",
                    epilog="rudolphmax/a-hqa",
                )

cols = ["Num", "Filename", "Spelling", "Effort", "Layout", "Letter Formation", "Alteration"]

if (not Path("data/validation_set.csv").is_file()):
  raise Exception("No validation dataset csv found.")

samples = pd.read_csv("data/validation_set.csv")

if (not Path("data/validation_labels.csv").is_file()):
  prepare_label_csv(cols)

labels = pd.read_csv("data/validation_labels.csv", sep=",")
start_index = 0

if labels.shape[0] > 0:
    start_index = labels.shape[0]

container = sg.Column([
    make_view(samples.iloc[start_index]["Filename"], samples.iloc[start_index]["Num"]),
], k="-CONTAINER-")

layout = [[container]]

window = sg.Window("Data Entry App", layout)

window.metadata = { "i": start_index, "rotations": [0]*samples.shape[0] }

while True:
    event, values = window.read()
    print(event)

    i = window.metadata["i"]
    sample = samples.iloc[i]

    if event == sg.WIN_CLOSED or event[0] == "-Exit-":
        break
    if "-RotateCCW-" in event:
        window.metadata["rotations"][i] += 90

        window.extend_layout(
            window["-CONTAINER-"],
            [make_view(sample["Filename"], sample["Num"], 90)],
        )
        window[("-ROW-", sample["Num"])].update(visible=False)

    if "-RotateCW-" in event:
        window.metadata["rotations"][i] -= 90

        window.extend_layout(
            window["-CONTAINER-"],
            [make_view(sample["Filename"], sample["Num"], window.metadata["rotations"][i])],
        )
        window[("-ROW-", sample["Num"])].update(visible=False)

    if event[0] == "-Next-":
        row = [
            sample["Num"],
            sample["Filename"],
            values[("-SPELLING-", sample["Num"])],
            values[("-EFFORT-", sample["Num"])],
            values[("-LAYOUT-", sample["Num"])],
            values[("-LETTER-FORMATION-", sample["Num"])],
            values[("-ALTERATION-", sample["Num"])],
        ]

        with Path("data/validation_labels.csv").open("a", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(row)

        next_index = i + 1  # TODO: constrain next_index by number of samples

        window.extend_layout(
            window["-CONTAINER-"],
            [make_view(samples.iloc[next_index]["Filename"], samples.iloc[next_index]["Num"])],
        )
        window[("-ROW-", sample["Num"])].update(visible=False)
        window.metadata["i"] += 1


window.close()
