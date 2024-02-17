import csv
import glob
import os

LANG_CSV = "..\\data\\translation\\base.csv"
CARD_FOLDER = "..\\data\\textures\\cards"

if __name__ == '__main__':
    filenames = glob.glob(CARD_FOLDER + "/*.png")
    csv_names = []
    with open(LANG_CSV, "r", encoding="utf-8") as f:
        csv_reader = csv.reader(f)
        for row in csv_reader:
            csv_names.append(row[0])

    for card_file in filenames:
        n = os.path.basename(card_file)[:-4]
        if n not in csv_names:
            print(f"Could not find {card_file} ({n}) in csv")


