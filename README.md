
# Graph Signal Processing of Connectome Harmonics
## Reproducibility Repository

This repository accompanies the manuscript

> **"Spectral organization of individualized connectome harmonics across brain structure, function and cognition"**

and reproduces the principal numerical analyses presented in the manuscript.

The code is organized as a modular MATLAB analysis pipeline reproducing the major stages of the study, including:

- Connectome harmonic realignment
- Harmonic descriptor computation
- Stability analyses
- Graph-theoretical analyses
- Surrogate analyses
- Spectral family organization
- Behavioral prediction
- Dynamic harmonic analyses
- Movement analyses
- Task contrasts
- Predictive architecture comparisons

The repository also contains the intermediate outputs generated for the manuscript, allowing every analysis stage to be inspected or reproduced independently.

---

# Design philosophy

This repository prioritizes **transparency** and **reproducibility** over computational efficiency.

Each major analysis stage can be executed independently and relies only on the analysis-ready inputs together with the relevant intermediate outputs from previous stages. This organization allows individual components of the pipeline to be inspected, validated and reproduced without rerunning the complete manuscript analyses.

---

# Repository structure

```text
Paper1_Reproducibility/
│
├── analysis/
├── src/
├── external/
├── data/
│   ├── inputs/
│   └── intermediate/
│       ├── full/
│       └── test/
├── DATA.md
├── README.md
├── LICENSE
├── CITATION.cff
└── .gitignore
```

---

# Code and data availability

The GitHub repository contains the complete MATLAB source code, analysis pipeline, documentation and third-party dependencies.

The complete analysis-ready dataset is distributed separately through the accompanying Zenodo archive because of its size (~8 GB).

Please refer to **DATA.md** for download and installation instructions.

---

# Running the pipeline

Run:

```matlab
RunPaper1Analysis
```

Each analysis block can be enabled or disabled independently through the configuration section of the script.

---

# Reduced reproducibility workflow

Reduced cohorts are used for several computationally intensive analyses in order to keep the reproducibility workflow practical. These reduced analyses verify the computational implementation and should not be interpreted scientifically. Full-cohort intermediate results are provided in the accompanying Zenodo archive.

---

# External dependencies

The `external/` directory contains only the third-party functions required by the reproducibility pipeline.

---

# Contact

**Thomas A. W. Bolton**

📧 thomas.bolton@epfl.ch
