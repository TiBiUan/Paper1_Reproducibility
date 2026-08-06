# Graph Signal Processing of Connectome Harmonics
## Reproducibility Repository

This repository accompanies the manuscript

> **"Spectral organization of individualized connectome harmonics across brain structure, function and cognition"**

and reproduces the principal numerical analyses presented in the manuscript.

The code is organized as a modular analysis pipeline, where each section reproduces one major stage of the study:

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

Each major analysis stage can be executed independently and relies only on the analysis-ready inputs together with the relevant intermediate outputs from previous stages. This organization allows individual components of the pipeline to be inspected, validated, and reproduced without rerunning the complete manuscript analyses.

---

# Repository structure

```text
Paper1_Reproducibility/
│
├── analysis/
│   └── RunPaper1Analysis.m
│
├── src/
│
├── external/
│
├── data/
│   ├── inputs/
│   └── intermediate/
│       ├── full/
│       └── test/
│
└── README.md
```

---

# Input data

The `data/inputs/` directory contains the analysis-ready data required by the pipeline, including

- structural connectivity
- connectome harmonics
- behavioral measures
- motion estimates
- task fMRI data
- regional distances
- all additional quantities required by the manuscript.

The loading routine validates the integrity of the data before each analysis.

---

# Intermediate checkpoints

The directory

```text
data/intermediate/full/
```

contains the principal outputs generated for the manuscript, allowing each analysis stage to be inspected without rerunning the complete pipeline.

```text
01_Realignment.mat
02_HarmonicDescriptors.mat
03_StabilityAnalysis.mat
04_RawSCAnalysis.mat
05_SurrogateAnalysis.mat
06_FamilyAnalysis.mat
07_BehavioralPrediction.mat
08_DynamicAnalysis.mat
09_MovementAnalysis.mat
10_TaskContrasts.mat
11_ArchitectureAnalysis.mat
```

The directory

```text
data/intermediate/test/
```

is automatically populated when running the reduced reproducibility workflow.

---

# Running the pipeline

Execute the complete analysis by running

```matlab
RunPaper1Analysis
```

Each major analysis stage can be enabled or disabled independently through the configuration section at the beginning of the script.

---

# Reduced reproducibility workflow

To keep the reproducibility workflow practical, some analyses are executed on reduced subject cohorts.

| Analysis | Subjects | Typical runtime |
|:-----------------------------|---------:|---------------:|
| Realignment | 875 | ~10 s |
| Harmonic descriptors | 10 | ~13.7 min |
| Stability significance | 875 | ~2 min |
| Raw SC analysis | 20 | ~1 min |
| Surrogate sparsity | 50 | ~1.4 min |
| Family organization | 875 | ~4.5 min |
| Behavioral prediction | 200 | ~36 min |
| Dynamic analysis | 10 | ~3.3 min |
| Movement analysis | 875 | ~1.8 min |
| Task contrasts | 875 | ~2.4 min |
| Architecture comparison | 400 | ~8.8 min |

### Hardware used for runtime estimates

- MacBook Pro 14-inch (2023)
- Apple M3 Pro
- 18 GB unified memory
- macOS
- MATLAB R2022a
- Parallel Computing Toolbox disabled

> **Note**
>
> Reduced-cohort analyses are intended solely to verify the computational workflow and software implementation. Scientific conclusions should be drawn exclusively from the full-cohort results provided in `data/intermediate/full/`.

---

# Dynamic analyses

The reduced workflow recomputes the dynamic analysis for a single representative task (**EMOTION**) in order to reduce runtime and repository size.

The complete dynamic analyses used in the manuscript are provided in

```text
data/intermediate/full/08_DynamicAnalysis.mat
```

---

# Behavioral prediction

The reduced workflow executes the complete prediction pipeline but **does not regenerate the behavioral null distributions**, as these require extensive repeated model fitting.

The null distributions used in the manuscript are included in

```text
data/intermediate/full/07_BehavioralPrediction.mat
```

---

# External dependencies

The `external/` directory contains only the third-party functions required by the reproducibility pipeline.

No additional neuroimaging software (e.g. BrainNet Viewer or SPM) is required.

---

# Contact

For questions regarding the repository or the accompanying manuscript:

**Thomas A. W. Bolton**

📧 thomas.bolton@epfl.ch
