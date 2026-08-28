# Cell Segmentation in Multiplexed Tissue Imaging
### A Systematic Benchmarking Study

[![Python 3.12](https://img.shields.io/badge/python-3.12-blue.svg)](https://www.python.org/downloads/release/python-3120/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Institution](https://img.shields.io/badge/Institution-University%20of%20Oulu-003580)](https://www.oulu.fi)

**Authors:** Ramisa Fariha Mridha, Md Ziaul Hoque, Tapio Seppänen  
**Affiliation:** Center for Machine Vision and Signal Analysis (CMVS), University of Oulu, Finland  
**Contact:** ramisa.mridha@oulu.fi

---

## Overview

This repository contains all code, scripts, and LaTeX source files for the paper:

> **"Cell Segmentation in Multiplexed Tissue Imaging: A Systematic Benchmarking Study"**  
> Submitted to IEEE Transactions on Biomedical Engineering and ICIP 2026

Five cell segmentation methods are benchmarked on the imaging mass cytometry (IMC) subset of TissueNet v1.1:

| Method | Description | Pipeline |
|---|---|---|
| **CP-Default** | Cellpose v4 (cpsam), automatic diameter | steinbock, mplexable |
| **CP-Diam15** | Cellpose v4 (cpsam), fixed diameter = 15 px | steinbock, mplexable (tuned) |
| **CP-Nuclei** | Cellpose nuclei model, single channel | Nuclear segmentation |
| **StarDist** | 2D_versatile_fluo pretrained model | CASSATT |
| **Classical** | Otsu thresholding + watershed | Baseline |

### Key Results

| Method | F1@0.5 (val) | F1@0.75 (val) | AP (val) | s/img |
|---|---|---|---|---|
| CP-Default | 0.766 ± 0.199 | 0.456 ± 0.238 | 0.433 ± 0.168 | 0.44 |
| **CP-Diam15** | **0.802 ± 0.164** | **0.514 ± 0.221** | **0.476 ± 0.148** | 0.84 |
| CP-Nuclei | 0.772 ± 0.185 | 0.486 ± 0.205 | 0.454 ± 0.146 | 0.41 |
| StarDist | 0.683 ± 0.101 | 0.321 ± 0.143 | 0.349 ± 0.088 | 0.16 |
| Classical | 0.272 ± 0.099 | 0.044 ± 0.037 | 0.091 ± 0.039 | 0.01 |

---

## Repository Structure

```
Cell-Segmentation-IMC-Benchmark/
│
├── benchmark/                          # Benchmark scripts
│   ├── tissuenet_benchmark_puhti_v2.py     # Main benchmark (CSC Puhti HPC)
│   ├── tissuenet_benchmark_final.py         # Final cleaned benchmark version
│   ├── benchmark_extended.py                # Extended methods (cyto2, Omnipose)
│   ├── tissuenet_imc_benchmark.py           # IMC subset extraction and benchmarking
│   └── tissuenet_stardist_and_analysis.py   # StarDist-specific analysis
│
├── figures/                            # Figure generation scripts
│   ├── generate_figures_extended.py        # All 12 publication figures (Puhti)
│   ├── generate_figures_puhti.py           # Puhti-optimised figure generator
│   ├── generate_figures_colab.py           # Google Colab figure generator
│   ├── generate_paper_figures.py           # Core publication figures
│   └── generate_figures.py                 # Utility figure functions
│
├── colab/                              # Google Colab notebooks
│   └── colab_complete_notebook.py          # Complete Colab benchmark notebook
│
├── paper/                              # LaTeX source files
│   ├── main.tex                            # IEEE Transactions full paper
│   ├── main_icip.tex                       # ICIP 2026 conference paper
│   └── Figures/                            # Generated figures (PDF)
│       ├── fig1_dataset_overview.pdf
│       ├── fig2_ground_truth.pdf
│       ├── fig3_method_representative.pdf
│       ├── fig4_method_hard.pdf
│       ├── fig5_bar_f1.pdf
│       ├── fig6_metric_comparison.pdf
│       ├── fig7_runtime.pdf
│       ├── fig8_failure_analysis.pdf
│       ├── fig9_f1_threshold_curve.pdf
│       ├── fig10_delta_f1_heatmap.pdf
│       ├── fig11_cellcount_vs_metrics.pdf
│       └── fig12_method_correlation.pdf
│
├── results/                            # Experimental results (not tracked by git)
│   └── .gitkeep
│
├── environment/                        # Environment configuration
│   ├── requirements.txt                    # Python dependencies
│   ├── requirements_colab.txt              # Colab-specific dependencies
│   └── puhti_job.sh                        # CSC Puhti SLURM job script
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## Dataset

The **TissueNet v1.1** dataset is used for evaluation. It is publicly available from the Deepcell/Van Valen lab.

**Download:**
```bash
# Download TissueNet v1.1
wget https://deepcell-data.s3.us-east-2.amazonaws.com/tissuenet-v1-1.zip
unzip tissuenet-v1-1.zip -d data/tissuenet_v1.1/
```

The IMC subset (38 validation, 16 test images at 256×256 px, 0.5 µm/px) is automatically extracted by the benchmark scripts using metadata filtering.

---

## Installation

### Option 1: Local environment

```bash
# Clone the repository
git clone https://github.com/Ramisa13/Cell-Segmentation-IMC-Benchmark.git
cd Cell-Segmentation-IMC-Benchmark

# Create virtual environment
python -m venv venv
source venv/bin/activate          # Linux/macOS
# venv\Scripts\activate           # Windows

# Install dependencies
pip install -r environment/requirements.txt
```

### Option 2: Google Colab

Open `colab/colab_complete_notebook.py` in Colab. The notebook handles all installations automatically.

### Option 3: CSC Puhti HPC

```bash
# SSH into Puhti
ssh username@puhti.csc.fi

# Clone into scratch directory
cd /scratch/project_2019277/username/
git clone https://github.com/Ramisa13/Cell-Segmentation-IMC-Benchmark.git

# Submit job
sbatch environment/puhti_job.sh
```

---

## Usage

### 1. Run the full benchmark (Puhti HPC)

```bash
python benchmark/tissuenet_benchmark_puhti_v2.py \
    --data_dir /scratch/project_2019277/tissuenet_v1.1/ \
    --output_dir /scratch/project_2019277/rmridha/benchmark_results/v2/
```

**Expected output:**
```
Loading TissueNet IMC subsets ...
  val: 38 images, shape (38, 256, 256, 2)
  test: 16 images, shape (16, 256, 256, 2)

--- VAL split (38 images) ---
  [cellpose_default]    17s  (0.44s/img)   F1@0.5: 0.766
  [cellpose_diam15]     32s  (0.84s/img)   F1@0.5: 0.802
  [cellpose_nuclei]     16s  (0.41s/img)   F1@0.5: 0.772
  [stardist]             6s  (0.16s/img)   F1@0.5: 0.683
  [classical]            0s  (0.01s/img)   F1@0.5: 0.272
```

### 2. Generate all 12 publication figures

```bash
python figures/generate_figures_extended.py
```

Figures are saved to `results/Figures/` as both `.pdf` and `.png`.

### 3. Run on Google Colab

Upload `colab/colab_complete_notebook.py` to Google Colab, or use the direct link:

```python
# In Colab:
!wget https://raw.githubusercontent.com/Ramisa13/Cell-Segmentation-IMC-Benchmark/main/colab/colab_complete_notebook.py
exec(open('colab_complete_notebook.py').read())
```

---

## Reproducibility Notes

### Software versions used

| Package | Version | Notes |
|---|---|---|
| Python | 3.12 | |
| Cellpose | 4.0.1 | Uses cpsam model by default |
| StarDist | 0.8 | 2D_versatile_fluo pretrained weights |
| TensorFlow | 2.17 | Required Keras backend for StarDist |
| PyTorch | 2.x | Required for Cellpose |
| scikit-image | 0.21 | Image processing operations |
| SciPy | 1.13 | Hungarian assignment algorithm |
| NumPy | 1.26 | Array operations |
| Matplotlib | 3.8 | Figure generation |

### Cellpose v4 model substitution

> **Important:** In Cellpose version 4, requesting the `cyto2` or `cyto2_omni` model string
> causes silent substitution with the `cpsam` model. Any study using Cellpose v4 with
> `cyto2` is in practice running `cpsam`. Pin Cellpose to `<4.0` to use the true cyto2 model.

```python
# Verify which model is actually loaded:
from cellpose.models import CellposeModel
model = CellposeModel(model_type='cyto2')
print(model.pretrained_model)   # Will print 'cpsam' in Cellpose v4
```

### Keras backend conflict

StarDist requires TensorFlow; Cellpose requires PyTorch. Set the Keras backend explicitly:

```python
import os
os.environ["KERAS_BACKEND"] = "tensorflow"   # Must be set BEFORE any imports
```

---

## Compute Environment

All experiments are run on the **CSC Puhti supercomputing facility**:

- **GPU:** NVIDIA V100 (32 GB HBM2)
- **CPU:** Intel Xeon Gold 6230
- **Project:** `project_2019277`
- **Data path:** `/scratch/project_2019277/tissuenet_v1.1/`

Google Colab (NVIDIA T4 GPU) is used as a fallback and for the Segment Anything Model evaluation.

---

## Results Summary

### Performance hierarchy (validation split, n=38)

```
CP-Diam15  ████████████████████  0.802  ← Best
CP-Nuclei  ███████████████████   0.772
CP-Default ███████████████████   0.766
StarDist   █████████████████     0.683
Classical  ██████                0.272  ← Baseline
```

### Key findings

1. **Diameter tuning is free and effective.** Fixing the Cellpose diameter to 15 pixels
   improves F1@0.5 by 3.6 pp and F1@0.75 by 5.8 pp with no extra annotation or training cost.

2. **Cellpose outperforms StarDist on nuclear segmentation.** On identical nuclear channel
   inputs, CP-Nuclei exceeds StarDist by 8.9 pp in F1@0.5 and 16.5 pp in F1@0.75.

3. **Cell density predicts difficulty.** Spearman ρ = −0.31 (p < 0.05) between cell count
   and F1@0.5 across all methods.

4. **20% of images are universally hard.** 8 of 38 validation images have F1@0.5 < 0.5
   for all methods simultaneously, indicating a data-level performance ceiling.

---

## Citation

If you use this code or benchmark in your research, please cite:

```bibtex
@article{mridha2025cellseg,
  title   = {Cell Segmentation in Multiplexed Tissue Imaging:
             A Systematic Benchmarking Study},
  author  = {Mridha, Ramisa Fariha and Hoque, Md Ziaul and
             Sepp{\"a}nen, Tapio},
  journal = {IEEE Transactions on Biomedical Engineering},
  year    = {2025},
  note    = {Under review}
}
```

For the conference version:

```bibtex
@inproceedings{mridha2026cellseg,
  title     = {Cell Segmentation in Multiplexed Tissue Imaging},
  author    = {Mridha, Ramisa Fariha and Hoque, Md Ziaul and
               Sepp{\"a}nen, Tapio},
  booktitle = {Proc. IEEE International Conference on Image Processing (ICIP)},
  year      = {2026}
}
```

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

The TissueNet v1.1 dataset is subject to its own license terms. See the
[Deepcell repository](https://github.com/vanvalenlab/deepcell-tf) for details.

---

## Acknowledgements

This work was conducted at the Center for Machine Vision and Signal Analysis (CMVS),
University of Oulu, Finland. Computational resources were provided by CSC Finland
(project `project_2019277`). The authors thank the Van Valen lab for making TissueNet
publicly available, and the developers of Cellpose and StarDist for their open-source
pretrained models.
