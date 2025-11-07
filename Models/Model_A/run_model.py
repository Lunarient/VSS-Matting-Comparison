#!/usr/bin/env python3
"""
Run MatAnyone inference and optional evaluation.
"""

import argparse
import subprocess
import os
import sys

# --- Utility to run shell commands ---
def run_cmd(cmd, cwd=None):
    print(f"\n🚀 Running: {' '.join(cmd)}")
    subprocess.run(cmd, cwd=cwd, check=True)


def main():
    parser = argparse.ArgumentParser(description="Run MatAnyone with optional Harmonizer and evaluation")

    # Input/output settings
    parser.add_argument('-i', '--input_path', type=str, default="inputs/video/test-sample1.mp4",
                        help='Path of the input video or frame folder.')
    parser.add_argument('-m', '--mask_path', type=str, default="inputs/mask/test-sample1.png",
                        help='Path of the first-frame segmentation mask.')
    parser.add_argument('-o', '--output_path', type=str,
                        default="../../../Data/Results/MatAnyone/",
                        help='Output folder (default: Data/Results/MatAnyone/).')

    # Model + params
    parser.add_argument('-c', '--ckpt_path', type=str,
                        default="pretrained_models/matanyone.pth",
                        help='Path of the MatAnyone model checkpoint.')
    parser.add_argument('-w', '--warmup', type=str, default="10",
                        help='Number of warmup iterations for the first frame alpha prediction.')
    parser.add_argument('-e', '--erode_kernel', type=str, default="10",
                        help='Erosion kernel size for input mask.')
    parser.add_argument('-d', '--dilate_kernel', type=str, default="10",
                        help='Dilation kernel size for input mask.')
    parser.add_argument('--suffix', type=str, default="", help='Suffix when saving (e.g., target1).')
    parser.add_argument('--save_image', action='store_true', help='Save output frames instead of video.')
    parser.add_argument('--max_size', type=str, default="-1",
                        help='When positive, the video will be downsampled if min(w, h) exceeds this.')

    # Optional steps
    parser.add_argument('--harmonize', action='store_true',
                        help='Run Harmonizer preprocessing first.')
    parser.add_argument('--evaluate', action='store_true',
                        help='Run evaluation after inference.')
    parser.add_argument('--res', choices=["lr", "hr"], default="lr",
                        help='Evaluation resolution: lr=512x288 or hr=1920x1080.')

    args = parser.parse_args()

    # Paths
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../"))
    model_root = os.path.join(project_root, "Models/Model_A/MatAnyone")
    harmonizer_script = os.path.join(project_root, "Models/Harmonizer/run_harmonizer.py")
    eval_script = os.path.join(model_root, f"evaluation/eval_yt_{args.res}.py")

    # --- Step 1: Harmonizer (optional) ---
    if args.harmonize:
        if os.path.exists(harmonizer_script):
            print("\n✨ Running Harmonizer pre-processing...")
            run_cmd([
                sys.executable, harmonizer_script,
                "--input", args.input_path,
                "--output", args.input_path
            ])
        else:
            print("⚠️  Harmonizer not found, skipping...")

    # --- Step 2: Run MatAnyone inference ---
    print("\n🎬 Running MatAnyone inference...")
    inference_script = os.path.join(model_root, "inference_matanyone.py")

    run_cmd([
        sys.executable, inference_script,
        "-i", args.input_path,
        "-m", args.mask_path,
        "-o", args.output_path,
        "-c", args.ckpt_path,
        "-w", args.warmup,
        "-e", args.erode_kernel,
        "-d", args.dilate_kernel,
        "--suffix", args.suffix,
        "--max_size", args.max_size
    ] + (["--save_image"] if args.save_image else []),
    cwd=model_root)

    # --- Step 3: Evaluation (optional) ---
    if args.evaluate:
        print("\n📊 Running evaluation...")
        pred_dir = os.path.join(project_root, "Data/Results/MatAnyone")
        true_dir = os.path.join(project_root, f"Data/YouTubeMatte/youtubematte_{'512x288' if args.res == 'lr' else '1920x1080'}")

        run_cmd([
            sys.executable, eval_script,
            "--pred-dir", pred_dir,
            "--true-dir", true_dir
        ], cwd=model_root)
    else:
        print("\n✅ Inference complete (no evaluation requested).")


if __name__ == "__main__":
    main()
