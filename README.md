# Reproducibility Package

## Spectral organization of individualized connectome harmonics across brain structure, function and cognition

This repository accompanies the manuscript

> **Spectral organization of individualized connectome harmonics across brain structure, function and cognition**

submitted to **Nature Communications**.

It contains the research version of the **Graph Signal Processing Toolbox (GSPTB)**, together with the complete reproducibility package accompanying this study. The package has been designed to enable independent reproduction of every numerical analysis reported in the accompanying manuscript, together with the intermediate outputs required to regenerate all reported figures. It provides a modular software framework for the computation and analysis of individualized connectome harmonics.

---

# Repository at a glance

| Item | Description |
|------|-------------|
| **Repository** | https://github.com/TiBiUan/Paper1_Reproducibility |
| **Permanent archive** | https://doi.org/10.5281/zenodo.21829598 |
| **License** | MIT |
| **Programming language** | MATLAB |
| **Maintainer** | Thomas A. W. Bolton |

---

# Purpose

The Graph Signal Processing Toolbox (GSPTB) provides a MATLAB framework for the computation, alignment and analysis of individualized connectome harmonics derived from structural brain connectivity.

The repository combines the research version of GSPTB with the complete analysis pipeline, documentation, required third-party software and intermediate outputs necessary to reproduce the reported analyses.

The repository has been organized so that each major analysis stage can be executed, inspected and validated independently. This modular organization facilitates both scientific reproducibility and methodological exploration, while allowing researchers to reuse individual components of the pipeline in future work.

The complete analysis-ready dataset is distributed separately through the accompanying Zenodo archive because of GitHub size limitations. Installation instructions are provided in **DATA.md**.

---

# Reproducibility statement

This repository has been validated from a clean installation by reproducing every numerical analysis reported in the accompanying manuscript. The resulting outputs were verified against the intermediate results used to generate the figures reported in the accompanying manuscript.

The validation procedure consisted of downloading the repository from GitHub, installing the accompanying reproducibility dataset from Zenodo, and executing the complete analysis pipeline without modification. The resulting outputs reproduced all numerical analyses and the intermediate results used to generate the figures presented in the manuscript.

---

# Design principles

The reproducibility package has been designed according to four guiding principles.

### Scientific reproducibility

Every reported result can be reproduced from the publicly released software and accompanying dataset.

### Transparency

Individual analysis stages remain accessible and can be inspected independently without executing the complete pipeline.

### Extensibility

Although developed for the accompanying manuscript, the toolbox has been designed as a general framework for individualized connectome harmonic analysis and may also serve as a foundation for future methodological developments.

### Modularity

The analysis pipeline is organized into self-contained computational modules, facilitating validation, methodological development and reuse.

---

# Repository organization

The repository is organized into a small number of clearly defined components.

| Directory | Purpose |
|----------|---------|
| `analysis/` | Complete manuscript analysis pipeline. |
| `src/` | Core implementation of the Graph Signal Processing Toolbox (GSPTB). |
| `external/` | Third-party software required by the reproducibility pipeline. |
| `data/` | Analysis-ready inputs and intermediate outputs (distributed separately through Zenodo). |

The repository structure is therefore

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
├── README.md
├── DATA.md
├── LICENSE
├── CITATION.cff
└── .gitignore
```

The separation between source code, analyses, external software and data has been chosen to facilitate navigation, maintenance and future extension of the toolbox while preserving a transparent and reproducible analysis workflow.

---

# Running the reproducibility pipeline

Once the reproducibility dataset has been installed (see **DATA.md**), the complete analysis pipeline can be executed from MATLAB by running

```matlab
RunPaper1Analysis;
```

The script is organized into a series of independent analysis modules corresponding to the principal components of the accompanying manuscript. Individual modules can be enabled or disabled through the configuration section located at the beginning of the script, allowing specific analyses to be reproduced without executing the complete pipeline.

Intermediate outputs generated during execution are stored within the `data/intermediate/` directory and may subsequently be reused by downstream analyses. This modular workflow reduces unnecessary computation while facilitating inspection and validation of individual processing stages.

---

# Reduced reproducibility workflow

Several analyses reported in the manuscript are computationally demanding when performed on the complete cohort of 875 participants. To facilitate practical reproduction of the analysis pipeline, selected computationally intensive procedures are executed on reduced cohorts within the default reproducibility workflow.

The complete intermediate outputs obtained from the full cohort are provided as part of the accompanying reproducibility dataset. Consequently, every subsequent analysis can be reproduced exactly as reported in the manuscript without requiring users to rerun the most computationally expensive stages.

This design choice substantially reduces execution time while preserving complete transparency of the computational workflow.

---

# External software

The reproducibility package relies on several third-party software components that are distributed through the `external/` directory.

These packages remain the intellectual property of their respective authors and are redistributed in accordance with their original licenses. Please refer to the corresponding documentation provided with each package for licensing information and appropriate citation.

---

# Troubleshooting

### Missing data

The repository does not contain the `data/` directory because of GitHub size limitations. Before executing the analysis pipeline, download the accompanying reproducibility dataset from the Zenodo archive and install it as described in **DATA.md**.

### macOS security

On macOS, the operating system may prevent execution of third-party compiled MEX binaries (for example `mexOMP`) when they are used for the first time because they originate from an unidentified developer.

If this occurs, allow execution through **System Settings → Privacy & Security**, then rerun the corresponding analysis. This behaviour is part of the standard macOS security model and is unrelated to the reproducibility package itself.

---

# Citation

If this reproducibility package contributes to your research, please cite both the accompanying manuscript and the archived software release.

### Accompanying manuscript

Please cite the accompanying manuscript when referring to the scientific methodology and results.

### Reproducibility package

Please also cite the archived Zenodo release when using the software or reproducibility package.

Zenodo DOI:

https://doi.org/10.5281/zenodo.21829598

---

# Contact

Questions regarding the reproducibility package, software or manuscript may be directed to

**Thomas A. W. Bolton**

📧 thomas.bolton@epfl.ch

---

This reproducibility package has been developed to facilitate transparent, reproducible and extensible research in graph signal processing, connectome harmonics and network neuroscience.