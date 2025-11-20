# 🎬 Video Matting Model Comparison (ESOF Project)

This project compares multiple **video matting models** —
**MatAnyOne**, **RVM (Robust Video Matting)**, and **MODNet**,
with optional **Harmonizer** post-processing for improved compositing.

---

## 🗂️ Project Structure

```
ESOFProject/
├── Data/
│ ├── Results/
| | └──Model_A/
│ └── YouTubeMatte/
│ │ ├── youtubematte_512x288/
│ │ └── youtubematte_1920x1080/
│ └── YouTubeMatte_first_frame_seg_mask/
│
├── Models/
│ ├── Model_A/MatAnyone/
│ ├── Model_B/RVM/
│ └── Model_C/MODNet/
│
│
└── Scripts/
  ├── setup_all_envs.sh
  └── run_all.sh
```

---

## ⚙️ Setup

Each model lives in its own environment.

1. **Create virtual environments and install dependencies:**
```bash
Scripts/setup_all_envs.sh
```
2. **Add your input videos (e.g. YouTubeMatte test sets) to:**
```
  Data/YouTubeMatte/
```
3. **Ensure each model folder contains:**
  - requirements.txt
  - run_model.py (entry script)
  - model_code/ (cloned repo or source files)

## ▶️ Running All Models

Execute all matting models and harmonizer in sequence:

```bash
Scripts/run_all.sh
```

Each model’s output will be written to:
```
Data/Results/<Model_Name>/
```

## 🧠 Notes
  - Each model has its own virtual environment to avoid dependency conflicts.

  - You can easily containerize each model later using Docker.

  - The folder naming convention (Model_A, Model_B, etc.) is flexible —
    you can rename as needed in Scripts/run_all.sh.

## 📜 License

Comply with each model’s individual license terms.
