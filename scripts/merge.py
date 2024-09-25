import pandas as pd
from subprocess import call, run
import os

def make_key(term, definition):
    """Combine the term and the definition to make a slug-like identifier"""
    key = f"{term}{definition}"
    # Convert to lowercase
    key = key.lower()
    # Remove spaces and punctuation
    key = ''.join(char for char in key if char.isalnum())
    return key


contributions="data/contributionsVerifiees.csv"
slashtrad="data/slashtrad.csv"
sigles = os.environ["sigles"]

call("scripts/getContributions.sh")
call("scripts/getSlashtrad.sh")
run(["git","checkout","--","data/sigles.csv"])

df_sigles: pd.DataFrame = pd.read_csv(sigles, index_col="id", dtype=str,
                                      encoding='unicode_escape')
print(f"{df_sigles.index.size} sigles avant le merge")
print("""+++++++++++++++
      """)

df_slashtrad: pd.DataFrame = pd.read_csv(slashtrad, index_col="id", dtype=str)
df_contributions: pd.DataFrame = pd.read_csv(contributions, index_col="id", dtype=str)

if ",".join(df_contributions.columns) == ",".join(df_slashtrad.columns):
    print("Fusion de slashtrad et contributions dans sigles.csv...")

    df = pd.concat([df_slashtrad, df_contributions])
    df = df.sort_values(by="term", ascending=True)
    df["key"] = df.apply(lambda row: make_key(row['term'], row['definition']), axis=1)  
    df = df.drop_duplicates(subset="key")
    df.drop(columns="key")

    print("""
          ++++++++++++++""")
    print(f"{df.index.size} sigles après le merge")

    df.to_csv("data/sigles.csv")
    df.to_excel("data/sigles.xlsx")

else:
    print("Les en-têtes de colonnes ne correspondent pas.")




