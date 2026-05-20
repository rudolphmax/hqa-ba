from __future__ import annotations

import csv
from pathlib import Path


# Create a csv file for storing labels
def prepare_label_csv(cols: list[str]) -> None:
  p = Path("data/validation_labels.csv")

  with p.open("w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(cols)
