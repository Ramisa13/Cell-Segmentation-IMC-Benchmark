#!/bin/bash
#SBATCH --job-name=imc_benchmark
#SBATCH --account=project_2019277
#SBATCH --partition=gpu
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --gres=gpu:v100:1
#SBATCH --output=logs/benchmark_%j.out
#SBATCH --error=logs/benchmark_%j.err

# =============================================================================
# CSC Puhti SLURM Job Script
# Cell Segmentation IMC Benchmark
# Project: project_2019277
# =============================================================================

echo "Job started: $(date)"
echo "Node: $(hostname)"
echo "GPU: $(nvidia-smi --query-gpu=name --format=csv,noheader)"

# ---- Load modules ----
module purge
module load pytorch/2.4
module load python-data/3.12

# ---- Set Keras backend (must be before any imports) ----
export KERAS_BACKEND=tensorflow

# ---- Paths ----
DATA_DIR=/scratch/project_2019277/tissuenet_v1.1
OUTPUT_DIR=/scratch/project_2019277/rmridha/benchmark_results/v2
REPO_DIR=/scratch/project_2019277/rmridha/Cell-Segmentation-IMC-Benchmark

# ---- Install dependencies (first run only) ----
# pip install --user cellpose==4.0.1 stardist tensorflow==2.17 -q

# ---- Create output directory ----
mkdir -p $OUTPUT_DIR/Figures
mkdir -p logs

# ---- Run benchmark ----
echo ""
echo "Running benchmark..."
python $REPO_DIR/benchmark/tissuenet_benchmark_puhti_v2.py \
    --data_dir $DATA_DIR \
    --output_dir $OUTPUT_DIR

# ---- Generate figures ----
echo ""
echo "Generating figures..."
python $REPO_DIR/figures/generate_figures_extended.py \
    --results_dir $OUTPUT_DIR \
    --fig_dir $OUTPUT_DIR/Figures

echo ""
echo "Job finished: $(date)"
echo "Results saved to: $OUTPUT_DIR"
