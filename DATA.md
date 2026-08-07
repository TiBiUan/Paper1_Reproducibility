# DATA

## Reproducibility dataset

The complete analysis-ready dataset accompanying the reproducibility package is distributed separately through Zenodo because its size exceeds GitHub's storage limits.

The dataset is permanently archived at

**https://doi.org/10.5281/zenodo.21829598**

and, together with the GitHub repository, forms the complete reproducibility package accompanying the manuscript

> **Spectral organization of individualized connectome harmonics across brain structure, function and cognition**

submitted to **Nature Communications**.

---

# Dataset contents

The Zenodo archive contains the complete `data/` directory required by the reproducibility pipeline.

The directory is organized into two components.

- **`inputs/`** contains the complete analysis-ready input data required by the reproducibility pipeline.

- **`intermediate/`** contains intermediate outputs generated throughout the analysis pipeline and is further divided into

  - **`full/`**, containing the complete intermediate outputs used to reproduce the numerical analyses reported in the manuscript and to regenerate the manuscript figures;

  - **`test/`**, containing intermediate outputs generated from reduced-cohort executions of the reproducibility pipeline.

No files require renaming or modification after extraction.

---

# Installation

1. Clone or download the GitHub repository.

2. Download the accompanying reproducibility dataset from Zenodo.

3. Extract the downloaded archive.

4. Copy the extracted `data/` directory into the repository root so that the directory structure becomes

```text
Paper1_Reproducibility/
│
├── analysis/
├── src/
├── external/
├── data/
│   ├── inputs/
│   └── intermediate/
├── README.md
├── DATA.md
├── LICENSE
└── CITATION.cff
```

No additional configuration or path modification is required.

---

# Verification

Once the dataset has been installed, open MATLAB from the repository root and execute

```matlab
RunPaper1Analysis;
```

Successful execution confirms that the reproducibility package has been installed correctly and that all required software dependencies are functioning as expected.

---

# Relationship to the repository

The GitHub repository contains

- the research version of the Graph Signal Processing Toolbox (GSPTB);
- the complete reproducibility pipeline;
- documentation;
- required third-party software.

The Zenodo archive contains the complete reproducibility dataset.

Together, the GitHub repository and Zenodo archive provide all material required to reproduce the numerical analyses reported in the accompanying manuscript.

---

# Contact

Questions regarding the reproducibility dataset may be directed to

**Thomas A. W. Bolton**

📧 thomas.bolton@epfl.ch