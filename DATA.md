
# DATA

The complete reproducibility dataset accompanying this repository is distributed through **Zenodo**.

> **Zenodo DOI:** *To be inserted after publication.*

The archive contains approximately **8 GB** of analysis-ready data.

---

# Contents

The Zenodo archive contains the complete `data/` directory expected by the repository:

```text
data/
├── inputs/
└── intermediate/
    ├── full/
    └── test/
```

No files need to be renamed or modified.

---

# Installation

1. Download or clone this GitHub repository.
2. Download the reproducibility dataset from Zenodo.
3. Extract the downloaded archive.
4. Copy the `data/` directory into the repository root while preserving the directory structure:

```text
Paper1_Reproducibility/
├── analysis/
├── src/
├── external/
├── data/
│   ├── inputs/
│   └── intermediate/
├── README.md
└── DATA.md
```

No path modifications or additional configuration are required.

---

# Verification

Start MATLAB, open the repository, and execute:

```matlab
RunPaper1Analysis
```

If the dataset has been installed correctly, the loading routine will validate the input files before the analyses begin.

---

# Notes

- The GitHub repository contains the source code and documentation.
- Zenodo contains the complete reproducibility dataset.
- Together, the two provide all material required to reproduce the analyses presented in the accompanying manuscript.
